import { writable } from 'svelte/store';

export const tutorialNavTick = writable(0);

export function bumpTutorialNav() {
  tutorialNavTick.update((n) => n + 1);
}
