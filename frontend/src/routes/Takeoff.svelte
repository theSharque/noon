<script>
  import { createEventDispatcher, onDestroy, onMount } from 'svelte';
  import {
    createTakeoffField,
    drawTakeoffField,
    formatFlyTime,
    planetPalette,
    stepTakeoffField,
  } from '../lib/takeoffFx.js';

  export let planetType = 1;
  export let planetName = '';
  export let remain = 10;
  export let total = 10;
  export let demo = false;

  const dispatch = createEventDispatcher();

  let canvas;
  let wrap;
  let raf = 0;
  let field;
  let fieldKey = '';
  let remainLive = Number(remain) || 0;
  let totalLive = Math.max(1, Number(total) || 1);
  let startedMs = Date.now();
  let baseRemain = Number(remain) || 0;
  let lastTs = 0;
  let ended = false;

  $: palette = planetPalette(planetType);
  $: progress = Math.max(0, Math.min(1, (totalLive - remainLive) / totalLive));
  $: timeLabel = formatFlyTime(remainLive);
  $: altLabel = altitudeLabel(progress);

  $: ensureField(planetType, planetName);
  $: armTimer(remain, total);

  function seedFromName(name) {
    const s = String(name || '');
    let h = 0;
    for (let i = 0; i < s.length; i++) h = (h * 31 + s.charCodeAt(i)) >>> 0;
    return h;
  }

  function altitudeLabel(p) {
    if (p < 0.2) return 'у поверхности';
    if (p < 0.45) return 'набор высоты';
    if (p < 0.75) return 'выход из атмосферы';
    if (p < 0.92) return 'разрежение';
    return 'орбита';
  }

  function ensureField(type, name) {
    const key = `${type}|${name || ''}`;
    if (key === fieldKey && field) return;
    fieldKey = key;
    field = createTakeoffField(type, (Number(type) * 9973 + (seedFromName(name) || 1)) >>> 0);
  }

  function armTimer(r, t) {
    baseRemain = Math.max(0, Number(r) || 0);
    remainLive = baseRemain;
    totalLive = Math.max(1, Number(t) || baseRemain || 1);
    startedMs = Date.now();
    ended = false;
  }

  function resize() {
    if (!canvas || !wrap) return;
    const dpr = Math.min(window.devicePixelRatio || 1, 2);
    const w = Math.max(1, wrap.clientWidth);
    const h = Math.max(1, wrap.clientHeight);
    canvas.width = Math.floor(w * dpr);
    canvas.height = Math.floor(h * dpr);
    canvas.style.width = `${w}px`;
    canvas.style.height = `${h}px`;
    const ctx = canvas.getContext('2d');
    ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
  }

  function frame(ts) {
    raf = requestAnimationFrame(frame);
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    const w = wrap?.clientWidth || canvas.clientWidth;
    const h = wrap?.clientHeight || canvas.clientHeight;
    const dt = lastTs ? Math.min(0.05, (ts - lastTs) / 1000) : 0.016;
    lastTs = ts;

    const elapsedSec = (Date.now() - startedMs) / 1000;
    remainLive = Math.max(0, baseRemain - elapsedSec);
    const journeyElapsed = Math.max(0, totalLive - remainLive);
    const journeyProgress = Math.max(0, Math.min(1, journeyElapsed / totalLive));

    if (!field) return;
    stepTakeoffField(field, dt, journeyProgress);
    drawTakeoffField(ctx, field, { w, h }, journeyProgress, ts / 1000);

    if (!ended && remainLive <= 0 && !demo) {
      ended = true;
      dispatch('arrived');
    } else if (ended && remainLive > 0) {
      ended = false;
    }
  }

  onMount(() => {
    resize();
    const ro = new ResizeObserver(() => resize());
    if (wrap) ro.observe(wrap);
    raf = requestAnimationFrame(frame);
    return () => ro.disconnect();
  });

  onDestroy(() => {
    if (raf) cancelAnimationFrame(raf);
  });
</script>

<div
  class="takeoff"
  bind:this={wrap}
  style="--hud:{palette.hud}; --hud-muted:{palette.hudMuted}"
>
  <canvas bind:this={canvas} class="takeoff-canvas"></canvas>
  <div class="hud">
    <div class="hud-title">Взлёт{planetName ? ` · ${planetName}` : ''}</div>
    <div class="hud-time">{timeLabel}</div>
    <div class="hud-bar">
      <div class="hud-bar-fill" style="width:{progress * 100}%"></div>
    </div>
    <div class="hud-meta">
      <span>{altLabel}</span>
      {#if demo}<span class="demo">demo</span>{/if}
    </div>
  </div>
</div>

<style>
  .takeoff {
    position: relative;
    width: 100%;
    height: 100%;
    min-height: 280px;
    overflow: hidden;
    background: #020810;
  }

  .takeoff-canvas {
    display: block;
    width: 100%;
    height: 100%;
  }

  .hud {
    position: absolute;
    left: 14px;
    top: 12px;
    right: 14px;
    pointer-events: none;
    font-family: var(--font-mono, ui-monospace, monospace);
    color: var(--hud);
    text-shadow: 0 0 12px color-mix(in srgb, var(--hud) 45%, transparent);
  }

  .hud-title {
    font-size: 0.78rem;
    letter-spacing: 0.04em;
    text-transform: uppercase;
    color: var(--hud-muted);
    margin-bottom: 4px;
  }

  .hud-time {
    font-size: 1.55rem;
    font-weight: 600;
    letter-spacing: 0.06em;
    line-height: 1.1;
  }

  .hud-bar {
    position: relative;
    margin-top: 10px;
    max-width: 280px;
    height: 4px;
    border-radius: 2px;
    background: color-mix(in srgb, var(--hud) 18%, transparent);
    overflow: hidden;
  }

  .hud-bar-fill {
    height: 100%;
    background: linear-gradient(90deg, transparent, var(--hud));
    box-shadow: 0 0 8px var(--hud);
    transition: width 0.2s linear;
  }

  .hud-meta {
    margin-top: 6px;
    display: flex;
    gap: 12px;
    font-size: 0.72rem;
    color: var(--hud-muted);
    letter-spacing: 0.03em;
  }

  .demo {
    border: 1px solid var(--hud-muted);
    padding: 0 6px;
    border-radius: 2px;
    text-transform: uppercase;
  }
</style>
