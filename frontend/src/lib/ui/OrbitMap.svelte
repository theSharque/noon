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
      left: slotCenterX(t.x),
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
    const ro = typeof ResizeObserver !== 'undefined' ? new ResizeObserver(layout) : null;
    if (ro && viewport) ro.observe(viewport);
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
    return () => {
      window.removeEventListener('resize', layout);
      ro?.disconnect();
    };
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

  function isMapUiTarget(e) {
    return Boolean(e.target?.closest?.('.frame-btn, .frame-actions, .sel-stop'));
  }

  function isTypingTarget(el) {
    if (!el || !(el instanceof Element)) return false;
    const tag = el.tagName;
    if (tag === 'INPUT' || tag === 'TEXTAREA' || tag === 'SELECT') return true;
    if (el.isContentEditable) return true;
    return Boolean(el.closest?.('input, textarea, select, [contenteditable="true"]'));
  }

  function onKeydown(e) {
    if (e.repeat || e.altKey || e.ctrlKey || e.metaKey) return;
    if (isTypingTarget(e.target)) return;
    if (document.querySelector('.scifi-confirm-backdrop, .tutorial-backdrop')) return;
    let action = null;
    if (e.key === 'Enter' && frameActions.use) action = 'use';
    else if (e.key === 'Escape' && frameActions.stop) action = 'stop';
    else if ((e.key === ' ' || e.key === 'Spacebar') && frameActions.upgrade) action = 'upgrade';
    if (!action) return;
    e.preventDefault();
    dispatch('frame', action);
  }

  function onDown(e) {
    if (e.button !== 0) return;
    if (isMapUiTarget(e)) return;
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
    if (!moved && e.type === 'mouseup' && !isMapUiTarget(e)) {
      const giX = hitTest(localX(e), length);
      dispatch('select', giX);
    }
    dragStart = null;
  }
</script>

<svelte:window on:keydown={onKeydown} />

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
      >
        {#if frameActions.stop}
          <button
            type="button"
            class="sel-stop"
            title="Стоп"
            aria-label="Стоп"
            on:mousedown|stopPropagation
            on:mouseup|stopPropagation
            on:click|stopPropagation={() => dispatch('frame', 'stop')}
          >✕</button>
        {/if}
      </div>

      {#each liveTimers as t (String(t.x))}
        <div class="mtimer" style={`left:${t.left}px; top:-75px; color:${t.color}`}>
          <div class="mtimer-disp">{t.label}</div>
          <div class="mtimer-bar">
            <div class="mtimer-lin" style={`transform:scaleX(${t.progress})`}></div>
          </div>
          <div class="mtimer-cnt">
            {#each Array(t.cycles < 0 ? 9 : Math.min(9, Math.max(0, t.cycles))) as _}
              <span class="mtimer-sq"></span>
            {/each}
          </div>
        </div>
      {/each}

      {#if frameActions.use || frameActions.upgrade}
        <div
          class="frame-actions"
          style={`left:${selX}px; top:-10px`}
          on:mousedown|stopPropagation
          on:mouseup|stopPropagation
        >
          {#if frameActions.use}
            <button type="button" class="frame-btn" on:click|stopPropagation={() => dispatch('frame', 'use')}>Старт</button>
          {/if}
          {#if frameActions.upgrade}
            <button
              type="button"
              class="frame-btn frame-btn-icon"
              title="Ап"
              aria-label="Ап"
              on:click|stopPropagation={() => dispatch('frame', 'upgrade')}
            >
              <svg viewBox="0 0 16 16" aria-hidden="true">
                <path d="M8 1.5 L8 10.5 M4.5 5.5 L8 1.5 L11.5 5.5" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" />
                <path d="M3 13.5 H13" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" />
              </svg>
            </button>
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
    user-select: none;
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
    user-select: none;
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

  .sel-stop {
    position: absolute;
    right: 4px;
    top: 2px;
    z-index: 4;
    width: 1.35em;
    height: 1.35em;
    padding: 0;
    border-radius: 2px;
    border: 1px solid rgba(255, 64, 64, 0.75);
    background: rgba(40, 0, 0, 0.82);
    color: #ff4040;
    font-family: var(--font-mono, ui-monospace, monospace);
    font-size: 12px;
    font-weight: 700;
    line-height: 1.2;
    text-shadow: 0 0 6px rgba(255, 64, 64, 0.55);
    cursor: pointer;
    pointer-events: auto;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .sel-stop:hover {
    background: rgba(80, 0, 0, 0.92);
    color: #ff6868;
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
    width: max-content;
    min-width: 61px;
    padding: 4px 6px 3px;
    margin: -4px 0 0;
    border-radius: 4px;
    background: rgba(0, 0, 0, 0.55);
    box-shadow: 0 0 10px 2px rgba(0, 0, 0, 0.45);
    pointer-events: none;
    font-size: 0.6rem;
    transform: translateX(-50%);
  }

  .mtimer-bar {
    position: relative;
    width: 61px;
    height: 4px;
    margin-top: 2px;
    background: rgba(0, 0, 0, 0.45);
    border: 1px solid rgba(255, 255, 255, 0.25);
    box-sizing: border-box;
    overflow: hidden;
  }

  .mtimer-lin {
    position: absolute;
    inset: 0;
    background: currentColor;
    transform-origin: left center;
  }

  .mtimer-cnt {
    display: flex;
    gap: 2px;
    width: 61px;
    margin-top: 3px;
    min-height: 5px;
  }

  .mtimer-sq {
    width: 5px;
    height: 5px;
    flex-shrink: 0;
    background: currentColor;
  }

  .mtimer-disp {
    line-height: 1.1;
    letter-spacing: 0.02em;
    text-shadow: 0 1px 2px #000, 0 0 6px rgba(0, 0, 0, 0.9);
  }

  .frame-actions {
    position: absolute;
    z-index: 8;
    transform: translate(-50%, -100%);
    display: flex;
    gap: 4px;
    pointer-events: auto;
  }

  .frame-btn {
    border: 1px solid rgba(0, 229, 255, 0.55);
    background: rgba(4, 12, 28, 0.85);
    color: var(--text-main, #e8f4ff);
    font-size: 0.7rem;
    padding: 2px 8px;
    cursor: pointer;
    pointer-events: auto;
  }

  .frame-btn-icon {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 1.55rem;
    height: 1.55rem;
    padding: 0;
  }

  .frame-btn-icon svg {
    width: 0.95rem;
    height: 0.95rem;
    display: block;
  }
</style>
