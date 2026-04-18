/**
 * CatalogBook – standalone book UI. Does not import from Catalog.
 * Table of contents (clickable) + Return to main; right column = cream page, no borders, all text black, in-content links disabled.
 */
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  ColorBox,
  Input,
  LabeledList,
  Section,
  Stack,
  VirtualList,
} from 'tgui-core/components';

type Entry = {
  id: string;
  name: string;
  thing_nature?: string;
};

const TOC_SECTION_ORDER = ['Food', 'Reagent', 'Drink', 'Alchohol drink', 'Atom', 'Other', 'Unknown'];

function groupEntriesBySection(entries: Entry[]): { section: string; entries: Entry[] }[] {
  const bySection = new Map<string, Entry[]>();
  for (const e of entries) {
    const section = e.thing_nature && e.thing_nature.trim() ? e.thing_nature : 'Unknown';
    if (!bySection.has(section)) bySection.set(section, []);
    bySection.get(section)!.push(e);
  }
  const result: { section: string; entries: Entry[] }[] = [];
  for (const section of TOC_SECTION_ORDER) {
    if (bySection.has(section)) {
      result.push({ section, entries: bySection.get(section)! });
    }
  }
  Array.from(bySection.entries()).forEach(([section, list]) => {
    if (!TOC_SECTION_ORDER.includes(section)) {
      result.push({ section, entries: list });
    }
  });
  return result;
}

type Data = {
  front_page_name: string;
  front_page_content: string;
  catalog_search: string;
  entries: Entry[];
  selected_entry: Record<string, unknown> | null;
};

