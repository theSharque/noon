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
  import { isInhyperEvent } from '../lib/inhyperFx.js';
  import ScifiPanel from '../lib/ui/ScifiPanel.svelte';
  import Station from './Station.svelte';
  import Planet from './Planet.svelte';
  import Orbit from './Orbit.svelte';
  import Infly from './Infly.svelte';
  import Inhyper from './Inhyper.svelte';
  import Inspace from './Inspace.svelte';
  import Indeep from './Indeep.svelte';

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
  let probeDiag = null;

  const PLACE_NAMES = {
    0: 'орбита',
    1: 'планета',
    2: 'корабль',
    3: 'станция',
    5: 'в полёте',
    7: 'система',
    8: 'гипер / deep space',
  };

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
    probeDiag = null;

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
    const pt = parseInt(info.pt, 10) || 0;

    probeDiag = {
      pt,
      ptName: PLACE_NAMES[pt] || `unknown(${pt})`,
      sname: info.sname || '',
      pname: info.pname || '',
      st: info.st,
      bgid: info.bgid,
      x: info.x,
      y: info.y,
      steps: [],
    };

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
    probeDiag.steps.push(`planetMap err=${planetProbe.err}`);
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
    probeDiag.steps.push(`orbitMap ok=${orbitProbe.ok}`);
    if (orbitProbe.ok) {
      initialOrbit = orbitProbe;
      mode = 'orbit';
      return;
    }

    const stationProbe = await loadStationGoods('1');
    probeDiag.steps.push(`station ok=${stationProbe.ok}`);
    if (stationProbe.ok) {
      stationGoods = stationProbe;
      mode = 'station';
      return;
    }

    const timer = await loadFlightTimer();
    probeDiag.steps.push(`timer ok=${timer.ok}${timer.ok ? ` et=${timer.et} remain=${timer.remain}` : ''}`);
    if (timer.ok) {
      flight = timer;
      starName = timer.sname || starName;
      if (isInflyEvent(timer.et)) {
        mode = 'infly';
        return;
      }
      if (isInhyperEvent(timer.et)) {
        mode = 'inhyper';
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

  function sleep(ms) {
    return new Promise((resolve) => setTimeout(resolve, ms));
  }

  async function onFlightArrived() {
    for (let i = 0; i < 10; i++) {
      await probePlace();
      if (mode !== 'infly' && mode !== 'inhyper' && mode !== 'flight') return;
      if (flight && Number(flight.remain) > 0) return;
      await sleep(250);
    }
  }

  function onInflyArrived() {
    onFlightArrived().catch((e) => {
      errorText = e?.message || 'Ошибка загрузки';
      mode = 'stub';
    });
  }

  function onInhyperArrived() {
    onFlightArrived().catch((e) => {
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
      {#if probeDiag}
        <pre class="diag">pt={probeDiag.pt} ({probeDiag.ptName})
sname={probeDiag.sname || '—'}  pname={probeDiag.pname || '—'}
st={probeDiag.st ?? '—'}  bgid={probeDiag.bgid ?? '—'}  x={probeDiag.x ?? '—'}  y={probeDiag.y ?? '—'}
{#each probeDiag.steps as step}{step}
{/each}</pre>
      {/if}
      <p class="hint demo-hint">
        Превью infly: <code>#/place?demo=infly&amp;st=2&amp;remain=90&amp;total=180</code>
      </p>
      <p class="hint demo-hint">
        Превью inhyper: <code>#/place?demo=inhyper&amp;remain=90&amp;total=180</code>
      </p>
      <p class="hint demo-hint">
        Превью inspace: <code>#/place?demo=inspace&amp;st=2&amp;bgid=0&amp;x=220&amp;y=180</code>
      </p>
      <p class="hint demo-hint">
        Превью indeep: <code>#/place?demo=indeep&amp;x=120&amp;y=-40</code>
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

  .diag {
    margin: 12px 0;
    padding: 10px 12px;
    background: rgba(0, 0, 0, 0.35);
    border: 1px solid var(--border-light);
    color: var(--neon-cyan);
    font-family: var(--font-mono, ui-monospace, monospace);
    font-size: 0.75rem;
    line-height: 1.45;
    white-space: pre-wrap;
    overflow: auto;
  }

  .stub img {
    max-width: 100%;
    height: auto;
    margin-top: 12px;
    opacity: 0.85;
  }
</style>
