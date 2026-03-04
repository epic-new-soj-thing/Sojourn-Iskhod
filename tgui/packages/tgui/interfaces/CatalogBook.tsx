/**
 * Book-style catalog UI: tabs (table of contents) on the left, current page on the right.
 * White background, readable text — like a real book.
 */
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, Button, Section, Stack, VirtualList } from 'tgui-core/components';
import { CatalogEntryContent } from './Catalog';

type Entry = {
  id: string;
  name: string;
};

type Data = {
  front_page_name: string;
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
  const { front_page_name, entries = [], selected_entry } = data;

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
          bold
          style={{
            color: '#1a1a1a',
            padding: '0 0.75rem 0.5rem',
            borderBottom: '1px solid #ddd',
            fontSize: '0.95rem',
          }}
        >
          Contents
        </Box>
        <Section scrollable fill style={{ backgroundColor: 'transparent', border: 'none' }}>
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
