<script>
  import { createEventDispatcher, onDestroy, onMount } from 'svelte';
  import {
    HEX_POINTS,
    TILE_H,
    TILE_W,
    buildingSrc,
    cellX,
    cellY,
    clampMapOffset,
    decorSrc,
    formatRemain,
    hitTest,
    mapPixelSize,
    selectionPos,
    terrainColor,
    terrainSrc,
    tileDrawPos,
    timerColor,
    timerPos,
  } from '../planetMap.js';

  export let ground = [];
  export let buildings = [];
  export let trees = [];
  export let highlights = [];
  export let timers = [];
  export let selected = { x: 0, y: 0 };
  export let zoom = 1;
  export let mapLight = false;
  export let frameActions = { use: false, stop: false, upgrade: false };

  const dispatch = createEventDispatcher();

  let viewport;
  let offset = { x: 40, y: 20 };
  let dragging = false;
  let dragStart = null;
  let moved = false;
  let now = Date.now();
  let tickId;
  let miniExpanded = false;
  let doneKeys = new Set();

  $: height = ground.length || buildings.length || 0;
  $: width = buildings[0]?.length || ground[0]?.length || 0;
  $: size = mapPixelSize(width || 1, height || 1);
  $: scale = 1 / zoom;
  $: sel = selectionPos(selected.x, selected.y);
  $: liveTimers = timers.map((t) => {
    const elapsed = (now - (t._started || now)) / 1000;
    let remain = t.remain - elapsed;
    let cycles = t.cycles;
    let total = t.total || 1;
    while (remain <= 0 && cycles !== 0) {
      if (cycles > 0) cycles -= 1;
      if (cycles === 0 && t.cycles >= 0) {
        remain = 0;
        break;
      }
      remain += total;
    }
    const bld = buildings[t.y]?.charAt(t.x) || '0';
    const progress = total > 0 ? Math.max(0, Math.min(1, remain / total)) : 0;
    return {
      ...t,
      remain,
      cycles,
      progress,
      color: timerColor(t.eventType, cycles, bld),
      label: formatRemain(remain),
      pos: timerPos(t.x, t.y),
      done: remain <= 0 && cycles === 0 && t.cycles >= 0,
    };
  });

  $: fx = 300 / (width + 0.5 || 1);
  $: fy = 300 / (height || 1);

  $: {
    const keys = new Set(timers.map((t) => `${t.x}x${t.y}`));
    for (const k of [...doneKeys]) {
      if (!keys.has(k)) doneKeys.delete(k);
    }
  }

  onMount(() => {
    tickId = setInterval(() => {
      now = Date.now();
      for (const t of liveTimers) {
        const key = `${t.x}x${t.y}`;
        if (t.done && !doneKeys.has(key)) {
          doneKeys.add(key);
          dispatch('timerDone', { x: t.x, y: t.y });
        }
      }
    }, 500);
  });

  onDestroy(() => {
    if (tickId) clearInterval(tickId);
  });

  export function centerOn(x, y) {
    if (!viewport) return;
    offset = {
      x: viewport.clientWidth / 2 - cellX(x, y) * scale,
      y: viewport.clientHeight / 2 - cellY(y) * scale,
    };
    offset = clampMapOffset(offset.x, offset.y, size.w, size.h, viewport.clientWidth, viewport.clientHeight, zoom);
  }

  function localPoint(e) {
    const rect = viewport.getBoundingClientRect();
    return {
      x: (e.clientX - rect.left - offset.x) / scale,
      y: (e.clientY - rect.top - offset.y) / scale,
    };
  }

  function onPointerDown(e) {
    if (e.button !== 0) return;
    dragging = true;
    moved = false;
    dragStart = { x: e.clientX, y: e.clientY, ox: offset.x, oy: offset.y };
    viewport.setPointerCapture?.(e.pointerId);
  }

  function onPointerMove(e) {
    if (!dragging || !dragStart) return;
    const dx = e.clientX - dragStart.x;
    const dy = e.clientY - dragStart.y;
    if (Math.hypot(dx, dy) > 10) moved = true;
    offset = clampMapOffset(
      dragStart.ox + dx,
      dragStart.oy + dy,
      size.w,
      size.h,
      viewport.clientWidth,
      viewport.clientHeight,
      zoom,
    );
  }

  function onPointerUp(e) {
    if (!dragging) return;
    dragging = false;
    if (!moved) {
      const pt = localPoint(e);
      const cell = hitTest(pt.x, pt.y, width, height);
      dispatch('select', cell);
    }
    dragStart = null;
  }

  function onWheel(e) {
    e.preventDefault();
    if (e.deltaY < 0 && zoom > 1) dispatch('zoom', zoom - 1);
    else if (e.deltaY > 0 && zoom < 4) dispatch('zoom', zoom + 1);
  }

  function onMiniClick(e) {
    const rect = e.currentTarget.getBoundingClientRect();
    const mx = e.clientX - rect.left;
    const my = e.clientY - rect.top;
    let gy = Math.floor(my / fy);
    let gx = gy % 2 === 0 ? Math.floor(mx / fx) : Math.floor(mx / fx - 0.5);
    if (gx < 0) gx = 0;
    if (gy < 0) gy = 0;
    if (gx >= width) gx = width - 1;
    if (gy >= height) gy = height - 1;
    dispatch('select', { x: gx, y: gy });
    centerOn(gx, gy);
  }

  function hlChar(x, y) {
    return highlights[y]?.charAt(x) || '0';
  }

  function miniFill(x, y) {
    let ch = ground[y]?.charAt(x) || '0';
    let color = terrainColor(ch);
    if (mapLight) {
      const hl = hlChar(x, y);
      if (hl === '1') color = '#000066';
      else if (hl === '2') color = '#000000';
    }
    return color;
  }
