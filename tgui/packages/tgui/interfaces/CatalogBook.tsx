/**
 * Book-style catalog UI: table of contents on the left, page on the right.
 * Plain, book-like appearance; entries are link-style text, no fancy buttons.
 */
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, Input, Stack, VirtualList } from 'tgui-core/components';
import { CatalogEntryContent } from './Catalog';

type Entry = {
  id: string;
  name: string;
};

type Data = {
  front_page_name: string;
  front_page_content: string;
  catalog_search: string;
  entries: Entry[];
  selected_entry: Record<string, unknown> | null;
};

const BOOK_PAGE_STYLE = {
  backgroundColor: '#faf6ef',
  color: '#2c2416',
  fontFamily: 'Georgia, "Times New Roman", serif',
  fontSize: '1rem',
  lineHeight: 1.5,
  padding: '1.25rem 1.5rem',
  height: '100%',
  minHeight: '100%',
  display: 'flex',
  flexDirection: 'column',
  overflowY: 'auto' as const,
};

const LINK_STYLE = {
  display: 'block',
  color: '#1a3a5c',
  textDecoration: 'none',
  cursor: 'pointer',
  fontFamily: 'Georgia, "Times New Roman", serif',
  fontSize: '0.9rem',
  padding: '0.2rem 0',
  background: 'none',
  border: 'none',
  textAlign: 'left' as const,
  width: '100%',
};

export const CatalogBook = (props) => {
  return (
    <Window width={960} height={720} className="CatalogBook--paper">
      <Window.Content className="CatalogBook--paper" backgroundColor="#e8dfd0">
        <CatalogBookContent />
      </Window.Content>
    </Window>
  );
};

const CatalogBookContent = (props) => {
  const { act, data } = useBackend<Data>();
  const { front_page_content = '', catalog_search = '', entries = [], selected_entry } = data;

  return (
    <Stack fill height="100%" align="stretch">
      {/* Left: Table of contents */}
      <Stack.Item
        basis="30%"
        className="CatalogBook-Sidebar"
        style={{
          backgroundColor: '#f2ebe0',
          borderRight: '1px solid #b8a990',
          padding: '0.75rem',
          minWidth: 0,
          overflowY: 'auto',
        }}
      >
        <Box style={{ color: '#1a1a1a', marginBottom: '0.5rem', fontSize: '0.85rem' }}>
          Contents
        </Box>
        <Box style={{ marginBottom: '0.35rem', fontSize: '0.8rem', color: '#555' }}>
          Find in this volume
        </Box>
        <Input
          fluid
          placeholder="Look up a subject…"
          value={catalog_search}
          onChange={(e, search) => act('set_catalog_search', { search })}
          style={{
            fontFamily: 'Georgia, serif',
            fontSize: '0.85rem',
            backgroundColor: '#fff',
            border: '1px solid #c4b8a8',
            color: '#1a1a1a',
            marginBottom: '0.5rem',
          }}
        />
        {entries.length === 0 ? (
          <Box style={{ color: '#666', fontStyle: 'italic', fontSize: '0.9rem' }}>
            {catalog_search ? 'No such heading in this volume.' : 'This volume is empty.'}
          </Box>
        ) : (
          <VirtualList style={{ border: 'none', background: 'none' }}>
            {entries.map((entry: Entry) => (
              <Box key={entry.id} style={{ marginBottom: '0.1rem' }}>
                <span
                  role="button"
                  tabIndex={0}
                  style={{
                    ...LINK_STYLE,
                    fontWeight: selected_entry?.id === entry.id ? 'bold' : 'normal',
                    textDecoration: selected_entry?.id === entry.id ? 'underline' : 'none',
                  }}
                  onClick={() => act('state_machine_enter_entry', { entry: entry.id })}
                  onKeyDown={(e) => {
                    if (e.key === 'Enter' || e.key === ' ') {
                      e.preventDefault();
                      act('state_machine_enter_entry', { entry: entry.id });
                    }
                  }}
                >
                  {entry.name}
                </span>
              </Box>
            ))}
          </VirtualList>
        )}
      </Stack.Item>

      {/* Right: Page - fills entire column */}
      <Stack.Item basis="70%" style={{ minWidth: 0, display: 'flex', minHeight: 0 }} className="CatalogBook-Page">
        {selected_entry ? (
          <Box style={BOOK_PAGE_STYLE} className="CatalogBook-PageContent">
            <CatalogEntryContent selected_entry={selected_entry} />
          </Box>
        ) : front_page_content ? (
          <Box style={BOOK_PAGE_STYLE} className="CatalogBook-PageContent CatalogBook-FrontPage">
            <div
              dangerouslySetInnerHTML={{ __html: front_page_content }}
              style={{ fontFamily: 'Georgia, "Times New Roman", serif', fontSize: '0.95rem' }}
            />
          </Box>
        ) : (
          <Box
            style={{
              ...BOOK_PAGE_STYLE,
              alignItems: 'center',
              justifyContent: 'center',
              color: '#666',
              fontStyle: 'italic',
            }}
          >
            Select a page from the contents.
          </Box>
        )}
      </Stack.Item>
    </Stack>
  );
};
