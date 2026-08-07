export const GALAXY_BG = '/app/img/ships/galaxy-bg.jpg';
export const GALAXY_MAX_RADIUS = 3000;
export const GALAXY_STAR_SNAP = 10;
export const ROUTE_AUTONAV_PAD_MIN = 40;
export const ROUTE_AUTONAV_PAD_RATIO = 0.12;
export const ROUTE_AUTONAV_EDGE_MAX = 400;
export const ROUTE_AUTONAV_FUEL_SAVE = 0.05;
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

export function isGalaxyStarPoint(point, stars) {
  if (!point || !stars?.length) return false;
  return stars.some((s) => s.x === point.x && s.y === point.y);
}

export function applyGalaxyRouteClick(route, snap, routeSkill, stars) {
  const max = routeMaxWaypoints(routeSkill);
  if (max <= 1) {
    return [snap];
  }
  if (!route?.length) {
    return [snap];
  }
  const last = route[route.length - 1];
  if (isGalaxyStarPoint(last, stars)) {
    return applyRouteWaypoint(route, snap, routeSkill);
  }
  return [...route.slice(0, -1), snap];
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

export function hyperFuelNeed(len, hyperCnt, routeSkill) {
  const skill = parseInt(routeSkill, 10) || 0;
  const cnt = parseInt(hyperCnt, 10) || 0;
  let fuel = Math.round((len / 15.0) ** 2) * cnt;
  fuel -= Math.round((fuel / 100) * skill);
  return fuel;
}

function segmentFuel(x1, y1, x2, y2, hyperCnt, routeSkill) {
  const len = Math.round(Math.hypot(x2 - x1, y2 - y1));
  return hyperFuelNeed(len, hyperCnt, routeSkill);
}

function starsInCorridor(x1, y1, x2, y2, pad, stars) {
  const xmin = Math.min(x1, x2) - pad;
  const xmax = Math.max(x1, x2) + pad;
  const ymin = Math.min(y1, y2) - pad;
  const ymax = Math.max(y1, y2) + pad;
  const dx = x2 - x1;
  const dy = y2 - y1;
  const len2 = dx * dx + dy * dy;
  if (len2 <= 0) return [];

  const len = Math.sqrt(len2);
  const out = [];

  for (const star of stars || []) {
    if (star.x < xmin || star.x > xmax || star.y < ymin || star.y > ymax) continue;
    const px = star.x - x1;
    const py = star.y - y1;
    const proj = (px * dx + py * dy) / len2;
    if (proj < -0.01) continue;
    const perp = Math.abs(px * dy - py * dx) / len;
    if (perp > pad) continue;
    out.push(star);
  }

  return out;
}

function findStarAt(x, y, stars) {
  for (const star of stars || []) {
    if (star.x === x && star.y === y) return star;
  }
  return null;
}

export function planRouteSegment(fromX, fromY, to, stars, hyperCnt, routeSkill, maxWaypoints) {
  const max = parseInt(maxWaypoints, 10) || 1;
  if (max <= 1) return [to];

  const toX = to.x;
  const toY = to.y;
  const fuelDirect = segmentFuel(fromX, fromY, toX, toY, hyperCnt, routeSkill);
  const dx = toX - fromX;
  const dy = toY - fromY;
  const dist = Math.hypot(dx, dy);
  if (dist <= 0) return [to];

  const pad = Math.max(ROUTE_AUTONAV_PAD_MIN, Math.round(ROUTE_AUTONAV_PAD_RATIO * dist));
  const corridor = starsInCorridor(fromX, fromY, toX, toY, pad, stars);
  const toStar = findStarAt(toX, toY, stars);

  const nodes = [{ x: fromX, y: fromY, isEnd: false }];
  for (const star of corridor) {
    if (toStar && star.x === toStar.x && star.y === toStar.y) continue;
    nodes.push({ x: star.x, y: star.y, isEnd: false });
  }
  const endIdx = nodes.length;
  nodes.push({ x: toX, y: toY, isEnd: true });

  const n = nodes.length;
  const maxStars = max - 1;
  const distMap = new Map();
  const prev = new Map();
  const queue = [{ cost: 0, u: 0, starHops: 0 }];

  distMap.set('0:0', 0);

  while (queue.length) {
    let minI = 0;
    for (let qi = 1; qi < queue.length; qi += 1) {
      if (queue[qi].cost < queue[minI].cost) minI = qi;
    }
    const { cost, u, starHops } = queue[minI];
    queue.splice(minI, 1);

    const ukey = `${u}:${starHops}`;
    if (distMap.get(ukey) !== cost) continue;
    if (nodes[u].isEnd) continue;

    for (let v = 0; v < n; v += 1) {
      if (v === u || v === 0) continue;

      const edgeLen = Math.hypot(nodes[v].x - nodes[u].x, nodes[v].y - nodes[u].y);
      if (edgeLen > ROUTE_AUTONAV_EDGE_MAX) continue;

      const isEnd = nodes[v].isEnd;
      let newStarHops = starHops;

      if (isEnd) {
        if (starHops + 1 > max) continue;
      } else {
        newStarHops = starHops + 1;
        if (newStarHops > maxStars) continue;
      }

      const w = segmentFuel(nodes[u].x, nodes[u].y, nodes[v].x, nodes[v].y, hyperCnt, routeSkill);
      const newCost = cost + w;
      const vkey = `${v}:${newStarHops}`;

      if (!distMap.has(vkey) || newCost < distMap.get(vkey)) {
        distMap.set(vkey, newCost);
        prev.set(vkey, { node: u, starHops });
        queue.push({ cost: newCost, u: v, starHops: newStarHops });
      }
    }
  }

  let bestCost = null;
  let bestKey = null;
  for (let sh = 0; sh <= maxStars; sh += 1) {
    const ekey = `${endIdx}:${sh}`;
    if (!distMap.has(ekey)) continue;
    const c = distMap.get(ekey);
    if (bestCost === null || c < bestCost) {
      bestCost = c;
      bestKey = ekey;
    }
  }

  if (bestKey === null) return [to];

  const saveThreshold = fuelDirect * (1 - ROUTE_AUTONAV_FUEL_SAVE);
  if (bestCost >= saveThreshold) return [to];

  const pathNodes = [];
  let key = bestKey;
  while (prev.has(key)) {
    const colon = key.indexOf(':');
    const node = parseInt(key.slice(0, colon), 10);
    if (node !== 0 && !nodes[node].isEnd) pathNodes.unshift(node);
    const p = prev.get(key);
    key = `${p.node}:${p.starHops}`;
  }

  const segment = pathNodes.map((idx) => ({ x: nodes[idx].x, y: nodes[idx].y }));
  segment.push(to);
  return segment;
}

export function applyAutonavTail(shipPos, waypoints, stars, routeSkill, hyperCnt) {
  if (!waypoints?.length) return waypoints || [];
  if ((parseInt(routeSkill, 10) || 0) <= 1) return waypoints;

  const prefix = waypoints.length > 1 ? waypoints.slice(0, -1) : [];
  const to = waypoints[waypoints.length - 1];
  const remaining = routeMaxWaypoints(routeSkill) - prefix.length;
  if (remaining <= 1) return waypoints;

  let fromX;
  let fromY;
  if (prefix.length) {
    fromX = prefix[prefix.length - 1].x;
    fromY = prefix[prefix.length - 1].y;
  } else if (shipPos) {
    fromX = shipPos.x;
    fromY = shipPos.y;
  } else {
    return waypoints;
  }

  const segment = planRouteSegment(fromX, fromY, to, stars, hyperCnt, routeSkill, remaining);
  return [...prefix, ...segment];
}
