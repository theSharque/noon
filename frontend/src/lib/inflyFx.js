export function starPalette(type) {
  const n = parseInt(type, 10) || 1;
  if (n === 2) {
    return {
      bg: '#070502',
      bgGlow: 'rgba(255, 200, 40, 0.14)',
      star: '#fff4c8',
      starDim: 'rgba(255, 220, 140, 0.35)',
      spark: '#ffe08a',
      streak: 'rgba(255, 210, 80, 0.95)',
      mote: 'rgba(255, 240, 180, 0.75)',
      hud: '#ffe566',
      hudMuted: 'rgba(255, 229, 102, 0.55)',
    };
  }
  if (n === 3) {
    return {
      bg: '#080202',
      bgGlow: 'rgba(255, 40, 30, 0.12)',
      star: '#ffd0d0',
      starDim: 'rgba(255, 120, 100, 0.35)',
      spark: '#ff8080',
      streak: 'rgba(255, 70, 50, 0.95)',
      mote: 'rgba(255, 160, 140, 0.7)',
      hud: '#ff6a6a',
      hudMuted: 'rgba(255, 106, 106, 0.55)',
    };
  }
  if (n === 4) {
    return {
      bg: '#050010',
      bgGlow: 'rgba(180, 40, 255, 0.16)',
      star: '#f0d8ff',
      starDim: 'rgba(200, 120, 255, 0.35)',
      spark: '#e0a0ff',
      streak: 'rgba(200, 80, 255, 0.95)',
      mote: 'rgba(220, 160, 255, 0.7)',
      hud: '#c77dff',
      hudMuted: 'rgba(199, 125, 255, 0.55)',
    };
  }
  if (n === 5) {
    return {
      bg: '#04060c',
      bgGlow: 'rgba(160, 180, 255, 0.12)',
      star: '#e8eeff',
      starDim: 'rgba(180, 196, 255, 0.35)',
      spark: '#c8d4ff',
      streak: 'rgba(170, 190, 255, 0.92)',
      mote: 'rgba(200, 210, 255, 0.7)',
      hud: '#b8c4ff',
      hudMuted: 'rgba(184, 196, 255, 0.55)',
    };
  }
  return {
    bg: '#020810',
    bgGlow: 'rgba(0, 180, 255, 0.12)',
    star: '#d8f6ff',
    starDim: 'rgba(90, 200, 255, 0.35)',
    spark: '#7adfff',
    streak: 'rgba(60, 200, 255, 0.95)',
    mote: 'rgba(140, 220, 255, 0.7)',
    hud: '#5cffd7',
    hudMuted: 'rgba(92, 255, 215, 0.55)',
  };
}

export function isInflyEvent(et) {
  const n = parseInt(et, 10);
  return n === 2 || n === 3 || n === 102 || n === 103;
}

export function journeySpeed(progress) {
  const t = Math.max(0, Math.min(1, progress));
  return 4 * t * (1 - t);
}

