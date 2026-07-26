<script>
  import { onDestroy, onMount } from 'svelte';
  import { link } from 'svelte-spa-router';
  import {
    createIndeepField,
    drawIndeepField,
    INDEEP_BG,
    stepIndeepField,
  } from '../lib/indeepFx.js';

  export let x = 0;
  export let y = 0;
  export let demo = false;

  let canvas;
  let wrap;
  let raf = 0;
  let field;
  let lastTs = 0;
  let bgImg = null;

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
    if (!canvas || !field) return;
    const ctx = canvas.getContext('2d');
    const w = wrap?.clientWidth || canvas.clientWidth;
    const h = wrap?.clientHeight || canvas.clientHeight;
    const dt = lastTs ? Math.min(0.05, (ts - lastTs) / 1000) : 0.016;
    lastTs = ts;
    stepIndeepField(field, dt);
    drawIndeepField(ctx, field, { w, h, bgImg }, ts / 1000);
  }

  onMount(() => {
    field = createIndeepField(Date.now());
    const img = new Image();
    img.onload = () => {
      bgImg = img;
    };
    img.src = INDEEP_BG;

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

<div class="indeep" bind:this={wrap}>
  <canvas bind:this={canvas} class="indeep-canvas"></canvas>
  <div class="hud">
    <div class="hud-title">Гипер</div>
    <div class="hud-coords">{x}:{y}</div>
    <div class="hud-meta">
      <a href="/ships" use:link class="hud-link">Управление — Корабли</a>
      {#if demo}<span class="demo">demo</span>{/if}
    </div>
  </div>
</div>

<style>
  .indeep {
    position: relative;
    width: 100%;
    height: 100%;
    min-height: 280px;
    overflow: hidden;
    background: #02040a;
  }

  .indeep-canvas {
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
    color: var(--neon-cyan);
    text-shadow: 0 0 12px color-mix(in srgb, var(--neon-cyan) 45%, transparent);
  }

  .hud-title {
    font-size: 0.78rem;
    letter-spacing: 0.04em;
    text-transform: uppercase;
    color: color-mix(in srgb, var(--neon-cyan) 55%, transparent);
    margin-bottom: 4px;
  }

  .hud-coords {
    font-size: 1.55rem;
    font-weight: 600;
    letter-spacing: 0.06em;
    line-height: 1.1;
  }

  .hud-meta {
    margin-top: 10px;
    display: flex;
    gap: 12px;
    align-items: center;
    font-size: 0.72rem;
    letter-spacing: 0.03em;
    pointer-events: auto;
  }

  .hud-link {
    color: color-mix(in srgb, var(--neon-cyan) 70%, transparent);
    text-decoration: none;
    border-bottom: 1px solid color-mix(in srgb, var(--neon-cyan) 35%, transparent);
  }

  .hud-link:hover {
    color: var(--neon-cyan);
  }

  .demo {
    border: 1px solid color-mix(in srgb, var(--neon-cyan) 55%, transparent);
    padding: 0 6px;
    border-radius: 2px;
    text-transform: uppercase;
    color: color-mix(in srgb, var(--neon-cyan) 55%, transparent);
  }
</style>
