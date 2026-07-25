<script>
  import { onMount } from 'svelte';
  import {
    destroyPlanetTile,
    loadPlanetInfo,
    loadPlanetMap,
    loadPlanetUpgrade,
    loadPlanetUse,
  } from '../lib/api.js';
  import PlanetMap from '../lib/ui/PlanetMap.svelte';
  import PlaceControlPanel from '../lib/ui/PlaceControlPanel.svelte';

  export let mapLight = 0;
  export let initialMap = null;

  let mapRef;
  let panelRef;
  let zoom = 1;
  let frameActions = { use: false, stop: false, upgrade: false };

  let ground = [];
  let buildings = [];
  let trees = [];
  let highlights = [];
  let timers = [];
  let selected = { x: 0, y: 0 };
  let mapReady = false;

  $: coordLabel = `Координаты ${selected.x} : ${selected.y}`;
  $: loadInfo = () => loadPlanetInfo(selected.x, selected.y);
  $: loadUse = () => loadPlanetUse(selected.x, selected.y);
  $: loadUpgrade = () => loadPlanetUpgrade(selected.x, selected.y);
  $: destroyTile = () => destroyPlanetTile(selected.x, selected.y);

  function stampTimers(list) {
    const started = Date.now();
    return (list || []).map((t) => ({ ...t, _started: started }));
  }

  function applyMap(data, { full = false } = {}) {
    if (full && data.ground?.length) ground = data.ground;
    if (data.buildings) buildings = data.buildings;
    if (data.trees) trees = data.trees;
    if (data.highlights) highlights = data.highlights;
    timers = stampTimers(data.timers || []);
    const h = (full ? data.ground?.length : buildings.length) || buildings.length || ground.length || 0;
    const w = (data.buildings?.[0] || data.ground?.[0] || buildings[0] || ground[0] || '').length;
    if (!mapReady && data.ok) {
      let lx = Number.isFinite(data.lastx) ? data.lastx : 0;
      let ly = Number.isFinite(data.lasty) ? data.lasty : 0;
      if (w > 0) lx = Math.max(0, Math.min(w - 1, lx));
      if (h > 0) ly = Math.max(0, Math.min(h - 1, ly));
      selected = { x: lx, y: ly };
      mapReady = true;
    }
  }

  async function mapRefresh(full = false) {
    const data = await loadPlanetMap({ full, ml: mapLight });
    if (!data.ok && data.err !== '0') return;
    applyMap(data, { full });
  }

  async function onSelect(e) {
    selected = e.detail;
    panelRef?.playSelect?.();
    await panelRef?.refresh?.();
  }

  async function onChanged() {
    await mapRefresh(false);
  }

  async function onTimerDone(e) {
    const { x, y } = e.detail;
    await mapRefresh(false);
    if (selected.x === x && selected.y === y) await panelRef?.refresh?.();
  }

  onMount(() => {
    (async () => {
      if (initialMap?.ok) applyMap(initialMap, { full: true });
      else await mapRefresh(true);
      await panelRef?.refresh?.();
      requestAnimationFrame(() => mapRef?.centerOn?.(selected.x, selected.y));
    })();
  });
</script>

<div class="planet-screen">
  <div class="planet-main">
    <PlanetMap
      bind:this={mapRef}
      {ground}
      {buildings}
      {trees}
      {highlights}
      {timers}
      {selected}
      {zoom}
      mapLight={Boolean(mapLight)}
      {frameActions}
      on:select={onSelect}
      on:zoom={(e) => (zoom = e.detail)}
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
  />
</div>

<style>
  .planet-screen {
    position: relative;
    min-height: 0;
    height: 100%;
    overflow: hidden;
  }

  .planet-main {
    position: absolute;
    inset: 0;
    min-height: 0;
    min-width: 0;
  }

  .planet-main :global(.planet-map-wrap) {
    border: none;
    border-radius: 0;
  }
</style>
