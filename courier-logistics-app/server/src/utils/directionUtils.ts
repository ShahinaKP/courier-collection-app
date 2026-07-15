const DIRECTION_MAP: Record<string, Record<string, string>> = {
  "RG-N": {
    "RG-N": "north",
    "RG-S": "south",
    "RG-E": "east",
    "RG-W": "west",
    "RG-C": "south",
  },
  "RG-S": {
    "RG-S": "south",
    "RG-N": "north",
    "RG-E": "east",
    "RG-W": "west",
    "RG-C": "north",
  },
  "RG-E": {
    "RG-E": "east",
    "RG-N": "north",
    "RG-S": "south",
    "RG-W": "west",
    "RG-C": "west",
  },
  "RG-W": {
    "RG-W": "west",
    "RG-N": "north",
    "RG-S": "south",
    "RG-E": "east",
    "RG-C": "east",
  },
  "RG-C": {
    "RG-C": "central",
    "RG-N": "north",
    "RG-S": "south",
    "RG-E": "east",
    "RG-W": "west",
  },
};

export const getDirection = (
  fromRegionCode: string,
  toRegionCode: string,
): string => {
  return DIRECTION_MAP[fromRegionCode]?.[toRegionCode] ?? "central";
};
