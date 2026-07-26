import { isBlackHole, starFill } from './galaxyMap.js';
import { formatFlyTime, journeySpeed } from './inflyFx.js';

export { formatFlyTime, journeySpeed };

export function isInhyperEvent(et) {
  const n = parseInt(et, 10);
  return n === 4 || n === 5 || n === 104 || n === 105;
}

export function isHyperStarTarget(et) {
  const n = parseInt(et, 10);
  return n === 4 || n === 104;
}

export function showHyperTargetStar(et, starType) {
  if (!isHyperStarTarget(et)) return false;
  const st = parseInt(starType, 10);
  if (!st || isBlackHole(st)) return false;
  return true;
}

export function hyperTargetStarColor(starType) {
  return starFill(starType);
}

export function hyperFieldSpeed(journeySpeedFactor) {
  return 0.55 + 0.45 * Math.max(0, Math.min(1, journeySpeedFactor));
}

export function hyperHudPalette(starType) {
  return {
    bg: '#030308',
    hud: '#00e5ff',
    hudMuted: 'rgba(0, 229, 255, 0.55)',
    glow: 'rgba(0, 229, 255, 0.12)',
  };
}

const BLUE = { r: 74, g: 168, b: 255 };
const RED = { r: 255, g: 74, b: 74 };
const NEUTRAL = { r: 200, g: 208, b: 224 };

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

function clamp(v, a, b) {
  return Math.max(a, Math.min(b, v));
}

function smoothstep(edge0, edge1, x) {
  const t = clamp((x - edge0) / (edge1 - edge0), 0, 1);
  return t * t * (3 - 2 * t);
}

function lerp(a, b, t) {
  return a + (b - a) * t;
}

function lerpColor(c0, c1, t) {
  return {
    r: Math.round(lerp(c0.r, c1.r, t)),
    g: Math.round(lerp(c0.g, c1.g, t)),
    b: Math.round(lerp(c0.b, c1.b, t)),
  };
}

function rgba(c, a) {
  return `rgba(${c.r},${c.g},${c.b},${a})`;
}

function makeParticle(rand, kind) {
  const isStreak = kind === 'streak';
  return {
    kind,
    angle: rand() * Math.PI * 2,
    dist: rand(),
    speed: isStreak ? 0.85 + rand() * 1.15 : 0.18 + rand() * 0.35,
    speedNorm: isStreak ? 0.85 + rand() * 0.35 : 0.28 + rand() * 0.22,
    size: isStreak ? 0.3 + rand() * 0.65 : 0.45 + rand() * 0.9,
    phase: rand(),
  };
}

export function createInhyperField(starType, seed = Date.now()) {
  const rand = mulberry32(seed >>> 0);
  const hud = hyperHudPalette(starType);

  const motes = [];
  for (let i = 0; i < 150; i++) {
    motes.push(makeParticle(rand, 'mote'));
  }

  const streaks = [];
  for (let i = 0; i < 90; i++) {
    streaks.push(makeParticle(rand, 'streak'));
  }

  return { hud, motes, streaks, seed };
}

export function stepInhyperField(field, dt, journeySpeedFactor, w, h) {
  const cx = w * 0.5;
  const cy = h * 0.5;
  const maxR = Math.hypot(cx, cy) * 1.2;
  const fieldSpeed = hyperFieldSpeed(journeySpeedFactor);

  const moteStep = dt * (0.04 + fieldSpeed * 0.22);
  for (const p of field.motes) {
    p.dist += p.speed * moteStep * (0.45 + p.dist * 1.4);
    if (p.dist >= 1) {
      p.dist = Math.random() * 0.06;
      p.angle = Math.random() * Math.PI * 2;
      p.phase = Math.random();
    }
  }

  const streakStep = dt * (0.12 + fieldSpeed * 0.75);
  for (const p of field.streaks) {
    p.dist += p.speed * streakStep * (0.3 + p.dist * 2.1);
    if (p.dist >= 1) {
      p.dist = Math.random() * 0.05;
      p.angle = Math.random() * Math.PI * 2;
      p.phase = Math.random();
    }
  }

  return { cx, cy, maxR, fieldSpeed };
}

function dopplerColor(dist, fieldSpeed, speedNorm) {
  const radialT = smoothstep(0.15, 0.95, dist);
  const strength = clamp(fieldSpeed * speedNorm, 0, 1);
  const shifted = lerpColor(BLUE, RED, radialT);
  return { color: lerpColor(NEUTRAL, shifted, strength), strength, radialT };
}

function drawChromaticDot(ctx, cx, cy, angle, r, size, color, strength, alpha) {
  const cos = Math.cos(angle);
  const sin = Math.sin(angle);
  const split = 1.2 * strength * (0.4 + r / Math.max(r, 1));
  const x = cx + cos * r;
  const y = cy + sin * r;
  const xb = cx + cos * Math.max(0, r - split);
  const yb = cy + sin * Math.max(0, r - split);
  const xr = cx + cos * (r + split);
  const yr = cy + sin * (r + split);

  ctx.globalAlpha = alpha * 0.55;
  ctx.fillStyle = rgba(BLUE, 1);
  ctx.beginPath();
  ctx.arc(xb, yb, size * 0.85, 0, Math.PI * 2);
  ctx.fill();

  ctx.globalAlpha = alpha * 0.55;
  ctx.fillStyle = rgba(RED, 1);
  ctx.beginPath();
  ctx.arc(xr, yr, size * 0.85, 0, Math.PI * 2);
  ctx.fill();

  ctx.globalAlpha = alpha;
  ctx.fillStyle = rgba(color, 1);
  ctx.beginPath();
  ctx.arc(x, y, size, 0, Math.PI * 2);
  ctx.fill();
}

