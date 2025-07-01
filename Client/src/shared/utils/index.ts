// Utilidades globales

/**
 * Concatena clases condicionalmente (similar a clsx/classnames)
 * @param {...(string | false | null | undefined)[]} args
 * @returns {string}
 */
export function cn(...args: (string | false | null | undefined)[]): string {
  return args.filter(Boolean).join(' ')
} 