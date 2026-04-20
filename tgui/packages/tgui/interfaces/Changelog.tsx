import dateformat from 'dateformat';
import yaml from 'js-yaml';
import { Fragment, useCallback, useEffect, useMemo, useRef, useState } from 'react';
import { resolveAsset } from 'tgui/assets';
import { useBackend } from 'tgui/backend';
import { Dropdown } from 'tgui/components';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  Icon,
  Section,
  Stack,
  Table,
} from 'tgui-core/components';
import { classes } from 'tgui-core/react';

const icons = {
  admin: { icon: 'user-shield', color: 'purple' },
  balance: { icon: 'balance-scale-right', color: 'yellow' },
  bugfix: { icon: 'bug', color: 'green' },
  code_imp: { icon: 'code', color: 'green' },
  config: { icon: 'cogs', color: 'purple' },
  expansion: { icon: 'check-circle', color: 'green' },
  experiment: { icon: 'radiation', color: 'yellow' },
  image: { icon: 'image', color: 'green' },
  imageadd: { icon: 'tg-image-plus', color: 'green' },
  imagedel: { icon: 'tg-image-minus', color: 'red' },
  qol: { icon: 'hand-holding-heart', color: 'green' },
  refactor: { icon: 'tools', color: 'green' },
  add: { icon: 'check-circle', color: 'green' },
  del: { icon: 'times-circle', color: 'red' },
  server: { icon: 'server', color: 'purple' },
  sound: { icon: 'volume-high', color: 'green' },
  soundadd: { icon: 'tg-sound-plus', color: 'green' },
  sounddel: { icon: 'tg-sound-minus', color: 'red' },
  spellcheck: { icon: 'spell-check', color: 'green' },
  tgs: { icon: 'toolbox', color: 'purple' },
  tweak: { icon: 'wrench', color: 'green' },
  unknown: { icon: 'info-circle', color: 'label' },
  wip: { icon: 'hammer', color: 'orange' },
};

type ChangelogData =
  | string
  | {
      [date: string]: {
        [author: string]: string[];
      };
    }
  | {
      author: string;
      changes: ({ [type: string]: string } | string)[];
      date?: string | Date;
      'delete-after'?: boolean;
    };

type Data = {
  dates: string[];
  month_prs?: Record<string, string[]>;
};

const MAX_LOAD_ATTEMPTS = 6;

function mergeChangelogData(parsed: ChangelogData[]): ChangelogData {
  const merged: Record<string, Record<string, unknown[]>> = {};
  for (const doc of parsed) {
    if (typeof doc !== 'object' || doc === null || Array.isArray(doc)) continue;
    const hasAuthor = 'author' in doc && 'changes' in doc && Array.isArray((doc as { changes: unknown }).changes);
    if (hasAuthor) {
      const pr = doc as { author: string; changes: unknown[]; date?: string };
      const dateKey =
        pr.date !== null && pr.date !== undefined
          ? typeof pr.date === 'string'
            ? pr.date
            : (pr.date as Date).toISOString().slice(0, 10)
          : '';
      if (!dateKey) continue;
      if (!merged[dateKey]) merged[dateKey] = {};
      merged[dateKey][pr.author] = pr.changes;
      continue;
    }
    for (const [date, authors] of Object.entries(doc)) {
      if (date === 'author' || date === 'changes' || date === 'delete-after') continue;
      if (typeof authors !== 'object' || authors === null || Array.isArray(authors)) continue;
      if (!merged[date]) merged[date] = {};
      for (const [name, authorChanges] of Object.entries(authors)) {
        merged[date][name] = Array.isArray(authorChanges) ? authorChanges : [];
      }
    }
  }
  return merged as ChangelogData;
}

