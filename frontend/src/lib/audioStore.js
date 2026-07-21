import { writable } from 'svelte/store';
import { getNoonConfig } from './api.js';

function clampVol(vol, fallback) {
  const n = Number(vol);
  if (!Number.isFinite(n)) return fallback;
  return Math.max(0, Math.min(100, n));
}

const cfg = getNoonConfig();

export const musicVolume = writable(clampVol(cfg.mv, 0));
export const soundVolume = writable(clampVol(cfg.sv, 50));

export function setMusicVolumeLocal(vol) {
  const v = clampVol(vol, 0);
  musicVolume.set(v);
  if (typeof window !== 'undefined' && window.__NOON__) {
    window.__NOON__.mv = v;
  }
  return v;
}

export function setSoundVolumeLocal(vol) {
  const v = clampVol(vol, 50);
  soundVolume.set(v);
  if (typeof window !== 'undefined' && window.__NOON__) {
    window.__NOON__.sv = v;
  }
  return v;
}
