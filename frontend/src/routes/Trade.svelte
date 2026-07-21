<script>
  import { onMount } from 'svelte';
  import { push } from 'svelte-spa-router';
  import {
    getNoonConfig,
    loadTradeBayShips,
    loadTradeBayWare,
    loadTradeComp,
    loadTradeConfDesc,
    loadTradeConfList,
    loadTradeSellShips,
    loadTradeSellWare,
    tradeBay,
    tradeConfBay,
    tradeSell,
  } from '../lib/api.js';
  import ScifiPanel from '../lib/ui/ScifiPanel.svelte';
  import ScifiButton from '../lib/ui/ScifiButton.svelte';
  import ScifiTabs from '../lib/ui/ScifiTabs.svelte';
  import ScifiSelect from '../lib/ui/ScifiSelect.svelte';

  const IMG = '/app/img/booklist';
  const TAB_DEFS = [
    { id: 'comp', label: 'Сравнение' },
    { id: 'bay', label: 'Купить' },
    { id: 'sell', label: 'Продать' },
    { id: 'conf', label: 'Конфедерация' },
  ];
  const CLASS_FILTERS = [
    { value: '0', label: 'Все' },
    { value: '5', label: 'Ископаемые' },
    { value: '1', label: 'Ресурсы' },
    { value: '2', label: 'Детали' },
    { value: '6', label: 'Чертежи' },
    { value: '7', label: 'Макеты' },
    { value: '9', label: 'Консервы' },
  ];

  let activeTab = 'comp';
  let busy = false;
  let errorText = '';

  let scratchAudio;
  let buzzAudio;

  let compRf = '0';
  let compMin = '1';
  let compItems = [];
  let compSelected = -1;
  let sellerLogin = '';
  let buyerLogin = '';

  let bayShips = [];
  let bayShipIdx = -1;
  let bayWare = [];
  let bayWareIdx = -1;
  let bayMoney = '';
  let bayQty = '0';
  let bayTitle = '';
  let baySum = '';
  let bayBtn = false;
  let bayBtnAll = false;
  let bayQtyGlow = '';
  let baySumGlow = '';

  let sellShips = [];
  let sellShipIdx = -1;
  let sellWare = [];
  let sellWareIdx = -1;
  let sellMoney = '';
  let sellQty = '0';
  let sellTitle = '';
  let sellSum = '';
  let sellBtn = false;
  let sellBtnAll = false;
  let sellQtyGlow = '';
  let sellSumGlow = '';

  let confItems = [];
  let confIdx = -1;
  let confDesc = '';
  let confMoney = '';
  let confCredits = '';
  let confQty = '1';
  let confPrice = '';
  let confConfPrice = '';
  let confCreditSum = '';
  let confConfSum = '';
  let confCanMoney = false;
  let confCanConf = false;
  let confBtnMoney = false;
  let confBtnConf = false;

  function flashColor(hex) {
    const raw = String(hex || '').replace(/^0x/i, '');
    if (!/^[0-9a-fA-F]{6}$/.test(raw)) return null;
    const r = parseInt(raw.slice(0, 2), 16);
    const g = parseInt(raw.slice(2, 4), 16);
    const b = parseInt(raw.slice(4, 6), 16);
    return `rgba(${r}, ${g}, ${b}, 0.35)`;
  }

  function num(v) {
    const n = Number(String(v ?? '').replace(/\s/g, ''));
    return Number.isFinite(n) ? n : NaN;
  }

  function isIntText(text) {
    if (text === '' || text === '0') return false;
    return String(parseInt(text, 10)) === String(text);
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

  function switchTab(id) {
    activeTab = id;
    playSelect();
  }

  async function refreshComp(oid = '') {
    const params = { min: compMin || '1', rf: compRf };
    if (oid) params.oid = oid;
    const data = await loadTradeComp(params);
    compItems = data.items || [];
  }

  async function onCompFilter() {
    sellerLogin = '';
    buyerLogin = '';
    compSelected = -1;
    await refreshComp();
  }

  async function onCompRow(idx) {
    if (idx < 0 || idx >= compItems.length) return;
    const row = compItems[idx];
    compSelected = idx;
    playSelect();
    sellerLogin = row.sellLogin || '';
    buyerLogin = row.buyLogin || '';
    await refreshComp(row.id);
    if (compSelected >= compItems.length) {
      compSelected = compItems.length ? 0 : -1;
    }
  }

  function openProfile(login) {
    if (!login) return;
    push(`/about?login=${encodeURIComponent(login)}`);
  }

  function clearBayDetail() {
    bayBtn = false;
    bayBtnAll = false;
    bayQty = '';
    bayTitle = '';
    baySum = '';
    bayQtyGlow = '';
    baySumGlow = '';
  }

  function clearSellDetail() {
    sellBtn = false;
    sellBtnAll = false;
    sellQty = '';
    sellTitle = '';
    sellSum = '';
    sellQtyGlow = '';
    sellSumGlow = '';
  }

  function recountBay() {
    const item = bayWare[bayWareIdx];
    if (!item) {
      bayBtn = false;
      bayBtnAll = false;
      bayQtyGlow = '';
      baySumGlow = '';
      return;
    }
    const oc = num(item.offerCnt);
    const op = num(item.price);
    const money = num(bayMoney);
    bayBtn = oc > 0;
    bayQtyGlow = 'ok';
    baySumGlow = 'ok';

    if (!isIntText(bayQty)) {
      bayBtn = false;
      bayQtyGlow = 'fail';
    }

    const qty = parseInt(bayQty, 10) || 0;
    if (qty > oc) {
      baySum = String(op * oc);
      bayBtn = false;
      baySumGlow = 'ok';
    } else {
      baySum = String(op * qty);
    }

    if (num(baySum) > money) {
      bayBtn = false;
      baySumGlow = 'fail';
    }
  }

  function recountSell() {
    const item = sellWare[sellWareIdx];
    if (!item) {
      sellBtn = false;
      sellBtnAll = false;
      sellQtyGlow = '';
      sellSumGlow = '';
      return;
    }
    const sc = num(item.shipCnt);
    const ic = num(item.demandCnt);
    const ip = num(item.price);
    sellBtn = ic > 0 && sc > 0;
    sellQtyGlow = 'ok';
    sellSumGlow = 'ok';

    if (!isIntText(sellQty)) {
      sellBtn = false;
      sellQtyGlow = 'fail';
    }

    const iMin = sc < ic ? sc : ic;
    const qty = parseInt(sellQty, 10) || 0;
    if (qty > iMin) {
      sellSum = String(ip * iMin);
      sellBtn = false;
      sellSumGlow = 'ok';
    } else {
      sellSum = String(ip * qty);
    }
  }

  function recountConf() {
    if (!isIntText(confQty) || parseInt(confQty, 10) <= 0) {
      confQty = '1';
    }
    const qty = parseInt(confQty, 10) || 1;
    const pr = num(confPrice);
    const cp = num(confConfPrice);
    confCreditSum = String(Math.round(pr * qty * 100) / 100);
    confConfSum = String(Math.round(cp * qty * 100) / 100);
    const money = num(confMoney);
    confBtnMoney = confCanMoney && num(confCreditSum) < money;
    confBtnConf = confCanConf && num(confCreditSum) < money;
  }

  async function loadBayWareForShip() {
    clearBayDetail();
    bayWare = [];
    bayWareIdx = -1;
    bayMoney = '';
    if (bayShipIdx < 0 || !bayShips[bayShipIdx]) return;
    const data = await loadTradeBayWare(bayShips[bayShipIdx].id);
    bayMoney = data.money || '';
    bayWare = data.items || [];
  }

  async function loadSellWareForShip() {
    clearSellDetail();
    sellWare = [];
    sellWareIdx = -1;
    sellMoney = '';
    if (sellShipIdx < 0 || !sellShips[sellShipIdx]) return;
    const data = await loadTradeSellWare(sellShips[sellShipIdx].id);
    sellMoney = data.money || '';
    sellWare = data.items || [];
  }

  async function refreshBayShips(keepIdx = true) {
    const prev = keepIdx ? bayShipIdx : -1;
    const data = await loadTradeBayShips();
    bayShips = data.ships || [];
    bayShipIdx = bayShips.length
      ? Math.max(0, Math.min(prev >= 0 ? prev : 0, bayShips.length - 1))
      : -1;
    await loadBayWareForShip();
  }

  async function refreshSellShips(keepIdx = true) {
    const prev = keepIdx ? sellShipIdx : -1;
    const data = await loadTradeSellShips();
    sellShips = data.ships || [];
    sellShipIdx = sellShips.length
      ? Math.max(0, Math.min(prev >= 0 ? prev : 0, sellShips.length - 1))
      : -1;
    await loadSellWareForShip();
  }

  async function onBayShip(idx) {
    bayShipIdx = idx;
    playSelect();
    await loadBayWareForShip();
  }

  function onBayWare(idx) {
    const item = bayWare[idx];
    if (!item) return;
    bayWareIdx = idx;
    playSelect();
    bayBtnAll = num(item.offerCnt) >= 1;
    bayQty = '0';
    bayTitle = item.name || '';
    recountBay();
  }

  async function onSellShip(idx) {
    sellShipIdx = idx;
    playSelect();
    await loadSellWareForShip();
  }

  function onSellWare(idx) {
    const item = sellWare[idx];
    if (!item) return;
    sellWareIdx = idx;
    playSelect();
    sellBtnAll = num(item.shipCnt) >= 1;
    sellQty = '0';
    sellTitle = item.name || '';
    recountSell();
  }

  async function loadConfDetail() {
    confDesc = 'Загрузка...';
    confMoney = '';
    confCredits = '';
    confCreditSum = '';
    confConfSum = '';
    confBtnMoney = false;
    confBtnConf = false;
    confCanMoney = false;
    confCanConf = false;
    if (confIdx < 0 || !confItems[confIdx]) {
      confDesc = '';
      return;
    }
    const data = await loadTradeConfDesc(confItems[confIdx].id);
    if (data.err !== '0') {
      confDesc = 'Нет данных';
      return;
    }
    confDesc = (data.desc || '').replace(/\n/g, '<br>');
    confMoney = data.money || '';
    confCredits = data.conf || '';
    confPrice = data.price || '';
    confConfPrice = data.confPrice || '';
    confCanMoney = data.canBuyMoney;
    confCanConf = data.canBuyConf;
    confQty = '1';
    recountConf();
  }

  async function onConfRow(idx) {
    confIdx = idx;
    playSelect();
    await loadConfDetail();
  }

  async function nopRefresh() {
    await Promise.all([refreshBayShips(true), refreshSellShips(true)]);
    if (activeTab === 'conf' && confIdx >= 0) {
      await loadConfDetail();
    }
  }

  async function doBay(ocnt) {
    if (busy) return;
    if (bayShipIdx < 0 || bayWareIdx < 0) return;
    const ship = bayShips[bayShipIdx];
    const item = bayWare[bayWareIdx];
    if (!ship || !item) return;
    busy = true;
    errorText = '';
    playBuzz();
    try {
      const result = await tradeBay({ shid: ship.id, oid: item.id, ocnt });
      const err = result.err || result.Err;
      if (err && String(err) !== '0') {
        errorText = `Ошибка покупки: ${err}`;
      }
      await nopRefresh();
    } finally {
      busy = false;
    }
  }

  async function doSell(ocnt) {
    if (busy) return;
    if (sellShipIdx < 0 || sellWareIdx < 0) return;
    const ship = sellShips[sellShipIdx];
    const item = sellWare[sellWareIdx];
    if (!ship || !item) return;
    busy = true;
    errorText = '';
    playBuzz();
    try {
      const result = await tradeSell({ shid: ship.id, oid: item.id, ocnt });
      const err = result.err || result.Err;
      if (err && String(err) !== '0') {
        errorText = `Ошибка продажи: ${err}`;
      }
      await nopRefresh();
    } finally {
      busy = false;
    }
  }

  async function doConfBuy(tp) {
    if (busy) return;
    if (confIdx < 0 || !confItems[confIdx]) return;
    busy = true;
    errorText = '';
    playBuzz();
    try {
      const result = await tradeConfBay({
        tp,
        oid: confItems[confIdx].id,
        ocnt: parseInt(confQty, 10) || 1,
      });
      const err = result.err || result.Err;
      if (err && String(err) !== '0') {
        errorText = `Ошибка покупки: ${err}`;
      }
      await nopRefresh();
    } finally {
      busy = false;
    }
  }

  onMount(() => {
    scratchAudio = new Audio(`${IMG}/sounds/scratch.mp3`);
    buzzAudio = new Audio(`${IMG}/sounds/buzz.mp3`);
    (async () => {
      await Promise.all([
        refreshComp(),
        refreshBayShips(false),
        refreshSellShips(false),
        (async () => {
          const data = await loadTradeConfList();
          confItems = data.items || [];
        })(),
      ]);
    })();
  });
</script>

<div class="trade-screen">
  <ScifiTabs tabs={TAB_DEFS} active={activeTab} on:change={(e) => switchTab(e.detail)} />

  {#if errorText}
    <p class="trade-error">{errorText}</p>
  {/if}

  {#if activeTab === 'comp'}
    <div class="comp-layout">
      <div class="filter-bar">
        <ScifiSelect
          className="class-select"
          bind:value={compRf}
          options={CLASS_FILTERS}
          on:change={onCompFilter}
        />
        <label class="min-wrap">
          <span>Мин. кол-во</span>
          <input class="scifi-input" type="text" bind:value={compMin} on:change={onCompFilter} />
        </label>
        <ScifiButton variant="ghost" on:click={onCompFilter}>Обновить</ScifiButton>
      </div>

      <ScifiPanel title="Рынок" className="pane comp-pane">
        <div class="table-wrap">
          <table class="scifi-table">
            <thead>
              <tr>
                <th>Наименование</th>
                <th class="num">Цена прод.</th>
                <th class="num">Кол.прод.</th>
                <th>Звезда прод.</th>
                <th class="num">Цена пок.</th>
                <th class="num">Кол.пок.</th>
                <th>Звезда пок.</th>
              </tr>
            </thead>
            <tbody>
              {#each compItems as row, i}
                <tr
                  class:active-row={compSelected === i}
                  style={flashColor(row.bgColor) ? `background:${flashColor(row.bgColor)}` : ''}
                  on:click={() => onCompRow(i)}
                >
                  <td>{row.name}</td>
                  <td class="num">{row.sellPrice}</td>
                  <td class="num">{row.sellCnt}</td>
                  <td>{row.sellStar}</td>
                  <td class="num">{row.buyPrice}</td>
                  <td class="num">{row.buyCnt}</td>
                  <td>{row.buyStar}</td>
                </tr>
              {:else}
                <tr><td colspan="7" class="empty">Нет предложений</td></tr>
              {/each}
            </tbody>
          </table>
        </div>
      </ScifiPanel>

      <div class="comp-actions">
        {#if sellerLogin}
          <ScifiButton variant="primary" on:click={() => openProfile(sellerLogin)}>
            Продавец: {sellerLogin}
          </ScifiButton>
        {/if}
        {#if buyerLogin}
          <ScifiButton variant="ghost" on:click={() => openProfile(buyerLogin)}>
            Покупатель: {buyerLogin}
          </ScifiButton>
        {/if}
      </div>
    </div>
  {:else if activeTab === 'bay'}
    <div class="dual-layout">
      <ScifiPanel title="Корабли" className="pane">
        <div class="table-wrap">
          <table class="scifi-table">
            <thead>
              <tr>
                <th>Наименование</th>
                <th>Расположение</th>
                <th class="num">Объем</th>
              </tr>
            </thead>
            <tbody>
              {#each bayShips as ship, i}
                <tr class:active-row={bayShipIdx === i} on:click={() => onBayShip(i)}>
                  <td>{ship.name}</td>
                  <td>{ship.place}</td>
                  <td class="num">{ship.cargo}</td>
                </tr>
              {:else}
                <tr><td colspan="3" class="empty">Нет кораблей у торговых станций</td></tr>
              {/each}
            </tbody>
          </table>
        </div>
      </ScifiPanel>

      <ScifiPanel title="Товары на станции" className="pane">
        <div class="table-wrap">
          <table class="scifi-table">
            <thead>
              <tr>
                <th>Наименование</th>
                <th class="num">На корабле</th>
                <th class="num">В наличии</th>
                <th class="num">Цена прод.</th>
              </tr>
            </thead>
            <tbody>
              {#each bayWare as item, i}
                <tr
                  class:active-row={bayWareIdx === i}
                  style={flashColor(item.bgColor) ? `background:${flashColor(item.bgColor)}` : ''}
                  on:click={() => onBayWare(i)}
                >
                  <td>{item.name}</td>
                  <td class="num">{item.shipCnt}</td>
                  <td class="num">{item.offerCnt}</td>
                  <td class="num">{item.price}</td>
                </tr>
              {:else}
                <tr><td colspan="4" class="empty">Выберите корабль</td></tr>
              {/each}
            </tbody>
          </table>
        </div>
        <div class="action-bar">
          <span class="item-title">{bayTitle || '—'}</span>
          <label class="qty-wrap">
            <span>Кол-во</span>
            <input
              class="scifi-input glow-{bayQtyGlow}"
              type="text"
              bind:value={bayQty}
              on:input={recountBay}
              disabled={busy || bayWareIdx < 0}
            />
          </label>
          <span class="sum glow-{baySumGlow}">Сумма: {baySum || '—'}</span>
          <div class="action-btns">
            {#if bayBtn}
              <ScifiButton variant="primary" disabled={busy} on:click={() => doBay(parseInt(bayQty, 10))}>
                Купить
              </ScifiButton>
            {/if}
            {#if bayBtnAll}
              <ScifiButton
                variant="ghost"
                disabled={busy}
                on:click={() => doBay(parseInt(bayWare[bayWareIdx]?.offerCnt, 10) || 0)}
              >
                Купить всё
              </ScifiButton>
            {/if}
          </div>
        </div>
      </ScifiPanel>
    </div>
  {:else if activeTab === 'sell'}
    <div class="dual-layout">
      <ScifiPanel title="Корабли" className="pane">
        <div class="table-wrap">
          <table class="scifi-table">
            <thead>
              <tr>
                <th>Наименование</th>
                <th>Расположение</th>
                <th class="num">Объем</th>
              </tr>
            </thead>
            <tbody>
              {#each sellShips as ship, i}
                <tr class:active-row={sellShipIdx === i} on:click={() => onSellShip(i)}>
                  <td>{ship.name}</td>
                  <td>{ship.place}</td>
                  <td class="num">{ship.cargo}</td>
                </tr>
              {:else}
                <tr><td colspan="3" class="empty">Нет кораблей для продажи</td></tr>
              {/each}
            </tbody>
          </table>
        </div>
      </ScifiPanel>

      <ScifiPanel title="Спрос станции" className="pane">
        <div class="table-wrap">
          <table class="scifi-table">
            <thead>
              <tr>
                <th>Наименование</th>
                <th class="num">На корабле</th>
                <th class="num">Требуется</th>
                <th class="num">Цена пок.</th>
              </tr>
            </thead>
            <tbody>
              {#each sellWare as item, i}
                <tr
                  class:active-row={sellWareIdx === i}
                  style={flashColor(item.bgColor) ? `background:${flashColor(item.bgColor)}` : ''}
                  on:click={() => onSellWare(i)}
                >
                  <td>{item.name}</td>
                  <td class="num">{item.shipCnt}</td>
                  <td class="num">{item.demandCnt}</td>
                  <td class="num">{item.price}</td>
                </tr>
              {:else}
                <tr><td colspan="4" class="empty">Выберите корабль</td></tr>
              {/each}
            </tbody>
          </table>
        </div>
        <div class="action-bar">
          <span class="item-title">{sellTitle || '—'}</span>
          <label class="qty-wrap">
            <span>Кол-во</span>
            <input
              class="scifi-input glow-{sellQtyGlow}"
              type="text"
              bind:value={sellQty}
              on:input={recountSell}
              disabled={busy || sellWareIdx < 0}
            />
          </label>
          <span class="sum glow-{sellSumGlow}">Сумма: {sellSum || '—'}</span>
          <div class="action-btns">
            {#if sellBtn}
              <ScifiButton variant="primary" disabled={busy} on:click={() => doSell(parseInt(sellQty, 10))}>
                Продать
              </ScifiButton>
            {/if}
            {#if sellBtnAll}
              <ScifiButton
                variant="ghost"
                disabled={busy}
                on:click={() => doSell(parseInt(sellWare[sellWareIdx]?.shipCnt, 10) || 0)}
              >
                Продать всё
              </ScifiButton>
            {/if}
          </div>
        </div>
      </ScifiPanel>
    </div>
  {:else if activeTab === 'conf'}
    <div class="dual-layout">
      <ScifiPanel title="Каталог" className="pane">
        <div class="table-wrap">
          <table class="scifi-table">
            <thead>
              <tr>
                <th>Наименование</th>
              </tr>
            </thead>
            <tbody>
              {#each confItems as item, i}
                <tr
                  class:active-row={confIdx === i}
                  style={flashColor(item.bgColor) ? `background:${flashColor(item.bgColor)}` : ''}
                  on:click={() => onConfRow(i)}
                >
                  <td>{item.name}</td>
                </tr>
              {:else}
                <tr><td class="empty">Каталог пуст</td></tr>
              {/each}
            </tbody>
          </table>
        </div>
      </ScifiPanel>

      <ScifiPanel title="Описание" className="pane">
        <div class="conf-desc">{@html confDesc}</div>
        <div class="action-bar">
          <span class="item-title">{confIdx >= 0 ? confItems[confIdx]?.name || '—' : '—'}</span>
          <label class="qty-wrap">
            <span>Кол-во</span>
            <input
              class="scifi-input"
              type="text"
              bind:value={confQty}
              on:input={recountConf}
              disabled={busy || confIdx < 0}
            />
          </label>
          <span class="sum">Цена: {confCreditSum || '—'}</span>
          <span class="sum">Цена conf: {confConfSum || '—'}</span>
          <div class="action-btns">
            {#if confBtnMoney}
              <ScifiButton variant="primary" disabled={busy} on:click={() => doConfBuy(1)}>
                За кредиты
              </ScifiButton>
            {/if}
            {#if confBtnConf}
              <ScifiButton variant="ghost" disabled={busy} on:click={() => doConfBuy(2)}>
                За conf
              </ScifiButton>
            {/if}
          </div>
        </div>
      </ScifiPanel>
    </div>
  {/if}
</div>

<style>
  .trade-screen {
    display: flex;
    flex-direction: column;
    gap: 10px;
    min-height: 0;
    height: 100%;
  }

  .trade-error {
    margin: 0;
    color: var(--accent-sell);
    font-size: 0.85rem;
  }

  .comp-layout,
  .dual-layout {
    display: flex;
    flex-direction: column;
    gap: 10px;
    min-height: 0;
    flex: 1;
  }

  .dual-layout {
    display: grid;
    grid-template-columns: minmax(0, 1fr) minmax(0, 1.3fr);
    grid-template-rows: minmax(0, 1fr);
  }

  .filter-bar {
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    gap: 10px;
  }

  .filter-bar :global(.class-select) {
    min-width: 160px;
  }

  .min-wrap,
  .qty-wrap {
    display: flex;
    align-items: center;
    gap: 8px;
    color: var(--text-muted);
    font-size: 0.85rem;
  }

  .min-wrap :global(.scifi-input),
  .qty-wrap :global(.scifi-input) {
    width: 90px;
  }

  .comp-layout :global(.comp-pane),
  .dual-layout :global(.pane) {
    min-height: 0;
    display: flex;
    flex-direction: column;
    flex: 1;
  }

  .comp-layout :global(.comp-pane .panel-content),
  .dual-layout :global(.pane .panel-content) {
    min-height: 0;
    flex: 1;
    display: flex;
    flex-direction: column;
    padding: 0;
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

  .comp-actions,
  .action-btns {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
  }

  .action-bar {
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    gap: 12px;
    padding: 10px 12px;
    border-top: 1px solid var(--border-light);
  }

  .item-title {
    color: var(--neon-cyan);
    font-size: 0.9rem;
    min-width: 100px;
  }

  .sum {
    color: var(--text-main);
    font-size: 0.9rem;
  }

  .sum.glow-fail {
    color: var(--accent-sell);
  }

  .sum.glow-ok {
    color: var(--accent-buy);
  }

  .conf-desc {
    padding: 10px 12px;
    overflow: auto;
    min-height: 80px;
    flex: 1;
    font-size: 0.9rem;
    line-height: 1.45;
    color: var(--text-main);
  }

  .conf-desc :global(a) {
    color: inherit;
  }

  .action-bar .action-btns {
    margin-left: auto;
  }

  @media (max-width: 500px) {
    .dual-layout {
      grid-template-columns: 1fr;
      grid-template-rows: none;
    }

    .action-bar .action-btns {
      margin-left: 0;
    }
  }
</style>
