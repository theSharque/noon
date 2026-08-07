export const GALAXY_BG = '/app/img/ships/galaxy-bg.jpg';
export const GALAXY_MAX_RADIUS = 3000;
export const GALAXY_BG_SIZE = GALAXY_MAX_RADIUS;
export const GALAXY_BG_HALF = GALAXY_BG_SIZE / 2;

export const RING_R = 4.5;
export const HOME_RING_R = RING_R;
export const FRIEND_RING_R = RING_R + 1;
export const FOE_RING_R = FRIEND_RING_R;
export const ROUTE_RING_R = RING_R;
export const RING_STROKE = 1.2;
export const QUEST_MARK_S = 10;
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

export function clampGalaxyPoint(x, y) {
  const len = Math.hypot(x, y);
  if (len <= 0 || len <= GALAXY_MAX_RADIUS) {
    return { x: Math.round(x), y: Math.round(y) };
  }
  const scale = GALAXY_MAX_RADIUS / len;
  return { x: Math.round(x * scale), y: Math.round(y * scale) };
}

export function sameGalaxyPoint(a, b) {
  if (!a || !b) return false;
  return a.x === b.x && a.y === b.y;
}

export function routeIncludesPoint(route, point) {
  if (!point || !route?.length) return false;
  return route.some((wp) => sameGalaxyPoint(wp, point));
}

export function isGalaxyPointValid(x, y) {
  return Math.hypot(x, y) <= GALAXY_MAX_RADIUS;
}

export const ROUTE_HIT_R = 6;

export function isNearPoint(x, y, px, py, radius = ROUTE_HIT_R) {
  const dx = px - x;
  const dy = py - y;
  return dx * dx + dy * dy <= radius * radius;
}

export function routeMaxWaypoints(routeSkill) {
  const skill = parseInt(routeSkill, 10) || 0;
  if (skill <= 0) return 1;
  return skill + 1;
}

export function applyRouteWaypoint(route, snap, routeSkill) {
  const max = routeMaxWaypoints(routeSkill);
  if (max <= 1) {
    return [snap];
  }
  if (!route?.length) {
    return [snap];
  }
  if (route.length < max) {
    return [...route, snap];
  }
  return [...route.slice(0, -1), snap];
}

export function formatRoutePts(waypoints) {
  return (waypoints || [])
    .map((p) => `${parseInt(p.x, 10)},${parseInt(p.y, 10)}`)
    .join(';');
}

export function parseRoutePts(rpts) {
  if (!rpts) return [];
  return String(rpts)
    .split(';')
    .map((chunk) => chunk.trim())
    .filter(Boolean)
    .map((chunk) => {
      const [xs, ys] = chunk.split(',');
      return { x: parseInt(xs, 10), y: parseInt(ys, 10) };
    })
    .filter((p) => Number.isFinite(p.x) && Number.isFinite(p.y));
}

export function findRouteWaypointIndex(x, y, waypoints, radius = ROUTE_HIT_R) {
  if (!waypoints?.length) return -1;
  for (let i = waypoints.length - 1; i >= 0; i -= 1) {
    const p = waypoints[i];
    if (isNearPoint(x, y, p.x, p.y, radius)) return i;
  }
  return -1;
}

export function routePolylinePoints(ship, waypoints) {
  const pts = [];
  if (ship) pts.push(`${ship.x},${ship.y}`);
  for (const p of waypoints || []) {
    pts.push(`${p.x},${p.y}`);
  }
  return pts.join(' ');
}
