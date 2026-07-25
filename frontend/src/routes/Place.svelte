<script>
  import { onMount } from 'svelte';
  import { querystring } from 'svelte-spa-router';
  import {
    getUserInfo,
    loadOrbitMap,
    loadPlanetMap,
    loadStationGoods,
  } from '../lib/api.js';
  import ScifiPanel from '../lib/ui/ScifiPanel.svelte';
  import Station from './Station.svelte';
  import Planet from './Planet.svelte';
  import Orbit from './Orbit.svelte';

  let mode = 'loading';
  let errorText = '';
  let starName = '';
  let planetName = '';
  let stationGoods = null;
  let mapLight = 0;
  let initialMap = null;
  let initialOrbit = null;

  const meta = {
    title: 'Местность',
    gallery: '/images/planet.jpg',
    hint: 'Планета, орбита, станция, галактика',
  };

  function parseMl(qs) {
    const raw = String(qs || '').replace(/^\?/, '');
    const params = new URLSearchParams(raw);
    const ml = params.get('ml');
    if (ml != null && /^\d+$/.test(ml)) return Number(ml);
    return 0;
  }

  async function probePlace() {
    mode = 'loading';
    errorText = '';
    initialMap = null;
    initialOrbit = null;
    stationGoods = null;

    mapLight = parseMl($querystring);
    const info = await getUserInfo();
    starName = info.sname || '';
    planetName = info.pname || '';

    const planetProbe = await loadPlanetMap({ full: true, ml: mapLight });
    if (String(planetProbe.err) !== '1') {
      if (String(planetProbe.err) === '2') {
        errorText = 'Карта планеты недоступна';
        mode = 'stub';
        return;
      }
      initialMap = planetProbe;
      mode = 'planet';
      return;
    }

    const orbitProbe = await loadOrbitMap();
    if (orbitProbe.ok) {
      initialOrbit = orbitProbe;
      mode = 'orbit';
      return;
    }

    const stationProbe = await loadStationGoods('1');
    if (stationProbe.ok) {
      stationGoods = stationProbe;
      mode = 'station';
      return;
    }

    mode = 'stub';
  }

  function onPlaceChanged() {
    probePlace().catch((e) => {
      errorText = e?.message || 'Ошибка загрузки';
      mode = 'stub';
    });
  }

  onMount(() => {
    probePlace().catch((e) => {
      errorText = e?.message || 'Ошибка загрузки';
      mode = 'stub';
    });
  });
</script>

{#if mode === 'loading'}
  <div class="place-screen">
    <ScifiPanel title="Местность">
      <p class="muted">Загрузка…</p>
    </ScifiPanel>
  </div>
{:else if mode === 'planet'}
  <div class="place-screen place-screen--map">
    <Planet {mapLight} {initialMap} />
  </div>
{:else if mode === 'orbit'}
  <div class="place-screen place-screen--map">
    <Orbit initialMap={initialOrbit} on:placeChanged={onPlaceChanged} />
  </div>
{:else if mode === 'station'}
  <div class="place-screen">
    <Station initialGoods={stationGoods} {starName} {planetName} />
  </div>
{:else}
  <div class="stub scifi-panel">
    <div class="panel-header">{meta.title}</div>
    <div class="panel-content">
      <p class="hint">{meta.hint}</p>
      <p class="note">
        {errorText || 'Сейчас вы не на планете, орбите и не на станции. Переходы — следующие экраны.'}
      </p>
      <img src={meta.gallery} alt={meta.title} />
    </div>
  </div>
{/if}

<style>
  .place-screen {
    display: flex;
    flex-direction: column;
    gap: 10px;
    min-height: 0;
    height: 100%;
  }

  .place-screen--map {
    gap: 0;
    margin: -10px -12px;
    width: calc(100% + 24px);
    height: calc(100% + 20px);
  }

  .muted {
    margin: 0;
    color: var(--text-muted);
    font-size: 0.9rem;
  }

  .stub {
    max-width: 900px;
    margin: 0 auto;
  }

  .hint {
    color: var(--text-muted);
  }

  .note {
    color: var(--text-main);
  }

  .stub img {
    max-width: 100%;
    height: auto;
    margin-top: 12px;
    opacity: 0.85;
  }
</style>
