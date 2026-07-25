<script>
  import { createEventDispatcher, onDestroy, onMount } from 'svelte';
  import {
    SLOT_H,
    SLOT_W,
    buildingSrc,
    clampOrbitOffset,
    emptySrc,
    formatRemain,
    hitTest,
    mapPixelWidth,
    planetBgSrc,
    slotCenterX,
    timerColor,
  } from '../orbitMap.js';

  export let line = '';
  export let timers = [];
  export let selected = 0;
  export let pid = 1;
  export let frameActions = { use: false, stop: false, upgrade: false };

  const dispatch = createEventDispatcher();

  let viewport;
  let offsetX = 0;
  let stripY = 0;
  let dragging = false;
  let dragStart = null;
  let moved = false;
  let now = Date.now();
  let tickId;
  let doneKeys = new Set();

  $: length = line.length;
  $: mapW = mapPixelWidth(length || 1);
  $: bgSrc = planetBgSrc(pid);
  $: selX = slotCenterX(selected);

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
    const progress = total > 0 ? Math.max(0, Math.min(1, remain / total)) : 0;
    return {
      ...t,
      remain,
      cycles,
      progress,
      color: timerColor(t.eventType, cycles),
      label: formatRemain(remain),
      left: slotCenterX(t.x) - 25,
      done: remain <= 0 && cycles === 0 && t.cycles >= 0,
    };
  });

  $: {
    const keys = new Set(timers.map((t) => String(t.x)));
    for (const k of [...doneKeys]) {
      if (!keys.has(k)) doneKeys.delete(k);
    }
  }

  onMount(() => {
    const layout = () => {
      if (!viewport) return;
      stripY = Math.max(80, viewport.clientHeight * 0.45);
      offsetX = clampOrbitOffset(offsetX, mapW, viewport.clientWidth);
    };
    layout();
    window.addEventListener('resize', layout);
    tickId = setInterval(() => {
      now = Date.now();
      for (const t of liveTimers) {
        const key = String(t.x);
        if (t.done && !doneKeys.has(key)) {
          doneKeys.add(key);
          dispatch('timerDone', { x: t.x });
        }
      }
    }, 500);
    return () => window.removeEventListener('resize', layout);
  });

  onDestroy(() => {
    if (tickId) clearInterval(tickId);
  });

  export function centerOn(x) {
    if (!viewport) return;
    offsetX = clampOrbitOffset(
      viewport.clientWidth / 2 - slotCenterX(x),
      mapW,
      viewport.clientWidth,
    );
  }

  function localX(e) {
    const rect = viewport.getBoundingClientRect();
    return e.clientX - rect.left - offsetX;
  }

  function onDown(e) {
    if (e.button !== 0) return;
    dragging = true;
    moved = false;
    dragStart = { x: e.clientX, ox: offsetX };
  }

  function onMove(e) {
    if (!dragging || !dragStart) return;
    const dx = e.clientX - dragStart.x;
    if (Math.abs(dx) > 4) moved = true;
    offsetX = clampOrbitOffset(dragStart.ox + dx, mapW, viewport.clientWidth);
  }

  function onUp(e) {
    if (!dragging) return;
    dragging = false;
    if (!moved && e.type === 'mouseup') {
      const giX = hitTest(localX(e), length);
      dispatch('select', giX);
    }
    dragStart = null;
  }
</script>

