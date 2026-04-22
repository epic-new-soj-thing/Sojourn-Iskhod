import { toTitleCase } from 'common/string';
import { useEffect, useState } from 'react';
import { Box } from 'tgui/components';

export enum SecurityLevelEnum {
  GREEN = 'code green',
  VIOLET = 'code violet',
  ORANGE = 'code orange',
  BLUE = 'code blue',
  RED = 'code red',
  DELTA = 'code delta',
}

export const SecurityLevelData: Record<
  string,
  { color: string }
> = {
  [SecurityLevelEnum.GREEN]: {
    color: '#23e870',
  },
  [SecurityLevelEnum.VIOLET]: {
    color: '#b787f0',
  },
  [SecurityLevelEnum.ORANGE]: {
    color: '#f0a030',
  },
  [SecurityLevelEnum.BLUE]: {
    color: '#45b6ea',
  },
  [SecurityLevelEnum.RED]: {
    color: '#fa4c41',
  },
};

export type ColoredSecurityLevelProps = {
  security_level: string;
};

export const ColoredSecurityLevel = (props: ColoredSecurityLevelProps) => {
  const { security_level } = props;

  if (security_level === SecurityLevelEnum.DELTA) {
    return <DeltaSecurityLevel />;
  }

  const data = SecurityLevelData[security_level];

  return (
    <Box inline color={data?.color ?? '#fff'}>
      {data ? toTitleCase(security_level) : security_level}
    </Box>
  );
};

export const DeltaSecurityLevel = (props) => {
  const DELTA_STRING = 'CODE DELTA';

  const [letterIdx, setLetterIdx] = useState(0);

  // Lower to make it animate faster
  const SPEED = 200;

  useEffect(() => {
    const id = setInterval(() => {
      setLetterIdx((idx) => {
        let new_idx = (idx + 1) % DELTA_STRING.length;
        if (DELTA_STRING[new_idx] === ' ') {
          new_idx += 1;
        }
        return new_idx;
      });
    }, SPEED);
    return () => clearInterval(id);
  }, []);

  return (
    <Box as="span" inline color="#f00" bold>
      {DELTA_STRING.substring(0, letterIdx)}
      <Box as="span" inline color="#45b6ea" bold>
        {DELTA_STRING.substring(letterIdx, letterIdx + 1)}
      </Box>
      {DELTA_STRING.substring(letterIdx + 1)}
    </Box>
  );
};
