<script>
  import { onMount } from 'svelte';
  import { querystring } from 'svelte-spa-router';
  import {
    getNoonConfig,
    loadWarePlaces,
    loadWareShipItems,
    loadWareShips,
    loadWareSiloItems,
    loadWareSilos,
    moveWareItem,
    moveWareMult,
  } from '../lib/api.js';
  import ScifiPanel from '../lib/ui/ScifiPanel.svelte';
  import ScifiButton from '../lib/ui/ScifiButton.svelte';
  import ScifiSelect from '../lib/ui/ScifiSelect.svelte';

  const IMG = '/app/img/booklist';
  const CLASS_FILTERS = [
    { value: '0', label: 'Все' },
    { value: '5', label: 'Ископаемые' },
    { value: '1', label: 'Ресурсы' },
    { value: '2', label: 'Детали' },
    { value: '6', label: 'Чертежи' },
    { value: '7', label: 'Макеты' },
    { value: '9', label: 'Консервы' },
  ];

  let placeOptions = [{ value: '*', label: 'Все' }];
  let placeValue = '*';
  let bootShid = '';

  let ships = [];
  let shipSelected = [];
  let shipLastIdx = -1;

  let shipItems = [];
  let shipItemSelected = [];
  let shipItemLastIdx = -1;
  let shipFree = '';
  let shipRf = '5';

  let silos = [];
  let siloSelected = -1;

  let wareItems = [];
  let wareItemSelected = [];
  let wareItemLastIdx = -1;
  let wareFree = '';
  let wareRf = '5';

  let qtyText = '';
  let qtyVisible = false;
  let moveAllVisible = false;
  let busy = false;
  let errorText = '';

  let scratchAudio;
  let buzzAudio;

  function wareRoot(node) {
    node.addEventListener('click', onRootClick);
    return {
      destroy() {
        node.removeEventListener('click', onRootClick);
      },
    };
  }

  $: qs = new URLSearchParams($querystring || '');
  $: qtyValid = isValidQty(qtyText);
  $: qtyGlow = !qtyVisible ? '' : qtyValid ? 'ok' : 'fail';
  $: moveVisible = qtyVisible && qtyValid;
  $: moveDirection = shipItemSelected.length
    ? 'to-ware'
    : wareItemSelected.length
      ? 'to-ship'
      : '';
  $: selectedItemName = selectedItemLabel();

  function isValidQty(text) {
    if (text === '' || text === '0') return false;
    return String(parseInt(text, 10)) === String(text);
  }

  function selectedItemLabel() {
    if (shipItemSelected.length === 1) {
      const item = shipItems[shipItemSelected[0]];
      return item ? item.name : '';
    }
    if (wareItemSelected.length === 1) {
      const item = wareItems[wareItemSelected[0]];
      return item ? item.name : '';
    }
    if (shipItemSelected.length > 1) return `Предметов: ${shipItemSelected.length}`;
    if (wareItemSelected.length > 1) return `Предметов: ${wareItemSelected.length}`;
    return '';
  }

  function playSelect() {
    try {
      const { sv } = getNoonConfig();
      if (!scratchAudio) return;
      scratchAudio.volume = Math.max(0, Math.min(1, sv / 100));
      scratchAudio.currentTime = 0;
      scratchAudio.play().catch(() => {});
    } catch {
      /* ignore sfx errors */
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
      /* ignore sfx errors */
    }
  }

  function hideMoveUi() {
    qtyText = '';
    qtyVisible = false;
    moveAllVisible = false;
  }

  function showMoveUi() {
    qtyVisible = true;
    moveAllVisible = true;
    qtyText = '0';
  }

  function toggleIndex(selected, idx, lastIdx, e, itemCount) {
    const ev = e || {};
    if (idx < 0 || idx >= itemCount) return { selected: [], last: -1 };
    if (ev.shiftKey && lastIdx >= 0) {
      const from = Math.min(lastIdx, idx);
      const to = Math.max(lastIdx, idx);
      const next = [];
      for (let i = from; i <= to; i++) next.push(i);
      return { selected: next, last: idx };
    }
    if (ev.ctrlKey || ev.metaKey) {
      const set = new Set(selected);
      if (set.has(idx)) set.delete(idx);
      else set.add(idx);
      const next = [...set].sort((a, b) => a - b);
      return { selected: next, last: idx };
    }
    return { selected: [idx], last: idx };
  }

  function selectedShipIds() {
    return shipSelected.map((i) => ships[i]?.id).filter(Boolean);
  }

  async function refreshShipItems() {
    const ids = selectedShipIds();
    if (!ids.length) {
      shipItems = [];
      shipFree = '';
      return;
    }
    const data = await loadWareShipItems(shipRf, ids);
    shipItems = data.items || [];
    shipFree = data.free || '';
  }

  async function refreshSilos() {
    const ids = selectedShipIds();
    if (!ids.length) {
      silos = [];
      siloSelected = -1;
      wareItems = [];
      wareFree = '';
      return;
    }
    const data = await loadWareSilos(ids);
    if (String(data.err) !== '0') {
      silos = [];
      siloSelected = -1;
      wareItems = [];
      wareFree = '';
      errorText = `Склады: ошибка ${data.err}`;
      return;
    }
    silos = data.silos || [];
    siloSelected = silos.length ? 0 : -1;
    await refreshWareItems();
  }

  async function refreshWareItems() {
    if (siloSelected < 0 || !silos[siloSelected]) {
      wareItems = [];
      wareFree = '';
      return;
    }
    const silo = silos[siloSelected];
    const data = await loadWareSiloItems(wareRf, silo.id, silo.tid);
    wareItems = data.items || [];
    wareFree = data.free || '';
  }

  async function loadShipsForPlace() {
    hideMoveUi();
    shipItemSelected = [];
    wareItemSelected = [];
    const data = await loadWareShips(placeValue, bootShid);
    ships = data.ships || [];
    const pos = Math.max(0, Math.min(data.pos || 0, ships.length - 1));
    shipSelected = ships.length ? [pos] : [];
    shipLastIdx = ships.length ? pos : -1;
    await Promise.all([refreshShipItems(), refreshSilos()]);
  }

  async function onPlaceChange(e) {
    placeValue = String(e.detail.value);
    await loadShipsForPlace();
  }

  async function onShipClick(idx, e) {
    const next = toggleIndex(shipSelected, idx, shipLastIdx, e, ships.length);
    shipSelected = next.selected;
    shipLastIdx = next.last;
    hideMoveUi();
    shipItemSelected = [];
    wareItemSelected = [];
    playSelect();
    await Promise.all([refreshShipItems(), refreshSilos()]);
  }

  async function onShipRfChange(e) {
    shipRf = String(e.detail.value);
    hideMoveUi();
    shipItemSelected = [];
    await refreshShipItems();
  }

  function onShipItemClick(idx, e) {
    const next = toggleIndex(shipItemSelected, idx, shipItemLastIdx, e, shipItems.length);
    shipItemSelected = next.selected;
    shipItemLastIdx = next.last;
    wareItemSelected = [];
    wareItemLastIdx = -1;
    if (shipItemSelected.length) {
      showMoveUi();
    } else {
      hideMoveUi();
    }
    playSelect();
  }

  async function onSiloClick(idx) {
    siloSelected = idx;
    hideMoveUi();
    shipItemSelected = [];
    wareItemSelected = [];
    playSelect();
    await refreshWareItems();
  }

  async function onWareRfChange(e) {
    wareRf = String(e.detail.value);
    hideMoveUi();
    wareItemSelected = [];
    await refreshWareItems();
  }

  function onWareItemClick(idx, e) {
    const next = toggleIndex(wareItemSelected, idx, wareItemLastIdx, e, wareItems.length);
    wareItemSelected = next.selected;
    wareItemLastIdx = next.last;
    shipItemSelected = [];
    shipItemLastIdx = -1;
    if (wareItemSelected.length) {
      showMoveUi();
    } else {
      hideMoveUi();
    }
    playSelect();
  }

  async function refreshAfterMove() {
    await Promise.all([refreshShipItems(), refreshWareItems()]);
    hideMoveUi();
    shipItemSelected = [];
    wareItemSelected = [];
  }

  function collectObjectIds(fromShip) {
    if (fromShip) {
      return shipItemSelected.map((i) => shipItems[i]?.id).filter(Boolean);
    }
    return wareItemSelected.map((i) => wareItems[i]?.id).filter(Boolean);
  }

  async function doMove(ocnt) {
    if (busy) return;
    const ids = selectedShipIds();
    if (!ids.length || siloSelected < 0 || !silos[siloSelected]) return;
    const fromShip = shipItemSelected.length > 0;
    const fromWare = wareItemSelected.length > 0;
    if (!fromShip && !fromWare) return;

    const objects = collectObjectIds(fromShip);
    if (!objects.length) return;

    const silo = silos[siloSelected];
    const move = fromShip ? '0' : '1';
    const single =
      ids.length === 1 &&
      objects.length === 1 &&
      ((fromShip && shipItemSelected.length === 1) ||
        (fromWare && wareItemSelected.length === 1));

    busy = true;
    errorText = '';
    playBuzz();
    try {
      let result;
      if (single) {
        result = await moveWareItem({
          shid: ids[0],
          plid: silo.id,
          tid: silo.tid,
          oid: objects[0],
          ocnt,
          move,
        });
      } else {
        result = await moveWareMult({
          ships: ids.join(','),
          plid: silo.id,
          tid: silo.tid,
          objects: objects.join(','),
          ocnt,
          move,
        });
      }
      const err = result.err || result.Err;
      if (err && String(err) !== '0') {
        errorText = `Ошибка перемещения: ${err}`;
      }
      await refreshAfterMove();
    } finally {
      busy = false;
    }
  }

  function onMove() {
    if (!qtyValid) return;
    doMove(parseInt(qtyText, 10));
  }

  function onMoveAll() {
    doMove(-1);
  }

  function onRootClick(e) {
    const table = e.target.closest('table[data-ware-table]');
    if (!table || !e.currentTarget.contains(table)) return;
    const tr = e.target.closest('tr[data-idx]');
    if (!tr || !table.contains(tr)) return;
    const idx = parseInt(tr.dataset.idx, 10);
    if (Number.isNaN(idx)) return;
    const kind = table.getAttribute('data-ware-table');
    switch (kind) {
      case 'ships':
        onShipClick(idx, e);
        break;
      case 'ship-items':
        onShipItemClick(idx, e);
        break;
      case 'silos':
        onSiloClick(idx);
        break;
      case 'ware-items':
        onWareItemClick(idx, e);
        break;
    }
  }

  onMount(() => {
    scratchAudio = new Audio(`${IMG}/sounds/scratch.mp3`);
    buzzAudio = new Audio(`${IMG}/sounds/buzz.mp3`);

    bootShid = qs.get('shid') || '';
    (async () => {
      const places = await loadWarePlaces();
      placeOptions = places.places.length ? places.places : [{ value: '*', label: 'Все' }];
      if (places.lastPlace) {
        const hit = placeOptions.find((p) => String(p.value) === String(places.lastPlace));
        placeValue = hit ? String(hit.value) : '*';
      } else {
        placeValue = '*';
      }
      await loadShipsForPlace();
    })();
  });
