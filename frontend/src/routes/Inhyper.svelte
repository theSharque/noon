<script>
  import { createEventDispatcher, onDestroy, onMount } from 'svelte';
  import {
    createInhyperField,
    drawInhyperField,
    formatFlyTime,
    hyperFieldSpeed,
    hyperTargetStarColor,
    journeySpeed,
    showHyperTargetStar,
    stepInhyperField,
  } from '../lib/inhyperFx.js';

  export let starType = 1;
  export let starName = '';
  export let eventType = 4;
  export let remain = 90;
  export let total = 180;
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

  $: progress = Math.max(0, Math.min(1, (totalLive - remainLive) / totalLive));
  $: speed = journeySpeed(progress);
  $: fieldSpeed = hyperFieldSpeed(speed);
  $: timeLabel = formatFlyTime(remainLive);
  $: targetStarVisible = showHyperTargetStar(eventType, starType);
  $: targetStarColor = targetStarVisible ? hyperTargetStarColor(starType) : '';

  $: ensureField(starType, starName);
  $: armTimer(remain, total);

  function seedFromName(name) {
    const s = String(name || '');
    let h = 0;
    for (let i = 0; i < s.length; i++) h = (h * 31 + s.charCodeAt(i)) >>> 0;
    return h;
  }

  function ensureField(type, name) {
    const key = `${type}|${name || ''}`;
    if (key === fieldKey && field) return;
    fieldKey = key;
    field = createInhyperField(type, (Number(type) * 7919 + (seedFromName(name) || 1)) >>> 0);
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
    const speedFactor = journeySpeed(journeyProgress);

    if (!field) return;
    const layoutPos = stepInhyperField(field, dt, speedFactor, w, h);
    drawInhyperField(ctx, field, {
      w,
      h,
      cx: layoutPos.cx,
      cy: layoutPos.cy,
      maxR: layoutPos.maxR,
      fieldSpeed: layoutPos.fieldSpeed,
      showTargetStar: targetStarVisible,
      targetStarColor,
    });

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

<div class="inhyper" bind:this={wrap} style="--hud:var(--neon-cyan); --hud-muted:color-mix(in srgb, var(--neon-cyan) 55%, transparent)">
  <canvas bind:this={canvas} class="inhyper-canvas"></canvas>
  <div class="hud">
    <div class="hud-title">Гиперперелёт{starName ? ` · ${starName}` : ''}</div>
    <div class="hud-time">{timeLabel}</div>
    <div class="hud-bar">
      <div class="hud-bar-fill" style="width:{progress * 100}%"></div>
      <div class="hud-bar-peak" style="left:50%"></div>
    </div>
    <div class="hud-meta">
      <span>скорость {(fieldSpeed * 100).toFixed(0)}%</span>
      {#if demo}<span class="demo">demo</span>{/if}
    </div>
  </div>
</div>

<style>
  .inhyper {
    position: relative;
    width: 100%;
    height: 100%;
    min-height: 280px;
    overflow: hidden;
    background: #030308;
  }

  .inhyper-canvas {
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
    background: linear-gradient(90deg, #4aa8ff, #ff4a4a);
    box-shadow: 0 0 8px var(--hud);
    transition: width 0.2s linear;
  }

  .hud-bar-peak {
    position: absolute;
    top: -2px;
    width: 2px;
    height: 8px;
    margin-left: -1px;
    background: var(--hud-muted);
    opacity: 0.7;
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
