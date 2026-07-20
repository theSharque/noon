import { push } from 'svelte-spa-router';

export function openPlayerAbout(login) {
  if (!login) return;
  push(`/about?login=${encodeURIComponent(login)}`);
}
