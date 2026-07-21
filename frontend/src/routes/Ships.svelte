<script>
  import { onDestroy, onMount } from 'svelte';
  import { push, querystring } from 'svelte-spa-router';
  import {
    getNoonConfig,
    loadShipsFleetList,
    loadShipsFleetOrderList,
    loadShipsFleetOrders,
    loadShipsInfo,
    loadShipsInterruptMsg,
    loadShipsItems,
    loadShipsList,
    loadShipsOrders,
    loadShipsPlaces,
    loadWarRead,
    loadWarStart,
    shipsDeconserv,
    shipsFleetAttack,
    shipsFleetOff,
    shipsFleetSet,
    shipsMakeAttack,
    shipsMakeFleet,
    shipsMakeOrder,
  } from '../lib/api.js';
  import ScifiPanel from '../lib/ui/ScifiPanel.svelte';
  import ScifiButton from '../lib/ui/ScifiButton.svelte';
  import ScifiSelect from '../lib/ui/ScifiSelect.svelte';

  const IMG = '/app/img/booklist';
  const ATTACK_ORDERS = new Set([14, 16, 17, 18, 32, 33, 49, 51]);
  const ATTACK_RPC = new Set([14, 16, 17, 18, 49, 51]);
  const ORDER_BTN = new Set([
    0, 1, 2, 3, 4, 5, 6, 7, 12, 14, 16, 17, 18, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33,
    34, 35, 36, 37, 38, 39, 40, 43, 44, 46, 47, 48, 49, 51,
  ]);
  const MAP_ORDERS = new Set([8, 9, 41]);
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
  let warSide = '0';
  let warLastMove = '0';
  let warPlaceHash = '';
  let warWid = '';

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
  $: displayShips = ships.map((ship, i) => ({
    ...ship,
    location: formatLocation(ship, tick),
    selected: selected.includes(i),
  }));

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
      const m = line.match(/^(.+?)\s+\((\d+)\)\s*$/);
      if (m) rows.push({ name: m[1], cnt: m[2] });
      else rows.push({ name: line, cnt: '' });
    }
    if (!rows.length) return text;

    const body = rows
      .map(
        (r) =>
          `<tr><td>${r.name}</td><td class="enc-qty">${r.cnt}</td></tr>`,
      )
      .join('');
    return (
      `<div class="enc-section"><div class="enc-section-title">${title}</div>` +
      `<table class="enc-table"><tbody>${body}</tbody></table></div>`
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
    if (!bgColor) return '';
    const hex = String(bgColor).replace(/^0x/i, '#');
    if (!/^#[0-9a-fA-F]{6}$/.test(hex)) return '';
    if (hex.toLowerCase() === '#000000') return '';
    return `background: ${hex}22`;
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
    warWid = '';
  }

  async function refreshPlaces(keepSelection = true) {
    const gen = ++loadGen;
    const data = await loadShipsPlaces();
    if (gen !== loadGen) return;
    placeOptions = data.places || [{ value: '*', label: 'Все' }];
    others = !!data.others;
    if (!keepSelection || !placeOptions.some((p) => String(p.value) === String(placeValue))) {
      const last = data.lastPlace || '*';
      placeValue = placeOptions.some((p) => String(p.value) === String(last)) ? last : '*';
    }
    await refreshShips(keepSelection);
  }

  async function refreshShips(keepSelection = true) {
    const gen = ++loadGen;
    const prevIds = keepSelection ? selectedIds() : [];
    const prefer = keepSelection && prevIds.length ? prevIds : lastShip || bootLs ? [lastShip || bootLs] : [];
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

      let next = [];
      if (prefer.length) {
        prefer.forEach((id) => {
          const idx = ships.findIndex((s) => s.id === id && s.bgColor !== '0xCC0000');
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
      await applySelection(false);
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

    if (MAP_ORDERS.has(id)) {
      monitor = 'map_stub';
      showOrderBtn = false;
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
      warLog = [...warLog, ...data.shots.map(formatShot)].slice(-80);
    }
  }

  function formatShot(raw) {
    const parts = String(raw).split(':');
    if (parts.length < 7) return raw;
    const defeat = parts[5] === '1' ? 'поражение' : 'попадание';
    return `${parts[0]} → ${parts[2]} · ${defeat} · сила ${parts[6]}`;
  }

  async function afterOrder(data) {
    if (data?.fid) {
      lastShip = data.fid;
      selected = [];
    }
    await refreshPlaces(true);
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
      if (ATTACK_RPC.has(id)) {
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
      case 'map_stub':
        return 'Карта';
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
      if (needReload) refreshPlaces(true);
    }, 1000);
  });

  onDestroy(() => {
    if (shipsTimer) clearInterval(shipsTimer);
    stopWarPoll();
  });
</script>

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
            <th>
              <button type="button" class="th-btn" on:click={() => sortBy(0)}>Имя</button>
            </th>
            <th>
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
              <td>{ship.name}</td>
              <td>{ship.location}</td>
            </tr>
          {:else}
            <tr>
              <td colspan="2">Нет кораблей</td>
            </tr>
          {/each}
        </tbody>
      </table>
    </ScifiPanel>

    <ScifiPanel title={monitorTitle()} className="ships-monitor-pane">
      <div class="monitor-head">
        <ScifiSelect
          className="orders-select"
          value={orderValue}
          options={orderOptions}
          disabled={!orderOptions.length}
          on:change={onOrderChange}
        />
        {#if showOrderBtn}
          <ScifiButton
            variant={orderGlow ? 'danger' : 'primary'}
            disabled={busy}
            on:click={clickOrder}
          >
            Выполнить
          </ScifiButton>
        {/if}
      </div>

      {#if monitor === 'info' || monitor === 'conserv'}
        <div class="monitor-body info-layout">
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

      {:else if monitor === 'map_stub'}
        <div class="monitor-body stub-box">
          <p>Интерактивная карта системы / галактики — следующий шаг порта.</p>
          <p class="muted">Приказы 8 / 9 / 41 пока без перемещения.</p>
        </div>

      {:else if monitor === 'war'}
        <div class="monitor-body war-layout">
          <div class="war-sides">
            <div>
              <h4>Свои</h4>
              <table class="scifi-table">
                <thead>
                  <tr><th>Тип</th><th>N</th><th>Щит</th></tr>
                </thead>
                <tbody>
                  {#each warNear as unit}
                    <tr>
                      <td>{unit.name}</td>
                      <td>{unit.count}</td>
                      <td>{unit.shield}/{unit.shieldTot}</td>
                    </tr>
                  {/each}
                </tbody>
              </table>
            </div>
            <div>
              <h4>Противник</h4>
              <table class="scifi-table">
                <thead>
                  <tr><th>Тип</th><th>N</th><th>Щит</th></tr>
                </thead>
                <tbody>
                  {#each warFar as unit}
                    <tr>
                      <td>{unit.name}</td>
                      <td>{unit.count}</td>
                      <td>{unit.shield}/{unit.shieldTot}</td>
                    </tr>
                  {/each}
                </tbody>
              </table>
            </div>
          </div>
          <div class="war-log">
            {#each warLog as line}
              <div>{line}</div>
            {/each}
          </div>
        </div>

      {:else if monitor === 'attack' || monitor === 'action' || monitor === 'land' || monitor === 'flyout' || monitor === 'dock' || monitor === 'undock' || monitor === 'make_fleet'}
        <div class="monitor-body stub-box">
          <p>
            {orderOptions.find((o) => String(o.value) === String(orderValue))?.label || 'Приказ'}
          </p>
          <p class="muted">Подтвердите выполнение кнопкой «Выполнить».</p>
        </div>

      {:else if monitor === 'multi'}
        <div class="monitor-body stub-box">
          <p>Выбрано кораблей: {selected.length}</p>
          <p class="muted">Выберите приказ для группы.</p>
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
    gap: 0.65rem;
    height: 100%;
    min-height: 0;
  }

  .ships-toolbar {
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    gap: 0.85rem;
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
    grid-template-columns: minmax(240px, var(--layout-side)) minmax(0, 1fr);
    gap: 0.75rem;
    flex: 1 1 auto;
    min-height: 0;
  }

  .ships-grid :global(.ships-list-pane),
  .ships-grid :global(.ships-monitor-pane) {
    min-height: 0;
    display: flex;
    flex-direction: column;
  }

  .ships-grid :global(.ships-list-pane .panel-content) {
    overflow: hidden;
    min-height: 0;
  }

  .ships-grid :global(.ships-monitor-pane .panel-content) {
    overflow: auto;
    min-height: 0;
  }

  .ships-grid :global(.ships-list-pane .scifi-table th),
  .ships-grid :global(.ships-list-pane .scifi-table td) {
    white-space: nowrap;
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

  .monitor-head {
    display: flex;
    flex-wrap: wrap;
    gap: 0.55rem;
    align-items: center;
    margin-bottom: 0.65rem;
  }

  .monitor-head :global(.orders-select) {
    flex: 1 1 12rem;
    min-width: 10rem;
  }

  .monitor-body {
    display: flex;
    flex-direction: column;
    gap: 0.65rem;
  }

  .info-layout {
    gap: 0.75rem;
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
    gap: 0.75rem;
  }

  .war-sides {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 0.65rem;
  }

  .war-sides h4 {
    margin: 0 0 0.35rem;
    color: var(--neon-cyan-dim);
    font-weight: 600;
    font-size: 0.85rem;
  }

  .war-log {
    max-height: 10rem;
    overflow: auto;
    font-family: var(--font-mono, var(--font-ui));
    font-size: 0.8rem;
    color: var(--text-muted);
    border-top: 1px solid rgba(0, 229, 255, 0.15);
    padding-top: 0.45rem;
  }

  @media (max-width: 500px) {
    .ships-grid {
      grid-template-columns: 1fr;
    }

    .war-sides {
      grid-template-columns: 1fr;
    }
  }
</style>
