import { isBlackHole, starFill } from './galaxyMap.js';

export function nebulaBgUrl(bgid) {
  const id = Math.max(0, parseInt(bgid, 10) || 0);
  return `/img/n${String(id).padStart(2, '0')}.jpg`;
}

function mulberry32(seed) {
  let a = seed >>> 0;
  return () => {
    a = (a + 0x6d2b79f5) >>> 0;
    let t = a;
    t = Math.imul(t ^ (t >>> 15), t | 1);
    t ^= t + Math.imul(t ^ (t >>> 7), t | 61);
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}

export function createInspaceField(starType, seed = Date.now()) {
  const rand = mulberry32(seed >>> 0);
  const stars = [];
  for (let i = 0; i < 420; i++) {
    stars.push({
      x: rand(),
      y: rand(),
      r: 0.35 + rand() * 1.1,
      a: 0.2 + rand() * 0.55,
      tw: rand() * Math.PI * 2,
      twSpeed: 0.35 + rand() * 0.9,
    });
  }
  return {
    stars,
    starType: parseInt(starType, 10) || 0,
    seed,
  };
}

export function stepInspaceField(field, dt) {
  for (const s of field.stars) {
    s.tw += s.twSpeed * dt;
  }
}

function drawNebula(ctx, img, w, h, alpha = 0.22) {
  if (!img || !img.complete || !img.naturalWidth) return;
  const scale = 4;
  const dw = w * scale;
  const dh = h * scale;
  const dx = (w - dw) / 2;
  const dy = (h - dh) / 2;
  ctx.save();
  ctx.globalAlpha = alpha;
  ctx.drawImage(img, dx, dy, dw, dh);
  ctx.restore();
}

function drawVignette(ctx, w, h) {
  const cx = w * 0.5;
  const cy = h * 0.5;
  const r = Math.hypot(cx, cy);
  const g = ctx.createRadialGradient(cx, cy, r * 0.2, cx, cy, r);
  g.addColorStop(0, 'rgba(0,0,0,0)');
  g.addColorStop(0.55, 'rgba(2,6,14,0.35)');
  g.addColorStop(1, 'rgba(0,0,0,0.78)');
  ctx.fillStyle = g;
  ctx.fillRect(0, 0, w, h);
}

function hexToRgb(hex) {
  const h = String(hex || '').replace('#', '');
  if (h.length !== 6) return { r: 200, g: 220, b: 255 };
  return {
    r: parseInt(h.slice(0, 2), 16),
    g: parseInt(h.slice(2, 4), 16),
    b: parseInt(h.slice(4, 6), 16),
  };
}

function drawCenterStar(ctx, cx, cy, radius, hex) {
  const { r, g, b } = hexToRgb(hex);
  const glow = ctx.createRadialGradient(cx, cy, 0, cx, cy, radius);
  glow.addColorStop(0, `rgba(${r},${g},${b},0.55)`);
  glow.addColorStop(0.25, `rgba(${r},${g},${b},0.22)`);
  glow.addColorStop(0.6, `rgba(${r},${g},${b},0.06)`);
  glow.addColorStop(1, `rgba(${r},${g},${b},0)`);
  ctx.globalAlpha = 1;
  ctx.fillStyle = glow;
  ctx.beginPath();
  ctx.arc(cx, cy, radius, 0, Math.PI * 2);
  ctx.fill();

  ctx.fillStyle = `rgba(${r},${g},${b},0.9)`;
  ctx.shadowColor = `rgba(${r},${g},${b},0.8)`;
  ctx.shadowBlur = 10;
  ctx.beginPath();
  ctx.arc(cx, cy, 2.2, 0, Math.PI * 2);
  ctx.fill();
  ctx.shadowBlur = 0;
}

export function drawInspaceField(ctx, field, layout, tSec = 0) {
  const {
    w,
    h,
    nebulaImg,
    nebulaAlpha = 0.22,
    showStar = true,
    showVignette = true,
    clearColor = '#03060c',
  } = layout;

  if (clearColor) {
    ctx.fillStyle = clearColor;
    ctx.fillRect(0, 0, w, h);
  }

  drawNebula(ctx, nebulaImg, w, h, nebulaAlpha);
  if (showVignette) drawVignette(ctx, w, h);

  const st = field.starType;
  if (showStar && st && !isBlackHole(st)) {
    const cx = w * 0.5;
    const cy = h * 0.5;
    drawCenterStar(ctx, cx, cy, Math.min(w, h) * 0.16, starFill(st));
  }

  for (const s of field.stars) {
    const twinkle = 0.55 + 0.45 * Math.sin(s.tw + tSec * 0.15);
    ctx.globalAlpha = s.a * twinkle;
    ctx.fillStyle = '#e8f4ff';
    ctx.beginPath();
    ctx.arc(s.x * w, s.y * h, s.r, 0, Math.PI * 2);
    ctx.fill();
  }
  ctx.globalAlpha = 1;
}
