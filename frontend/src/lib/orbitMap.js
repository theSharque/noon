export const ORBIT_IMG = '/app/img/orbit';
export const CELL = 100;
export const SLOT_W = 150;
export const SLOT_H = 150;

export const BLD_LABELS = {
  B: 'Строительство',
  T: 'Торговая станция',
  A: 'Электростанция',
  I: 'Хранилище',
  G: 'Геоспутник',
  Q: 'Орб. сбор. цех',
  W: 'Орб. газ. сбор.',
  V: 'Лазерный спутник',
  X: 'Плазменый спутник',
  Y: 'Квантовый генератор',
  Z: 'Термоядерный преобразователь',
};

export function planetBgSrc(pid) {
  const n = parseInt(pid, 10);
  const id = Number.isFinite(n) && n >= 1 && n <= 5 ? n : 1;
  return `/images/p${id}.png`;
}

export function orbitPlanetFullSize(viewW, viewH) {
  const vmin = Math.min(viewW || 0, viewH || 0);
  return Math.min(vmin * 0.7, 520);
}

export function planetApproachScale(progress) {
  const t = Math.max(0, Math.min(1, Number(progress) || 0));
  const s0 = 0.01;
  const s80 = 0.1;
  const s1 = 1;
  const v0 = 0.05;
  const v80 = 0.35;
  const v1 = 8;
  if (t <= 0.8) {
    const u = t / 0.8;
    return hermite(s0, s80, v0 * 0.8, v80 * 0.8, u);
  }
  const u = (t - 0.8) / 0.2;
  return hermite(s80, s1, v80 * 0.2, v1 * 0.2, u);
}

function hermite(p0, p1, m0, m1, u) {
  const u2 = u * u;
  const u3 = u2 * u;
  return (
    (2 * u3 - 3 * u2 + 1) * p0 +
    (u3 - 2 * u2 + u) * m0 +
    (-2 * u3 + 3 * u2) * p1 +
    (u3 - u2) * m1
  );
}

export function emptySrc() {
  return `${ORBIT_IMG}/jpeg0.png`;
}

export function buildingSrc(ch) {
  return `${ORBIT_IMG}/bld${ch}.png`;
}

export function hitTest(mapX, length) {
  let giX = Math.floor((mapX + 50) / CELL);
  if (giX < 0) giX = 0;
  if (giX >= length) giX = Math.max(0, length - 1);
  return giX;
}

export function slotCenterX(x) {
  return x * CELL;
}

export function mapPixelWidth(length) {
  return Math.max(CELL, (length - 1) * CELL + SLOT_W);
}

export function clampOrbitOffset(ox, mapW, viewW) {
  let x = ox;
  if (x > 400) x = 400;
  if (x + mapW < viewW + 100) x = -mapW + viewW + 100;
  if (mapW <= viewW) x = Math.max(0, (viewW - mapW) / 2);
  return x;
}

export function timerColor(eventType, cycles) {
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
      return '#FFFFFF';
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