const BOOK_PAGE_STYLE = {
  backgroundColor: '#faf6ef',
  color: '#000',
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

const TOC_ENTRY_STYLE = {
  display: 'block',
  color: '#1a3a5c',
  fontFamily: 'Georgia, "Times New Roman", serif',
  fontSize: '0.9rem',
  padding: '0.2rem 0',
  background: 'none',
  border: 'none',
  textAlign: 'left' as const,
  width: '100%',
  cursor: 'pointer',
  textDecoration: 'none',
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
        <Box
          as="span"
          role="button"
          tabIndex={0}
          mb={0.5}
          style={{
            ...TOC_ENTRY_STYLE,
            marginBottom: '0.5rem',
          }}
          onClick={(e) => {
            (e.target as HTMLElement)?.blur?.();
            act('state_machine_enter_front');
          }}
          onKeyDown={(e) => {
            if (e.key === 'Enter' || e.key === ' ') {
              e.preventDefault();
              (e.target as HTMLElement)?.blur?.();
              act('state_machine_enter_front');
            }
          }}
        >
          Return to main
        </Box>
        <Box style={{ color: '#000', marginBottom: '0.5rem', fontSize: '0.85rem' }}>
          Contents
        </Box>
        <Box style={{ marginBottom: '0.35rem', fontSize: '0.8rem', color: '#000' }}>
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
            color: '#000',
            marginBottom: '0.5rem',
          }}
        />
        {entries.length === 0 ? (
          <Box style={{ color: '#000', fontStyle: 'italic', fontSize: '0.9rem' }}>
            {catalog_search ? 'No such heading in this volume.' : 'This volume is empty.'}
          </Box>
        ) : (
          <VirtualList style={{ border: 'none', background: 'none' }}>
            {groupEntriesBySection(entries).map(({ section, entries: sectionEntries }) => (
              <Box key={section} style={{ marginBottom: '0.75rem' }}>
                <Box
                  style={{
                    color: '#000',
                    fontSize: '0.8rem',
                    fontWeight: 'bold',
                    marginBottom: '0.25rem',
                    borderBottom: '1px solid #c4b8a8',
                    paddingBottom: '0.15rem',
                  }}
                >
                  {section}
                </Box>
                {sectionEntries.map((entry: Entry) => (
                  <Box key={entry.id} style={{ marginBottom: '0.1rem' }}>
                    <span
                      role="button"
                      tabIndex={0}
                      style={{
                        ...TOC_ENTRY_STYLE,
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
              </Box>
            ))}
          </VirtualList>
        )}
      </Stack.Item>

      <Stack.Item
        basis="70%"
        style={{
          minWidth: 0,
          display: 'flex',
          minHeight: 0,
          backgroundColor: '#faf6ef',
        }}
        className="CatalogBook-Page"
      >
        {selected_entry ? (
          <Box style={BOOK_PAGE_STYLE} className="CatalogBook-PageContent">
            <BookEntryView selected_entry={selected_entry} />
          </Box>
        ) : front_page_content ? (
          <Box style={BOOK_PAGE_STYLE} className="CatalogBook-PageContent CatalogBook-FrontPage">
            <div
              dangerouslySetInnerHTML={{ __html: front_page_content }}
              style={{ fontFamily: 'Georgia, "Times New Roman", serif', fontSize: '0.95rem', color: '#000' }}
            />
          </Box>
        ) : (
          <Box
            style={{
              ...BOOK_PAGE_STYLE,
              alignItems: 'center',
              justifyContent: 'center',
              color: '#000',
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

/** Book-only entry renderer: same data as Catalog but no in-content links, book layout. */
const BookEntryView = (props: { selected_entry: Record<string, unknown> }) => {
  const { selected_entry } = props;
  const id = selected_entry.id as string;

  if (id.startsWith('/datum/cooking/recipe') || id.startsWith('/datum/cooking_with_jane/recipe')) {
    return <BookCookingEntry entry={selected_entry} />;
  }
  if (id.startsWith('/datum/reagent/drink') || id.startsWith('/datum/reagent/ethanol')) {
    return <BookDrinksEntry entry={selected_entry} />;
  }
  if (id.startsWith('/datum/reagent')) {
    return <BookReagentsEntry entry={selected_entry} />;
  }
  return <Box>Unknown entry type: {id}</Box>;
};

const BookCookingEntry = (props: { entry: Record<string, unknown> }) => {
  const e = props.entry;
  return (
    <Section fill style={{ height: '100%', display: 'flex', flexDirection: 'column', minHeight: 0 }}>
      <Stack align="center" justify="space-around">
        <Stack.Item grow>
          <Box fontSize={2} bold>{String(e.name ?? '')}</Box>
          <Box>{String(e.create_in ?? '')}</Box>
          <Box>{String(e.description ?? '')}</Box>
        </Stack.Item>
        <Stack.Item grow textAlign="center">
          <Box className={String(e.icon ?? '')} />
        </Stack.Item>
      </Stack>
      <Box fontSize={1.5} bold mt={1}>Specifications</Box>
      <LabeledList>
        <LabeledList.Item label={e.product_is_reagent ? 'Reagent Name' : 'Product Name'}>
          {String(e.product_name ?? '')}
        </LabeledList.Item>
        <LabeledList.Item label={e.product_is_reagent ? 'Units Produced' : 'Product Count'}>
          {Number(e.product_count ?? 0)}
        </LabeledList.Item>
        {Number(e.byproduct_count ?? 0) > 0 && (
          <>
            <LabeledList.Item label="Reagent Byproduct">{String(e.byproduct_name ?? '')}</LabeledList.Item>
            <LabeledList.Item label="Byproduct Units Produced">{Number(e.byproduct_count ?? 0)}</LabeledList.Item>
          </>
        )}
        {e.recipe_guide && (
          <LabeledList.Item label="Recipe">
            <Box className="CatalogBook-entryBox" p={1}>
              {/* eslint-disable react/no-danger */}
              <div dangerouslySetInnerHTML={{ __html: String(e.recipe_guide) }} />
            </Box>
          </LabeledList.Item>
        )}
      </LabeledList>
    </Section>
  );
};

const BookDrinksEntry = (props: { entry: Record<string, unknown> }) => {
  const e = props.entry;
  const recipe_data = e.recipe_data as Array<Record<string, unknown>> | null | undefined;
  return (
    <Section fill style={{ height: '100%', display: 'flex', flexDirection: 'column', minHeight: 0 }}>
      <Box fontSize={2} bold>{String(e.name ?? '')}</Box>
      <Box>{String(e.description ?? '')}</Box>
      <Box>{String(e.taste ?? '')}</Box>
      <Box fontSize={1.5} bold mt={1}>Specifications</Box>
      <LabeledList>
        <LabeledList.Item label="Type">{String(e.thing_nature ?? '')}</LabeledList.Item>
        {e.strength && <LabeledList.Item label="Alcohol Strength">{String(e.strength)}</LabeledList.Item>}
        {e.temperature && <LabeledList.Item label="Served">{String(e.temperature)}</LabeledList.Item>}
        {e.nutrition && <LabeledList.Item label="Nourishment">{String(e.nutrition)}</LabeledList.Item>}
        {(recipe_data?.length ?? 0) > 0 && (
          <LabeledList.Item label="Recipe">
            {(recipe_data ?? []).map((data, index) => (
              <Box key={index} className="CatalogBook-entryBox" p={1}>
                <RecipeDisplay recipe_data={data} />
              </Box>
            ))}
          </LabeledList.Item>
        )}
      </LabeledList>
    </Section>
  );
};

const BookReagentsEntry = (props: { entry: Record<string, unknown> }) => {
  const e = props.entry;
  const heating = e.heating_decompose as { types: { name: string; type: string }[] } | null | undefined;
  const chilling = e.chilling_decompose as { types: { name: string; type: string }[] } | null | undefined;
  const result_of = e.result_of_decomposition_in as { name: string; type: string }[] | null | undefined;
  const recipe_data = e.recipe_data as Array<Record<string, unknown>> | null | undefined;
  const can_be_used_in = e.can_be_used_in as { name: string; type: string }[] | null | undefined;
  const nsa = e.nsa as number | undefined;

  return (
    <Section fill style={{ height: '100%', display: 'flex', flexDirection: 'column', minHeight: 0 }}>
      <Box fontSize={2} bold>{String(e.name ?? '')}</Box>
      <Box>{String(e.description ?? '')}</Box>
      <Box>{String(e.taste ?? '')}</Box>
      {!e.scannable && <Box>Impossible to scan.</Box>}
      <Box fontSize={1.5} bold mt={1}>Specifications</Box>
      <LabeledList>
        {e.reagent_type && <LabeledList.Item label="Type">{String(e.reagent_type)}</LabeledList.Item>}
        {e.reagent_state && <LabeledList.Item label="Phase">{String(e.reagent_state)} at STP</LabeledList.Item>}
        {e.color && (
          <LabeledList.Item label="Color">
            <ColorBox color={String(e.color)} width={3} />
          </LabeledList.Item>
        )}
        {e.metabolism_blood && (
          <LabeledList.Item label="Metabolism">
            <Box>{Number(e.metabolism_blood)}u/s in blood</Box>
            {e.metabolism_stomach ? (
              <Box>{Number(e.metabolism_stomach)}u/s in stomach</Box>
            ) : (
              <Box>{Number(e.metabolism_blood) / 2}u/s in stomach</Box>
            )}
          </LabeledList.Item>
        )}
        <LabeledList.Item label="NSA">{nsa != null ? nsa : 0} units</LabeledList.Item>
        {e.addiction_threshold && <LabeledList.Item label="Addiction Threshold">{Number(e.addiction_threshold)}u</LabeledList.Item>}
        {e.addiction_chance && <LabeledList.Item label="Addiction Chance">{String(e.addiction_chance)}</LabeledList.Item>}
        {e.overdose && <LabeledList.Item label="Overdose At">{Number(e.overdose)}u</LabeledList.Item>}
        {(heating?.types?.length ?? 0) > 0 && (
          <LabeledList.Item label={`Decomposition Above ${e.heating_point}K`}>
            <Box className="CatalogBook-entryBox" p={1}>
              {(heating?.types ?? []).map((typ) => (
                <Box key={typ.type} inline style={{ marginRight: '0.5em' }}>{typ.name}</Box>
              ))}
            </Box>
          </LabeledList.Item>
        )}
        {(chilling?.types?.length ?? 0) > 0 && (
          <LabeledList.Item label={`Decomposition Below ${e.chilling_point}K`}>
            <Box className="CatalogBook-entryBox" p={1}>
              {(chilling?.types ?? []).map((typ) => (
                <Box key={typ.type} inline style={{ marginRight: '0.5em' }}>{typ.name}</Box>
              ))}
            </Box>
          </LabeledList.Item>
        )}
        {(result_of?.length ?? 0) > 0 && (
          <LabeledList.Item label="Result Of Decomposition">
            <Box className="CatalogBook-entryBox" p={1}>
              {(result_of ?? []).map((d) => (
                <Box key={d.type} inline style={{ marginRight: '0.5em' }}>{d.name}</Box>
              ))}
            </Box>
          </LabeledList.Item>
        )}
        {(recipe_data?.length ?? 0) > 0 && (
          <LabeledList.Item label="Recipe">
            {(recipe_data ?? []).map((data, index) => (
              <Box key={index} className="CatalogBook-entryBox" p={1}>
                <RecipeDisplay recipe_data={data} />
              </Box>
            ))}
          </LabeledList.Item>
        )}
        {(can_be_used_in?.length ?? 0) > 0 && (
          <LabeledList.Item label="Takes Part In Reactions">
            <Box className="CatalogBook-entryBox" p={1}>
              {(can_be_used_in ?? []).map((r) => (
                <Box key={r.type} inline style={{ marginRight: '0.5em' }}>{r.name}</Box>
              ))}
            </Box>
          </LabeledList.Item>
        )}
      </LabeledList>
    </Section>
  );
};

/** Display-only recipe (no links). */
const RecipeDisplay = (props: { recipe_data: Record<string, unknown> }) => {
  const d = props.recipe_data;
  const reagents = d.reagents as Array<{ parts: string; reagent: string }> | null | undefined;
  const catalyst = d.catalyst as Array<{ units: number; reagent: string }> | null | undefined;
  const inhibitors = d.inhibitors as Array<{ reagent: string }> | null | undefined;
  const byproducts = d.byproducts as Array<{ reagent: string }> | null | undefined;
  const minT = d.minimum_temperature as number | null | undefined;
  const maxT = d.maximum_temperature as number | null | undefined;
  let temperature = null;
  if (minT != null && maxT != null) {
    temperature = <Box>At temperatures between {minT}K and {maxT}K</Box>;
  } else if (minT != null) {
    temperature = <Box>At temperatures above {minT}K</Box>;
  } else if (maxT != null) {
    temperature = <Box>At temperatures below {maxT}K</Box>;
  }
  return (
    <Box>
      {reagents?.map((v) => (
        <Box key={v.reagent}>{v.parts} of {v.reagent}</Box>
      ))}
      {catalyst?.map((v) => (
        <Box key={v.reagent}>In presence of {v.units}u of {v.reagent}</Box>
      ))}
      {inhibitors?.map((v) => (
        <Box key={v.reagent}>Without presence of {v.reagent}</Box>
      ))}
      {byproducts?.map((v) => (
        <Box key={v.reagent}>Additional Creation of {v.reagent}</Box>
      ))}
      {temperature}
      {d.required_object && <Box>Should take place inside of {String(d.required_object)}</Box>}
      <Box>Results in {String(d.result_amount ?? '')} of substance</Box>
    </Box>
  );
};