export function formatFlyTime(sec) {
  const s = Math.max(0, Math.floor(Number(sec) || 0));
  const h = Math.floor(s / 3600);
  const m = Math.floor((s % 3600) / 60);
  const r = s % 60;
  const pad = (n) => String(n).padStart(2, '0');
  return `${h}:${pad(m)}:${pad(r)}`;
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

export function createInflyField(starType, seed = Date.now()) {
  const rand = mulberry32(seed >>> 0);
  const palette = starPalette(starType);

  const far = [];
  for (let i = 0; i < 180; i++) {
    far.push({
      x: rand(),
      y: rand(),
      r: 0.4 + rand() * 0.7,
      a: 0.15 + rand() * 0.35,
      tw: rand() * Math.PI * 2,
      twSpeed: 0.4 + rand() * 0.8,
    });
  }

  const mid = [];
  for (let i = 0; i < 90; i++) {
    mid.push({
      x: rand(),
      y: rand(),
      r: 0.6 + rand() * 1.1,
      a: 0.25 + rand() * 0.45,
      tw: rand() * Math.PI * 2,
      twSpeed: 0.6 + rand() * 1.2,
    });
  }

  const near = [];
  for (let i = 0; i < 40; i++) {
    near.push({
      x: rand(),
      y: rand(),
      r: 1 + rand() * 1.6,
      a: 0.35 + rand() * 0.5,
      tw: rand() * Math.PI * 2,
      twSpeed: 0.8 + rand() * 1.4,
    });
  }

  const sparks = [];
  for (let i = 0; i < 80; i++) {
    sparks.push(makeRadial(rand, 'spark'));
  }

  const streaks = [];
  for (let i = 0; i < 120; i++) {
    streaks.push(makeRadial(rand, 'streak'));
  }

  const motes = [];
  for (let i = 0; i < 50; i++) {
    motes.push(makeRadial(rand, 'mote'));
  }

  return { palette, far, mid, near, sparks, streaks, motes, seed };
}

function makeRadial(rand, kind) {
  return {
    kind,
    angle: rand() * Math.PI * 2,
    dist: rand(),
    speed: 0.35 + rand() * 0.9,
    size: kind === 'streak' ? 0.35 + rand() * 0.7 : kind === 'mote' ? 0.6 + rand() * 1.1 : 0.35 + rand() * 0.65,
    phase: rand(),
  };
}

export function stepInflyField(field, dt, speedFactor, w, h) {
  const cx = w * 0.5;
  const cy = h * 0.5;
  const maxR = Math.hypot(cx, cy) * 1.15;

  for (const s of field.far) {
    s.tw += dt * s.twSpeed;
  }
  for (const s of field.mid) {
    s.tw += dt * s.twSpeed;
  }
  for (const s of field.near) {
    s.tw += dt * s.twSpeed;
  }

  const dustSpeed = dt * (0.08 + speedFactor * 0.55);
  for (const list of [field.sparks, field.streaks, field.motes]) {
    for (const p of list) {
      p.dist += p.speed * dustSpeed * (0.35 + p.dist * 1.8);
      if (p.dist >= 1) {
        p.dist = Math.random() * 0.08;
        p.angle = Math.random() * Math.PI * 2;
        p.phase = Math.random();
      }
    }
  }

  return { cx, cy, maxR };
}

export function drawInflyField(ctx, field, layout, speedFactor, time, planet) {
  const { w, h, cx, cy, maxR } = layout;
  const p = field.palette;

  ctx.fillStyle = p.bg;
  ctx.fillRect(0, 0, w, h);

  const glow = ctx.createRadialGradient(cx, cy, 0, cx, cy, maxR * 0.7);
  glow.addColorStop(0, p.bgGlow);
  glow.addColorStop(1, 'rgba(0,0,0,0)');
  ctx.fillStyle = glow;
  ctx.fillRect(0, 0, w, h);

  drawStarLayer(ctx, field.far, w, h, p.starDim, 0.7);
  drawStarLayer(ctx, field.mid, w, h, p.star, 0.9);
  drawStarLayer(ctx, field.near, w, h, p.star, 1.15);

  if (planet?.img && planet.fullSize > 0 && planet.scale > 0) {
    drawApproachPlanet(ctx, cx, cy, planet.img, planet.fullSize, planet.scale);
  }

  ctx.save();
  for (const mote of field.motes) {
    const r = mote.dist * maxR;
    const x = cx + Math.cos(mote.angle) * r;
    const y = cy + Math.sin(mote.angle) * r;
    const alpha = Math.min(0.85, mote.dist * 1.35) * (0.55 + speedFactor * 0.4);
    ctx.fillStyle = p.mote;
    ctx.globalAlpha = alpha;
    ctx.beginPath();
    ctx.arc(x, y, mote.size * (0.5 + mote.dist * 1.0), 0, Math.PI * 2);
    ctx.fill();
  }
  ctx.restore();

  ctx.save();
  ctx.strokeStyle = p.streak;
  ctx.lineCap = 'round';
  for (const streak of field.streaks) {
    const r = streak.dist * maxR;
    const len = (8 + streak.size * 28) * (0.35 + speedFactor * 0.9) * (0.2 + streak.dist);
    const x = cx + Math.cos(streak.angle) * r;
    const y = cy + Math.sin(streak.angle) * r;
    const x2 = cx + Math.cos(streak.angle) * Math.max(0, r - len);
    const y2 = cy + Math.sin(streak.angle) * Math.max(0, r - len);
    ctx.globalAlpha = Math.min(1, streak.dist * 1.4) * (0.5 + speedFactor * 0.5);
    ctx.lineWidth = 0.35 + streak.size * (0.25 + speedFactor * 0.45);
    ctx.beginPath();
    ctx.moveTo(x2, y2);
    ctx.lineTo(x, y);
    ctx.stroke();
  }
  ctx.restore();

  ctx.save();
  ctx.fillStyle = p.spark;
  for (const spark of field.sparks) {
    const r = spark.dist * maxR;
    const x = cx + Math.cos(spark.angle) * r;
    const y = cy + Math.sin(spark.angle) * r;
    ctx.globalAlpha = Math.min(1, spark.dist * 1.5) * (0.55 + speedFactor * 0.45);
    const size = spark.size * (0.35 + spark.dist * 1.1);
    ctx.beginPath();
    ctx.arc(x, y, size, 0, Math.PI * 2);
    ctx.fill();
  }
  ctx.restore();

  ctx.globalAlpha = 1;
  void time;
}

function drawApproachPlanet(ctx, cx, cy, img, fullSize, scale) {
  const size = fullSize * scale;
  if (size < 0.5) return;
  const half = size / 2;
  ctx.save();
  ctx.globalAlpha = Math.min(1, 0.35 + scale * 0.9);
  ctx.drawImage(img, cx - half, cy - half, size, size);
  ctx.restore();
}

function drawStarLayer(ctx, stars, w, h, color, sizeMul) {
  ctx.fillStyle = color;
  for (const s of stars) {
    const tw = 0.65 + 0.35 * Math.sin(s.tw);
    ctx.globalAlpha = s.a * tw;
    ctx.beginPath();
    ctx.arc(s.x * w, s.y * h, s.r * sizeMul, 0, Math.PI * 2);
    ctx.fill();
  }
  ctx.globalAlpha = 1;
}

function drawStarLayerTimed(ctx, stars, w, h, color, sizeMul, tSec) {
  ctx.fillStyle = color;
  for (const s of stars) {
    const tw = 0.65 + 0.35 * Math.sin(s.tw + tSec * s.twSpeed);
    ctx.globalAlpha = s.a * tw;
    ctx.beginPath();
    ctx.arc(s.x * w, s.y * h, s.r * sizeMul, 0, Math.PI * 2);
    ctx.fill();
  }
  ctx.globalAlpha = 1;
}

/** Static starfield backdrop (no hyperspace dust) — same palette as Infly. */
export function paintStarfield(ctx, field, w, h, tSec = 0) {
  const p = field.palette;
  ctx.fillStyle = p.bg;
  ctx.fillRect(0, 0, w, h);

  const cx = w * 0.5;
  const cy = h * 0.5;
  const maxR = Math.hypot(cx, cy);
  const glow = ctx.createRadialGradient(cx, cy, 0, cx, cy, maxR * 0.7);
  glow.addColorStop(0, p.bgGlow);
  glow.addColorStop(1, 'rgba(0,0,0,0)');
  ctx.fillStyle = glow;
  ctx.fillRect(0, 0, w, h);

  drawStarLayerTimed(ctx, field.far, w, h, p.starDim, 0.7, tSec);
  drawStarLayerTimed(ctx, field.mid, w, h, p.star, 0.9, tSec);
  drawStarLayerTimed(ctx, field.near, w, h, p.star, 1.15, tSec);
}
