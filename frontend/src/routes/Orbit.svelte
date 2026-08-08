<script>
  import { createEventDispatcher, onMount } from 'svelte';
  import {
    destroyOrbitTile,
    loadOrbitInfo,
    loadOrbitMap,
    loadOrbitUpgrade,
    loadOrbitUse,
  } from '../lib/api.js';
  import OrbitMap from '../lib/ui/OrbitMap.svelte';
  import PlaceControlPanel from '../lib/ui/PlaceControlPanel.svelte';

  export let initialMap = null;
  export let bgUrl = '';

  const dispatch = createEventDispatcher();

  let mapRef;
  let panelRef;
  let frameActions = { use: false, stop: false, upgrade: false };

  let line = '';
  let timers = [];
  let selected = 0;
  let pid = 1;
  let mapReady = false;

  $: coordLabel = `Слот ${selected}`;
  $: loadInfo = () => loadOrbitInfo(selected);
  $: loadUse = () => loadOrbitUse(selected);
  $: loadUpgrade = () => loadOrbitUpgrade(selected);
  $: destroyTile = () => destroyOrbitTile(selected);

  function stampTimers(list) {
    const started = Date.now();
    return (list || []).map((t) => ({ ...t, _started: started }));
  }

  function applyMap(data) {
    if (!data?.ok) return;
    line = data.line || '';
    timers = stampTimers(data.timers || []);
    pid = data.pid || 1;
    if (!mapReady) {
      let lx = Number.isFinite(data.lastx) ? data.lastx : 0;
      if (line.length > 0) lx = Math.max(0, Math.min(line.length - 1, lx));
      selected = lx;
      mapReady = true;
    }
  }

  async function mapRefresh() {
    const data = await loadOrbitMap();
    if (!data.ok) return;
    applyMap(data);
  }

  async function onSelect(e) {
    selected = e.detail;
    panelRef?.playSelect?.();
    await panelRef?.refresh?.();
  }

  async function onChanged() {
    await mapRefresh();
  }

  function onPlaceChanged() {
    dispatch('placeChanged');
  }

  async function onTimerDone(e) {
    const { x } = e.detail;
    await mapRefresh();
    if (selected === x) await panelRef?.refresh?.();
  }

  onMount(() => {
    (async () => {
      if (initialMap?.ok) applyMap(initialMap);
      else await mapRefresh();
      await panelRef?.refresh?.();
      requestAnimationFrame(() => mapRef?.centerOn?.(selected));
    })();
  });
</script>

<div class="orbit-screen">
  <div class="orbit-main">
    <OrbitMap
      bind:this={mapRef}
      {line}
      {timers}
      {selected}
      {pid}
      {bgUrl}
      {frameActions}
      on:select={onSelect}
      on:timerDone={onTimerDone}
      on:frame={(e) => panelRef?.runAction?.(e.detail)}
    />
  </div>

  <PlaceControlPanel
    bind:this={panelRef}
    bind:frameActions
    {coordLabel}
    {loadInfo}
    {loadUse}
    {loadUpgrade}
    {destroyTile}
    on:changed={onChanged}
    on:placeChanged={onPlaceChanged}
  />
</div>

<style>
  .orbit-screen {
    position: relative;
    min-height: 0;
    height: 100%;
    overflow: hidden;
  }

  .orbit-main {
    position: absolute;
    inset: 0;
    min-height: 0;
    min-width: 0;
  }
</style>
