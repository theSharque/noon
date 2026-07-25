<script>
  import { onMount } from 'svelte';
  import { querystring } from 'svelte-spa-router';
  import {
    getUserInfo,
    loadFlightTimer,
    loadOrbitMap,
    loadPlanetMap,
    loadStationGoods,
  } from '../lib/api.js';
  import { formatFlyTime, isInflyEvent } from '../lib/inflyFx.js';
  import ScifiPanel from '../lib/ui/ScifiPanel.svelte';
  import Station from './Station.svelte';
  import Planet from './Planet.svelte';
  import Orbit from './Orbit.svelte';
  import Infly from './Infly.svelte';

  let mode = 'loading';
  let errorText = '';
  let starName = '';
  let planetName = '';
  let stationGoods = null;
  let mapLight = 0;
  let initialMap = null;
  let initialOrbit = null;
  let flight = null;
  let demoInfly = false;

  const meta = {
    title: 'Местность',
    gallery: '/images/planet.jpg',
    hint: 'Планета, орбита, станция, галактика',
  };

  function parseQs(qs) {
    const raw = String(qs || '').replace(/^\?/, '');
    return new URLSearchParams(raw);
  }

  function parseMl(qs) {
    const ml = parseQs(qs).get('ml');
    if (ml != null && /^\d+$/.test(ml)) return Number(ml);
    return 0;
  }

  function parseDemoInfly(qs) {
    const params = parseQs(qs);
    if (params.get('demo') !== 'infly') return null;
    return {
      st: Math.max(1, parseInt(params.get('st') || '1', 10) || 1),
      remain: Math.max(1, parseInt(params.get('remain') || '120', 10) || 120),
      total: Math.max(1, parseInt(params.get('total') || '240', 10) || 240),
      sname: params.get('sname') || 'Демо-система',
    };
  }

  async function probePlace() {
    mode = 'loading';
    errorText = '';
    initialMap = null;
    initialOrbit = null;
    stationGoods = null;
    flight = null;
    demoInfly = false;

    const demo = parseDemoInfly($querystring);
    if (demo) {
      flight = {
        remain: demo.remain,
        total: demo.total,
        st: demo.st,
        sname: demo.sname,
        et: 2,
      };
      demoInfly = true;
      mode = 'infly';
      return;
    }

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

    const timer = await loadFlightTimer();
    if (timer.ok) {
      flight = timer;
      starName = timer.sname || starName;
      if (isInflyEvent(timer.et)) {
        mode = 'infly';
        return;
      }
      mode = 'flight';
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

  function onInflyArrived() {
    onPlaceChanged();
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
{:else if mode === 'infly' && flight}
  <div class="place-screen place-screen--map">
    <Infly
      starType={flight.st}
      starName={flight.sname || starName}
      remain={flight.remain}
      total={flight.total || flight.remain || 1}
      demo={demoInfly}
      on:arrived={onInflyArrived}
    />
  </div>
{:else if mode === 'flight' && flight}
  <div class="place-screen">
    <ScifiPanel title="В полёте">
      <p class="muted">Экран перехода ещё в работе.</p>
      <p class="note">Осталось: {formatFlyTime(flight.remain)}</p>
    </ScifiPanel>
  </div>
{:else}
  <div class="stub scifi-panel">
    <div class="panel-header">{meta.title}</div>
    <div class="panel-content">
      <p class="hint">{meta.hint}</p>
      <p class="note">
        {errorText || 'Сейчас вы не на планете, орбите и не на станции. Переходы — следующие экраны.'}
      </p>
      <p class="hint demo-hint">
        Превью infly: <code>#/place?demo=infly&amp;st=2&amp;remain=90&amp;total=180</code>
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

  .demo-hint {
    margin-top: 10px;
    font-size: 0.85rem;
  }

  .demo-hint code {
    font-size: 0.8rem;
    color: var(--neon-cyan);
  }

  .stub img {
    max-width: 100%;
    height: auto;
    margin-top: 12px;
    opacity: 0.85;
  }
</style>
