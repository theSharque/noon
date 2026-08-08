<script>
  import { onDestroy, onMount, tick } from 'svelte';
  import { createInflyField, paintStarfield } from '../inflyFx.js';
  import {
    DESIGN_H,
    DESIGN_W,
    cardById,
    fireOrigin,
    fireTarget,
    layoutWarBattle,
    parseWarShot,
    shieldFillPct,
    voidTarget,
    warUnitPic,
  } from '../warArenaLayout.js';

  export const WAR_DEBUG = true;

  export let near = [];
  export let far = [];
  export let shotBatch = null;
  export let debugLog = [];

  let rootEl;
  let bgCanvas;
  let fxCanvas;
  let viewportW = DESIGN_W;
  let viewportH = DESIGN_H;
  let layout = layoutWarBattle([], [], DESIGN_W, DESIGN_H);
  let starField = createInflyField(1, 42);
  let booms = [];
  let boomSeq = 0;
  let bgRaf = 0;
  let bgT0 = 0;
  let fxRaf = 0;
  let activeFx = [];

  $: layout = layoutWarBattle(near, far, viewportW, viewportH);

  $: if (shotBatch?.t) {
    playShotBatch(shotBatch);
  }

  function observeSize() {
    if (!rootEl || typeof ResizeObserver === 'undefined') return null;
    const ro = new ResizeObserver((entries) => {
      const rect = entries[0]?.contentRect;
      if (!rect) return;
      viewportW = Math.max(1, rect.width);
      viewportH = Math.max(1, rect.height);
    });
    ro.observe(rootEl);
    return ro;
  }

  function resolveEndpoints(shot, cards, fieldW, fieldH, scaleX) {
    const parsed = parseWarShot(shot);
    if (!parsed) return null;

    const attacker = cardById(cards, parsed.attackerId);
    const fromNear = attacker?.side === 'near' || parsed.attackerId.startsWith('a');
    const midY = fieldH / 2;
    const origin =
      fireOrigin(attacker) ||
      (fromNear ? { x: 300 * scaleX, y: midY } : { x: 385 * scaleX, y: midY });

    let target;
    const defId = parsed.defenderId;
    if (defId === 'as0' || defId === 'ds0') {
      target = voidTarget(fromNear, fieldW, fieldH);
    } else {
      const defender = cardById(cards, defId);
      target = fireTarget(defender, fromNear) || voidTarget(fromNear, fieldW, fieldH);
    }

    const jitter = parsed.defeat === 0 ? 10 : 3;
    target = {
      x: target.x + (Math.random() * jitter * 2 - jitter),
      y: target.y + (Math.random() * jitter * 2 - jitter),
    };

    if (origin.y === target.y) target.y += 2;

    return { ...parsed, origin, target, fromNear };
  }

  function wouldKill(defender, defeat) {
    if (!defender || (defeat !== -1 && defeat !== -2)) return false;
    const count = parseInt(defender.count, 10) || 0;
    return count <= 1;
  }

  function spawnBoom(x, y, size) {
    const id = ++boomSeq;
    booms = [...booms, { id, x, y, size: size || 48 }];
    setTimeout(() => {
      booms = booms.filter((b) => b.id !== id);
    }, 700);
  }

  function beamColor(wType) {
    switch (wType) {
      case 1:
        return '#44ff66';
      case 2:
        return '#b366ff';
      case 3:
        return '#ffdd44';
      default:
        return '#ff3333';
    }
  }

  function drawBeam(ctx, fx, alpha) {
    const { origin, target, wType } = fx;
    const color = beamColor(wType);
    const isLaser = wType === 0;
    ctx.save();
    ctx.globalAlpha = alpha;
    ctx.strokeStyle = color;
    ctx.lineWidth = isLaser ? 1 : wType === 2 ? 3 : 2;
    ctx.shadowColor = color;
    ctx.shadowBlur = isLaser ? 1 : 8;

    if (wType === 2) {
      ctx.beginPath();
      const steps = 24;
      const dx = (target.x - origin.x) / steps;
      const amp = 12;
      for (let i = 0; i <= steps; i++) {
        const x = origin.x + dx * i;
        const y = origin.y + Math.sin(i * 0.8) * amp * (1 - i / steps);
        if (i === 0) ctx.moveTo(x, y);
        else ctx.lineTo(x, y);
      }
      ctx.stroke();
    } else if (wType === 3) {
      const t = fx.progress ?? 1;
      const cx = origin.x + (target.x - origin.x) * t;
      const cy = origin.y + (target.y - origin.y) * t;
      const angle = Math.atan2(target.y - origin.y, target.x - origin.x);
      const len = 14;
      ctx.translate(cx, cy);
      ctx.rotate(angle);
      ctx.beginPath();
      ctx.moveTo(-len / 2, 0);
      ctx.lineTo(len / 2, 0);
      ctx.stroke();
    } else {
      ctx.beginPath();
      ctx.moveTo(origin.x, origin.y);
      ctx.lineTo(target.x, target.y);
      ctx.stroke();
    }
    ctx.restore();
  }

  function setupCanvas(canvas, w, h) {
    const ctx = canvas.getContext('2d');
    if (!ctx) return null;
    const dpr = window.devicePixelRatio || 1;
    canvas.width = w * dpr;
    canvas.height = h * dpr;
    canvas.style.width = `${w}px`;
    canvas.style.height = `${h}px`;
    ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
    return ctx;
  }

  function paintBg() {
    if (!bgCanvas) return;
    const w = layout.fieldW;
    const h = layout.fieldH;
    const ctx = setupCanvas(bgCanvas, w, h);
    if (!ctx) return;
    const tSec = (performance.now() - bgT0) / 1000;
    paintStarfield(ctx, starField, w, h, tSec);
  }

  function startBgLoop() {
    cancelAnimationFrame(bgRaf);
    bgT0 = performance.now();
    const loop = () => {
      paintBg();
      bgRaf = requestAnimationFrame(loop);
    };
    bgRaf = requestAnimationFrame(loop);
  }

  function paintFx() {
    if (!fxCanvas) return;
    const ctx = fxCanvas.getContext('2d');
    if (!ctx) return;
    const dpr = window.devicePixelRatio || 1;
    const w = layout.fieldW;
    const h = layout.fieldH;
    fxCanvas.width = w * dpr;
    fxCanvas.height = h * dpr;
    fxCanvas.style.width = `${w}px`;
    fxCanvas.style.height = `${h}px`;
    ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
    ctx.clearRect(0, 0, w, h);

    const now = performance.now();
    for (const fx of activeFx) {
      const elapsed = now - fx.start;
      const duration = fx.wType === 3 ? 700 : 500;
      const alpha = Math.max(0, 1 - elapsed / duration);
      if (fx.wType === 3) {
        fx.progress = Math.min(1, elapsed / duration);
      }
      if (alpha > 0) drawBeam(ctx, fx, alpha);
    }
    activeFx = activeFx.filter((fx) => now - fx.start < (fx.wType === 3 ? 700 : 500));
    if (activeFx.length) {
      fxRaf = requestAnimationFrame(paintFx);
    }
  }

  async function playShotBatch(batch) {
    const snapLayout = layoutWarBattle(batch.near || [], batch.far || [], viewportW, viewportH);
    const cards = snapLayout.cards;
    const shots = batch.shots || [];
    activeFx = [];

    for (const raw of shots) {
      const ep = resolveEndpoints(
        raw,
        cards,
        snapLayout.fieldW,
        snapLayout.fieldH,
        snapLayout.scaleX
      );
      if (!ep) continue;
      activeFx.push({ ...ep, start: performance.now(), progress: 0 });

      const defender = cardById(cards, ep.defenderId);
      if (wouldKill(defender, ep.defeat)) {
        const t = fireTarget(defender, ep.fromNear) || { x: defender.x, y: defender.y };
        spawnBoom(t.x, t.y, defender?.h ? defender.h * 0.4 : 48);
      }
    }

    cancelAnimationFrame(fxRaf);
    await tick();
    paintFx();
    if (activeFx.length) fxRaf = requestAnimationFrame(paintFx);
  }

  let resizeObserver;

  $: if (bgCanvas && layout.fieldW && layout.fieldH) {
    paintBg();
  }

  onMount(() => {
    resizeObserver = observeSize();
    if (rootEl) {
      viewportW = rootEl.clientWidth || DESIGN_W;
      viewportH = rootEl.clientHeight || DESIGN_H;
    }
    startBgLoop();
  });

  onDestroy(() => {
    resizeObserver?.disconnect();
    cancelAnimationFrame(bgRaf);
    cancelAnimationFrame(fxRaf);
  });
