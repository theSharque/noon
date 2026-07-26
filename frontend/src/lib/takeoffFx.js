import { formatFlyTime } from './inflyFx.js';
import { planetPalette } from './landFx.js';

export { formatFlyTime, planetPalette };

export function isTakeoffEvent(et) {
  const n = parseInt(et, 10);
  return n === 1 || n === 101;
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

function clamp(v, a, b) {
  return Math.max(a, Math.min(b, v));
}

function smoothstep(edge0, edge1, x) {
  const t = clamp((x - edge0) / (edge1 - edge0), 0, 1);
  return t * t * (3 - 2 * t);
}

function rgba(c, a) {
  return `rgba(${c.r},${c.g},${c.b},${clamp(a, 0, 1)})`;
}

function makeRush(rand) {
  return {
    angle: (rand() - 0.5) * Math.PI * 1.15,
    dist: rand(),
    speed: 0.45 + rand() * 1.2,
    size: 0.3 + rand() * 0.85,
    phase: rand(),
    kind: rand() < 0.55 ? 'streak' : 'mote',
  };
}

export function createTakeoffField(ptype, seed = Date.now()) {
  const rand = mulberry32(seed >>> 0);
  const palette = planetPalette(ptype);

  const stars = [];
  for (let i = 0; i < 130; i++) {
    stars.push({
      x: rand(),
      y: rand(),
      r: 0.35 + rand() * 1.05,
      a: 0.2 + rand() * 0.5,
      tw: rand() * Math.PI * 2,
      twSpeed: 0.3 + rand() * 0.85,
    });
  }

  const clouds = [];
  for (let i = 0; i < palette.cloudCount; i++) {
    clouds.push({
      u: rand() * 2 - 1,
      dist: 0.15 + rand() * 0.85,
      w: 0.14 + rand() * 0.4,
      h: 0.03 + rand() * 0.07,
      a: 0.3 + rand() * 0.5,
      phase: rand() * Math.PI * 2,
      layer: rand(),
    });
  }

  const patches = [];
  const n = palette.kind === 'gas' ? 12 : 36;
  for (let i = 0; i < n; i++) {
    let kind = 'rock';
    if (palette.kind === 'earth') {
      kind = rand() < 0.28 ? 'sea' : rand() < 0.5 ? 'grass' : rand() < 0.72 ? 'desert' : 'mountain';
    } else if (palette.kind === 'desert') {
      kind = rand() < 0.6 ? 'dune' : 'canyon';
    } else if (palette.kind === 'dead') {
      kind = 'crater';
    } else {
      kind = 'band';
    }
    patches.push({
      u: rand() * 2 - 1,
      v: 0.25 + rand() * 0.75,
      w: 0.05 + rand() * 0.16,
      h: 0.03 + rand() * 0.1,
      kind,
      tone: rand(),
    });
  }

  const rush = [];
  for (let i = 0; i < 110; i++) rush.push(makeRush(rand));

  return {
    palette,
    stars,
    clouds,
    patches,
    rush,
    seed,
    bob: 0,
    roll: 0,
    groundScroll: 0,
  };
}

export function stepTakeoffField(field, dt, progress) {
  const t = clamp(progress, 0, 1);
  const climb = 0.25 + t * 2.2;

  field.bob += dt * (0.8 + t * 1.4);
  field.roll = Math.sin(field.bob * 0.5) * 0.018 * (0.35 + t);

  for (const s of field.stars) s.tw += dt * s.twSpeed;

  for (const c of field.clouds) {
    c.dist += dt * climb * (0.1 + c.layer * 0.22);
    c.phase += dt * 0.55;
    if (c.dist > 1.35) {
      c.dist = 0.04 + Math.random() * 0.1;
      c.u = Math.random() * 2 - 1;
    }
  }

  for (const p of field.rush) {
    p.dist += p.speed * dt * climb * 0.65;
    if (p.dist >= 1) {
      p.dist = Math.random() * 0.06;
      p.angle = (Math.random() - 0.5) * Math.PI * 1.15;
      p.phase = Math.random();
    }
  }

  field.groundScroll += dt * climb * 0.22;

  for (const patch of field.patches) {
    patch.v += dt * climb * 0.28 * (0.35 + patch.v * patch.v);
    if (patch.v > 1.2) {
      patch.v = Math.random() * 0.05;
      patch.u = Math.random() * 2 - 1;
    }
  }

  return { progress: t };
}

export function drawTakeoffField(ctx, field, layout, progress, time) {
  const { w, h } = layout;
  const p = field.palette;
  const t = clamp(progress, 0, 1);
  const atmVis = p.atmStrength * (1 - smoothstep(0.12, 0.88, t));
  const starFade = smoothstep(0.2, 0.78, t);
  const surface = 1 - smoothstep(0.15, 0.72, t);
  const detail = 1 - smoothstep(0.35, 0.9, t);
  const speed = 0.35 + t * 1.0;

  const vpX = w * 0.5;
  const vpY = h * (0.55 - t * 0.18);
  const horizonY = h * (0.32 + t * 0.38);
  const curve = smoothstep(0.15, 0.85, t) * 0.3;
  const pad = Math.ceil(Math.hypot(w, h) * 0.035) + 4;

  ctx.globalAlpha = 1;
  ctx.fillStyle = p.space;
  ctx.fillRect(0, 0, w, h);

  ctx.save();
  ctx.translate(vpX, vpY);
  ctx.rotate(field.roll);
  ctx.translate(-vpX, -vpY);

  ctx.fillStyle = p.space;
  ctx.fillRect(-pad, -pad, w + pad * 2, h + pad * 2);

  if (starFade > 0.02) {
    ctx.save();
    for (const s of field.stars) {
      const sy = s.y * Math.max(8, horizonY - 6);
      if (sy > horizonY - 2) continue;
      const tw = 0.65 + 0.35 * Math.sin(s.tw);
      ctx.globalAlpha = s.a * tw * starFade;
      ctx.fillStyle = '#e8f4ff';
      ctx.beginPath();
      ctx.arc(s.x * w, sy, s.r, 0, Math.PI * 2);
      ctx.fill();
    }
    ctx.restore();
  }

  drawAtmosphereSky(ctx, w, h, horizonY, atmVis, p, t);
  drawPlanetDisk(ctx, w, h, vpX, horizonY, curve, surface, atmVis, p, t);

  if (p.cloudAlpha > 0 && field.clouds.length && atmVis > 0.05) {
    drawCloudsTowardCamera(ctx, field, w, h, vpX, horizonY, atmVis, detail, time);
  }

  if (surface > 0.02) {
    drawGroundPerspective(ctx, field, w, h, vpX, vpY, horizonY, surface, detail, t);
  }

  drawRushTowardCamera(ctx, field, vpX, vpY, Math.hypot(w, h), speed, atmVis);

  drawVignette(ctx, w, h, t);
  ctx.restore();

  if (t > 0.9) {
    ctx.fillStyle = rgba({ r: 255, g: 255, b: 255 }, ((t - 0.9) / 0.1) * 0.22);
    ctx.fillRect(0, 0, w, h);
  }

  ctx.globalAlpha = 1;
}

function drawAtmosphereSky(ctx, w, h, horizonY, atm, p, t) {
  if (atm < 0.01) return;
  const sky = ctx.createLinearGradient(0, 0, 0, Math.min(h, horizonY + h * 0.25));
  sky.addColorStop(0, rgba(p.atmMid, 0));
  sky.addColorStop(0.45, rgba(p.atmMid, atm * 0.18));
  sky.addColorStop(0.8, rgba(p.atmNear, atm * 0.5));
  sky.addColorStop(1, rgba(p.atmNear, atm * 0.78));
  ctx.fillStyle = sky;
  ctx.fillRect(0, 0, w, Math.min(h, horizonY + h * 0.3));
}

function drawPlanetDisk(ctx, w, h, cx, horizonY, curve, surface, atm, p, t) {
  const bulge = curve * w * 0.65;

  ctx.save();
  ctx.beginPath();
  ctx.moveTo(-2, h + 4);
  ctx.lineTo(-2, horizonY + bulge * 0.2);
  ctx.quadraticCurveTo(cx, horizonY - bulge, w + 2, horizonY + bulge * 0.2);
  ctx.lineTo(w + 2, h + 4);
  ctx.closePath();

  const fill = ctx.createLinearGradient(0, horizonY - bulge, 0, h);
  fill.addColorStop(0, p.groundFar);
  fill.addColorStop(0.4, p.groundNear);
  fill.addColorStop(1, p.groundDeep);
  ctx.globalAlpha = 0.35 + surface * 0.65;
  ctx.fillStyle = fill;
  ctx.fill();

  if (atm > 0.05) {
    const rim = ctx.createLinearGradient(0, horizonY - bulge - 8, 0, horizonY + h * 0.12);
    rim.addColorStop(0, rgba(p.haze, 0));
    rim.addColorStop(0.45, rgba(p.haze, atm * 0.45));
    rim.addColorStop(1, rgba(p.haze, 0));
    ctx.globalAlpha = 1;
    ctx.fillStyle = rim;
    ctx.fill();
  }
  ctx.restore();
  void t;
}

function drawCloudsTowardCamera(ctx, field, w, h, cx, horizonY, atm, detail, time) {
  const p = field.palette;
  ctx.save();
  const sorted = field.clouds.slice().sort((a, b) => a.dist - b.dist);
  for (const c of sorted) {
    const d = clamp(c.dist, 0.04, 1.35);
    const scale = 0.2 + d * d * 2.2;
    const y = horizonY - h * 0.12 + d * h * 0.22;
    const x = cx + c.u * w * 0.42 * (0.15 + d);
    const cw = c.w * w * scale;
    const ch = c.h * h * scale * (0.75 + detail * 0.5);
    ctx.globalAlpha =
      c.a * p.cloudAlpha * atm * clamp(1.15 - d * 0.4, 0.15, 1) * (0.5 + 0.5 * Math.sin(c.phase + time));
    ctx.fillStyle = 'rgba(245,250,255,0.92)';
    ellipseCloud(ctx, x, y, cw, ch);
    ellipseCloud(ctx, x + cw * 0.3, y - ch * 0.28, cw * 0.55, ch * 0.7);
    ellipseCloud(ctx, x - cw * 0.25, y - ch * 0.12, cw * 0.48, ch * 0.55);
  }
  ctx.restore();
}

function projectGround(u, v, vpX, vpY, horizonY, w, h) {
  const depth = clamp(v, 0.001, 1.25);
  const near = depth * depth;
  const y = horizonY + near * (h - horizonY + 20);
  const spread = 0.08 + near * 0.92;
  const x = vpX + u * w * 0.55 * spread;
  const scale = 0.08 + near * 1.35;
  return { x, y, scale, depth };
}

function drawGroundPerspective(ctx, field, w, h, vpX, vpY, horizonY, surface, detail, t) {
  const p = field.palette;
  ctx.save();
  ctx.beginPath();
  ctx.rect(0, horizonY - 4, w, h - horizonY + 8);
  ctx.clip();

  ctx.globalAlpha = surface * 0.22;
  ctx.strokeStyle = rgba(p.haze, 0.18 + detail * 0.12);
  ctx.lineWidth = 1;
  const scroll = field.groundScroll || 0;
  for (let i = 0; i < 7; i++) {
    const v = ((i / 7) + scroll) % 1;
    if (v < 0.04 || v > 0.98) continue;
    const left = projectGround(-1, v, vpX, vpY, horizonY, w, h);
    const right = projectGround(1, v, vpX, vpY, horizonY, w, h);
    ctx.beginPath();
    ctx.moveTo(left.x, left.y);
    ctx.lineTo(right.x, right.y);
    ctx.stroke();
  }

  const sorted = field.patches.slice().sort((a, b) => a.v - b.v);
  for (const patch of sorted) {
    const pr = projectGround(patch.u, patch.v, vpX, vpY, horizonY, w, h);
    const pw = patch.w * w * pr.scale;
    const ph = patch.h * (h - horizonY) * pr.scale * 0.55;
    ctx.globalAlpha = surface * (0.3 + pr.depth * 0.55) * (0.45 + detail * 0.55);

    if (patch.kind === 'sea') ctx.fillStyle = '#1a6088';
    else if (patch.kind === 'grass') ctx.fillStyle = '#2f8a40';
    else if (patch.kind === 'desert') ctx.fillStyle = '#c0a060';
    else if (patch.kind === 'mountain') ctx.fillStyle = '#5a5a68';
    else if (patch.kind === 'dune') ctx.fillStyle = p.bandC;
    else if (patch.kind === 'canyon') ctx.fillStyle = p.bandB;
    else if (patch.kind === 'crater') ctx.fillStyle = p.feature;
    else if (patch.kind === 'band') ctx.fillStyle = patch.tone < 0.5 ? p.bandA : p.bandC;
    else ctx.fillStyle = p.feature;

    const x0 = pr.x;
    const y0 = pr.y;
    const halfFar = pw * 0.35;
    const halfNear = pw * 0.85;
    const top = y0 - ph * 0.35;
    const bot = y0 + ph * 0.65;

    if (patch.kind === 'dune') {
      ctx.beginPath();
      ctx.moveTo(x0 - halfNear, bot);
      ctx.quadraticCurveTo(x0, top - ph * 0.2, x0 + halfNear, bot);
      ctx.fill();
    } else if (patch.kind === 'crater') {
      ctx.beginPath();
      ctx.ellipse(x0, y0, Math.max(2, pw * 0.7), Math.max(1.5, ph * 0.55), 0, 0, Math.PI * 2);
      ctx.fill();
      ctx.globalAlpha *= 0.5;
      ctx.strokeStyle = p.groundDeep;
      ctx.lineWidth = 1 + detail;
      ctx.stroke();
    } else {
      ctx.beginPath();
      ctx.moveTo(x0 - halfFar, top);
      ctx.lineTo(x0 + halfFar, top);
      ctx.lineTo(x0 + halfNear, bot);
      ctx.lineTo(x0 - halfNear, bot);
      ctx.closePath();
      ctx.fill();
    }
  }

  ctx.restore();
  void t;
}

function drawRushTowardCamera(ctx, field, vpX, vpY, maxR, speed, atm) {
  const p = field.palette;
  const a = 0.25 + speed * 0.6 + atm * 0.12;

  ctx.save();
  ctx.lineCap = 'round';
  for (const s of field.rush) {
    const r = s.dist * maxR * 0.95;
    const ang = s.angle - Math.PI * 0.5;
    const x = vpX + Math.cos(ang) * r;
    const y = vpY + Math.sin(ang) * r;
    if (s.kind === 'streak') {
      const len = (12 + s.size * 42) * (0.2 + speed) * (0.12 + s.dist);
      const x2 = vpX + Math.cos(ang) * Math.max(0, r - len);
      const y2 = vpY + Math.sin(ang) * Math.max(0, r - len);
      ctx.strokeStyle = p.streak;
      ctx.globalAlpha = a * Math.min(1, s.dist * 1.5) * (0.4 + speed * 0.5);
      ctx.lineWidth = 0.45 + s.size * (0.25 + speed * 0.45);
      ctx.beginPath();
      ctx.moveTo(x2, y2);
      ctx.lineTo(x, y);
      ctx.stroke();
    } else {
      ctx.fillStyle = p.mote;
      ctx.globalAlpha = a * Math.min(1, s.dist * 1.35) * 0.55;
      ctx.beginPath();
      ctx.arc(x, y, s.size * (0.45 + s.dist * 1.1), 0, Math.PI * 2);
      ctx.fill();
    }
  }
  ctx.restore();
}

function drawVignette(ctx, w, h, t) {
  const vig = ctx.createRadialGradient(w * 0.5, h * 0.42, h * 0.18, w * 0.5, h * 0.5, h * 0.92);
  vig.addColorStop(0, 'rgba(0,0,0,0)');
  vig.addColorStop(0.72, 'rgba(0,0,0,0)');
  vig.addColorStop(1, `rgba(0,0,0,${0.28 + t * 0.12})`);
  ctx.fillStyle = vig;
  ctx.fillRect(0, 0, w, h);
}

function ellipseCloud(ctx, x, y, ww, hh) {
  ctx.beginPath();
  ctx.ellipse(x, y, Math.max(1, ww * 0.5), Math.max(1, hh * 0.5), 0, 0, Math.PI * 2);
  ctx.fill();
}
