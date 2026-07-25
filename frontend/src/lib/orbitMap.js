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