function drawChromaticStreak(ctx, cx, cy, angle, r, len, width, color, strength, alpha) {
  const cos = Math.cos(angle);
  const sin = Math.sin(angle);
  const r0 = Math.max(0, r - len);
  const split = 1.6 * strength * (0.35 + r * 0.002);

  ctx.lineCap = 'round';
  ctx.lineWidth = width;

  ctx.globalAlpha = alpha * 0.5;
  ctx.strokeStyle = rgba(BLUE, 1);
  ctx.beginPath();
  ctx.moveTo(cx + cos * Math.max(0, r0 - split), cy + sin * Math.max(0, r0 - split));
  ctx.lineTo(cx + cos * Math.max(0, r - split), cy + sin * Math.max(0, r - split));
  ctx.stroke();

  ctx.globalAlpha = alpha * 0.5;
  ctx.strokeStyle = rgba(RED, 1);
  ctx.beginPath();
  ctx.moveTo(cx + cos * (r0 + split), cy + sin * (r0 + split));
  ctx.lineTo(cx + cos * (r + split), cy + sin * (r + split));
  ctx.stroke();

  ctx.globalAlpha = alpha;
  ctx.strokeStyle = rgba(color, 1);
  ctx.beginPath();
  ctx.moveTo(cx + cos * r0, cy + sin * r0);
  ctx.lineTo(cx + cos * r, cy + sin * r);
  ctx.stroke();
}

function drawTargetStar(ctx, cx, cy, color, fieldSpeed) {
  const pulse = 0.85 + fieldSpeed * 0.25;
  const glow = ctx.createRadialGradient(cx, cy, 0, cx, cy, 28 * pulse);
  glow.addColorStop(0, color);
  glow.addColorStop(0.25, color);
  glow.addColorStop(1, 'rgba(0,0,0,0)');
  ctx.globalAlpha = 0.35 + fieldSpeed * 0.2;
  ctx.fillStyle = glow;
  ctx.beginPath();
  ctx.arc(cx, cy, 28 * pulse, 0, Math.PI * 2);
  ctx.fill();

  ctx.globalAlpha = 1;
  ctx.fillStyle = color;
  ctx.shadowColor = color;
  ctx.shadowBlur = 14 + fieldSpeed * 10;
  ctx.beginPath();
  ctx.arc(cx, cy, 2.4 * pulse, 0, Math.PI * 2);
  ctx.fill();
  ctx.shadowBlur = 0;
}

export function drawInhyperField(ctx, field, layout) {
  const { w, h, cx, cy, maxR, fieldSpeed } = layout;
  const hud = field.hud;

  ctx.fillStyle = hud.bg;
  ctx.fillRect(0, 0, w, h);

  const centerGlow = ctx.createRadialGradient(cx, cy, 0, cx, cy, maxR * 0.55);
  const glowA = 0.1 + fieldSpeed * 0.14;
  centerGlow.addColorStop(0, `rgba(74, 168, 255, ${glowA})`);
  centerGlow.addColorStop(0.45, `rgba(74, 168, 255, ${glowA * 0.25})`);
  centerGlow.addColorStop(1, 'rgba(0,0,0,0)');
  ctx.fillStyle = centerGlow;
  ctx.fillRect(0, 0, w, h);

  if (layout.showTargetStar && layout.targetStarColor) {
    ctx.save();
    drawTargetStar(ctx, cx, cy, layout.targetStarColor, fieldSpeed);
    ctx.restore();
  }

  const vignette = ctx.createRadialGradient(cx, cy, maxR * 0.25, cx, cy, maxR);
  vignette.addColorStop(0, 'rgba(0,0,0,0)');
  vignette.addColorStop(0.65, 'rgba(20,20,28,0.25)');
  vignette.addColorStop(1, 'rgba(0,0,0,0.72)');
  ctx.fillStyle = vignette;
  ctx.fillRect(0, 0, w, h);

  ctx.save();
  for (const mote of field.motes) {
    const r = mote.dist * maxR;
    const { color, strength } = dopplerColor(mote.dist, fieldSpeed, mote.speedNorm);
    const alpha = Math.min(0.8, 0.2 + mote.dist * 0.9) * (0.45 + fieldSpeed * 0.35);
    const size = mote.size * (0.45 + mote.dist * 0.9);
    drawChromaticDot(ctx, cx, cy, mote.angle, r, size, color, strength, alpha);
  }
  ctx.restore();

  ctx.save();
  for (const streak of field.streaks) {
    const r = streak.dist * maxR;
    const { color, strength } = dopplerColor(streak.dist, fieldSpeed, streak.speedNorm);
    const len = (10 + streak.size * 36) * (0.4 + fieldSpeed * 0.95) * (0.18 + streak.dist) * 5;
    const alpha = Math.min(1, 0.35 + streak.dist * 1.1) * (0.55 + fieldSpeed * 0.45);
    const width = 0.3 + streak.size * (0.2 + fieldSpeed * 0.4);
    drawChromaticStreak(ctx, cx, cy, streak.angle, r, len, width, color, strength, alpha);
  }
  ctx.restore();

  ctx.globalAlpha = 1;
}
