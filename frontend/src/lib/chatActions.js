import { writable } from 'svelte/store';

export const playerAbout = writable(null);

export function openPlayerAbout(login) {
  playerAbout.set(login);
}

export function clearPlayerAbout() {
  playerAbout.set(null);
}
