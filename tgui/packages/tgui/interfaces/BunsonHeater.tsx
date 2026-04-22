import { useBackend } from 'tgui/backend';
import { Button } from 'tgui/components';
import { Window } from 'tgui/layouts';
import {
  AnimatedNumber,
  Box,
  LabeledList,
  Section,
  Stack,
} from 'tgui-core/components';
import { round } from 'tgui-core/math';

import { Reagents } from './common/Reagents';

type Data = {
  mode: number; // 0 = off, 1 = heat, 2 = cool
  beaker: Reagents | null;
};

export const BunsonHeater = (props) => {
  const { act, data } = useBackend<Data>();

  const { mode, beaker } = data;

  return (
    <Window width={320} height={380}>
      <Window.Content scrollable>
        <Section title="Mode">
          <Stack fill>
            <Stack.Item grow>
              <Button
                fluid
                fontSize={1.25}
                icon="power-off"
                selected={mode === 0}
                onClick={() => act('mode', { mode: 0 })}
              >
                Off
              </Button>
            </Stack.Item>
            <Stack.Item grow>
              <Button
                fluid
                fontSize={1.25}
                icon="fire"
                selected={mode === 1}
                onClick={() => act('mode', { mode: 1 })}
              >
                Heat
              </Button>
            </Stack.Item>
            <Stack.Item grow>
              <Button
                fluid
                fontSize={1.25}
                icon="snowflake"
                selected={mode === 2}
                onClick={() => act('mode', { mode: 2 })}
              >
                Cool
              </Button>
            </Stack.Item>
          </Stack>
        </Section>
        <Section
          title={
            'Beaker ' +
            (beaker ? ` (${beaker.total_volume}/${beaker.maximum_volume})` : '')
          }
          buttons={
            <Button icon="eject" onClick={() => act('eject')}>
              Eject
            </Button>
          }
        >
          {beaker ? (
            <Box>
              <LabeledList>
                <LabeledList.Item label="Current temperature">
                  <AnimatedNumber
                    value={beaker.chem_temp}
                    format={(val) => round(val, 1) + ' K'}
                  />
                </LabeledList.Item>
              </LabeledList>
              {beaker.contents.length ? (
                beaker.contents.map((r) => (
                  <Box key={r.id} color="label">
                    {r.volume} unit{r.volume === 1 ? '' : 's'} {r.name}
                  </Box>
                ))
              ) : (
                <Box color="bad">Beaker empty</Box>
              )}
            </Box>
          ) : (
            <Box color="average">No beaker loaded.</Box>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
