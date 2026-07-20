import { writable } from 'svelte/store';

export const mailLastId = writable(0);
export const mailHasUnread = writable(false);

export function markMailSeen(maxId) {
  if (maxId > 0) mailLastId.set(maxId);
  mailHasUnread.set(false);
}