<div class="orbit-map-wrap">
  <div class="orbit-bg" style={`background-image:url('${bgSrc}')`}></div>
  <div
    class="orbit-viewport"
    bind:this={viewport}
    on:mousedown={onDown}
    on:mousemove={onMove}
    on:mouseup={onUp}
    on:mouseleave={onUp}
    role="presentation"
  >
    <div
      class="orbit-strip"
      style={`transform:translate(${offsetX}px, ${stripY}px); width:${mapW}px; height:${SLOT_H}px`}
    >
      {#each Array(length) as _, i}
        {@const ch = line.charAt(i)}
        {@const isWide = ch === '0' || !ch || ch === 'B'}
        {@const half = isWide ? SLOT_W / 2 : 50}
        {#if ch === '0' || !ch}
          <img
            class="slot empty"
            src={emptySrc()}
            alt=""
            draggable="false"
            style={`left:${slotCenterX(i) - half}px; top:-25px; width:${SLOT_W}px; height:${SLOT_H}px`}
          />
        {:else}
          <img
            class="slot bld"
            src={buildingSrc(ch)}
            alt={ch}
            draggable="false"
            style={`left:${slotCenterX(i) - half}px; top:${ch === 'B' ? -25 : 0}px; width:${isWide ? SLOT_W : 100}px; height:${isWide ? SLOT_H : 100}px`}
          />
        {/if}
      {/each}

      <div
        class="sel-frame"
        class:pulse={true}
        style={`left:${selX - SLOT_W / 2}px; top:-25px; width:${SLOT_W}px; height:${SLOT_H}px`}
      ></div>

      {#each liveTimers as t (String(t.x))}
        <div class="mtimer" style={`left:${t.left}px; top:-75px; color:${t.color}`}>
          <div class="mtimer-bar">
            <div class="mtimer-lin" style={`transform:scaleX(${t.progress})`}></div>
            <div class="mtimer-cnt" style={`width:${Math.max(0, t.cycles) * 5}px`}></div>
          </div>
          <div class="mtimer-disp">{t.label}</div>
        </div>
      {/each}

      {#if frameActions.use || frameActions.stop || frameActions.upgrade}
        <div class="frame-actions" style={`left:${selX}px; top:-10px`}>
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
</div>

<style>
  .orbit-map-wrap {
    position: relative;
    width: 100%;
    height: 100%;
    overflow: hidden;
    background: #02060f;
  }

  .orbit-bg {
    position: absolute;
    inset: 0;
    background-position: 70% 45%;
    background-repeat: no-repeat;
    background-size: min(70vmin, 520px);
    filter: saturate(1.05);
    pointer-events: none;
  }

  .orbit-viewport {
    position: absolute;
    inset: 0;
    cursor: grab;
    touch-action: none;
  }

  .orbit-viewport:active {
    cursor: grabbing;
  }

  .orbit-strip {
    position: absolute;
    left: 0;
    top: 0;
    will-change: transform;
  }

  .slot {
    position: absolute;
    width: 150px;
    height: 150px;
    object-fit: contain;
    pointer-events: none;
    user-select: none;
    z-index: 3;
  }

  .slot.empty {
    z-index: 1;
    opacity: 0.85;
  }

  .sel-frame {
    position: absolute;
    z-index: 2;
    border: 2px solid rgba(0, 229, 255, 0.65);
    box-shadow: 0 0 12px rgba(0, 229, 255, 0.35);
    border-radius: 8px;
    pointer-events: none;
  }

  .sel-frame.pulse {
    animation: pulse 1.6s ease-in-out infinite;
  }

  @keyframes pulse {
    0%,
    100% {
      opacity: 0.55;
    }
    50% {
      opacity: 1;
    }
  }

  .mtimer {
    position: absolute;
    z-index: 5;
    width: 150px;
    pointer-events: none;
    font-size: 0.7rem;
    text-shadow: 0 0 4px #000;
  }

  .mtimer-bar {
    position: relative;
    height: 6px;
    background: rgba(0, 0, 0, 0.45);
    border: 1px solid rgba(255, 255, 255, 0.25);
    overflow: hidden;
  }

  .mtimer-lin {
    position: absolute;
    inset: 0;
    background: currentColor;
    transform-origin: left center;
  }

  .mtimer-cnt {
    position: absolute;
    left: 0;
    bottom: 0;
    height: 2px;
    background: #fff;
  }

  .mtimer-disp {
    margin-top: 2px;
    text-align: center;
  }

  .frame-actions {
    position: absolute;
    z-index: 6;
    transform: translate(-50%, -100%);
    display: flex;
    gap: 4px;
  }

  .frame-btn {
    border: 1px solid rgba(0, 229, 255, 0.55);
    background: rgba(4, 12, 28, 0.85);
    color: var(--text-main, #e8f4ff);
    font-size: 0.7rem;
    padding: 2px 8px;
    cursor: pointer;
  }
</style>
