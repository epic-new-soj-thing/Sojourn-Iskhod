import { useBackend } from 'tgui/backend';
import { Button } from 'tgui/components';
import { Window } from 'tgui/layouts';
import {
  Box,
  Dimmer,
  Section,
  Slider,
  Table,
} from 'tgui-core/components';
import { round } from 'tgui-core/math';
import type { BooleanLike } from 'tgui-core/react';

type Reagent = {
  name: string;
  volume: number;
  mass: number;
  purity: number;
  type: string;
  log: string;
};

type Beaker = {
  currentVolume: number;
  maxVolume: number;
  contents: Reagent[];
};

type Data = {
  lowerRange: number;
  upperRange: number;
  processing: BooleanLike;
  eta: number;
  graphUpperRange: number;
  peakHeight: number;
  beaker1: Beaker | null;
  beaker2: Beaker | null;
  hasBeakerInHand: BooleanLike;
};

export const MassSpec = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    processing,
    lowerRange,
    upperRange,
    graphUpperRange,
    eta,
    beaker1,
    beaker2,
    hasBeakerInHand,
  } = data;

  const centerValue = (lowerRange + upperRange) / 2;
  const beaker1HasContents = beaker1?.contents?.length > 0;

  return (
    <Window width={600} height={550}>
      <Window.Content scrollable>
        {!!processing && (
          <Dimmer>
            <Box color="label">Purifying... {round(eta, 0)}s</Box>
          </Dimmer>
        )}
        <Section
          title="Controls"
          buttons={
            <Button
              icon="play"
              disabled={!beaker1 || !beaker2 || !beaker1HasContents || processing}
              onClick={() => act('activate')}
            >
              Start
            </Button>
          }
        >
          {(beaker1HasContents && (
            <Box>
              Mass range: {lowerRange} - {upperRange} (Eta: {round(eta, 0)}s)
            </Box>
          )) || (
            <Box color="average">Please insert an input beaker with reagents!</Box>
          )}
        </Section>

        <Section
          title={`Input beaker ${beaker1 ? `(${beaker1.currentVolume}/${beaker1.maxVolume} units)` : ''}`}
          buttons={
            beaker1 ? (
              <Button icon="eject" onClick={() => act('eject1')}>
                Eject
              </Button>
            ) : (
              <Button
                icon="plus"
                onClick={() => act('insert1')}
                style={{ opacity: hasBeakerInHand ? 1 : 0.5 }}
                tooltip={!hasBeakerInHand && 'You need to hold a container in your hand'}
                tooltipPosition="bottom-start"
              >
                Insert
              </Button>
            )
          }
        >
          {beaker1HasContents && (
            <Box color="label">Eta of selection: {round(eta, 0)} seconds</Box>
          )}
          {beaker1?.contents?.length > 0 ? (
            <Table>
              <Table.Row header>
                <Table.Cell>Reagent</Table.Cell>
                <Table.Cell>Mass</Table.Cell>
                <Table.Cell>Volume</Table.Cell>
                <Table.Cell>Purity</Table.Cell>
                <Table.Cell>Status</Table.Cell>
              </Table.Row>
              {beaker1.contents.map((reagent, i) => {
                const selected =
                  reagent.mass >= lowerRange && reagent.mass <= upperRange;
                return (
                  <Table.Row key={i} color={selected ? 'good' : undefined}>
                    <Table.Cell>{reagent.name}</Table.Cell>
                    <Table.Cell>{reagent.mass}</Table.Cell>
                    <Table.Cell>{reagent.volume}</Table.Cell>
                    <Table.Cell>{reagent.purity}%</Table.Cell>
                    <Table.Cell>{reagent.log}</Table.Cell>
                  </Table.Row>
                );
              })}
            </Table>
          ) : (
            <Box color="average">
              {beaker1 ? 'Beaker is empty.' : 'No beaker loaded.'}
            </Box>
          )}
        </Section>

        <Section
          title="Mass range"
        >
          <Box mb={1}>
            Lower: {lowerRange} — Upper: {upperRange}
          </Box>
          <Slider
            value={lowerRange}
            minValue={0}
            maxValue={centerValue}
            stepPixelSize={2}
            onChange={(e, value) => act('leftSlider', { value })}
          />
          <Slider
            value={upperRange}
            minValue={centerValue}
            maxValue={graphUpperRange}
            stepPixelSize={2}
            onChange={(e, value) => act('rightSlider', { value })}
          />
          <Slider
            value={centerValue}
            minValue={0}
            maxValue={graphUpperRange}
            stepPixelSize={2}
            onChange={(e, value) => act('centerSlider', { value })}
          />
        </Section>

        <Section
          title={`Output beaker ${beaker2 ? `(${beaker2.currentVolume}/${beaker2.maxVolume} units)` : ''}`}
          buttons={
            beaker2 ? (
              <Button icon="eject" onClick={() => act('eject2')}>
                Eject
              </Button>
            ) : (
              <Button
                icon="plus"
                onClick={() => act('insert2')}
                style={{ opacity: hasBeakerInHand ? 1 : 0.5 }}
                tooltip={!hasBeakerInHand && 'You need to hold a container in your hand'}
                tooltipPosition="bottom-start"
              >
                Insert
              </Button>
            )
          }
        >
          {beaker2?.contents?.length > 0 ? (
            <Table>
              <Table.Row header>
                <Table.Cell>Reagent</Table.Cell>
                <Table.Cell>Mass</Table.Cell>
                <Table.Cell>Volume</Table.Cell>
                <Table.Cell>Purity</Table.Cell>
                <Table.Cell>Status</Table.Cell>
              </Table.Row>
              {beaker2.contents.map((reagent, i) => (
                <Table.Row key={i}>
                  <Table.Cell>{reagent.name}</Table.Cell>
                  <Table.Cell>{reagent.mass}</Table.Cell>
                  <Table.Cell>{reagent.volume}</Table.Cell>
                  <Table.Cell>{reagent.purity}%</Table.Cell>
                  <Table.Cell>{reagent.log}</Table.Cell>
                </Table.Row>
              ))}
            </Table>
          ) : (
            <Box color="average">
              {beaker2 ? 'Beaker is empty.' : 'No beaker loaded.'}
            </Box>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
