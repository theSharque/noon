<script>
  import {
    BH_CORE_R,
    BH_GLOW_R,
    GALAXY_BG,
    GALAXY_BG_HALF,
    GALAXY_BG_SIZE,
    GALAXY_MAX_RADIUS,
    QUEST_MARK_S,
    FRIEND_RING_R,
    FOE_RING_R,
    HOME_RING_R,
    RING_R,
    RING_STROKE,
    STAR_CORE_R,
    isBlackHole,
    ringStroke,
    starFill,
    starGlowR,
  } from '../galaxyMap.js';

  export let viewport = undefined;
  export let idPrefix = 'galaxy';
  export let className = '';
  export let stars = [];
  export let yellow = [];
  export let home = null;
  export let hideHomeRing = false;
  export let quest = null;
  export let ship = null;
  export let cross = null;
  export let offset = { x: 0, y: 0 };
  export let bounds = { minX: 0, minY: 0, maxX: 800, maxY: 600 };
  export let hover = '';
  export let descHtml = '';
  export let showDesc = false;

  function starGlowUrl(type) {
    const n = parseInt(type, 10);
    const st = n === 2 || n === 3 || n === 5 ? n : 1;
    return `url(#${idPrefix}-star-glow-${st})`;
  }
</script>

<div
  class="galaxy-viewport {className}"
  bind:this={viewport}
  on:pointerdown
  on:pointermove
  on:pointerup
  on:pointerleave
>
  <svg
    class="galaxy-svg"
    style={`transform:translate(${offset.x}px,${offset.y}px)`}
    width={bounds.maxX - bounds.minX}
    height={bounds.maxY - bounds.minY}
    viewBox={`${bounds.minX} ${bounds.minY} ${bounds.maxX - bounds.minX} ${bounds.maxY - bounds.minY}`}
  >
    <defs>
      <radialGradient id={`${idPrefix}-bh-glow`} cx="50%" cy="50%" r="50%">
        <stop offset="0%" stop-color="#c800ff" stop-opacity="0.95" />
        <stop offset="30%" stop-color="#c800ff" stop-opacity="0.2" />
        <stop offset="100%" stop-color="#c800ff" stop-opacity="0" />
      </radialGradient>
      {#each [1, 2, 3, 5] as st}
        <radialGradient id={`${idPrefix}-star-glow-${st}`} cx="50%" cy="50%" r="50%">
          <stop offset="0%" stop-color={starFill(st)} stop-opacity="0.95" />
          <stop offset="40%" stop-color={starFill(st)} stop-opacity="0.35" />
          <stop offset="100%" stop-color={starFill(st)} stop-opacity="0" />
        </radialGradient>
      {/each}
    </defs>
    <image
      href={GALAXY_BG}
      x={-GALAXY_BG_HALF}
      y={-GALAXY_BG_HALF}
      width={GALAXY_BG_SIZE}
      height={GALAXY_BG_SIZE}
      opacity="0.25"
      preserveAspectRatio="none"
    />
    <circle
      class="map-bound"
      cx="0"
      cy="0"
      r={GALAXY_MAX_RADIUS}
      fill="none"
      stroke="rgba(180, 220, 255, 0.35)"
      stroke-width="1.5"
      stroke-dasharray="18 14"
      pointer-events="none"
    />
    {#each yellow as y}
      <circle
        cx={y.x}
        cy={y.y}
        r={RING_R}
        fill="none"
        stroke={ringStroke('yellow')}
        stroke-width={RING_STROKE}
      />
    {/each}
    {#each stars as s}
      {#if s.friend}
        <circle
          cx={s.x}
          cy={s.y}
          r={FRIEND_RING_R}
          fill="none"
          stroke={ringStroke('friend')}
          stroke-width={RING_STROKE}
        />
      {/if}
      {#if s.foe}
        <circle
          cx={s.x}
          cy={s.y}
          r={FOE_RING_R}
          fill="none"
          stroke={ringStroke('foe')}
          stroke-width={RING_STROKE}
        />
      {/if}
      {#if s.aliance}
        <circle
          cx={s.x}
          cy={s.y}
          r={RING_R}
          fill="none"
          stroke={ringStroke('aliance')}
          stroke-width={RING_STROKE}
        />
      {/if}
      {#if isBlackHole(s.type)}
        <circle cx={s.x} cy={s.y} r={BH_GLOW_R} fill={`url(#${idPrefix}-bh-glow)`} />
        <circle cx={s.x} cy={s.y} r={BH_CORE_R} fill="#000000" />
      {:else}
        <circle
          cx={s.x}
          cy={s.y}
          r={starGlowR(s.type)}
          fill={starGlowUrl(s.type)}
        />
        <circle cx={s.x} cy={s.y} r={STAR_CORE_R} fill={starFill(s.type)} />
      {/if}
    {/each}
    {#if home && !hideHomeRing}
      <circle
        cx={home.x}
        cy={home.y}
        r={HOME_RING_R}
        fill="none"
        stroke={ringStroke('home')}
        stroke-width={RING_STROKE}
      />
    {/if}
    {#if quest}
      <g transform={`rotate(45 ${quest.x} ${quest.y})`}>
        <rect
          x={quest.x - QUEST_MARK_S / 2}
          y={quest.y - QUEST_MARK_S / 2}
          width={QUEST_MARK_S}
          height={QUEST_MARK_S}
          fill="none"
          stroke="#ffffff"
          stroke-width={RING_STROKE}
        />
      </g>
    {/if}
    {#if ship}
      <circle
        cx={ship.x}
        cy={ship.y}
        r={RING_R}
        fill="none"
        stroke="#ffffff"
        stroke-width={RING_STROKE}
      />
    {/if}
    {#if cross}
      <g stroke="var(--neon-cyan)" stroke-width="1.5">
        <line x1={cross.x - 8} y1={cross.y} x2={cross.x + 8} y2={cross.y} />
        <line x1={cross.x} y1={cross.y - 8} x2={cross.x} y2={cross.y + 8} />
      </g>
    {/if}
    <slot />
  </svg>
  {#if hover}
    <div class="galaxy-hover">{hover}</div>
  {/if}
  {#if showDesc}
    <div class="html-rich galaxy-desc">{@html descHtml || 'Кликните по карте'}</div>
  {/if}
  <slot name="overlay" />
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
    user-select: none;
  }

  .galaxy-viewport:active {
    cursor: crosshair;
  }

  .galaxy-viewport.bleed {
    border: none;
    border-radius: 0;
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
    color: #ffe566 !important;
  }

  .galaxy-desc :global(font[color='#00FF00']),
  .galaxy-desc :global(font[color='#00ff00']) {
    color: #9dff9d !important;
  }
</style>
