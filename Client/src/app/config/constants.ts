// constants.ts

export const REGEX_EMAIL: RegExp = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
export const REGEX_URL: RegExp =
  /^(https?:\/\/)?([\w-]+(\.[\w-]+)+)([\w.,@?^=%&:/~+#-]*[\w@?^=%&/~+#-])?$/;
export const REGEX_TEL: RegExp =
  /^[+]?[(]?[0-9]{3}[)]?[-\s.]?[0-9]{3}[-\s.]?[0-9]{4,6}$/;

export const DEFAULT_INPUT_MIN_LENGTH: number = 0;
export const DEFAULT_INPUT_MAX_LENGTH: number = 255;

export const DEFAULT_INPUT_MIN_NUMBER: number = 0;
export const DEFAULT_INPUT_MAX_NUMBER: number = 100;

export const DEFAULT_INPUT_MIN_DATE: string = new Date('1900-01-01')
  .toISOString()
  .split('T')[0];
export const DEFAULT_INPUT_MAX_DATE: string = new Date('2100-12-31')
  .toISOString()
  .split('T')[0];
