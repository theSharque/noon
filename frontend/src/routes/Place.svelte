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
  import { isInflyEvent } from '../lib/inflyFx.js';
  import { isInhyperEvent } from '../lib/inhyperFx.js';
  import { isLandEvent } from '../lib/landFx.js';
  import { isTakeoffEvent } from '../lib/takeoffFx.js';
  import ScifiPanel from '../lib/ui/ScifiPanel.svelte';
  import Station from './Station.svelte';
  import Planet from './Planet.svelte';
  import Orbit from './Orbit.svelte';
  import Infly from './Infly.svelte';
  import Inhyper from './Inhyper.svelte';
  import Inspace from './Inspace.svelte';
  import Indeep from './Indeep.svelte';
  import Land from './Land.svelte';
  import Takeoff from './Takeoff.svelte';

  let mode = 'loading';
  let errorText = '';
  let starName = '';
  let planetName = '';
  let stationGoods = null;
  let mapLight = 0;
  let initialMap = null;
  let initialOrbit = null;
  let flight = null;
  let space = null;
  let deep = null;
  let demoInfly = false;
  let demoInhyper = false;
  let demoInspace = false;
  let demoIndeep = false;
  let demoLand = false;
  let demoTakeoff = false;

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
      ptype: Math.max(0, parseInt(params.get('ptype') || '1', 10) || 0),
      remain: Math.max(1, parseInt(params.get('remain') || '120', 10) || 120),
      total: Math.max(1, parseInt(params.get('total') || '240', 10) || 240),
      sname: params.get('sname') || 'Демо-система',
      pname: params.get('pname') || '',
    };
  }

  function parseDemoInhyper(qs) {
    const params = parseQs(qs);
    if (params.get('demo') !== 'inhyper') return null;
    const et = parseInt(params.get('et') || '4', 10) || 4;
    return {
      et,
      st: Math.max(0, parseInt(params.get('st') || (et === 5 || et === 105 ? '0' : '1'), 10) || 0),
      remain: Math.max(1, parseInt(params.get('remain') || '90', 10) || 90),
      total: Math.max(1, parseInt(params.get('total') || '180', 10) || 180),
      sname: params.get('sname') || (et === 5 || et === 105 ? '120:95' : 'Гипер-цель'),
    };
  }

  function parseDemoInspace(qs) {
    const params = parseQs(qs);
    if (params.get('demo') !== 'inspace') return null;
    const bgid = Math.max(0, parseInt(params.get('bgid') || '0', 10) || 0);
    return {
      st: Math.max(0, parseInt(params.get('st') || '1', 10) || 0),
      bgid,
      bgUrl: `/img/n${String(bgid).padStart(2, '0')}.jpg`,
      sname: params.get('sname') || 'Демо-система',
      x: parseInt(params.get('x') || '220', 10) || 0,
      y: parseInt(params.get('y') || '180', 10) || 0,
    };
  }

  function parseDemoIndeep(qs) {
    const params = parseQs(qs);
    if (params.get('demo') !== 'indeep') return null;
    return {
      x: parseInt(params.get('x') || '120', 10) || 0,
      y: parseInt(params.get('y') || '-40', 10) || 0,
    };
  }

  function parseDemoLand(qs) {
    const params = parseQs(qs);
    if (params.get('demo') !== 'land') return null;
    const ptype = Math.max(1, parseInt(params.get('ptype') || '1', 10) || 1);
    return {
      ptype,
      remain: Math.max(1, parseInt(params.get('remain') || '10', 10) || 10),
      total: Math.max(1, parseInt(params.get('total') || '10', 10) || 10),
      pname: params.get('pname') || demoPlanetName(ptype),
      et: 0,
    };
  }

  function parseDemoTakeoff(qs) {
    const params = parseQs(qs);
    if (params.get('demo') !== 'takeoff') return null;
    const ptype = Math.max(1, parseInt(params.get('ptype') || '1', 10) || 1);
    return {
      ptype,
      remain: Math.max(1, parseInt(params.get('remain') || '10', 10) || 10),
      total: Math.max(1, parseInt(params.get('total') || '10', 10) || 10),
      pname: params.get('pname') || demoPlanetName(ptype),
      et: 1,
    };
  }

  function demoPlanetName(ptype) {
    if (ptype === 3) return 'Демо-мёртвая';
    if (ptype === 4) return 'Демо-пустыня';
    if (ptype === 2) return 'Демо-гигант';
    return 'Демо-земля';
  }

  function fail(message) {
    errorText = message || 'Местность недоступна';
    mode = 'error';
  }

  async function probePlace() {
    mode = 'loading';
    errorText = '';
    initialMap = null;
    initialOrbit = null;
    stationGoods = null;
    flight = null;
    space = null;
    deep = null;
    demoInfly = false;
    demoInhyper = false;
    demoInspace = false;
    demoIndeep = false;
    demoLand = false;
    demoTakeoff = false;

    const demoAscent = parseDemoTakeoff($querystring);
    if (demoAscent) {
      flight = {
        remain: demoAscent.remain,
        total: demoAscent.total,
        et: demoAscent.et,
        ptype: demoAscent.ptype,
        pname: demoAscent.pname,
        sname: '',
        st: 1,
      };
      planetName = demoAscent.pname;
      demoTakeoff = true;
      mode = 'takeoff';
      return;
    }

    const demoLanding = parseDemoLand($querystring);
    if (demoLanding) {
      flight = {
        remain: demoLanding.remain,
        total: demoLanding.total,
        et: demoLanding.et,
        ptype: demoLanding.ptype,
        pname: demoLanding.pname,
        sname: '',
        st: 1,
      };
      planetName = demoLanding.pname;
      demoLand = true;
      mode = 'land';
      return;
    }

    const demoDeep = parseDemoIndeep($querystring);
    if (demoDeep) {
      deep = demoDeep;
      demoIndeep = true;
      mode = 'indeep';
      return;
    }

    const demoSpace = parseDemoInspace($querystring);
    if (demoSpace) {
      space = demoSpace;
      demoInspace = true;
      mode = 'inspace';
      return;
    }

    const demoHyper = parseDemoInhyper($querystring);
    if (demoHyper) {
      flight = {
        remain: demoHyper.remain,
        total: demoHyper.total,
        st: demoHyper.st,
        sname: demoHyper.sname,
        et: demoHyper.et,
      };
      demoInhyper = true;
      mode = 'inhyper';
      return;
    }

    const demo = parseDemoInfly($querystring);
    if (demo) {
      flight = {
        remain: demo.remain,
        total: demo.total,
        st: demo.st,
        sname: demo.sname,
        ptype: demo.ptype,
        pname: demo.pname,
        et: 3,
      };
      demoInfly = true;
      mode = 'infly';
      return;
    }

    mapLight = parseMl($querystring);
    const info = await getUserInfo();
    starName = info.sname || '';
    planetName = info.pname || '';
    const pt = parseInt(info.pt, 10) || 0;

    if (pt === 7) {
      space = {
        st: info.st || 1,
        bgid: info.bgid || 0,
        bgUrl: info.bgUrl,
        sname: info.sname || starName,
        x: info.x || 0,
        y: info.y || 0,
      };
      mode = 'inspace';
      return;
    }

    if (pt === 8) {
      deep = {
        x: info.x || 0,
        y: info.y || 0,
      };
      mode = 'indeep';
      return;
    }

    const planetProbe = await loadPlanetMap({ full: true, ml: mapLight });
    if (String(planetProbe.err) !== '1') {
      if (String(planetProbe.err) === '2') {
        fail('Карта планеты недоступна');
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
      if (timer.pname) planetName = timer.pname;
      if (isLandEvent(timer.et)) {
        mode = 'land';
        return;
      }
      if (isTakeoffEvent(timer.et)) {
        mode = 'takeoff';
        return;
      }
      if (isInflyEvent(timer.et)) {
        mode = 'infly';
        return;
      }
      if (isInhyperEvent(timer.et)) {
        mode = 'inhyper';
        return;
      }
      fail(`Неизвестный переход (et=${timer.et})`);
      return;
    }

    fail('Местность недоступна');
  }

  function onPlaceChanged() {
    probePlace().catch((e) => fail(e?.message || 'Ошибка загрузки'));
  }

  function sleep(ms) {
    return new Promise((resolve) => setTimeout(resolve, ms));
  }

  async function onFlightArrived() {
    for (let i = 0; i < 10; i++) {
      await probePlace();
      if (mode !== 'infly' && mode !== 'inhyper' && mode !== 'land' && mode !== 'takeoff') {
        return;
      }
      if (flight && Number(flight.remain) > 0) return;
      await sleep(250);
    }
  }

  function onInflyArrived() {
    onFlightArrived().catch((e) => fail(e?.message || 'Ошибка загрузки'));
  }

  function onInhyperArrived() {
    onFlightArrived().catch((e) => fail(e?.message || 'Ошибка загрузки'));
  }

  function onLandArrived() {
    onFlightArrived().catch((e) => fail(e?.message || 'Ошибка загрузки'));
  }

  function onTakeoffArrived() {
    onFlightArrived().catch((e) => fail(e?.message || 'Ошибка загрузки'));
  }

  onMount(() => {
    probePlace().catch((e) => fail(e?.message || 'Ошибка загрузки'));
  });

  let lastDemoKey = '';
  $: {
    const params = parseQs($querystring);
    const demo = params.get('demo') || '';
    const demoKey = demo
      ? `${demo}|${params.get('ptype') || ''}|${params.get('st') || ''}|${params.get('et') || ''}|${params.get('remain') || ''}|${params.get('total') || ''}|${params.get('pname') || ''}|${params.get('sname') || ''}|${params.get('bgid') || ''}|${params.get('x') || ''}|${params.get('y') || ''}`
      : '';
    if (demoKey && demoKey !== lastDemoKey) {
      lastDemoKey = demoKey;
      if (mode !== 'loading') {
        probePlace().catch((e) => fail(e?.message || 'Ошибка загрузки'));
      }
    } else if (!demoKey) {
      lastDemoKey = '';
    }
  }
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
{:else if mode === 'inspace' && space}
  <div class="place-screen place-screen--map">
    <Inspace
      starType={space.st}
      starName={space.sname || starName}
      bgUrl={space.bgUrl}
      x={space.x}
      y={space.y}
      demo={demoInspace}
    />
  </div>
{:else if mode === 'indeep' && deep}
  <div class="place-screen place-screen--map">
    <Indeep x={deep.x} y={deep.y} demo={demoIndeep} />
  </div>
{:else if mode === 'land' && flight}
  <div class="place-screen place-screen--map">
    <Land
      planetType={flight.ptype || 1}
      planetName={flight.pname || planetName}
      remain={flight.remain}
      total={flight.total || flight.remain || 1}
      demo={demoLand}
      on:arrived={onLandArrived}
    />
  </div>
{:else if mode === 'takeoff' && flight}
  <div class="place-screen place-screen--map">
    <Takeoff
      planetType={flight.ptype || 1}
      planetName={flight.pname || planetName}
      remain={flight.remain}
      total={flight.total || flight.remain || 1}
      demo={demoTakeoff}
      on:arrived={onTakeoffArrived}
    />
  </div>
{:else if mode === 'infly' && flight}
  <div class="place-screen place-screen--map">
    <Infly
      starType={flight.st}
      starName={flight.sname || starName}
      planetType={flight.ptype || 0}
      remain={flight.remain}
      total={flight.total || flight.remain || 1}
      demo={demoInfly}
      on:arrived={onInflyArrived}
    />
  </div>
{:else if mode === 'inhyper' && flight}
  <div class="place-screen place-screen--map">
    <Inhyper
      starType={flight.st}
      starName={flight.sname || starName}
      eventType={flight.et}
      remain={flight.remain}
      total={flight.total || flight.remain || 1}
      demo={demoInhyper}
      on:arrived={onInhyperArrived}
    />
  </div>
{:else}
  <div class="place-screen">
    <ScifiPanel title="Местность">
      <p class="muted">{errorText || 'Местность недоступна'}</p>
    </ScifiPanel>
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
</style>
