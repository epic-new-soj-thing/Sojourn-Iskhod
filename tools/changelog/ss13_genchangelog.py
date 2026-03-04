'''
Usage:
    $ python ss13_genchangelog.py [--dry-run] html/changelog.html html/changelogs/

ss13_genchangelog.py - Generate changelog from YAML.

Copyright 2013 Rob "N3X15" Nelson <nexis@7chan.org>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
'''

from __future__ import print_function
import yaml, os, glob, sys, re, time, argparse
from datetime import datetime, date, timedelta
from time import time

today = date.today()

dateformat = "%d %B %Y"

opt = argparse.ArgumentParser()
opt.add_argument('-d', '--dry-run', dest='dryRun', default=False, action='store_true', help='Only parse changelogs and, if needed, the targetFile. (A .dry_changelog.yml will be output for debugging purposes.)')
opt.add_argument('-t', '--time-period', dest='timePeriod', default=52, type=int, help='Weeks back to display (default 52 = 1 year). Use 0 for all entries, no limit.')
opt.add_argument('--cache-only', dest='cacheOnly', default=False, action='store_true', help='Use only html/changelogs/.all_changelog.yml for entries; do not read or modify individual yml files.')
opt.add_argument('--from-yaml', dest='fromYaml', default=False, action='store_true', help='Ignore existing cache and build changelog only from PR yml files (fixes dates when cache is wrong).')
opt.add_argument('targetFile', help='The HTML changelog we wish to update.')
opt.add_argument('ymlDir', help='The directory of YAML changelogs we will use.')

args = opt.parse_args()

# Resolve paths so we read/write the right files regardless of cwd
args.targetFile = os.path.abspath(args.targetFile)
args.ymlDir = os.path.abspath(args.ymlDir)

all_changelog_entries = {}

validPrefixes = [
    'tweak',
    'soundadd',
    'sounddel',
    'add',
    'del',
    'imageadd',
    'imagedel',
    'maptweak',
    'spellcheck',
    'experiment',
    'balance',
    'admin',
    'server',
    'fix'
]

# Placeholder lines from PR template / generated reports - never show in changelog
IGNORED_CHANGE_TEXTS = {
    'Added more things',
    'Added new things',
    'Removed old things',
    'something server ops should know',
    'something server ops should know-->',
}


def dictToTuples(inp):
    return [(k, v) for k, v in inp.items()]


def _change_signature(change):
    """Return (type, normalized_text) for a change dict so we can match across YAML formatting."""
    (k, v) = dictToTuples(change)[0]
    text = (v or '').strip()
    text = ' '.join(text.split())  # collapse whitespace/newlines to single space
    return (k, text)


# Always use html/changelogs/.all_changelog.yml (relative to target file)
targetDir = os.path.dirname(args.targetFile)
_changelogs_dir = os.path.join(targetDir, 'changelogs')
changelog_cache = os.path.join(_changelogs_dir, '.all_changelog.yml')
_yml_dir = os.path.abspath(args.ymlDir)

def _parse_date_key(key):
    """Parse a cache date key (string, date, or datetime) into a date object."""
    ty = type(key).__name__
    if ty == 'datetime':
        return key.date()
    if ty == 'date':
        return key
    if ty in ['str', 'unicode']:
        s = key.strip()
        for fmt in (dateformat, "%Y-%m-%d", "%Y-%m-%dT%H:%M:%S", "%Y-%m-%d %H:%M:%S"):
            try:
                return datetime.strptime(s, fmt).date()
            except ValueError:
                continue
        if len(s) >= 10:
            try:
                return datetime.strptime(s[:10], "%Y-%m-%d").date()
            except ValueError:
                pass
        raise ValueError("cannot parse date: {!r}".format(key))
    return key

failed_cache_read = True
if args.fromYaml:
    print('Building from yml only (--from-yaml); ignoring existing cache.')