export const Changelog = () => {
  const { act, data: backendData } = useBackend<Data>();
  const rawDates = backendData?.dates ?? [];
  const monthPrs = backendData?.month_prs ?? null;

  // Sort newest first: by year descending, then month descending (2026-12, 2026-11, ..., 2025-01)
  const dates = useMemo(
    () => [...rawDates].sort((a, b) => (a > b ? -1 : a < b ? 1 : 0)),
    [rawDates],
  );

  const [data, setData] = useState<ChangelogData>('Loading changelog data...');
  const [selectedIndex, setSelectedIndex] = useState(0);
  const initialLoadDone = useRef(false);

  const dateChoices = useMemo(
    () =>
      dates.map((date) =>
        date.startsWith('AutoChangeLog-pr-')
          ? 'PR #' + date.replace('AutoChangeLog-pr-', '')
          : date,
      ),
    [dates],
  );
  const selectedDate = dateChoices[selectedIndex] ?? '';

  const getData = useCallback(
    (date: string, attemptNumber = 1) => {
      if (attemptNumber > MAX_LOAD_ATTEMPTS) {
        setData(
          'Failed to load data after ' + MAX_LOAD_ATTEMPTS + ' attempts',
        );
        return;
      }

      const keysToLoad = monthPrs && monthPrs[date]?.length ? monthPrs[date] : [date];
      keysToLoad.forEach((key) => act('get_month', { date: key }));

      const attempt = () => {
        const fetchOne = (key: string) =>
          fetch(resolveAsset(key + '.yml')).then((r) => r.text());
        Promise.all(keysToLoad.map(fetchOne))
          .then((texts) => {
            const errorRegex = /^Cannot find/;
            const failed = texts.some((t) => errorRegex.test(t));
            if (failed) {
              setData('Loading changelog data' + '.'.repeat(attemptNumber + 3));
              setTimeout(() => getData(date, attemptNumber + 1), 50 + attemptNumber * 50);
              return;
            }
            const parsed = texts.map((t) => yaml.load(t, { schema: yaml.CORE_SCHEMA }) as ChangelogData);
            const merged = keysToLoad.length > 1 ? mergeChangelogData(parsed) : parsed[0];
            setData(merged);
          })
          .catch(() => {
            if (attemptNumber < MAX_LOAD_ATTEMPTS) {
              setData('Loading changelog data' + '.'.repeat(attemptNumber + 3));
              setTimeout(() => getData(date, attemptNumber + 1), 100 + attemptNumber * 50);
            } else {
              setData('Failed to load data after ' + MAX_LOAD_ATTEMPTS + ' attempts');
            }
          });
      };
      setTimeout(attempt, 100);
    },
    [act, monthPrs],
  );

  // Load first month only once when dates first become available (don't reset when backend updates after act())
  useEffect(() => {
    if (dates.length > 0) {
      if (!initialLoadDone.current) {
        initialLoadDone.current = true;
        setSelectedIndex(0);
        getData(dates[0]);
      }
    } else if (backendData !== undefined) {
      setData('No changelog entries found.');
    }
  }, [dates, getData, backendData]);

  const scrollToBottom = () => {
    window.scrollTo(
      0,
      document.body.scrollHeight ?? document.documentElement.scrollHeight,
    );
  };

  const dateDropdown =
    dateChoices.length > 0 && (
      <Stack mb={1}>
        <Stack.Item>
          <Button
            className="Changelog__Button"
            disabled={selectedIndex === 0}
            icon={'chevron-left'}
            onClick={() => {
              const index = selectedIndex - 1;
              setData('Loading changelog data...');
              setSelectedIndex(index);
              scrollToBottom();
              getData(dates[index]);
            }}
          />
        </Stack.Item>
        <Stack.Item>
          <Dropdown
            autoScroll={false}
            options={dateChoices}
            onSelected={(value) => {
              const index = dateChoices.indexOf(value);
              setData('Loading changelog data...');
              setSelectedIndex(index);
              scrollToBottom();
              getData(dates[index]);
            }}
            selected={selectedDate}
            width="150px"
          />
        </Stack.Item>
        <Stack.Item>
          <Button
            className="Changelog__Button"
            disabled={selectedIndex === dateChoices.length - 1}
            icon={'chevron-right'}
            onClick={() => {
              const index = selectedIndex + 1;
              setData('Loading changelog data...');
              setSelectedIndex(index);
              scrollToBottom();
              getData(dates[index]);
            }}
          />
        </Stack.Item>
      </Stack>
    );

  const header = (
    <Section>
      <h1>Iskhod Outpost</h1>
      <p>
        <b>Thanks to: </b>
        CEV Eris, Baystation 12, /vg/station, NTstation, CDK Station devs,
        FacepunchStation, GoonStation devs, the original Space Station 13
        developers, and the countless others who have contributed to the game,
        issue tracker or wiki over the years.
      </p>
      <p>
        {'Source and issue tracker: '}
        <a href="https://github.com/epic-new-soj-thing/Sojourn-Iskhod/">
          Sojourn-Iskhod on GitHub
        </a>
        {'. Based on '}
        <a href="https://github.com/epic-new-soj-thing/Sojourn-Iskhod/">
          CEV Eris
        </a>
        {'. Code under AGPLv3. Content under CC BY-SA 3.0.'}
      </p>
      {dateDropdown}
    </Section>
  );

  const footer = (
    <Section>
      {dateDropdown}
      <p>
        {'Except where otherwise noted, code is under '}
        <a href="https://www.gnu.org/licenses/agpl-3.0.html">GNU AGPL v3</a>
        {'. Content under '}
        <a href="https://creativecommons.org/licenses/by-sa/3.0/">
          Creative Commons 3.0 BY-SA
        </a>
        {' where applicable.'}
      </p>
    </Section>
  );

  const isAutoChangelog =
    typeof data === 'object' &&
    data !== null &&
    !Array.isArray(data) &&
    'author' in data &&
    'changes' in data &&
    Array.isArray((data as { changes: unknown }).changes);

  const changes =
    typeof data === 'object' &&
    data !== null &&
    !Array.isArray(data) &&
    Object.keys(data).length > 0 &&
    (isAutoChangelog
      ? (() => {
          const prData = data as {
            author: string;
            changes: ({ [type: string]: string } | string)[];
            date?: string | Date;
          };
          const dateVal =
            prData.date !== null && prData.date !== undefined
              ? prData.date
              : null;
          const title =
            dateVal !== null && dateVal !== undefined
              ? dateformat(
                  typeof dateVal === 'string' ? dateVal : dateVal.toISOString().slice(0, 10),
                  'd mmmm yyyy',
                  true,
                )
              : selectedDate;
          const normalizedChanges = (prData.changes ?? []).map((change) =>
            typeof change === 'object' && change !== null && !Array.isArray(change)
              ? change
              : { unknown: String(change) },
          );
          return (
            <Section key={selectedDate} title={title}>
              <Box ml={3}>
                <h4>{prData.author} changed:</h4>
                <Box ml={3}>
                  <Table>
                    {normalizedChanges.map((change, i) => {
                      const changeType = Object.keys(change)[0];
                      if (!changeType) return null;
                      const message = change[changeType];
                      return (
                        <Table.Row key={i}>
                          <Table.Cell
                            className={classes([
                              'Changelog__Cell',
                              'Changelog__Cell--Icon',
                            ])}
                          >
                            <Icon
                              color={
                                icons[changeType]
                                  ? icons[changeType].color
                                  : icons['unknown'].color
                              }
                              name={
                                icons[changeType]
                                  ? icons[changeType].icon
                                  : icons['unknown'].icon
                              }
                            />
                          </Table.Cell>
                          <Table.Cell className="Changelog__Cell">
                            {message !== null && message !== undefined ? String(message) : ''}
                          </Table.Cell>
                        </Table.Row>
                      );
                    })}
                  </Table>
                </Box>
              </Box>
            </Section>
          );
        })()
      : (() => {
          const parseDate = (s: string) => {
            const part = s.slice(0, 10).split('-').map(Number);
            return [part[0] ?? 0, part[1] ?? 0, part[2] ?? 0] as [number, number, number];
          };
          const entries = Object.entries(data)
            .filter(([k]) => k !== 'author' && k !== 'changes' && k !== 'delete-after')
            .sort(([a], [b]) => {
              const [ya, ma, da] = parseDate(a);
              const [yb, mb, db] = parseDate(b);
              if (ya !== yb) return ya - yb;
              if (ma !== mb) return ma - mb;
              return da - db;
            })
            .reverse();
          return entries.map(([date, authors]) =>
            typeof authors === 'object' && authors !== null && !Array.isArray(authors) ? (
              <Section
                key={date}
                title={dateformat(date.length >= 10 ? date.slice(0, 10) : date, 'd mmmm yyyy', true)}
              >
                <Box ml={3}>
                  {Object.entries(authors).map(([name, authorChanges]) => (
                    <Fragment key={name}>
                      <h4>{name} changed:</h4>
                      <Box ml={3}>
                        <Table>
                          {(Array.isArray(authorChanges) ? authorChanges : []).map(
                            (change, i) => {
                              const changeType = Object.keys(change)[0];
                              return (
                                <Table.Row key={i}>
                                  <Table.Cell
                                    className={classes([
                                      'Changelog__Cell',
                                      'Changelog__Cell--Icon',
                                    ])}
                                  >
                                    <Icon
                                      color={
                                        icons[changeType]
                                          ? icons[changeType].color
                                          : icons['unknown'].color
                                      }
                                      name={
                                        icons[changeType]
                                          ? icons[changeType].icon
                                          : icons['unknown'].icon
                                      }
                                    />
                                  </Table.Cell>
                                  <Table.Cell className="Changelog__Cell">
                                    {change[changeType]}
                                  </Table.Cell>
                                </Table.Row>
                              );
                            },
                          )}
                        </Table>
                      </Box>
                    </Fragment>
                  ))}
                </Box>
              </Section>
            ) : null,
          );
        })());

  return (
    <Window title="Changelog" width={675} height={650}>
      <Window.Content scrollable>
        {header}
        {changes}
        {typeof data === 'string' && <p>{data}</p>}
        {footer}
      </Window.Content>
    </Window>
  );
};
