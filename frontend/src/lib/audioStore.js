import { writable } from 'svelte/store';
import { getNoonConfig } from './api.js';

const cfg = getNoonConfig();

export const musicVolume = writable(Number(cfg.mv) || 0);
export const soundVolume = writable(Number(cfg.sv) || 50);

export function setMusicVolumeLocal(vol) {
  const v = Math.max(0, Math.min(100, Number(vol) || 0));
  musicVolume.set(v);
  if (typeof window !== 'undefined' && window.__NOON__) {
    window.__NOON__.mv = v;
  }
  return v;
}

export function setSoundVolumeLocal(vol) {
  const v = Math.max(0, Math.min(100, Number(vol) || 0));
  soundVolume.set(v);
  if (typeof window !== 'undefined' && window.__NOON__) {
    window.__NOON__.sv = v;
  }
  return v;
}