elif os.path.isfile(changelog_cache):
    try:
        with open(changelog_cache,encoding='utf-8') as f:
            (_, all_changelog_entries) = yaml.load_all(f, Loader=yaml.SafeLoader)
            if all_changelog_entries is None:
                all_changelog_entries = {}
            failed_cache_read = False
            print('Loaded cache from {} ({} date(s))'.format(changelog_cache, len(all_changelog_entries)))

            # Convert old timestamps to newer format (support %d %B %Y and ISO %Y-%m-%d).
            new_entries = {}
            for _date in all_changelog_entries.keys():
                new_entries[_parse_date_key(_date)] = all_changelog_entries[_date]
            all_changelog_entries = new_entries
    except Exception as e:
        print("Failed to read cache:")
        print(e, file=sys.stderr)

if args.dryRun:
    changelog_cache = os.path.join(_changelogs_dir, '.dry_changelog.yml')

if failed_cache_read and not args.fromYaml and os.path.isfile(args.targetFile):
    from bs4 import BeautifulSoup
    from bs4.element import NavigableString
    print(' Generating cache...')
    with open(args.targetFile, 'r', encoding='utf-8') as f:
        soup = BeautifulSoup(f)
        for e in soup.find_all('div', {'class': 'commit'}):
            entry = {}
            date = datetime.strptime(e.h2.string.strip(), dateformat).date()  # key
            for authorT in e.find_all('h3', {'class': 'author'}):
                author = authorT.string
                # Strip suffix
                if author.endswith('updated:'):
                    author = author[:-8]
                author = author.strip()

                # Find <ul>
                ulT = authorT.next_sibling
                while(ulT.name != 'ul'):
                    ulT = ulT.next_sibling
                changes = []

                for changeT in ulT.children:
                    if changeT.name != 'li':
                        continue
                    val = changeT.decode_contents(formatter="html")
                    newdat = {changeT['class'][0] + '': val + ''}
                    if newdat not in changes:
                        changes += [newdat]

                if len(changes) > 0:
                    entry[author] = changes
            if date in all_changelog_entries:
                all_changelog_entries[date].update(entry)
            else:
                all_changelog_entries[date] = entry

del_after = []
errors = False

if args.cacheOnly:
    print('Using only .all_changelog.yml for changelog entries.')
    if failed_cache_read:
        print('Warning: could not read cache; changelog will be empty.', file=sys.stderr)
else:
    print('Reading changelogs...')
    # Top-level yml plus autochangelogs subfolder (AutoChangeLog-pr-*.yml), unless already in autochangelogs
    if os.path.basename(_yml_dir.rstrip(os.sep)) == 'autochangelogs':
        yml_files = glob.glob(os.path.join(args.ymlDir, "*.yml"))
    else:
        yml_files = (glob.glob(os.path.join(args.ymlDir, "*.yml")) +
                     glob.glob(os.path.join(args.ymlDir, "autochangelogs", "*.yml")))
    for fileName in yml_files:
        name, ext = os.path.splitext(os.path.basename(fileName))
        if name.startswith('.'):
            continue
        if name == 'example':
            continue
        fileName = os.path.abspath(fileName)
        print(' Reading {}...'.format(fileName))
        cl = {}
        with open(fileName, 'r',encoding='utf-8') as f:
            cl = yaml.load(f, Loader=yaml.SafeLoader)
            f.close()
        # Use PR merge date from yml if present (from API when generated), else today
        if 'date' in cl and cl['date']:
            try:
                raw = cl['date']
                if isinstance(raw, str):
                    entry_date = _parse_date_key(raw)
                elif hasattr(raw, 'date') and callable(getattr(raw, 'date')):
                    entry_date = raw.date()  # datetime from YAML
                elif isinstance(raw, date):
                    entry_date = raw
                else:
                    entry_date = today
            except (ValueError, TypeError):
                entry_date = today
        else:
            entry_date = today
        if entry_date not in all_changelog_entries:
            all_changelog_entries[entry_date] = {}
        author_entries = all_changelog_entries[entry_date].get(cl['author'], [])
        if 'changes' in cl and len(cl['changes']):
            new = 0
            for change in cl['changes']:
                if change not in author_entries:
                    (change_type, _) = dictToTuples(change)[0]
                    if change_type not in validPrefixes:
                        errors = True
                        print('  {0}: Invalid prefix {1}'.format(fileName, change_type), file=sys.stderr)
                    author_entries += [change]
                    new += 1
            all_changelog_entries[entry_date][cl['author']] = author_entries
            if new > 0:
                print('  Added {0} new changelog entries.'.format(new))
            # Move these changes off any other date (so PR merge date wins; match by type+text to handle YAML formatting)
            if entry_date is not None:
                pr_sigs = {_change_signature(ch) for ch in cl['changes']}
                for other_date in list(all_changelog_entries.keys()):
                    if other_date == entry_date:
                        continue
                    if cl['author'] not in all_changelog_entries[other_date]:
                        continue
                    other_list = all_changelog_entries[other_date][cl['author']]
                    remaining = [c for c in other_list if _change_signature(c) not in pr_sigs]
                    if not remaining:
                        del all_changelog_entries[other_date][cl['author']]
                    else:
                        all_changelog_entries[other_date][cl['author']] = remaining
                # Prune empty date keys
                for k in list(all_changelog_entries.keys()):
                    if not all_changelog_entries[k]:
                        del all_changelog_entries[k]

        if cl.get('delete-after', False):
            if os.path.isfile(fileName):
                if args.dryRun:
                    print('  Would delete {0} (delete-after set)...'.format(fileName))
                else:
                    del_after += [fileName]

        if args.dryRun:
            continue

        # Do not overwrite yml files; only read from them and merge into cache/HTML

