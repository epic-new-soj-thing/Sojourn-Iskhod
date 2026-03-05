/**
 * Book-style catalog UI: tabs (table of contents) on the left, current page on the right.
 * White background, readable text — like a real book.
 */
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, Button, Input, Section, Stack, VirtualList } from 'tgui-core/components';
import { CatalogEntryContent } from './Catalog';

type Entry = {
  id: string;
  name: string;
};

type Data = {
  front_page_name: string;
  catalog_search: string;
  entries: Entry[];
  selected_entry: Record<string, unknown> | null;
};

const BOOK_PAGE_STYLE = {
  backgroundColor: '#ffffff',
  color: '#1a1a1a',
  fontFamily: 'Georgia, "Times New Roman", serif',
  fontSize: '1rem',
  lineHeight: 1.5,
  padding: '1.25rem 1.5rem',
  height: '100%' as const,
  overflowY: 'auto' as const,
};

export const CatalogBook = (props) => {
  return (
    <Window width={800} height={600}>
      <Window.Content
        backgroundColor="#f5f5f0"
        style={{
          fontFamily: 'Georgia, "Times New Roman", serif',
        }}
      >
        <CatalogBookContent />
      </Window.Content>
    </Window>
  );
};

const CatalogBookContent = (props) => {
  const { act, data } = useBackend<Data>();
  const { front_page_name, catalog_search = '', entries = [], selected_entry } = data;

  return (
    <Stack fill height="100%" align="stretch">
      {/* Left: Tabs (table of contents) */}
      <Stack.Item
        basis="32%"
        style={{
          backgroundColor: '#fff',
          borderRight: '1px solid #ccc',
          padding: '0.5rem 0',
          minWidth: 0,
        }}
      >
        <Box
          style={{
            color: '#1a1a1a',
            padding: '0 0.75rem 0.5rem',
            borderBottom: '1px solid #ddd',
            fontSize: '0.8rem',
            fontFamily: 'Georgia, "Times New Roman", serif',
          }}
        >
          <Box bold fontSize="0.95rem" mb={0.5}>
            Contents
          </Box>
          <Box color="#555" mb={0.25}>
            Find in this volume
          </Box>
          <Input
            fluid
            placeholder="Look up a subject…"
            value={catalog_search}
            onChange={(e, search) => act('set_catalog_search', { search })}
            style={{
              fontFamily: 'Georgia, "Times New Roman", serif',
              fontSize: '0.9rem',
              backgroundColor: '#fafaf8',
              border: '1px solid #ccc',
              color: '#1a1a1a',
            }}
          />
        </Box>
        <Section scrollable fill style={{ backgroundColor: 'transparent', border: 'none' }}>
          {entries.length === 0 ? (
            <Box
              style={{
                color: '#666',
                fontStyle: 'italic',
                padding: '1rem 0.75rem',
                fontFamily: 'Georgia, "Times New Roman", serif',
                fontSize: '0.9rem',
              }}
            >
              {catalog_search
                ? 'No such heading in this volume. Try another word from the index.'
                : 'This volume is empty.'}
            </Box>
          ) : (
            <VirtualList>
              {entries.map((entry: Entry) => (
                <Box key={entry.id}>
                  <Button
                    fluid
                    textAlign="left"
                    color="transparent"
                    style={{
                      color: '#1a1a1a',
                      fontWeight: selected_entry?.id === entry.id ? 'bold' : 'normal',
                      backgroundColor:
                        selected_entry?.id === entry.id ? '#e8e8e8' : 'transparent',
                      borderLeft:
                        selected_entry?.id === entry.id
                          ? '3px solid #333'
                          : '3px solid transparent',
                      padding: '0.4rem 0.75rem',
                      fontFamily: 'Georgia, "Times New Roman", serif',
                    }}
                    onClick={() =>
                      act('state_machine_enter_entry', { entry: entry.id })
                    }
                  >
                    {entry.name}
                  </Button>
                </Box>
              ))}
            </VirtualList>
          )}
        </Section>
      </Stack.Item>

      {/* Right: Page (white, text) */}
      <Stack.Item basis="68%" style={{ minWidth: 0 }}>
        {selected_entry ? (
          <Box style={BOOK_PAGE_STYLE}>
            <CatalogEntryContent selected_entry={selected_entry} />
          </Box>
        ) : (
          <Box
            style={{
              ...BOOK_PAGE_STYLE,
              display: 'flex',
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
