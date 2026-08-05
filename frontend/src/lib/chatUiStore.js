import { writable } from 'svelte/store';

const KEY = 'noon.chatCollapsed';

function readCollapsed() {
  if (typeof localStorage === 'undefined') return false;
  try {
    return localStorage.getItem(KEY) === '1';
  } catch {
    return false;
  }
}

export const chatCollapsed = writable(readCollapsed());

export function setChatCollapsed(value) {
  const v = Boolean(value);
  chatCollapsed.set(v);
  if (typeof localStorage !== 'undefined') {
    try {
      localStorage.setItem(KEY, v ? '1' : '0');
    } catch {
      /* ignore quota / private mode */
    }
  }
  return v;
}