out_path = args.targetFile.replace('.htm', '.dry.htm') if args.dryRun else args.targetFile
print('Writing changelog to {}'.format(out_path))
with open(out_path, 'w', encoding='utf-8') as changelog:
    with open(os.path.join(targetDir, 'templates', 'header.html'), 'r', encoding='utf-8') as h:
        for line in h:
            changelog.write(line)

    changelog.write('\n<div class="changelog-entries">\n')
    weekstoshow = timedelta(weeks=args.timePeriod) if args.timePeriod else None  # 0 = no limit
    for _date in reversed(sorted(all_changelog_entries.keys())):
        # Normalize to date so strftime works (keys may be date, datetime, or string)
        if hasattr(_date, 'date') and callable(getattr(_date, 'date')):
            d = _date.date()
        elif isinstance(_date, date):
            d = _date
        else:
            try:
                d = _parse_date_key(_date)
            except (ValueError, TypeError):
                continue
        if weekstoshow is not None and not (today - d < weekstoshow):
            continue
        entry_htm = '\n'
        entry_htm += '\t\t\t<h2 class="date">{date}</h2>\n'.format(date=d.strftime(dateformat))
        write_entry = False
        for author in sorted(all_changelog_entries[_date].keys()):
            if len(all_changelog_entries[_date]) == 0:
                continue
            author_htm = '\t\t\t<h3 class="author">{author} updated:</h3>\n'.format(author=author)
            author_htm += '\t\t\t<ul class="changes bgimages16">\n'
            changes_added = []
            for (css_class, change) in (dictToTuples(e)[0] for e in all_changelog_entries[_date][author]):
                change_stripped = change.strip()
                if change_stripped in changes_added:
                    continue
                if change_stripped in IGNORED_CHANGE_TEXTS or change_stripped.endswith('-->'):
                    continue
                write_entry = True
                changes_added += [change_stripped]
                author_htm += '\t\t\t\t<li class="{css_class}">{change}</li>\n'.format(css_class=css_class, change=change_stripped)
            author_htm += '\t\t\t</ul>\n'
            if len(changes_added) > 0:
                entry_htm += author_htm
        if write_entry:
            changelog.write(entry_htm)

    changelog.write('</div>\n\n')
    with open(os.path.join(targetDir, 'templates', 'footer.html'), 'r', encoding='utf-8') as h:
        for line in h:
            changelog.write(line)


if not args.cacheOnly:
    with open(changelog_cache, 'w') as f:
        cache_head = 'DO NOT EDIT THIS FILE BY HAND!  AUTOMATICALLY GENERATED BY ss13_genchangelog.py.'
        yaml.safe_dump_all([cache_head, all_changelog_entries], f, default_flow_style=False)

if not args.cacheOnly and len(del_after):
    print('Cleaning up...')
    for fileName in del_after:
        if os.path.isfile(fileName):
            print(' Deleting {0} (delete-after set)...'.format(fileName))
            os.remove(fileName)

if errors:
    sys.exit(1)