</script>

<div class="ware-screen" use:wareRoot>
  <div class="place-bar">
    <span class="place-label">Место</span>
    <ScifiSelect
      className="place-select"
      bind:value={placeValue}
      options={placeOptions}
      on:change={onPlaceChange}
    />
  </div>

  {#if errorText}
    <p class="ware-error">{errorText}</p>
  {/if}

  <div class="ware-grid">
    <ScifiPanel title="Корабли" className="pane ships-pane">
      <div class="table-wrap">
        <table class="scifi-table" data-ware-table="ships">
          <thead>
            <tr>
              <th>Наименование</th>
              <th>Расположение</th>
              <th class="num">Объем</th>
            </tr>
          </thead>
          <tbody>
            {#each ships as ship, i}
              <tr data-idx={i} class:active-row={shipSelected.includes(i)}>
                <td>{ship.name}</td>
                <td>{ship.place}</td>
                <td class="num">{ship.cargo}</td>
              </tr>
            {:else}
              <tr><td colspan="3" class="empty">Нет кораблей</td></tr>
            {/each}
          </tbody>
        </table>
      </div>
    </ScifiPanel>

    <ScifiPanel title="Груз корабля" className="pane items-pane">
      <div class="items-toolbar">
        <span>Доступно пространства: {shipFree || '—'}</span>
        <ScifiSelect
          className="class-select"
          bind:value={shipRf}
          options={CLASS_FILTERS}
          on:change={onShipRfChange}
        />
      </div>
      <div class="table-wrap">
        <table class="scifi-table" data-ware-table="ship-items">
          <thead>
            <tr>
              <th>Наименование</th>
              <th class="num">Доступно</th>
              <th class="num">Масса</th>
            </tr>
          </thead>
          <tbody>
            {#each shipItems as item, i}
              <tr data-idx={i} class:active-row={shipItemSelected.includes(i)}>
                <td>{item.name}</td>
                <td class="num">{item.count}</td>
                <td class="num">{item.mass}</td>
              </tr>
            {:else}
              <tr><td colspan="3" class="empty">Пусто</td></tr>
            {/each}
          </tbody>
        </table>
      </div>
    </ScifiPanel>

    <div class="move-bar">
      <div class="move-meta">
        {#if moveDirection === 'to-ware'}
          <span class="dir">↓ на склад</span>
        {:else if moveDirection === 'to-ship'}
          <span class="dir">↑ на корабль</span>
        {:else}
          <span class="dir muted">Выберите груз</span>
        {/if}
        {#if selectedItemName}
          <span class="item-name">{selectedItemName}</span>
        {/if}
      </div>
      {#if qtyVisible}
        <label class="qty-wrap">
          <span>Количество</span>
          <input
            class="scifi-input glow-{qtyGlow}"
            type="text"
            bind:value={qtyText}
            disabled={busy}
          />
        </label>
      {/if}
      <div class="move-actions">
        {#if moveVisible}
          <ScifiButton variant="primary" disabled={busy} on:click={onMove}>
            Переместить
          </ScifiButton>
        {/if}
        {#if moveAllVisible}
          <ScifiButton variant="ghost" disabled={busy} on:click={onMoveAll}>
            Переместить всё
          </ScifiButton>
        {/if}
      </div>
    </div>

    <ScifiPanel title="Склады" className="pane silos-pane">
      <div class="table-wrap">
        <table class="scifi-table" data-ware-table="silos">
          <thead>
            <tr>
              <th>Наименование</th>
              <th>Расположение</th>
              <th class="num">Объем</th>
            </tr>
          </thead>
          <tbody>
            {#each silos as silo, i}
              <tr data-idx={i} class:active-row={siloSelected === i}>
                <td>{silo.name}</td>
                <td>{silo.place}</td>
                <td class="num">{silo.cargo}</td>
              </tr>
            {:else}
              <tr><td colspan="3" class="empty">Нет складов</td></tr>
            {/each}
          </tbody>
        </table>
      </div>
    </ScifiPanel>

    <ScifiPanel title="Груз склада" className="pane items-pane">
      <div class="items-toolbar">
        <span>Доступно пространства: {wareFree || '—'}</span>
        <ScifiSelect
          className="class-select"
          bind:value={wareRf}
          options={CLASS_FILTERS}
          on:change={onWareRfChange}
        />
      </div>
      <div class="table-wrap">
        <table class="scifi-table" data-ware-table="ware-items">
          <thead>
            <tr>
              <th>Наименование</th>
              <th class="num">Доступно</th>
              <th class="num">Масса</th>
            </tr>
          </thead>
          <tbody>
            {#each wareItems as item, i}
              <tr data-idx={i} class:active-row={wareItemSelected.includes(i)}>
                <td>{item.name}</td>
                <td class="num">{item.count}</td>
                <td class="num">{item.mass}</td>
              </tr>
            {:else}
              <tr><td colspan="3" class="empty">Пусто</td></tr>
            {/each}
          </tbody>
        </table>
      </div>
    </ScifiPanel>
  </div>
</div>

<style>
  .ware-screen {
    display: flex;
    flex-direction: column;
    gap: 10px;
    min-height: 0;
    height: 100%;
  }

  .place-bar {
    display: flex;
    align-items: center;
    gap: 10px;
    flex-wrap: wrap;
  }

  .place-label {
    color: var(--text-muted);
    font-size: 0.85rem;
    text-transform: uppercase;
    letter-spacing: 0.04em;
  }

  .place-bar :global(.place-select) {
    min-width: min(320px, 100%);
  }

  .ware-error {
    margin: 0;
    color: var(--accent-sell);
    font-size: 0.85rem;
  }

  .ware-grid {
    display: grid;
    grid-template-columns: 480px minmax(0, 1.2fr);
    grid-template-rows: minmax(140px, 1fr) auto minmax(140px, 1fr);
    gap: 10px;
    min-height: 0;
    flex: 1;
  }

  .ware-grid :global(.pane) {
    min-height: 0;
    display: flex;
    flex-direction: column;
  }

  .ware-grid :global(.pane .panel-content) {
    min-height: 0;
    flex: 1;
    display: flex;
    flex-direction: column;
    padding: 0;
  }

  .items-toolbar {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 8px;
    flex-wrap: wrap;
    padding: 8px 10px 0;
    font-size: 0.8rem;
    color: var(--text-muted);
  }

  .items-toolbar :global(.class-select) {
    min-width: 140px;
  }

  .table-wrap {
    overflow: auto;
    min-height: 0;
    flex: 1;
  }

  .empty {
    color: var(--text-muted);
    font-style: italic;
    text-align: center;
  }

  .move-bar {
    grid-column: 1 / -1;
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    gap: 12px;
    padding: 10px 12px;
    background: var(--panel-bg);
    border: 1px solid var(--border-light);
    box-shadow: var(--glow-soft);
  }

  .move-meta {
    display: flex;
    flex-direction: column;
    gap: 2px;
    min-width: 140px;
  }

  .dir {
    color: var(--neon-cyan);
    font-size: 0.8rem;
    text-transform: uppercase;
    letter-spacing: 0.04em;
  }

  .dir.muted {
    color: var(--text-muted);
  }

  .item-name {
    color: var(--text-main);
    font-size: 0.9rem;
  }

  .qty-wrap {
    display: flex;
    align-items: center;
    gap: 8px;
    color: var(--text-muted);
    font-size: 0.85rem;
  }

  .qty-wrap :global(.scifi-input) {
    width: 100px;
  }

  .move-actions {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
    margin-left: auto;
  }

  @media (max-width: 500px) {
    .ware-grid {
      grid-template-columns: 1fr;
      grid-template-rows: none;
    }

    .move-bar {
      order: 0;
    }

    .move-actions {
      margin-left: 0;
    }
  }
</style>
