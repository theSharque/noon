export const INDEEP_BG = '/app/img/place/indeep-bg.jpg';

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

export function createIndeepField(seed = Date.now()) {
  const rand = mulberry32(seed >>> 0);
  const stars = [];
  for (let i = 0; i < 520; i++) {
    stars.push({
      x: rand(),
      y: rand(),
      r: 0.3 + rand() * 1.05,
      a: 0.18 + rand() * 0.55,
      tw: rand() * Math.PI * 2,
      twSpeed: 0.3 + rand() * 1.0,
      cool: rand() > 0.55,
    });
  }
  return { stars, seed };
}

export function stepIndeepField(field, dt) {
  for (const s of field.stars) {
    s.tw += s.twSpeed * dt;
  }
}

function drawBackdrop(ctx, img, w, h, alpha = 0.22) {
  if (!img || !img.complete || !img.naturalWidth) return;
  const scale = 2.5;
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
  const g = ctx.createRadialGradient(cx, cy, r * 0.15, cx, cy, r);
  g.addColorStop(0, 'rgba(0,0,0,0)');
  g.addColorStop(0.5, 'rgba(2,4,12,0.4)');
  g.addColorStop(1, 'rgba(0,0,0,0.82)');
  ctx.fillStyle = g;
  ctx.fillRect(0, 0, w, h);
}

export function drawIndeepField(ctx, field, layout, tSec = 0) {
  const { w, h, bgImg } = layout;
  ctx.fillStyle = '#02040a';
  ctx.fillRect(0, 0, w, h);

  drawBackdrop(ctx, bgImg, w, h, 0.7);
  drawVignette(ctx, w, h);

  for (const s of field.stars) {
    const twinkle = 0.5 + 0.5 * Math.sin(s.tw + tSec * 0.12);
    ctx.globalAlpha = s.a * twinkle;
    ctx.fillStyle = s.cool ? '#b8d4ff' : '#e8f4ff';
    ctx.beginPath();
    ctx.arc(s.x * w, s.y * h, s.r, 0, Math.PI * 2);
    ctx.fill();
  }
  ctx.globalAlpha = 1;
}
