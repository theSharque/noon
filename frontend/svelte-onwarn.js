export function svelteOnWarn(warning, defaultHandler) {
  if (warning.code?.startsWith('a11y-')) return;
  if (warning.code === 'css-unused-selector') return;
  defaultHandler(warning);
}
