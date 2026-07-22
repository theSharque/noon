export const GALAXY_BG = '/app/img/ships/galaxy-bg.jpg';
export const GALAXY_BG_SIZE = 2000;
export const GALAXY_BG_HALF = GALAXY_BG_SIZE / 2;

export const RING_R = 4.5;
export const RING_STROKE = 1.2;
export const QUEST_MARK_S = 8;
export const STAR_CORE_R = 0.7;
export const BH_GLOW_R = 10.4;
export const BH_CORE_R = 2.9;

export function isBlackHole(type) {
  return parseInt(type, 10) === 4;
}

export function starFill(type) {
  if (type === 'h') return '#ffffff';
  if (type === 'e') return '#00ff00';
  if (type === 'r') return '#ff4040';
  if (type === 's') return '#7ec8ff';
  if (type === 'f') return '#c77dff';
  const n = parseInt(type, 10);
  if (n === 1) return '#00ccff';
  if (n === 2) return '#ffff00';
  if (n === 3) return '#ff2020';
  if (n === 4) return '#c800ff';
  if (n === 5) return '#b8c4ff';
  return '#e8f6ff';
}

export function starGlowR(type) {
  const n = parseInt(type, 10);
  if (n === 3 || n === 4) return 3.5;
  if (type === 'h' || type === 'e' || type === 'r') return 4;
  return 2.8;
}

export function ringStroke(kind) {
  if (kind === 'friend' || kind === 'home') return '#5cff8a';
  if (kind === 'foe') return '#ff6a6a';
  if (kind === 'aliance') return '#ffe566';
  if (kind === 'yellow') return 'var(--neon-cyan)';
  return '#ffffff';
}

export function computeGalaxyBounds(stars = []) {
  let minX = -GALAXY_BG_HALF;
  let minY = -GALAXY_BG_HALF;
  let maxX = GALAXY_BG_HALF;
  let maxY = GALAXY_BG_HALF;
  for (const s of stars) {
    minX = Math.min(minX, s.x - 40);
    minY = Math.min(minY, s.y - 40);
    maxX = Math.max(maxX, s.x + 40);
    maxY = Math.max(maxY, s.y + 40);
  }
  return { minX, minY, maxX, maxY };
}

export function galaxyCenterOffset(viewport, bounds, cx, cy) {
  if (!viewport) return { x: 0, y: 0 };
  return {
    x: viewport.clientWidth / 2 - (cx - bounds.minX),
    y: viewport.clientHeight / 2 - (cy - bounds.minY),
  };
}

export function galaxyLocalPoint(viewport, offset, bounds, e) {
  if (!viewport) return null;
  const rect = viewport.getBoundingClientRect();
  return {
    x: e.clientX - rect.left - offset.x + bounds.minX - 2,
    y: e.clientY - rect.top - offset.y + bounds.minY - 1,
  };
}