</script>

<div class="planet-map-wrap">
  <div
    class="planet-viewport"
    bind:this={viewport}
    on:pointerdown={onPointerDown}
    on:pointermove={onPointerMove}
    on:pointerup={onPointerUp}
    on:pointerleave={onPointerUp}
    on:wheel={onWheel}
  >
    <div
      class="planet-layer"
      style={`transform:translate(${offset.x}px,${offset.y}px) scale(${scale}); width:${size.w}px; height:${size.h}px`}
    >
      {#each ground as row, y}
        {#each row.split('') as ch, x}
          {@const tp = tileDrawPos(x, y)}
          <img
            class="tile"
            src={terrainSrc(ch)}
            alt=""
            draggable="false"
            style={`left:${tp.x}px; top:${tp.y}px; width:${TILE_W}px; height:${TILE_H}px`}
          />
        {/each}
      {/each}

      <div class="sel-frame" style={`left:${sel.x}px; top:${sel.y}px; width:${TILE_W}px; height:${TILE_H}px`}>
        <svg class="sel-hex" viewBox={`0 0 ${TILE_W} ${TILE_H}`} aria-hidden="true">
          <polygon class="sel-hex-glow" points={HEX_POINTS} />
          <polygon class="sel-hex-stroke" points={HEX_POINTS} />
        </svg>
      </div>

      {#each buildings as row, y}
        {#each row.split('') as ch, x}
          {#if ch !== '0'}
            <img
              class="bld"
              src={buildingSrc(ch)}
              alt={ch}
              draggable="false"
              style={`left:${cellX(x, y)}px; top:${cellY(y)}px`}
            />
          {:else if trees[y]?.charAt(x) && trees[y].charAt(x) !== '0'}
            <img
              class="decor"
              src={decorSrc(trees[y].charAt(x))}
              alt=""
              draggable="false"
              style={`left:${cellX(x, y)}px; top:${cellY(y)}px`}
            />
          {/if}
        {/each}
      {/each}

      {#each liveTimers as t ( `${t.x}x${t.y}` )}
        <div class="mtimer" style={`left:${t.pos.x}px; top:${t.pos.y}px; color:${t.color}`}>
          <div class="mtimer-bar">
            <div class="mtimer-lin" style={`transform:scaleX(${t.progress})`}></div>
            <div class="mtimer-cnt" style={`width:${Math.max(0, t.cycles) * 5}px`}></div>
          </div>
          <div class="mtimer-disp">{t.label}</div>
        </div>
      {/each}

      {#if frameActions.use || frameActions.stop || frameActions.upgrade}
        <div class="frame-actions" style={`left:${sel.x + TILE_W / 2}px; top:${sel.y}px`}>
          {#if frameActions.stop}
            <button type="button" class="frame-btn" on:click|stopPropagation={() => dispatch('frame', 'stop')}>Стоп</button>
          {/if}
          {#if frameActions.use}
            <button type="button" class="frame-btn" on:click|stopPropagation={() => dispatch('frame', 'use')}>Старт</button>
          {/if}
          {#if frameActions.upgrade}
            <button type="button" class="frame-btn" on:click|stopPropagation={() => dispatch('frame', 'upgrade')}>Ап</button>
          {/if}
        </div>
      {/if}
    </div>
  </div>

  {#if width > 1}
    <div
      class="minimap"
      class:expanded={miniExpanded}
      on:mouseenter={() => (miniExpanded = true)}
      on:mouseleave={() => (miniExpanded = false)}
    >
      <div class="mini-canvas" on:click={onMiniClick} role="presentation">
        {#each Array(height) as _, y}
          {#each Array(width) as _, x}
            <div
              class="mini-cell"
              style={`
                left:${(y % 2 === 0 ? x * fx : fx / 2 + x * fx)}px;
                top:${y * fy}px;
                width:${fx}px;
                height:${fy}px;
                background:${miniFill(x, y)};
              `}
            ></div>
          {/each}
        {/each}
        <div
          class="mini-sel"
          style={`
            left:${(selected.y % 2 === 0 ? selected.x * fx : fx / 2 + selected.x * fx)}px;
            top:${selected.y * fy}px;
            width:${fx}px;
            height:${fy}px;
          `}
        ></div>
      </div>
    </div>
  {/if}

  <div class="zoom-bar">
    <button type="button" class="zbtn" disabled={zoom <= 1} on:click={() => dispatch('zoom', zoom - 1)}>−</button>
    <span>{zoom}×</span>
    <button type="button" class="zbtn" disabled={zoom >= 4} on:click={() => dispatch('zoom', zoom + 1)}>+</button>
  </div>
</div>

<style>
  .planet-map-wrap {
    position: relative;
    min-height: 0;
    height: 100%;
    border: 1px solid var(--border-light);
    border-radius: var(--radius-panel);
    overflow: hidden;
    background: radial-gradient(ellipse at 30% 20%, rgba(0, 40, 80, 0.55), rgba(2, 8, 20, 0.95));
  }

  .planet-viewport {
    width: 100%;
    height: 100%;
    overflow: hidden;
    touch-action: none;
    cursor: grab;
  }

  .planet-viewport:active {
    cursor: grabbing;
  }

  .planet-layer {
    position: relative;
    transform-origin: 0 0;
    will-change: transform;
  }

  .tile {
    position: absolute;
    pointer-events: none;
    user-select: none;
    z-index: 1;
  }

  .bld,
  .decor {
    position: absolute;
    pointer-events: none;
    user-select: none;
    transform: translate(-50%, -50%);
    z-index: 3;
  }

  .mtimer {
    position: absolute;
    z-index: 5;
    width: 117px;
    pointer-events: none;
    font-family: var(--font-mono);
  }

  .mtimer-bar {
    position: relative;
    height: 8px;
    background: rgba(0, 0, 0, 0.55);
    border: 1px solid rgba(255, 255, 255, 0.2);
    overflow: hidden;
  }

  .mtimer-lin {
    position: absolute;
    inset: 0;
    transform-origin: left center;
    background: currentColor;
    opacity: 0.85;
  }

  .mtimer-cnt {
    position: absolute;
    left: 0;
    top: 0;
    bottom: 0;
    background: repeating-linear-gradient(
      90deg,
      currentColor 0 3px,
      transparent 3px 5px
    );
    opacity: 0.95;
  }

  .mtimer-disp {
    font-size: 0.7rem;
    text-shadow: 0 0 4px #000;
    margin-top: 1px;
  }

  .sel-frame {
    position: absolute;
    z-index: 2;
    pointer-events: none;
  }

  .sel-hex {
    display: block;
    width: 100%;
    height: 100%;
    overflow: visible;
    animation: sel-frame-pulse 2.286s linear infinite;
  }

  .sel-hex-glow {
    fill: rgba(0, 229, 255, 0.1);
    stroke: var(--neon-cyan);
    stroke-width: 6;
    stroke-linejoin: round;
    opacity: 0.45;
    filter: blur(2px);
  }

  .sel-hex-stroke {
    fill: rgba(0, 229, 255, 0.08);
    stroke: var(--neon-cyan);
    stroke-width: 2.5;
    stroke-linejoin: round;
  }

  @keyframes sel-frame-pulse {
    0%,
    100% {
      opacity: 1;
    }
    47.5% {
      opacity: 0;
    }
  }

  .frame-actions {
    position: absolute;
    z-index: 6;
    transform: translate(-50%, -100%);
    display: flex;
    gap: 4px;
    margin-top: -4px;
    pointer-events: auto;
  }

  .frame-btn {
    border: 1px solid var(--border-active);
    background: rgba(4, 20, 40, 0.9);
    color: var(--neon-cyan);
    font-size: 0.7rem;
    padding: 2px 6px;
    border-radius: 3px;
    cursor: pointer;
  }

  .minimap {
    position: absolute;
    top: 8px;
    left: 8px;
    width: 34px;
    height: 30px;
    opacity: 0.55;
    overflow: hidden;
    border: 1px solid var(--border-light);
    background: #000;
    transition: width 0.25s ease, height 0.25s ease, opacity 0.25s ease;
    z-index: 8;
  }

  .minimap.expanded {
    width: 300px;
    height: 300px;
    opacity: 1;
  }

  .mini-canvas {
    position: relative;
    width: 300px;
    height: 300px;
    cursor: crosshair;
  }

  .mini-cell {
    position: absolute;
    box-sizing: border-box;
  }

  .mini-sel {
    position: absolute;
    box-sizing: border-box;
    border: 1px solid var(--neon-cyan);
    pointer-events: none;
  }

  .zoom-bar {
    position: absolute;
    right: 10px;
    bottom: 10px;
    z-index: 8;
    display: flex;
    align-items: center;
    gap: 6px;
    padding: 4px 8px;
    background: rgba(4, 16, 32, 0.85);
    border: 1px solid var(--border-light);
    border-radius: 4px;
    font-family: var(--font-mono);
    font-size: 0.8rem;
    color: var(--text-main);
  }

  .zbtn {
    width: 22px;
    height: 22px;
    border: 1px solid var(--border-active);
    background: transparent;
    color: var(--neon-cyan);
    cursor: pointer;
  }

  .zbtn:disabled {
    opacity: 0.35;
    cursor: default;
  }
</style>
