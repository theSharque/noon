export const PLANET_IMG = '/app/img/planet';
export const CELL_W = 120;
export const CELL_H = 60;
export const TILE_W = 130;
export const TILE_H = 100;
export const ORIGIN_X = TILE_W / 2;
export const ORIGIN_Y = TILE_H / 2;

export const TERRAIN_COLORS = {
  '0': '#0066CC',
  '1': '#663300',
  '2': '#999999',
  '3': '#CCCCCC',
  '4': '#CCCC33',
  '5': '#006600',
  '6': '#009900',
  '7': '#006600',
  '8': '#DDDDDD',
  '9': '#DD9900',
};

export const BLD_LABELS = {
  A: 'Академия',
  B: 'Строительство',
  C: 'Капсула',
  K: 'Карьер',
  P: 'Нанодиспенсер',
  L: 'Лаборатория',
  F: 'Завод',
  E: 'Электростанция',
  M: 'Шахта',
  O: 'Буровая',
  S: 'Склад',
  R: 'Сборочный цех',
  D: 'Ракетная защита',
  H: 'Лазерная защита',
  J: 'Плазменная защита',
  N: 'Микроволновый мазер',
  U: 'Планетарный щит',
};

export function cellCenterX(x, y) {
  return y % 2 === 0 ? x * CELL_W : x * CELL_W + CELL_W / 2;
}

export function cellCenterY(y) {
  return y * CELL_H;
}

export function cellX(x, y) {
  return cellCenterX(x, y) + ORIGIN_X;
}

export function cellY(y) {
  return cellCenterY(y) + ORIGIN_Y;
}

export function terrainColor(ch) {
  return TERRAIN_COLORS[ch] || '#FFFFFF';
}

export function terrainSrc(ch) {
  return `${PLANET_IMG}/jpeg${ch}.png`;
}

export function buildingSrc(ch) {
  return `${PLANET_IMG}/bld${ch}.png`;
}

export function decorSrc(ch) {
  return `${PLANET_IMG}/fg${ch}.png`;
}

export function hitTest(mapX, mapY, width, height) {
  const mx = mapX - ORIGIN_X;
  const my = mapY - ORIGIN_Y;
  let giY = Math.floor((my + 30) * 2 / 120);
  let giX = Math.floor(((mx + 60) - 60 * Math.floor(((my + 30) % 120) / 60)) / 120);
  if (giX < 0) giX = 0;
  if (giY < 0) giY = 0;
  if (giX >= width) giX = width - 1;
  if (giY >= height) giY = height - 1;
  return { x: giX, y: giY };
}

export function mapPixelSize(width, height) {
  return {
    w: Math.max(TILE_W, (width - 1) * CELL_W + CELL_W / 2 + TILE_W),
    h: Math.max(TILE_H, (height - 1) * CELL_H + TILE_H),
  };
}

export function timerColor(eventType, cycles, bldChar) {
  if (cycles < 0) return '#FF00FF';
  switch (String(eventType)) {
    case '1':
      return '#FF4040';
    case '2':
      return '#00FF00';
    case '3':
      return '#00FFFF';
    case '4':
      return '#FFFF00';
    case '5':
      return '#00FFFF';
    default:
      if (bldChar === 'K' || bldChar === 'M' || bldChar === 'O') return '#FFFFFF';
      return '#000000';
  }
}

export function formatRemain(seconds) {
  let diff = Math.max(0, Math.floor(seconds));
  const vD = Math.floor(diff / 86400);
  diff %= 86400;
  const vH = Math.floor(diff / 3600);
  diff %= 3600;
  const vM = Math.floor(diff / 60);
  const vS = diff % 60;
  const pad = (n) => (n >= 10 ? String(n) : `0${n}`);
  let s = vD > 0 ? `${vD}.` : '';
  s += `${pad(vH)}:${pad(vM)}:${pad(vS)}`;
  return s;
}

export function timerPos(x, y) {
  return {
    x: cellCenterX(x, y) - 60 + ORIGIN_X,
    y: cellCenterY(y) - 60 + ORIGIN_Y,
  };
}

export function tileDrawPos(x, y) {
  return {
    x: cellCenterX(x, y) + ORIGIN_X - TILE_W / 2,
    y: cellCenterY(y) + ORIGIN_Y - TILE_H / 2,
  };
}

export function selectionPos(x, y) {
  return tileDrawPos(x, y);
}

export const HEX_POINTS = '65,2 128,34 128,65 65,97 2,65 2,34';

export function clampMapOffset(ox, oy, mapW, mapH, viewW, viewH, zoom) {
  const scaledW = mapW / zoom;
  const scaledH = mapH / zoom;
  let x = ox;
  let y = oy;
  if (x + scaledW < viewW + 100) x = -scaledW + viewW + 100;
  if (y + scaledH < viewH) y = -scaledH + viewH;
  if (x > 400) x = Math.min(400, viewW * 0.4);
  if (y > 80) y = Math.min(80, viewH * 0.15);
  return { x, y };
}
