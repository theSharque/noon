export const SYSTEM_MAX_RADIUS = 800;
export const SYSTEM_MIN_RADIUS = 25;
export const SYSTEM_PADDING = 40;
export const SYSTEM_BG_SIZE = (SYSTEM_MAX_RADIUS + SYSTEM_PADDING) * 2;

export function systemPlanetXy(angleDeg, orb) {
  const rad = (angleDeg * Math.PI) / 180;
  return {
    x: Math.round(Math.sin(rad) * orb),
    y: Math.round(Math.cos(rad) * orb * 0.75),
  };
}

export function computeSystemBounds() {
  const r = SYSTEM_MAX_RADIUS + SYSTEM_PADDING;
  return { minX: -r, minY: -r, maxX: r, maxY: r };
}

export function systemCenterOffset(viewport, bounds, cx, cy) {
  if (!viewport) return { x: 0, y: 0 };
  return systemClampOffset(viewport, bounds, {
    x: viewport.clientWidth / 2 - (cx - bounds.minX),
    y: viewport.clientHeight / 2 - (cy - bounds.minY),
  });
}

export function systemClampOffset(viewport, bounds, offset) {
  if (!viewport) return offset;
  const vw = viewport.clientWidth;
  const vh = viewport.clientHeight;
  const mw = bounds.maxX - bounds.minX;
  const mh = bounds.maxY - bounds.minY;
  const minX = vw >= mw ? (vw - mw) / 2 : vw - mw;
  const maxX = vw >= mw ? (vw - mw) / 2 : 0;
  const minY = vh >= mh ? (vh - mh) / 2 : vh - mh;
  const maxY = vh >= mh ? (vh - mh) / 2 : 0;
  return {
    x: Math.min(maxX, Math.max(minX, offset.x)),
    y: Math.min(maxY, Math.max(minY, offset.y)),
  };
}

export function systemLocalPoint(viewport, offset, bounds, e) {
  if (!viewport) return null;
  const rect = viewport.getBoundingClientRect();
  return {
    x: e.clientX - rect.left - offset.x + bounds.minX - 2,
    y: e.clientY - rect.top - offset.y + bounds.minY - 1,
  };
}

export function clampSystemPoint(x, y) {
  const len = Math.hypot(x, y);
  if (len <= 0 || len <= SYSTEM_MAX_RADIUS) {
    return { x: Math.round(x), y: Math.round(y) };
  }
  const scale = SYSTEM_MAX_RADIUS / len;
  return { x: Math.round(x * scale), y: Math.round(y * scale) };
}

export function isSystemPointValid(x, y) {
  const len = Math.hypot(x, y);
  return len >= SYSTEM_MIN_RADIUS && len <= SYSTEM_MAX_RADIUS;
}
