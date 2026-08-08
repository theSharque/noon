<script>
  import { onDestroy, onMount, tick as svelteTick } from 'svelte';
  import { push, querystring } from 'svelte-spa-router';
  import {
    getNoonConfig,
    getStarCoord,
    getSystemCoord,
    loadShipsFleetList,
    loadShipsFleetOrderList,
    loadShipsFleetOrders,
    loadShipsInfo,
    loadShipsInterruptMsg,
    loadShipsItems,
    loadShipsList,
    loadShipsOrders,
    loadShipsPlaces,
    loadStarMap,
    loadSystemMap,
    loadWarRead,
    loadWarStart,
    shipsDeconserv,
    shipsFleetAttack,
    shipsFleetOff,
    shipsFleetSet,
    shipsMakeAttack,
    shipsMakeFleet,
    shipsMakeOrder,
    shipsStarMove,
    shipsSystemMove,
  } from '../lib/api.js';
  import ScifiPanel from '../lib/ui/ScifiPanel.svelte';
  import ScifiButton from '../lib/ui/ScifiButton.svelte';
  import ScifiSelect from '../lib/ui/ScifiSelect.svelte';
  import GalaxyMap from '../lib/ui/GalaxyMap.svelte';
  import SystemMap from '../lib/ui/SystemMap.svelte';
  import WarArena from '../lib/ui/WarArena.svelte';
  import {
    RING_R,
    RING_STROKE,
    applyAutonavTail,
    applyGalaxyRouteClick,
    computeGalaxyBounds,
    findRouteWaypointIndex,
    formatRoutePts,
    galaxyCenterOffset,
    GALAXY_STAR_SNAP,
    galaxyLocalPoint,
    isGalaxyPointValid,
    isNearPoint,
    routePolylinePoints,
    routeIncludesPoint,
    ROUTE_RING_R,
    sameGalaxyPoint,
    GALAXY_MAX_RADIUS,
  } from '../lib/galaxyMap.js';
  import {
    SYSTEM_MAX_RADIUS,
    computeSystemBounds,
    isSystemPointValid,
    systemCenterOffset,
    systemClampOffset,
    systemLocalPoint,
    systemPlanetXy,
  } from '../lib/systemMap.js';
  import { flashBgStyle } from '../lib/flashColor.js';

  const IMG = '/app/img/booklist';
  const ATTACK_ORDERS = new Set([14, 16, 17, 18, 20, 32, 33, 49, 51]);
  const ATTACK_RPC = new Set([14, 16, 17, 18, 49, 51]);
  const ORDER_BTN = new Set([
    0, 1, 2, 3, 4, 5, 6, 7, 12, 14, 16, 17, 18, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33,
    34, 35, 36, 37, 38, 39, 40, 43, 44, 46, 47, 48, 49, 51,
  ]);
  const GALAXY_ORDERS = new Set([9, 41]);
  const SYSTEM_ORDERS = new Set([8]);
  const SYSTEM_IMG = '/app/img/ships/system';
  const PLANET_SIZE = { 1: 12, 2: 20, 3: 12, 4: 14, 5: 8 };
  const SYSTEM_MARKER_R = 2.5;
  const SYSTEM_CIRCLE_R = RING_R;
  const SYSTEM_TRASH_S = 4;
  const MAP_STROKE = RING_STROKE;
  const CARGO_ORDERS = new Set([10, 28, 30]);
  const LAND_ORDERS = new Set([1, 22, 23, 24, 34, 35, 36, 37, 40, 43]);
  const DOCK_ORDERS = new Set([4, 31]);
  const UNDOCK_ORDERS = new Set([3, 39]);
  const FLEET_MAKE = new Set([0, 44]);
  const PLANET_ATK = new Set([14, 38]);
  const SHIP_ATK = new Set([16, 32, 33, 49]);
  const FLEET_ATK = new Set([17, 18, 51]);

  let placeOptions = [{ value: '*', label: 'Все' }];
  let placeValue = '*';
  let others = false;

  let ships = [];
  let selected = [];
  let lastIdx = -1;
  let lastShip = '';
  let sortOrd = null;

  let orderOptions = [{ value: '100', label: 'Выберите приказ' }];
  let orderValue = '100';
  let showOrderBtn = false;
  let orderGlow = false;

  let monitor = 'empty';
  let infoHtml = '';
  let fleetHtml = '';
  let shipPic = '';
  let renameName = '';
  let renameGroup = '';
  let interruptMsg = '';
  let conservCnt = '1';
  let conservMax = 1;

  let cargoItems = [];
  let fleetMembers = [];
  let fleetSelected = [];
  let fleetLastIdx = -1;
  let fleetMaxStep = '';
  let strategStep = '1';

  let warNear = [];
  let warFar = [];
  let warLog = [];
  let warFxBatch = null;
  let warSide = '0';
  let warLastMove = '0';
  let warPlaceHash = '';
  let warWid = '';

  let galaxyStars = [];
  let galaxyYellow = [];
  let galaxyHome = null;
  let galaxyQuest = null;
  let galaxyShip = null;
  let galaxyBounds = { minX: 0, minY: 0, maxX: 800, maxY: 600 };
  let galaxyOffset = { x: 0, y: 0 };
  let galaxyHover = '';
  let galaxyDesc = '';
  let galaxyRoute = [];
  let galaxyRouteSkill = 0;
  let galaxyHyperCnt = 0;
  let galaxyBaseDesc = '';
  let galaxyHomeJump = false;
  let galaxyPlace = { x: 0, y: 0 };
  let galaxyCoordX = '';
  let galaxyCoordY = '';
  let galaxyPreviewT = 0;
  let galaxyViewport;
  let galaxyDragging = false;
  let galaxyDragMoved = false;
  let galaxyDragStart = { x: 0, y: 0, ox: 0, oy: 0 };
  let galaxyCoordTimer;

  let systemBounds = computeSystemBounds();
  let systemOffset = { x: 0, y: 0 };
  let systemViewport;
  let systemDragging = false;
  let systemDragMoved = false;
  let systemDragStart = { x: 0, y: 0, ox: 0, oy: 0 };
  let systemPlanets = [];
  let systemOrbits = [];
  let systemMarkers = [];
  let systemShip = null;
  let systemPlace = { x: 0, y: 0 };
  let systemCoordX = '';
  let systemCoordY = '';
  let systemPreviewT = 0;
  let systemDesc = '';
  let systemHover = '';
  let systemBg = '';
  let systemName = '';
  let systemStype = 1;
  let systemCoordTimer;
  let systemOrbitTimer;
  let systemOrbitBusy = false;

  let busy = false;
  let errorText = '';
  let tick = 0;

  let scratchAudio;
  let buzzAudio;
  let shipsTimer;
  let warTimer;
  let shipsStartMs = Date.now();
  let loadGen = 0;

  $: qs = new URLSearchParams($querystring || '');
  $: bootLs = qs.get('ls') || '';
  $: galaxyHomeInRoute =
    galaxyHome && galaxyRoute.length > 0 && routeIncludesPoint(galaxyRoute, galaxyHome);

  $: displayShips = ships.map((ship, i) => ({
    ...ship,
    location: formatLocation(ship, tick),
    selected: selected.includes(i),
    kind: shipKind(ship),
  }));

  function shipKind(ship) {
    if (ship.you) return 'pilot';
    const p = String(ship.id || '').charAt(0);
    if (p === 'F') return 'fleet';
    if (p === 'S' || p === 'C' || p === 'Z' || p === 'A') return 'ship';
    return '';
  }

  function kindIconClass(ship) {
    if (ship.rel == null) return '';
    return `kind-icon--foreign kind-icon--rel-${ship.rel}`;
  }

  function kindLabel(kind, ship) {
    if (kind === 'pilot') return 'Вы здесь';
    if (ship?.rel === '2') return 'Враг';
    if (ship?.rel === '1') return 'Друг';
    if (ship?.rel === '0') return 'Нейтрален';
    if (kind === 'fleet') return 'Флот';
    if (kind === 'ship') return 'Корабль';
    return '';
  }

  function formatShipInfoHtml(raw) {
    const text = String(raw || '').trim();
    if (!text || text === 'Загрузка...') return text;

    const parts = text.split(/<br\s*\/?>/i);
    const rows = [];
    for (const part of parts) {
      let line = part.trim();
      if (!line) continue;
      let warn = false;
      const fontM = line.match(/^<font[^>]*color=["']?#FF0000["']?[^>]*>([\s\S]*)<\/font>$/i);
      if (fontM) {
        line = fontM[1].trim();
        warn = true;
      }
      const m = line.match(/^([^:<]+):\s*([\s\S]*)$/);
      if (!m) {
        rows.push({ key: '', val: line, warn: false });
        continue;
      }
      rows.push({ key: m[1].trim(), val: m[2].trim(), warn });
    }
    if (!rows.length) return text;

    const body = rows
      .map((r) => {
        const valAttr = r.warn ? ' class="ship-warn"' : '';
        return `<tr><td class="enc-key">${r.key}</td><td${valAttr}>${r.val}</td></tr>`;
      })
      .join('');
    return `<div class="enc-section"><table class="enc-table enc-ttx"><tbody>${body}</tbody></table></div>`;
  }

  function formatFleetInfoHtml(raw) {
    const text = String(raw || '').trim();
    if (!text) return '';

    const lines = text.split(/\n/).map((l) => l.trim()).filter(Boolean);
    let title = 'Состав флота';
    const rows = [];
    for (const line of lines) {
      const plain = line.replace(/<\/?b>/gi, '').replace(/:$/, '').trim();
      if (/состав\s+флота/i.test(plain)) {
        title = plain;
        continue;
      }
      const pipe = line.match(/^(.+)\|(\d+)\|(\d+)\|(\d+)\|(\d+)\s*$/);
      if (pipe) {
        rows.push({
          name: pipe[1],
          cnt: pipe[2],
          planet: pipe[3],
          hyper: pipe[4],
          cargo: pipe[5],
        });
        continue;
      }
      const legacy = line.match(/^(.+?)\s+\((\d+)\)\s*$/);
      if (legacy) rows.push({ name: legacy[1], cnt: legacy[2] });
      else rows.push({ name: line, cnt: '' });
    }
    if (!rows.length) return text;

    const hasStats = rows.some((r) => r.planet != null);
    const head = hasStats
      ? '<thead><tr><th>Корабль</th><th class="enc-qty">Кол-во</th><th class="enc-qty">В системе</th><th class="enc-qty">В гипере</th><th class="enc-qty">Трюм</th></tr></thead>'
      : '';
    const body = rows
      .map((r) => {
        if (hasStats && r.planet != null) {
          return `<tr><td>${r.name}</td><td class="enc-qty">${r.cnt}</td><td class="enc-qty">${r.planet}</td><td class="enc-qty">${r.hyper}</td><td class="enc-qty">${r.cargo}</td></tr>`;
        }
        return `<tr><td>${r.name}</td><td class="enc-qty">${r.cnt}</td></tr>`;
      })
      .join('');
    return (
      `<div class="enc-section"><div class="enc-section-title">${title}</div>` +
      `<table class="enc-table enc-fleet">${head}<tbody>${body}</tbody></table></div>`
    );
  }

  function playSelect() {
    try {
      const { sv } = getNoonConfig();
      if (!scratchAudio) return;
      scratchAudio.volume = Math.max(0, Math.min(1, sv / 100));
      scratchAudio.currentTime = 0;
      scratchAudio.play().catch(() => {});
    } catch {
      /* ignore */
    }
  }

  function playBuzz() {
    try {
      const { sv } = getNoonConfig();
      if (!buzzAudio) return;
      buzzAudio.volume = Math.max(0, Math.min(1, sv / 100));
      buzzAudio.currentTime = 0;
      buzzAudio.play().catch(() => {});
    } catch {
      /* ignore */
    }
  }

  function formatEta(sec) {
    let diff = Math.max(0, Math.floor(sec));
    const vD = Math.floor(diff / 86400);
    diff %= 86400;
    const vH = Math.floor(diff / 3600);
    diff %= 3600;
    const vM = Math.floor(diff / 60);
    const vS = diff % 60;
    let timestring = '';
    if (vD > 0) timestring = `${vD}.`;
    timestring += `${vH >= 10 ? vH : `0${vH}`}:`;
    timestring += `${vM >= 10 ? vM : `0${vM}`}:`;
    timestring += vS >= 10 ? String(vS) : `0${vS}`;
    return timestring;
  }

  function formatLocation(ship, _tick) {
    if (ship.tp == null || Number.isNaN(ship.tp)) return ship.place || '';
    const elapsed = (Date.now() - shipsStartMs) / 1000;
    const remain = ship.tp - elapsed;
    if (remain > 0) return `${formatEta(remain)} ${ship.place || ''}`.trim();
    return `00:00:00 ${ship.place || ''}`.trim();
  }

  function rowStyle(bgColor) {
    return flashBgStyle(bgColor);
  }

  function parseOrderId(raw) {
    const s = String(raw || '');
    const colon = s.indexOf(':');
    const base = colon > 0 ? s.slice(0, colon) : s;
    const param = colon > 0 ? s.slice(colon + 1) : '';
    return { id: parseInt(base, 10) || 0, param, raw: s };
  }

  function selectedIds() {
    return selected.map((i) => ships[i]?.id).filter(Boolean);
  }

  function primaryId() {
    if (selected.length === 1) return ships[selected[0]]?.id || lastShip;
    return lastShip;
  }

  function isInfoMonitor() {
    return monitor === 'info' || monitor === 'conserv' || monitor === 'multi' || monitor === 'empty';
  }

  function stopWarPoll() {
    if (warTimer) {
      clearInterval(warTimer);
      warTimer = null;
    }
  }

  function resetMonitor() {
    stopWarPoll();
    monitor = 'empty';
    infoHtml = '';
    fleetHtml = '';
    shipPic = '';
    cargoItems = [];
    fleetMembers = [];
    fleetSelected = [];
    fleetLastIdx = -1;
    showOrderBtn = false;
    orderGlow = false;
    warNear = [];
    warFar = [];
    warLog = [];
    warFxBatch = null;
    warWid = '';
    resetGalaxy();
    resetSystem();
  }

  function resetGalaxy() {
    clearGalaxyCoordTimer();
    galaxyStars = [];
    galaxyYellow = [];
    galaxyHome = null;
    galaxyQuest = null;
    galaxyShip = null;
    galaxyDesc = '';
    galaxyRoute = [];
    galaxyBaseDesc = '';
    galaxyHomeJump = false;
    galaxyPlace = { x: 0, y: 0 };
    galaxyCoordX = '';
    galaxyCoordY = '';
    galaxyPreviewT = 0;
    galaxyHover = '';
    galaxyDragging = false;
    galaxyDragMoved = false;
  }

  function clearGalaxyCoordTimer() {
    if (galaxyCoordTimer) {
      clearTimeout(galaxyCoordTimer);
      galaxyCoordTimer = null;
    }
  }

  function scheduleGalaxyCoords() {
    clearGalaxyCoordTimer();
    galaxyCoordTimer = setTimeout(() => {
      galaxyCoordTimer = null;
      applyGalaxyCoords();
    }, 500);
  }

  function resetSystem() {
    stopSystemOrbitPoll();
    clearSystemCoordTimer();
    systemPlanets = [];
    systemOrbits = [];
    systemMarkers = [];
    systemShip = null;
    systemPlace = { x: 0, y: 0 };
    systemCoordX = '';
    systemCoordY = '';
    systemPreviewT = 0;
    systemDesc = '';
    systemHover = '';
    systemBg = '';
    systemName = '';
    systemStype = 1;
    systemBounds = computeSystemBounds();
    systemOffset = { x: 0, y: 0 };
  }

  function clearSystemCoordTimer() {
    if (systemCoordTimer) {
      clearTimeout(systemCoordTimer);
      systemCoordTimer = null;
    }
  }

  function stopSystemOrbitPoll() {
    if (systemOrbitTimer) {
      clearInterval(systemOrbitTimer);
      systemOrbitTimer = null;
    }
    systemOrbitBusy = false;
  }

  function startSystemOrbitPoll() {
    stopSystemOrbitPoll();
    systemOrbitTimer = setInterval(() => {
      refreshSystemMapQuiet();
    }, 5000);
  }

  function applySystemMapData(data, { resetPreview = false } = {}) {
    systemPlanets = (data.planets || []).map((p) => ({
      ...p,
      ...systemPolarXy(p.angle, p.orb),
    }));
    systemOrbits = uniqueSystemOrbits(data.planets || []);
    systemMarkers = data.markers || [];
    systemBg = data.bgUrl || systemBg;
    systemName = data.sname || systemName;
    systemStype = data.stype || systemStype;
    const start = systemStartFromData(data);
    systemShip = start;
    if (resetPreview || systemPreviewT === 0) {
      systemPlace = { ...start };
      systemCoordX = String(start.x);
      systemCoordY = String(start.y);
      systemPreviewT = 0;
      systemDesc = lightenGalaxyDesc(data.ftxt || '');
      showOrderBtn = false;
      orderGlow = false;
    }
  }

  async function refreshSystemMapQuiet() {
    if (monitor !== 'system' || systemOrbitBusy) return;
    const shid = primaryId();
    if (!shid) return;
    systemOrbitBusy = true;
    try {
      const data = await loadSystemMap(shid);
      if (monitor !== 'system' || !data.ok) return;
      applySystemMapData(data, { resetPreview: false });
    } catch {
    } finally {
      systemOrbitBusy = false;
    }
  }

  function scheduleSystemCoords() {
    clearSystemCoordTimer();
    systemCoordTimer = setTimeout(() => {
      systemCoordTimer = null;
      applySystemCoords();
    }, 500);
  }

  async function refreshPlaces(keepSelection = true, { syncMonitor = true, focusId = '' } = {}) {
    const gen = ++loadGen;
    const data = await loadShipsPlaces();
    if (gen !== loadGen) return;
    placeOptions = data.places || [{ value: '*', label: 'Все' }];
    others = !!data.others;
    if (!keepSelection || !placeOptions.some((p) => String(p.value) === String(placeValue))) {
      const last = data.lastPlace || '*';
      placeValue = placeOptions.some((p) => String(p.value) === String(last)) ? last : '*';
    }
    await refreshShips(keepSelection, { syncMonitor, focusId });
  }

  async function refreshShips(keepSelection = true, { syncMonitor = true, focusId = '' } = {}) {
    const gen = ++loadGen;
    const prevIds = keepSelection && !focusId ? selectedIds() : [];
    busy = true;
    errorText = '';
    try {
      const data = await loadShipsList({
        oth: others,
        pl: placeValue,
        ord: sortOrd,
      });
      if (gen !== loadGen) return;
      shipsStartMs = Date.now();
      ships = data.ships || [];
      tick = 0;
      if (focusId) lastShip = focusId;
      else if (data.fid) lastShip = data.fid;

      const prefer =
        focusId
          ? [focusId]
          : keepSelection && prevIds.length
            ? prevIds
            : lastShip || bootLs
              ? [lastShip || bootLs]
              : [];

      let next = [];
      if (prefer.length) {
        prefer.forEach((id) => {
          const idx = ships.findIndex((s) => s.id === id);
          if (idx >= 0 && !next.includes(idx)) next.push(idx);
        });
      }
      if (!next.length && ships.length) {
        const idx = ships.findIndex((s) => s.bgColor !== '0xCC0000');
        next = [idx >= 0 ? idx : 0];
      }
      selected = next;
      lastIdx = next.length ? next[next.length - 1] : -1;
      if (selected.length === 1) lastShip = ships[selected[0]]?.id || '';
      if (syncMonitor) await applySelection(false);
    } catch (e) {
      errorText = 'Ошибка загрузки флота';
    } finally {
      if (gen === loadGen) busy = false;
    }
  }

  async function applySelection(play = true) {
    resetMonitor();
    orderOptions = [{ value: '100', label: 'Выберите приказ' }];
    orderValue = '100';
    if (!selected.length) return;
    if (play) playSelect();

    if (selected.length > 1) {
      const ids = selectedIds();
      const data = await loadShipsFleetOrders(ids);
      orderOptions = data.orders || orderOptions;
      orderValue = '100';
      monitor = 'multi';
      return;
    }

    const ship = ships[selected[0]];
    if (!ship) return;
    lastShip = ship.id;
    const prefix = ship.id.slice(0, 1);

    if (prefix === 'C') {
      monitor = 'conserv';
      conservMax = ship.cnt > 0 ? ship.cnt : 1;
      conservCnt = '1';
      renameGroup = ship.group || '';
    } else if (prefix === 'F') {
      monitor = 'info';
    } else {
      monitor = 'info';
    }

    infoHtml = 'Загрузка...';
    const [orders, info] = await Promise.all([
      loadShipsOrders(ship.id),
      loadShipsInfo(ship.id),
    ]);
    orderOptions = orders.orders || orderOptions;
    orderValue = '100';
    infoHtml = formatShipInfoHtml(info.out || '');
    fleetHtml = formatFleetInfoHtml(info.info || '');
    shipPic = info.pic || '';
  }

  function onShipClick(idx, e) {
    if (busy) return;
    const ship = ships[idx];
    if (!ship) return;
    if (ship.bgColor === '0xCC0000' && !(e.ctrlKey || e.metaKey || e.shiftKey)) {
      selected = [idx];
      lastIdx = idx;
      applySelection(true);
      return;
    }

    let next;
    if (e.shiftKey && lastIdx >= 0) {
      const a = Math.min(lastIdx, idx);
      const b = Math.max(lastIdx, idx);
      next = [];
      for (let i = a; i <= b; i++) {
        if (ships[i]?.bgColor !== '0xCC0000') next.push(i);
      }
      if (!next.length) next = [idx];
    } else if (e.ctrlKey || e.metaKey) {
      next = selected.slice();
      const pos = next.indexOf(idx);
      if (pos >= 0) next.splice(pos, 1);
      else if (ship.bgColor !== '0xCC0000' || next.length === 0) next.push(idx);
      lastIdx = idx;
    } else {
      next = [idx];
      lastIdx = idx;
    }
    selected = next;
    applySelection(true);
  }

  async function onOrderChange(e) {
    orderValue = e.detail.value;
    const { id, param } = parseOrderId(orderValue);
    showOrderBtn = false;
    orderGlow = false;
    stopWarPoll();
    warLog = [];

    if (id === 100) {
      if (selected.length === 1) {
        const ship = ships[selected[0]];
        const prefix = ship?.id?.slice(0, 1);
        monitor = prefix === 'C' ? 'conserv' : 'info';
        infoHtml = 'Загрузка...';
        const info = await loadShipsInfo(ship.id);
        infoHtml = formatShipInfoHtml(info.out || '');
        fleetHtml = formatFleetInfoHtml(info.info || '');
        shipPic = info.pic || '';
      } else {
        monitor = selected.length > 1 ? 'multi' : 'empty';
      }
      return;
    }

    if (GALAXY_ORDERS.has(id)) {
      monitor = 'galaxy';
      showOrderBtn = false;
      orderGlow = false;
      await openGalaxyMap(id === 41);
      return;
    }

    if (SYSTEM_ORDERS.has(id)) {
      monitor = 'system';
      showOrderBtn = false;
      orderGlow = false;
      await openSystemMap();
      return;
    }

    if (CARGO_ORDERS.has(id)) {
      monitor = 'cargo';
      cargoItems = [];
      const data = await loadShipsItems(primaryId());
      cargoItems = data.items || [];
      showOrderBtn = ORDER_BTN.has(id);
      return;
    }

    if (id === 11) {
      monitor = 'rename';
      const ship = ships[selected[0]];
      const name = ship?.name || '';
      renameName = name.startsWith('*') ? name.slice(1) : name;
      renameGroup = ship?.group || '';
      showOrderBtn = false;
      return;
    }

    if (id === 7) {
      monitor = 'disband';
      fleetSelected = [];
      const data = await loadShipsFleetList(primaryId());
      fleetMembers = data.ships || [];
      showOrderBtn = true;
      return;
    }

    if (id === 42) {
      monitor = 'strateg';
      fleetSelected = [];
      strategStep = '1';
      const data = await loadShipsFleetOrderList(primaryId());
      fleetMembers = data.ships || [];
      fleetMaxStep = data.ms || '';
      showOrderBtn = true;
      return;
    }

    if (id === 45) {
      monitor = 'interrupt';
      const data = await loadShipsInterruptMsg(primaryId());
      interruptMsg = data.msg || '';
      showOrderBtn = false;
      return;
    }

    if (id === 50) {
      monitor = 'war';
      warWid = param;
      warLog = [];
      await startWar(param);
      showOrderBtn = false;
      return;
    }

    if (FLEET_MAKE.has(id)) monitor = 'make_fleet';
    else if (LAND_ORDERS.has(id)) monitor = 'land';
    else if (id === 2) monitor = 'flyout';
    else if (UNDOCK_ORDERS.has(id)) monitor = 'undock';
    else if (DOCK_ORDERS.has(id)) monitor = 'dock';
    else if (PLANET_ATK.has(id)) monitor = 'attack';
    else if (SHIP_ATK.has(id)) monitor = 'attack';
    else if (FLEET_ATK.has(id)) monitor = 'attack';
    else monitor = 'action';

    showOrderBtn = ORDER_BTN.has(id);
    orderGlow = ATTACK_ORDERS.has(id);
  }

  async function startWar(wid) {
    stopWarPoll();
    if (!wid) {
      errorText = 'Нет id боя';
      return;
    }
    const data = await loadWarStart(wid);
    if (String(data.err) !== '0') {
      warNear = [];
      warFar = [];
      warLog = [`Ошибка загрузки боя (err=${data.err})`];
      return;
    }
    warNear = data.near || [];
    warFar = data.far || [];
    warSide = data.side || '0';
    warLastMove = data.lastMove || '0';
    warPlaceHash = data.placeHash || '';
    warLog = ['Бой загружен'];
    warTimer = setInterval(() => {
      pollWar();
    }, 1000);
  }

  async function pollWar() {
    if (!warPlaceHash) return;
    const data = await loadWarRead({
      wi: warPlaceHash,
      lm: warLastMove,
      sd: warSide,
    });
    if (String(data.err) === '2' || data.reload) {
      warLog = [...warLog, 'Состав боя изменился — перезагрузка'];
      await startWar(warWid);
      return;
    }
    if (String(data.err) !== '0') return;
    warLastMove = data.lastMove || warLastMove;
    if (data.shots?.length) {
      warFxBatch = {
        t: Date.now(),
        shots: [...data.shots],
        near: warNear.map((u) => ({ ...u })),
        far: warFar.map((u) => ({ ...u })),
      };
      applyWarShots(data.shots);
      warLog = [...warLog, ...data.shots.map(formatShot)].slice(-80);
    }
  }

  function applyWarShots(shots) {
    let near = warNear.map((u) => ({ ...u }));
    let far = warFar.map((u) => ({ ...u }));

    const hitSide = (list, defId, defeat, power) => {
      const idx = list.findIndex((u) => u.id === defId);
      if (idx < 0) return list;
      const u = { ...list[idx] };
      let shield = parseInt(u.shield, 10) || 0;
      let count = parseInt(u.count, 10) || 0;
      let shieldTot = parseInt(u.shieldTot, 10) || 0;

      if (defeat > 0) {
        shield = Math.max(0, shield - (power || defeat));
      } else if (defeat === -1 || defeat === -2) {
        const perShip = count > 0 ? Math.round(shieldTot / count) : 0;
        shield = Math.max(0, shield - (Number.isFinite(power) ? power : 0));
        if (count > 1) {
          count -= 1;
          shieldTot = Math.max(0, shieldTot - perShip);
        } else {
          count = 0;
          shield = 0;
          shieldTot = 0;
        }
      }

      u.shield = String(shield);
      u.count = String(count);
      u.shieldTot = String(shieldTot);
      const next = list.slice();
      if (count <= 0 && shield <= 0) next.splice(idx, 1);
      else next[idx] = u;
      return next;
    };

    for (const raw of shots) {
      const parts = String(raw).split(':');
      if (parts.length < 7) continue;
      const defId = parts[2];
      const defeat = parseInt(parts[5], 10);
      const power = parseInt(parts[6], 10);
      if (Number.isNaN(defeat)) continue;
      if (defId.startsWith('a')) near = hitSide(near, defId, defeat, power);
      else if (defId.startsWith('d')) far = hitSide(far, defId, defeat, power);
      else {
        near = hitSide(near, defId, defeat, power);
        far = hitSide(far, defId, defeat, power);
      }
    }

    warNear = near;
    warFar = far;
  }

  function formatShot(raw) {
    const parts = String(raw).split(':');
    if (parts.length < 7) return raw;
    const defeat = parseInt(parts[5], 10);
    const power = parts[6];
    let result = 'попадание';
    if (defeat === 0) result = 'промах';
    else if (defeat === -1) result = 'уничтожен';
    else if (defeat === -2) result = 'захвачен';
    return `${parts[0]} → ${parts[2]} · ${result} · сила ${power}`;
  }

  function centerGalaxy(cx, cy) {
    const x = cx ?? galaxyHome?.x ?? (galaxyBounds.minX + galaxyBounds.maxX) / 2;
    const y = cy ?? galaxyHome?.y ?? (galaxyBounds.minY + galaxyBounds.maxY) / 2;
    galaxyOffset = galaxyCenterOffset(galaxyViewport, galaxyBounds, x, y);
  }

  function galaxyLocal(e) {
    return galaxyLocalPoint(galaxyViewport, galaxyOffset, galaxyBounds, e);
  }

  function galaxyPointerDown(e) {
    galaxyDragging = true;
    galaxyDragMoved = false;
    galaxyDragStart = {
      x: e.clientX,
      y: e.clientY,
      ox: galaxyOffset.x,
      oy: galaxyOffset.y,
    };
  }

  function galaxyPointerMove(e) {
    if (!galaxyDragging) {
      const pt = galaxyLocal(e);
      if (pt) galaxyHover = `${Math.round(pt.x)}:${Math.round(pt.y)}`;
      return;
    }
    const dx = e.clientX - galaxyDragStart.x;
    const dy = e.clientY - galaxyDragStart.y;
    if (Math.abs(dx) > 3 || Math.abs(dy) > 3) galaxyDragMoved = true;
    galaxyOffset = {
      x: galaxyDragStart.ox + dx,
      y: galaxyDragStart.oy + dy,
    };
  }

  function snapGalaxyPoint(x, y, radius = GALAXY_STAR_SNAP) {
    let best = null;
    let bestD = Infinity;
    const consider = (px, py) => {
      if (Math.abs(px - x) > radius || Math.abs(py - y) > radius) return;
      const d = (px - x) * (px - x) + (py - y) * (py - y);
      if (d < bestD) {
        bestD = d;
        best = { x: px, y: py };
      }
    };
    for (const s of galaxyStars) consider(s.x, s.y);
    for (const y of galaxyYellow) consider(y.x, y.y);
    if (galaxyHome) consider(galaxyHome.x, galaxyHome.y);
    if (galaxyQuest) consider(galaxyQuest.x, galaxyQuest.y);
    return best || { x: Math.round(x), y: Math.round(y) };
  }

  async function galaxyPointerUp(e) {
    if (!galaxyDragging) return;
    galaxyDragging = false;
    if (galaxyDragMoved) return;
    const pt = galaxyLocal(e);
    if (!pt) return;
    if (!isGalaxyPointValid(pt.x, pt.y)) {
      galaxyDesc = lightenGalaxyDesc(
        `<font color="#FF0000">Точка за пределами галактики (макс. ${GALAXY_MAX_RADIUS} от центра)</font>`,
      );
      showOrderBtn = false;
      orderGlow = false;
      return;
    }
    const snap = snapGalaxyPoint(pt.x, pt.y);
    const idx = findRouteWaypointIndex(snap.x, snap.y, galaxyRoute);
    if (idx >= 0) {
      galaxyRoute = [...galaxyRoute.slice(0, idx), ...galaxyRoute.slice(idx + 1)];
    } else if (
      galaxyShip &&
      isNearPoint(snap.x, snap.y, galaxyShip.x, galaxyShip.y)
    ) {
      if (!galaxyRoute.length) return;
      await onGalaxyEscape();
      return;
    } else {
      galaxyRoute = applyGalaxyRouteClick(galaxyRoute, snap, galaxyRouteSkill, galaxyStars);
      galaxyRoute = applyAutonavTail(
        galaxyShip,
        galaxyRoute,
        galaxyStars,
        galaxyRouteSkill,
        galaxyHyperCnt,
      );
    }
    await refreshGalaxyRoutePreview();
  }

  async function applyGalaxyMonitorOpen(homeJump) {
    galaxyHomeJump = homeJump;
    galaxyRoute = [];
    galaxyPreviewT = 0;
    galaxyCoordX = '';
    galaxyCoordY = '';
    galaxyPlace = { x: 0, y: 0 };
    showOrderBtn = false;
    orderGlow = false;
    galaxyDesc = galaxyBaseDesc;
    if (homeJump && galaxyHome) {
      centerGalaxy(galaxyHome.x, galaxyHome.y);
      galaxyRoute = [{ x: galaxyHome.x, y: galaxyHome.y }];
      await refreshGalaxyRoutePreview();
    } else {
      centerGalaxy(galaxyShip?.x, galaxyShip?.y);
    }
  }

  async function onGalaxyEscape() {
    if (galaxyRoute.length > 0) {
      galaxyRoute = [];
      await refreshGalaxyRoutePreview();
      return;
    }
    centerGalaxy(galaxyShip?.x, galaxyShip?.y);
  }

  function onGalaxyKeydown(e) {
    if (monitor !== 'galaxy') return;
    if (e.key === 'Escape') {
      e.preventDefault();
      onGalaxyEscape();
    }
  }

  async function openGalaxyMap(homeJump) {
    resetGalaxy();
    const shid = primaryId();
    if (!shid) return;
    busy = true;
    try {
      const data = await loadStarMap(shid);
      galaxyStars = data.stars || [];
      galaxyYellow = data.yellow || [];
      galaxyHome =
        data.hstx != null && data.hsty != null ? { x: data.hstx, y: data.hsty } : null;
      galaxyQuest =
        data.quest && data.qsx != null && data.qsy != null
          ? { x: data.qsx, y: data.qsy }
          : null;
      galaxyShip =
        data.shx != null && data.shy != null ? { x: data.shx, y: data.shy } : null;
      galaxyRouteSkill = data.routeSkill || 0;
      galaxyHyperCnt = data.hyperCnt || 0;
      galaxyBounds = computeGalaxyBounds(galaxyStars);
      galaxyBaseDesc = lightenGalaxyDesc(data.desc || '');
      await svelteTick();
      await applyGalaxyMonitorOpen(homeJump);
    } catch {
      errorText = 'Ошибка карты галактики';
    } finally {
      busy = false;
    }
  }

  function lightenGalaxyDesc(html) {
    return String(html || '')
      .replace(/#FF0000/gi, '#FFB4B4')
      .replace(/#FFFF00/gi, '#FFE566')
      .replace(/#00FF00/gi, '#9DFF9D');
  }

  async function refreshGalaxyRoutePreview() {
    const shid = primaryId();
    if (!shid || !galaxyRoute.length) {
      galaxyPreviewT = 0;
      galaxyPlace = { x: 0, y: 0 };
      galaxyCoordX = '';
      galaxyCoordY = '';
      showOrderBtn = false;
      orderGlow = false;
      if (!galaxyRoute.length) galaxyDesc = galaxyBaseDesc;
      return;
    }
    const last = galaxyRoute[galaxyRoute.length - 1];
    const data = await getStarCoord(last.x, last.y, shid, formatRoutePts(galaxyRoute));
    if (String(data.err) === '7') {
      galaxyDesc = lightenGalaxyDesc(
        `<font color="#FF0000">Точка за пределами галактики (макс. ${GALAXY_MAX_RADIUS} от центра)</font>`,
      );
      showOrderBtn = false;
      orderGlow = false;
      return;
    }
    if (String(data.err) !== '0') {
      showOrderBtn = false;
      orderGlow = false;
      return;
    }
    const tail = galaxyRoute[galaxyRoute.length - 1] || last;
    const rx = parseInt(data.rx != null ? data.rx : tail.x, 10);
    const ry = parseInt(data.ry != null ? data.ry : tail.y, 10);
    const t = parseInt(data.t != null ? data.t : '3', 10);
    const desc = data.desc || '';
    galaxyPlace = { x: rx, y: ry };
    galaxyCoordX = String(rx);
    galaxyCoordY = String(ry);
    galaxyPreviewT = t;
    galaxyDesc = lightenGalaxyDesc(desc);
    showOrderBtn = t === 1 || t === 2;
    orderGlow = showOrderBtn && /#FF0000/i.test(desc);
  }

  async function applyGalaxyCoords() {
    const mx = parseInt(galaxyCoordX, 10);
    const my = parseInt(galaxyCoordY, 10);
    if (Number.isNaN(mx) || Number.isNaN(my)) return;
    if (!isGalaxyPointValid(mx, my)) {
      galaxyDesc = lightenGalaxyDesc(
        `<font color="#FF0000">Точка за пределами галактики (макс. ${GALAXY_MAX_RADIUS} от центра)</font>`,
      );
      showOrderBtn = false;
      orderGlow = false;
      return;
    }
    const snap = snapGalaxyPoint(mx, my);
    if (galaxyShip && sameGalaxyPoint(snap, galaxyShip) && !galaxyRoute.length) return;
    const last = galaxyRoute[galaxyRoute.length - 1];
    if (last && last.x === snap.x && last.y === snap.y && galaxyPreviewT > 0) return;
    playBuzz();
    galaxyRoute = applyGalaxyRouteClick(galaxyRoute, snap, galaxyRouteSkill, galaxyStars);
    galaxyRoute = applyAutonavTail(
      galaxyShip,
      galaxyRoute,
      galaxyStars,
      galaxyRouteSkill,
      galaxyHyperCnt,
    );
    await refreshGalaxyRoutePreview();
  }

  function systemPolarXy(angleDeg, orb) {
    return systemPlanetXy(angleDeg, orb);
  }

  function centerSystem(cx, cy) {
    const x = cx ?? systemShip?.x ?? 0;
    const y = cy ?? systemShip?.y ?? 0;
    systemOffset = systemCenterOffset(systemViewport, systemBounds, x, y);
  }

  function systemLocal(e) {
    return systemLocalPoint(systemViewport, systemOffset, systemBounds, e);
  }

  function systemPointerDown(e) {
    systemDragging = true;
    systemDragMoved = false;
    systemDragStart = {
      x: e.clientX,
      y: e.clientY,
      ox: systemOffset.x,
      oy: systemOffset.y,
    };
  }

  function systemPointerMove(e) {
    if (!systemDragging) {
      const pt = systemLocal(e);
      if (pt) systemHover = `${Math.round(pt.x)}:${Math.round(pt.y)}`;
      return;
    }
    const dx = e.clientX - systemDragStart.x;
    const dy = e.clientY - systemDragStart.y;
    if (Math.abs(dx) > 3 || Math.abs(dy) > 3) systemDragMoved = true;
    systemOffset = systemClampOffset(systemViewport, systemBounds, {
      x: systemDragStart.ox + dx,
      y: systemDragStart.oy + dy,
    });
  }

  async function systemPointerUp(e) {
    if (!systemDragging) return;
    systemDragging = false;
    if (systemDragMoved) return;
    const pt = systemLocal(e);
    if (!pt) return;
    if (!isSystemPointValid(pt.x, pt.y)) {
      systemDesc = lightenGalaxyDesc(
        `<font color="#FF0000">Точка за пределами системы (макс. ${SYSTEM_MAX_RADIUS} от звезды)</font>`,
      );
      showOrderBtn = false;
      orderGlow = false;
      return;
    }
    await probeSystem(Math.round(pt.x), Math.round(pt.y));
  }

  function systemStartFromData(data) {
    if (data.pt === 0) {
      return systemPolarXy(data.arg1, data.arg2);
    }
    return { x: data.arg1, y: data.arg2 };
  }

  function uniqueSystemOrbits(planets) {
    const seen = new Set();
    const orbs = [];
    for (const p of planets) {
      if (seen.has(p.orb)) continue;
      seen.add(p.orb);
      orbs.push(p.orb);
    }
    return orbs;
  }

  function planetImg(type) {
    const t = PLANET_SIZE[type] ? type : 1;
    return `${SYSTEM_IMG}/p${t}.gif`;
  }

  function planetSize(type) {
    return PLANET_SIZE[type] || 16;
  }

  function planetShadowSize(type) {
    return planetSize(type) + 1;
  }

  function planetShadowRotate(angle) {
    return 6.28 - angle;
  }

  function markerStroke(ct) {
    if (ct === 2) return '#5cff8a';
    if (ct === 3) return '#c8c8c8';
    return '#ff6a6a';
  }

  async function openSystemMap() {
    resetSystem();
    const shid = primaryId();
    if (!shid) return;
    busy = true;
    try {
      const data = await loadSystemMap(shid);
      if (!data.ok) {
        errorText = 'Ошибка карты системы';
        return;
      }
      applySystemMapData(data, { resetPreview: true });
      await svelteTick();
      centerSystem(systemShip?.x, systemShip?.y);
      startSystemOrbitPoll();
    } catch {
      errorText = 'Ошибка карты системы';
    } finally {
      busy = false;
    }
  }

  async function probeSystem(mx, my) {
    const shid = primaryId();
    if (!shid) return;
    const data = await getSystemCoord(mx, my, shid);
    if (String(data.err) === '3') {
      systemDesc = lightenGalaxyDesc('<font color="#FF0000">Слишком близко к звезде</font>');
      showOrderBtn = false;
      orderGlow = false;
      return;
    }
    if (String(data.err) === '6') {
      systemDesc = lightenGalaxyDesc(
        `<font color="#FF0000">Точка за пределами системы (макс. ${SYSTEM_MAX_RADIUS} от звезды)</font>`,
      );
      showOrderBtn = false;
      orderGlow = false;
      return;
    }
    if (String(data.err) !== '0') {
      showOrderBtn = false;
      orderGlow = false;
      return;
    }
    const rx = parseInt(data.rx != null ? data.rx : mx, 10);
    const ry = parseInt(data.ry != null ? data.ry : my, 10);
    const t = parseInt(data.t != null ? data.t : '3', 10);
    const desc = data.desc || '';
    systemPlace = { x: rx, y: ry };
    systemCoordX = String(rx);
    systemCoordY = String(ry);
    systemPreviewT = t;
    systemDesc = lightenGalaxyDesc(desc);
    showOrderBtn = t === 1 || t === 2;
    orderGlow = showOrderBtn && /#FF0000/i.test(desc);
  }

  async function applySystemCoords() {
    const mx = parseInt(systemCoordX, 10);
    const my = parseInt(systemCoordY, 10);
    if (Number.isNaN(mx) || Number.isNaN(my)) return;
    if (!isSystemPointValid(mx, my)) {
      systemDesc = lightenGalaxyDesc(
        `<font color="#FF0000">Точка за пределами системы (макс. ${SYSTEM_MAX_RADIUS} от звезды)</font>`,
      );
      showOrderBtn = false;
      orderGlow = false;
      return;
    }
    if (mx === systemPlace.x && my === systemPlace.y && systemPreviewT > 0) return;
    playBuzz();
    await probeSystem(mx, my);
  }

  async function afterOrder(data) {
    const focusId = data?.fid || primaryId();
    if (focusId) lastShip = focusId;
    await refreshPlaces(true, { focusId });
  }

  async function clickOrder() {
    if (busy || !showOrderBtn) return;
    playBuzz();
    const { id, raw } = parseOrderId(orderValue);
    showOrderBtn = false;
    busy = true;
    try {
      let data;
      const ids = selectedIds();
      if (GALAXY_ORDERS.has(id)) {
        data = await shipsStarMove({
          shid: primaryId(),
          pts: formatRoutePts(galaxyRoute),
        });
      } else if (SYSTEM_ORDERS.has(id)) {
        data = await shipsSystemMove({
          shid: primaryId(),
          x: systemPlace.x,
          y: systemPlace.y,
        });
      } else if (ATTACK_RPC.has(id)) {
        if (ids.length > 1) data = await shipsFleetAttack(ids);
        else data = await shipsMakeAttack({ shid: primaryId(), orid: raw });
      } else if (ids.length > 1) {
        data = await shipsMakeFleet(ids);
      } else if (id === 11) {
        data = await shipsMakeOrder({
          shid: primaryId(),
          orid: '11',
          nname: renameName,
          gname: renameGroup,
        });
      } else {
        data = await shipsMakeOrder({ shid: primaryId(), orid: raw });
      }
      await afterOrder(data);
    } catch {
      errorText = 'Ошибка приказа';
    } finally {
      busy = false;
    }
  }

  async function clickRename() {
    playBuzz();
    busy = true;
    try {
      const data = await shipsMakeOrder({
        shid: primaryId(),
        orid: '11',
        nname: renameName,
        gname: renameGroup,
      });
      await afterOrder(data);
    } finally {
      busy = false;
    }
  }

  async function clickSaveInterrupt() {
    playBuzz();
    busy = true;
    try {
      const data = await shipsMakeOrder({
        shid: primaryId(),
        orid: '45',
        msg: interruptMsg,
      });
      await afterOrder(data);
    } finally {
      busy = false;
    }
  }

  async function clickDeconserv(all) {
    playBuzz();
    const ship = ships[selected[0]];
    if (!ship) return;
    busy = true;
    try {
      const cnt = all ? conservMax : parseInt(conservCnt, 10) || 1;
      const data = await shipsDeconserv({
        shid: ship.id,
        cnt,
        gname: renameGroup,
      });
      await afterOrder(data);
    } finally {
      busy = false;
    }
  }

  function onFleetMemberClick(idx, e) {
    let next;
    if (e.shiftKey && fleetLastIdx >= 0) {
      const a = Math.min(fleetLastIdx, idx);
      const b = Math.max(fleetLastIdx, idx);
      next = [];
      for (let i = a; i <= b; i++) next.push(i);
    } else if (e.ctrlKey || e.metaKey) {
      next = fleetSelected.slice();
      const pos = next.indexOf(idx);
      if (pos >= 0) next.splice(pos, 1);
      else next.push(idx);
      fleetLastIdx = idx;
    } else {
      next = [idx];
      fleetLastIdx = idx;
    }
    fleetSelected = next;
  }

  async function clickFleetOut() {
    if (!fleetSelected.length) return;
    playBuzz();
    busy = true;
    try {
      const ids = fleetSelected.map((i) => fleetMembers[i]?.id).filter(Boolean);
      const data = await shipsFleetOff({ fid: primaryId(), shipIds: ids });
      await afterOrder(data);
    } finally {
      busy = false;
    }
  }

  async function clickFleetStrateg() {
    if (!fleetSelected.length) return;
    playBuzz();
    busy = true;
    try {
      const ids = fleetSelected.map((i) => fleetMembers[i]?.id).filter(Boolean);
      const data = await shipsFleetSet({ set: strategStep, shipIds: ids });
      await afterOrder(data);
    } finally {
      busy = false;
    }
  }

  function goWarehouse() {
    playBuzz();
    const id = primaryId();
    if (!id) return;
    push(`/ware?shid=${encodeURIComponent(id)}`);
  }

  function onInfoClick(e) {
    const a = e.target.closest('a');
    if (!a) return;
    const href = a.getAttribute('href') || '';
    const m = href.match(/page\.php\?id=18(?:%26|&)login=([^&'"]+)/i);
    if (!m) return;
    e.preventDefault();
    const login = decodeURIComponent(m[1].replace(/\+/g, ' '));
    push(`/about?login=${encodeURIComponent(login)}`);
  }

  function onPlaceChange(e) {
    placeValue = e.detail.value;
    refreshShips(true);
  }

  function onOthersChange() {
    others = !others;
    refreshShips(true);
  }

  function sortBy(col) {
    sortOrd = col;
    refreshShips(true);
  }

  $: monitorHeading =
    monitor === 'system'
      ? systemName || 'Карта системы'
      : monitor === 'galaxy'
        ? 'Карта галактики'
        : monitorTitle();

  $: quickOrders = orderOptions.filter((o) => String(o.value) !== '100');

  function isDangerOrder(value) {
    return ATTACK_ORDERS.has(parseOrderId(value).id);
  }

  async function quickOrder(value) {
    if (busy) return;
    await onOrderChange({ detail: { value } });
    if (showOrderBtn) await clickOrder();
  }

  function monitorTitle() {
    switch (monitor) {
      case 'info':
      case 'conserv':
        return 'Информация';
      case 'rename':
        return 'Переименовать';
      case 'cargo':
        return 'Отсек';
      case 'disband':
        return 'Расформировать флот';
      case 'strateg':
        return 'Главнокомандующий';
      case 'interrupt':
        return 'Сообщение перехвата';
      case 'system':
        return systemName || 'Карта системы';
      case 'galaxy':
        return 'Карта галактики';
      case 'war':
        return 'Бой';
      case 'attack':
        return 'Атака';
      case 'make_fleet':
        return 'Флот';
      case 'land':
        return 'Посадка';
      case 'flyout':
        return 'Выход на орбиту';
      case 'dock':
        return 'Стыковка';
      case 'undock':
        return 'Отстыковка';
      case 'multi':
        return 'Группа';
      case 'action':
        return 'Приказ';
      default:
        return 'Монитор';
    }
  }

  onMount(() => {
    scratchAudio = new Audio(`${IMG}/sounds/scratch.mp3`);
    buzzAudio = new Audio(`${IMG}/sounds/buzz.mp3`);
    if (bootLs) lastShip = bootLs;
    refreshPlaces(true);
    shipsTimer = setInterval(() => {
      tick += 1;
      const needReload = ships.some((s) => {
        if (s.tp == null || Number.isNaN(s.tp)) return false;
        const remain = s.tp - (Date.now() - shipsStartMs) / 1000;
        return remain <= 0;
      });
      if (needReload) refreshPlaces(true, { syncMonitor: isInfoMonitor() });
    }, 1000);
  });

  onDestroy(() => {
    if (shipsTimer) clearInterval(shipsTimer);
    stopWarPoll();
    clearGalaxyCoordTimer();
    clearSystemCoordTimer();
    stopSystemOrbitPoll();
  });
</script>

<svelte:window on:keydown={onGalaxyKeydown} />

<div class="ships-screen">
  <div class="ships-toolbar">
    <label class="toolbar-field">
      <span>Место</span>
      <ScifiSelect value={placeValue} options={placeOptions} on:change={onPlaceChange} />
    </label>
    <label class="others-check">
      <input type="checkbox" checked={others} on:change={onOthersChange} />
      <span>Чужие</span>
    </label>
    {#if busy}
      <span class="busy-note">…</span>
    {/if}
  </div>

  {#if errorText}
    <p class="ships-error">{errorText}</p>
  {/if}

  <div class="ships-grid">
    <ScifiPanel title="Корабли" className="ships-list-pane">
      <table class="scifi-table">
        <thead>
          <tr>
            <th class="kind-col" aria-hidden="true"></th>
            <th class="name-col">
              <button type="button" class="th-btn" on:click={() => sortBy(0)}>Имя</button>
            </th>
            <th class="place-col">
              <button type="button" class="th-btn" on:click={() => sortBy(1)}>Расположение</button>
            </th>
          </tr>
        </thead>
        <tbody>
          {#each displayShips as ship, i}
            <tr
              class:active-row={ship.selected}
              style={rowStyle(ship.bgColor)}
              on:click={(e) => onShipClick(i, e)}
            >
              <td class="kind-col">
                {#if ship.kind}
                  <span
                    class="kind-icon {kindIconClass(ship)}"
                    title={kindLabel(ship.kind, ship)}
                    aria-label={kindLabel(ship.kind, ship)}
                  >
                    {#if ship.kind === 'pilot'}
                      <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" aria-hidden="true">
                        <circle cx="12" cy="5" r="3.4" />
                        <path d="M12 8.5v8M5.5 12h13M12 16.5l-4.5 5M12 16.5l4.5 5" />
                      </svg>
                    {:else if ship.kind === 'fleet'}
                      <svg viewBox="0 0 24 24" width="14" height="14" fill="currentColor" aria-hidden="true">
                        <path d="M12 2.5L16.2 10H7.8Z" />
                        <path d="M7 12.5L11.2 20H2.8Z" />
                        <path d="M17 12.5L21.2 20H12.8Z" />
                      </svg>
                    {:else}
                      <svg viewBox="0 0 24 24" width="14" height="14" fill="currentColor" aria-hidden="true">
                        <path d="M12 3.5L20 20.5H4Z" />
                      </svg>
                    {/if}
                  </span>
                {/if}
              </td>
              <td class="name-col" title={ship.name}>{ship.name}</td>
              <td class="place-col" title={ship.location}>{ship.location}</td>
            </tr>
          {:else}
            <tr>
              <td colspan="3">Нет кораблей</td>
            </tr>
          {/each}
        </tbody>
      </table>
    </ScifiPanel>

    <ScifiPanel className="ships-monitor-pane">
      <div slot="header" class="monitor-header">
        <span class="monitor-title">{monitorHeading}</span>
        <ScifiSelect
          className="orders-select"
          value={orderValue}
          options={orderOptions}
          disabled={!orderOptions.length}
          on:change={onOrderChange}
        />
        {#if monitor === 'galaxy'}
          <div class="galaxy-coords">
            <input
              class="scifi-input narrow"
              bind:value={galaxyCoordX}
              aria-label="X"
              on:input={scheduleGalaxyCoords}
            />
            <span class="galaxy-coords-sep">:</span>
            <input
              class="scifi-input narrow"
              bind:value={galaxyCoordY}
              aria-label="Y"
              on:input={scheduleGalaxyCoords}
            />
          </div>
        {:else if monitor === 'system'}
          <div class="galaxy-coords">
            <input
              class="scifi-input narrow"
              bind:value={systemCoordX}
              aria-label="X"
              on:input={scheduleSystemCoords}
            />
            <span class="galaxy-coords-sep">:</span>
            <input
              class="scifi-input narrow"
              bind:value={systemCoordY}
              aria-label="Y"
              on:input={scheduleSystemCoords}
            />
          </div>
        {/if}
        <ScifiButton
          className="order-run-btn"
          variant={showOrderBtn && orderGlow ? 'danger' : 'primary'}
          disabled={busy || !showOrderBtn}
          on:click={clickOrder}
        >
          Выполнить
        </ScifiButton>
      </div>
      {#if monitor === 'info' || monitor === 'conserv'}
        <div class="monitor-body info-layout">
          <div class="info-with-orders">
            <div class="info-main">
              {#if shipPic}
                <img class="ship-pic" src={`/img/ships/f${shipPic}.png`} alt="" />
              {/if}
              <div class="html-rich info-html" on:click={onInfoClick}>
                {@html infoHtml || '—'}
              </div>
              {#if fleetHtml}
                <div class="html-rich fleet-html">{@html fleetHtml}</div>
              {/if}
              {#if monitor === 'conserv'}
                <div class="conserv-actions">
                  <label>
                    Кол-во
                    <input class="scifi-input" bind:value={conservCnt} />
                  </label>
                  <label>
                    Группа
                    <input class="scifi-input" bind:value={renameGroup} />
                  </label>
                  <ScifiButton variant="primary" disabled={busy} on:click={() => clickDeconserv(false)}>
                    Расконсервировать
                  </ScifiButton>
                  <ScifiButton variant="ghost" disabled={busy} on:click={() => clickDeconserv(true)}>
                    Все ({conservMax})
                  </ScifiButton>
                </div>
              {/if}
            </div>
            {#if quickOrders.length}
              <div class="quick-orders" aria-label="Приказы">
                {#each quickOrders as opt}
                  <ScifiButton
                    className="quick-order-btn"
                    variant={isDangerOrder(opt.value) ? 'danger' : 'ghost'}
                    disabled={busy}
                    on:click={() => quickOrder(opt.value)}
                  >
                    {opt.label}
                  </ScifiButton>
                {/each}
              </div>
            {/if}
          </div>
        </div>

      {:else if monitor === 'rename'}
        <div class="monitor-body form-stack">
          <label>
            Имя
            <input class="scifi-input" bind:value={renameName} />
          </label>
          <label>
            Группа
            <input class="scifi-input" bind:value={renameGroup} />
          </label>
          <ScifiButton variant="primary" disabled={busy} on:click={clickRename}>
            Переименовать
          </ScifiButton>
        </div>

      {:else if monitor === 'cargo'}
        <div class="monitor-body">
          <table class="scifi-table">
            <thead>
              <tr>
                <th>Наименование</th>
                <th>Кол-во</th>
                <th>Масса</th>
              </tr>
            </thead>
            <tbody>
              {#each cargoItems as item}
                <tr style={rowStyle(item.bgColor)}>
                  <td>{item.name}</td>
                  <td>{item.count}</td>
                  <td>{item.mass}</td>
                </tr>
              {:else}
                <tr><td colspan="3">Пусто</td></tr>
              {/each}
            </tbody>
          </table>
          <div class="monitor-actions">
            <ScifiButton variant="primary" on:click={goWarehouse}>Склад</ScifiButton>
          </div>
        </div>

      {:else if monitor === 'disband' || monitor === 'strateg'}
        <div class="monitor-body">
          {#if monitor === 'strateg' && fleetMaxStep}
            <p class="muted">Макс. порядок: {fleetMaxStep}</p>
          {/if}
          <table class="scifi-table">
            <thead>
              <tr><th>Наименование</th></tr>
            </thead>
            <tbody>
              {#each fleetMembers as ship, i}
                <tr
                  class:active-row={fleetSelected.includes(i)}
                  on:click={(e) => onFleetMemberClick(i, e)}
                >
                  <td>{ship.name}</td>
                </tr>
              {:else}
                <tr><td>Нет кораблей</td></tr>
              {/each}
            </tbody>
          </table>
          <div class="monitor-actions">
            {#if monitor === 'disband'}
              <span class="muted">Выбрано: {fleetSelected.length}</span>
              <ScifiButton
                variant="warn"
                disabled={busy || !fleetSelected.length}
                on:click={clickFleetOut}
              >
                Исключить
              </ScifiButton>
            {:else}
              <label>
                Порядок
                <input class="scifi-input narrow" bind:value={strategStep} />
              </label>
              <ScifiButton
                variant="primary"
                disabled={busy || !fleetSelected.length}
                on:click={clickFleetStrateg}
              >
                Назначить
              </ScifiButton>
            {/if}
          </div>
        </div>

      {:else if monitor === 'interrupt'}
        <div class="monitor-body form-stack">
          <label>
            Сообщение
            <textarea class="scifi-input msg-area" rows="5" bind:value={interruptMsg}></textarea>
          </label>
          <ScifiButton variant="primary" disabled={busy} on:click={clickSaveInterrupt}>
            Сохранить
          </ScifiButton>
        </div>

      {:else if monitor === 'galaxy'}
        <div class="monitor-body galaxy-layout">
          <GalaxyMap
            idPrefix="galaxy"
            bind:viewport={galaxyViewport}
            stars={galaxyStars}
            yellow={galaxyYellow}
            home={galaxyHome}
            hideHomeRing={galaxyHomeInRoute}
            quest={galaxyQuest}
            ship={galaxyShip}
            offset={galaxyOffset}
            bounds={galaxyBounds}
            hover={galaxyHover}
            showDesc={true}
            descHtml={galaxyDesc}
            on:pointerdown={galaxyPointerDown}
            on:pointermove={galaxyPointerMove}
            on:pointerup={galaxyPointerUp}
            on:pointerleave={() => {
              galaxyDragging = false;
              galaxyHover = '';
            }}
          >
            {#if galaxyPreviewT > 0 && galaxyShip && galaxyRoute.length}
              <polyline
                class="route-march"
                class:route-blocked={galaxyPreviewT === 3}
                points={routePolylinePoints(galaxyShip, galaxyRoute)}
                fill="none"
                stroke={galaxyPreviewT === 3 ? '#ff5a5a' : 'var(--neon-cyan)'}
                stroke-width="1.5"
                stroke-linecap="round"
                stroke-linejoin="round"
              />
              {#each galaxyRoute as wp}
                {#if !(galaxyShip && sameGalaxyPoint(galaxyShip, wp))}
                  <circle
                    cx={wp.x}
                    cy={wp.y}
                    r={ROUTE_RING_R}
                    fill="none"
                    stroke="var(--neon-cyan)"
                    stroke-width={MAP_STROKE}
                  />
                {/if}
              {/each}
            {/if}
          </GalaxyMap>
        </div>

      {:else if monitor === 'system'}
        <div class="monitor-body galaxy-layout">
          <SystemMap
            bind:viewport={systemViewport}
            offset={systemOffset}
            bounds={systemBounds}
            bgUrl={systemBg}
            stype={systemStype}
            hover={systemHover}
            showDesc={true}
            descHtml={systemDesc}
            on:pointerdown={systemPointerDown}
            on:pointermove={systemPointerMove}
            on:pointerup={systemPointerUp}
            on:pointerleave={() => {
              systemDragging = false;
              systemHover = '';
            }}
          >
            {#each systemOrbits as orb}
              <circle
                cx="0"
                cy="0"
                r={orb}
                fill="none"
                stroke="rgba(180, 220, 255, 0.28)"
                stroke-width="1"
              />
            {/each}
            {#each systemPlanets as p}
              <image
                href={planetImg(p.type)}
                x={p.x - planetSize(p.type) / 2}
                y={p.y - planetSize(p.type) / 2}
                width={planetSize(p.type)}
                height={planetSize(p.type)}
              >
                <title>{p.name}</title>
              </image>
              {#if p.type !== 5}
                <image
                  href={`${SYSTEM_IMG}/shadow.png`}
                  x={p.x - planetShadowSize(p.type) / 2}
                  y={p.y - planetShadowSize(p.type) / 2}
                  width={planetShadowSize(p.type)}
                  height={planetShadowSize(p.type)}
                  transform={`rotate(${planetShadowRotate(p.angle)} ${p.x} ${p.y})`}
                  pointer-events="none"
                />
              {/if}
            {/each}
            {#each systemMarkers as m}
              {#if m.ct === 3}
                <rect
                  x={m.x - SYSTEM_TRASH_S / 2}
                  y={m.y - SYSTEM_TRASH_S / 2}
                  width={SYSTEM_TRASH_S}
                  height={SYSTEM_TRASH_S}
                  fill="none"
                  stroke={markerStroke(m.ct)}
                  stroke-width={MAP_STROKE}
                />
              {:else}
                <circle
                  cx={m.x}
                  cy={m.y}
                  r={SYSTEM_MARKER_R}
                  fill="none"
                  stroke={markerStroke(m.ct)}
                  stroke-width={MAP_STROKE}
                />
              {/if}
            {/each}
            {#if systemShip}
              <circle
                cx={systemShip.x}
                cy={systemShip.y}
                r={SYSTEM_CIRCLE_R}
                fill="none"
                stroke="#ffffff"
                stroke-width={MAP_STROKE}
              />
            {/if}
            {#if systemPreviewT > 0 && systemShip}
              <line
                class="route-march"
                class:route-blocked={systemPreviewT === 3}
                x1={systemShip.x}
                y1={systemShip.y}
                x2={systemPlace.x}
                y2={systemPlace.y}
                fill="none"
                stroke={systemPreviewT === 3 ? '#ff5a5a' : 'var(--neon-cyan)'}
                stroke-width="1.5"
                stroke-linecap="round"
              />
              <circle
                cx={systemPlace.x}
                cy={systemPlace.y}
                r={SYSTEM_CIRCLE_R}
                fill="none"
                stroke="var(--neon-cyan)"
                stroke-width={MAP_STROKE}
              />
            {/if}
          </SystemMap>
        </div>

      {:else if monitor === 'war'}
        <div class="monitor-body war-layout">
          <WarArena near={warNear} far={warFar} shotBatch={warFxBatch} debugLog={warLog} />
        </div>

      {:else if monitor === 'attack' || monitor === 'action' || monitor === 'land' || monitor === 'flyout' || monitor === 'dock' || monitor === 'undock' || monitor === 'make_fleet'}
        <div class="monitor-body stub-box">
          <p>
            {orderOptions.find((o) => String(o.value) === String(orderValue))?.label || 'Приказ'}
          </p>
          <p class="muted">Подтвердите выполнение кнопкой «Выполнить».</p>
        </div>

      {:else if monitor === 'multi'}
        <div class="monitor-body info-layout">
          <div class="info-with-orders">
            <div class="info-main stub-box">
              <p>Выбрано кораблей: {selected.length}</p>
              <p class="muted">Выберите приказ для группы.</p>
            </div>
            {#if quickOrders.length}
              <div class="quick-orders" aria-label="Приказы">
                {#each quickOrders as opt}
                  <ScifiButton
                    className="quick-order-btn"
                    variant={isDangerOrder(opt.value) ? 'danger' : 'ghost'}
                    disabled={busy}
                    on:click={() => quickOrder(opt.value)}
                  >
                    {opt.label}
                  </ScifiButton>
                {/each}
              </div>
            {/if}
          </div>
        </div>

      {:else}
        <div class="monitor-body stub-box">
          <p class="muted">Выберите корабль</p>
        </div>
      {/if}
    </ScifiPanel>
  </div>
</div>

<style>
  .ships-screen {
    display: flex;
    flex-direction: column;
    gap: 0.35rem;
    height: 100%;
    min-height: 0;
  }

  .ships-toolbar {
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    gap: 0.85rem;
    margin-top: -0.15rem;
  }

  .toolbar-field {
    display: flex;
    align-items: center;
    gap: 0.45rem;
    color: var(--text-muted);
    font-size: 0.85rem;
    min-width: 14rem;
  }

  .toolbar-field :global(.scifi-combo) {
    min-width: 12rem;
  }

  .others-check {
    display: inline-flex;
    align-items: center;
    gap: 0.4rem;
    color: var(--text-main);
    font-size: 0.9rem;
    cursor: pointer;
  }

  .busy-note {
    color: var(--neon-cyan-dim);
  }

  .ships-error {
    margin: 0;
    color: var(--accent-sell);
    font-size: 0.9rem;
  }

  .ships-grid {
    display: grid;
    grid-template-columns: minmax(240px, 360px) minmax(0, 1fr);
    gap: 0.75rem;
    flex: 1 1 auto;
    min-height: 0;
    align-items: stretch;
  }

  .ships-grid :global(.ships-list-pane),
  .ships-grid :global(.ships-monitor-pane) {
    min-height: 0;
    display: flex;
    flex-direction: column;
  }

  .ships-grid :global(.ships-list-pane .panel-content) {
    overflow: auto;
    min-height: 0;
  }

  .ships-grid :global(.ships-monitor-pane .panel-content) {
    display: flex;
    flex-direction: column;
    overflow: hidden;
    min-height: 0;
  }

  .ships-grid :global(.ships-list-pane .scifi-table) {
    table-layout: fixed;
    width: 100%;
  }

  .ships-grid :global(.ships-list-pane .scifi-table th),
  .ships-grid :global(.ships-list-pane .scifi-table td) {
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }

  .ships-grid :global(.ships-list-pane .scifi-table tbody tr) {
    user-select: none;
  }

  .ships-grid :global(.ships-list-pane .kind-col) {
    width: 24px;
    max-width: 24px;
    padding-left: 4px;
    padding-right: 2px;
    text-align: center;
    vertical-align: middle;
  }

  .ships-grid :global(.ships-list-pane .name-col) {
    width: 42%;
  }

  .ships-grid :global(.ships-list-pane .place-col) {
    width: auto;
  }

  .kind-icon {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    color: var(--neon-cyan);
    opacity: 0.9;
  }

  .kind-icon--foreign {
    transform: scaleY(-1);
  }

  .kind-icon--rel-0 {
    color: #e8f0f4;
  }

  .kind-icon--rel-1 {
    color: #4cff7a;
  }

  .kind-icon--rel-2 {
    color: #ff5252;
  }

  .kind-icon svg {
    display: block;
  }

  .th-btn {
    background: none;
    border: 0;
    color: inherit;
    font: inherit;
    cursor: pointer;
    padding: 0;
  }

  .th-btn:hover {
    color: var(--neon-cyan);
  }

  .ships-grid :global(.ships-monitor-pane .panel-header) {
    display: flex;
    align-items: center;
    gap: 0.55rem;
    flex-wrap: wrap;
  }

  .monitor-header {
    display: flex;
    align-items: center;
    gap: 0.55rem;
    flex: 1 1 auto;
    min-width: 0;
    flex-wrap: wrap;
  }

  .monitor-title {
    flex: 0 0 auto;
    white-space: nowrap;
  }

  .monitor-header :global(.orders-select) {
    flex: 1 1 12rem;
    min-width: 10rem;
  }

  .monitor-header :global(.scifi-btn) {
    flex: 0 0 auto;
  }

  .monitor-header :global(.order-run-btn) {
    min-width: 7.5rem;
  }

  .monitor-body {
    display: flex;
    flex-direction: column;
    gap: 0.65rem;
    min-height: 0;
    flex: 1 1 auto;
    overflow: auto;
  }

  .info-layout {
    gap: 0.75rem;
  }

  .info-with-orders {
    display: flex;
    align-items: flex-start;
    gap: 0.75rem;
    min-height: 0;
    flex: 1 1 auto;
  }

  .info-main {
    display: flex;
    flex-direction: column;
    gap: 0.75rem;
    flex: 1 1 auto;
    min-width: 0;
  }

  .quick-orders {
    display: flex;
    flex-direction: column;
    gap: 0.35rem;
    flex: 0 0 auto;
    width: min(15.5rem, 34%);
    max-height: 100%;
    overflow: auto;
    padding-left: 0.15rem;
  }

  .quick-orders :global(.quick-order-btn) {
    width: 100%;
    justify-content: flex-start;
    text-align: left;
    white-space: normal;
    line-height: 1.25;
    min-height: 2rem;
    padding: 0.35rem 0.65rem;
    font-size: 0.82rem;
  }

  .ship-pic {
    width: min(180px, 40%);
    height: auto;
    align-self: flex-end;
    image-rendering: auto;
    opacity: 0.95;
  }

  .info-html :global(a),
  .fleet-html :global(a) {
    color: inherit;
  }

  .info-html :global(.ship-warn) {
    color: var(--accent-sell);
  }

  .info-html :global(.enc-section),
  .fleet-html :global(.enc-section) {
    margin-top: 0;
  }

  .form-stack label,
  .conserv-actions label {
    display: flex;
    flex-direction: column;
    gap: 0.25rem;
    color: var(--text-muted);
    font-size: 0.85rem;
  }

  .conserv-actions,
  .monitor-actions {
    display: flex;
    flex-wrap: wrap;
    gap: 0.5rem;
    align-items: flex-end;
  }

  .msg-area {
    resize: vertical;
    min-height: 6rem;
  }

  .narrow {
    width: 5rem;
  }

  .stub-box {
    color: var(--text-main);
    line-height: 1.45;
  }

  .muted {
    color: var(--text-muted);
    margin: 0;
  }

  .war-layout {
    padding: 0;
    gap: 0;
    min-height: 0;
    flex: 1 1 auto;
    overflow: hidden;
  }

  .galaxy-layout {
    gap: 0;
    min-height: 0;
    flex: 1 1 auto;
    overflow: hidden;
  }

  .route-march {
    stroke-dasharray: 5 6;
    stroke-dashoffset: 0;
    opacity: 0.9;
    animation: route-march 0.7s linear infinite;
  }

  .route-march.route-blocked {
    opacity: 0.75;
  }

  @keyframes route-march {
    to {
      stroke-dashoffset: -22;
    }
  }

  .galaxy-coords {
    display: flex;
    align-items: center;
    gap: 0.35rem;
    flex: 0 0 auto;
  }

  .galaxy-coords-sep {
    color: var(--neon-cyan-dim);
    font-size: 0.95rem;
    line-height: 1;
    user-select: none;
    text-transform: none;
  }

  .galaxy-coords :global(.scifi-input.narrow) {
    width: 4.5rem;
  }

  @media (max-width: 500px) {
    .ships-grid {
      grid-template-columns: 1fr;
    }
  }
</style>
