<script>
  import { starFill } from '../galaxyMap.js';
  import {
    SYSTEM_BG_SIZE,
    SYSTEM_MAX_RADIUS,
  } from '../systemMap.js';

  export let viewport = undefined;
  export let idPrefix = 'system';
  export let className = '';
  export let offset = { x: 0, y: 0 };
  export let bounds = { minX: -840, minY: -840, maxX: 840, maxY: 840 };
  export let hover = '';
  export let descHtml = '';
  export let showDesc = false;
  export let bgUrl = '';
  export let stype = 1;

  function starGlowUrl(type) {
    const n = parseInt(type, 10);
    const st = n === 2 || n === 3 ? n : 1;
    return `url(#${idPrefix}-star-glow-${st})`;
  }

  function starRadius(type) {
    const STAR_R = { 1: 34, 2: 26, 3: 33 };
    return STAR_R[type] || STAR_R[1];
  }
</script>

<div
  class="galaxy-viewport system-viewport {className}"
  bind:this={viewport}
  on:pointerdown
  on:pointermove
  on:pointerup
  on:pointerleave
>
  <svg
    class="galaxy-svg system-svg"
    style={`transform:translate(${offset.x}px,${offset.y}px)`}
    width={bounds.maxX - bounds.minX}
    height={bounds.maxY - bounds.minY}
    viewBox={`${bounds.minX} ${bounds.minY} ${bounds.maxX - bounds.minX} ${bounds.maxY - bounds.minY}`}
  >
    {#if bgUrl}
      <image
        href={bgUrl}
        x={-SYSTEM_BG_SIZE / 2}
        y={-SYSTEM_BG_SIZE / 2}
        width={SYSTEM_BG_SIZE}
        height={SYSTEM_BG_SIZE}
        opacity="0.25"
        preserveAspectRatio="none"
      />
    {/if}
    <circle
      cx="0"
      cy="0"
      r={SYSTEM_MAX_RADIUS}
      fill="none"
      stroke="rgba(0, 229, 255, 0.08)"
      stroke-width="1"
      pointer-events="none"
    />
    <defs>
      {#each [1, 2, 3] as st}
        <radialGradient id={`${idPrefix}-star-glow-${st}`} cx="50%" cy="50%" r="50%">
          <stop offset="0%" stop-color="#ffffff" stop-opacity="1" />
          <stop offset="18%" stop-color={starFill(st)} stop-opacity="1" />
          <stop offset="45%" stop-color={starFill(st)} stop-opacity="0.55" />
          <stop offset="78%" stop-color={starFill(st)} stop-opacity="0.12" />
          <stop offset="100%" stop-color={starFill(st)} stop-opacity="0" />
        </radialGradient>
      {/each}
    </defs>
    {#key stype}
      <circle
        cx="0"
        cy="0"
        r={starRadius(stype)}
        fill={starGlowUrl(stype)}
        pointer-events="none"
      />
    {/key}
    <slot />
  </svg>
  {#if hover}
    <div class="galaxy-hover">{hover}</div>
  {/if}
  {#if showDesc}
    <div class="html-rich galaxy-desc">{@html descHtml || 'Кликните по карте'}</div>
  {/if}
</div>

<style>
  .galaxy-viewport {
    position: relative;
    flex: 1 1 auto;
    width: 100%;
    min-height: 0;
    height: auto;
    align-self: stretch;
    overflow: hidden;
    border: 1px solid var(--border-light);
    border-radius: var(--radius-panel, 4px);
    background: #000;
    cursor: crosshair;
    touch-action: none;
  }

  .galaxy-viewport:active {
    cursor: crosshair;
  }

  .galaxy-svg {
    position: absolute;
    left: 0;
    top: 0;
    overflow: visible;
  }

  .galaxy-hover {
    position: absolute;
    right: 8px;
    top: 8px;
    z-index: 2;
    padding: 2px 8px;
    font-size: 0.75rem;
    color: var(--neon-cyan-dim);
    background: rgba(4, 8, 20, 0.55);
    pointer-events: none;
  }

  .galaxy-desc {
    position: absolute;
    left: 10px;
    bottom: 10px;
    z-index: 2;
    max-width: min(70%, 28rem);
    margin: 0;
    padding: 0.35rem 0.55rem;
    font-size: 0.82rem;
    line-height: 1.35;
    color: #fff;
    background: rgba(0, 0, 0, 0.45);
    text-shadow: 0 1px 2px rgba(0, 0, 0, 0.95);
    pointer-events: none;
  }

  .galaxy-desc :global(a) {
    color: inherit;
  }

  .galaxy-desc :global(font) {
    text-shadow: 0 1px 2px rgba(0, 0, 0, 0.9);
  }

  .galaxy-desc :global(font[color='#FF0000']),
  .galaxy-desc :global(font[color='#ff0000']) {
    color: #ffb4b4 !important;
  }

  .galaxy-desc :global(font[color='#FFFF00']),
  .galaxy-desc :global(font[color='#ffff00']) {
    color: #fff3a8 !important;
  }

  .galaxy-desc :global(font[color='#00FF00']),
  .galaxy-desc :global(font[color='#00ff00']) {
    color: #9dffb0 !important;
  }
</style>