</script>

<div class="war-arena" bind:this={rootEl}>
  <div class="war-field">
    <canvas class="war-bg-stars" bind:this={bgCanvas}></canvas>

    {#each layout.cards as card (card.key)}
      <div
        class="war-card war-card-{card.side}"
        style="left:{card.x}px;top:{card.y}px;width:{card.w}px;height:{card.h}px;"
      >
        <img class="war-ship-pic" src={warUnitPic(card, card.side)} alt="" />
        <div class="war-count">{card.count}</div>
        <div class="war-shield-track">
          <div
            class="war-shield-fill"
            style="width:{shieldFillPct(card.shield, card.shieldTot)}%"
          ></div>
        </div>
      </div>
    {/each}

    {#each booms as boom (boom.id)}
      <img
        class="war-boom"
        src="/img/ships/boom.gif"
        alt=""
        style="left:{boom.x - boom.size / 2}px;top:{boom.y - boom.size / 2}px;width:{boom.size}px;height:{boom.size}px;"
      />
    {/each}

    <canvas class="war-fx" bind:this={fxCanvas}></canvas>
  </div>

  <!-- WAR_DEBUG_START -->
  {#if WAR_DEBUG && debugLog?.length}
    <div class="war-debug-log" aria-hidden="true">
      {#each debugLog.slice(-8) as line}
        <div>{line}</div>
      {/each}
    </div>
  {/if}
  <!-- WAR_DEBUG_END -->
</div>

<style>
  .war-arena {
    position: relative;
    flex: 1 1 auto;
    min-height: 0;
    min-width: 0;
    display: flex;
    align-items: stretch;
    justify-content: stretch;
    overflow: hidden;
    background: #000;
  }

  .war-field {
    position: relative;
    flex: 1 1 auto;
    width: 100%;
    height: 100%;
    min-width: 0;
    min-height: 0;
  }

  .war-bg-stars {
    position: absolute;
    inset: 0;
    width: 100%;
    height: 100%;
    pointer-events: none;
  }

  .war-card {
    position: absolute;
    box-sizing: border-box;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: flex-end;
    pointer-events: none;
  }

  .war-ship-pic {
    flex: 1 1 auto;
    width: 85%;
    height: auto;
    max-height: 72%;
    object-fit: contain;
    object-position: center bottom;
    filter: drop-shadow(0 0 6px rgba(0, 200, 255, 0.25));
  }

  .war-count {
    position: absolute;
    top: 4%;
    right: 6%;
    font-size: clamp(0.65rem, 2.2vmin, 1rem);
    font-weight: 700;
    color: #e8f4ff;
    text-shadow: 0 0 6px rgba(0, 0, 0, 0.9);
    line-height: 1;
  }

  .war-shield-track {
    width: 88%;
    height: 5px;
    margin-bottom: 4%;
    background: rgba(0, 0, 0, 0.55);
    border: 1px solid rgba(0, 229, 255, 0.35);
    border-radius: 1px;
    overflow: hidden;
  }

  .war-shield-fill {
    height: 100%;
    background: linear-gradient(90deg, #0066aa, #00e5ff);
    transition: width 0.15s ease-out;
  }

  .war-fx {
    position: absolute;
    inset: 0;
    width: 100%;
    height: 100%;
    pointer-events: none;
  }

  .war-boom {
    position: absolute;
    pointer-events: none;
    z-index: 4;
    object-fit: contain;
  }

  .war-debug-log {
    position: absolute;
    right: 6px;
    bottom: 6px;
    max-width: min(42%, 280px);
    max-height: 7.5rem;
    overflow: auto;
    padding: 0.35rem 0.45rem;
    font-family: var(--font-mono, monospace);
    font-size: 0.62rem;
    line-height: 1.35;
    color: rgba(180, 220, 230, 0.85);
    background: rgba(0, 8, 16, 0.72);
    border: 1px solid rgba(0, 229, 255, 0.2);
    pointer-events: none;
    z-index: 5;
  }
</style>
