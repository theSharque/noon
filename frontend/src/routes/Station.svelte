<script>
  import { onMount } from 'svelte';
  import {
    getNoonConfig,
    getUserInfo,
    loadStationGoods,
    loadStationLots,
    loadStationTradeInfo,
    saveStationTrade,
  } from '../lib/api.js';
  import ScifiPanel from '../lib/ui/ScifiPanel.svelte';
  import ScifiButton from '../lib/ui/ScifiButton.svelte';
  import ScifiSelect from '../lib/ui/ScifiSelect.svelte';

  const IMG = '/app/img/booklist';
  const CLASS_FILTERS = [
    { value: '0', label: 'Все' },
    { value: '1', label: 'Ресурсы' },
    { value: '5', label: 'Ископаемые' },
    { value: '2', label: 'Детали' },
    { value: '6', label: 'Чертежи' },
    { value: '7', label: 'Макеты' },
    { value: '9', label: 'Корабли' },
  ];

  const SAVE_ERR = {
    '1': 'Станция недоступна',
    '2': 'Только владелец может менять ордера',
    '3': 'Недостаточно товара на складе',
    '4': 'Недостаточно кредитов',
  };

  export let initialGoods = null;
  export let starName = '';
  export let planetName = '';

  let busy = false;
  let errorText = '';

  let filterRf = '1';
  let lots = [];
  let lotIdx = -1;
  let goods = [];
  let goodsValue = '';

  let money = '';
  let maxcnt = '0';
  let canbay = false;
  let cansell = false;

  let bayMin = '';
  let bayAvg = '';
  let bayMax = '';
  let bayCnt = '0';
  let bayPrice = '0';
  let baySum = '';
  let bayCntGlow = '';
  let bayPriceGlow = '';

  let sellMin = '';
  let sellAvg = '';
  let sellMax = '';
  let sellCnt = '0';
  let sellPrice = '0';
  let sellSum = '';
  let sellCntGlow = '';
  let sellPriceGlow = '';

  let showSave = false;

  $: goodsLabel = goods.find((g) => g.value === String(goodsValue))?.label || '';
  $: lotsTitle = starName && planetName
    ? `Сделки на станции: ${starName} - ${planetName}`
    : starName
      ? `Сделки на станции: ${starName}`
      : 'Сделки на станции';

  let scratchAudio;
  let buzzAudio;

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

  function isFlashInt(text) {
    const n = Number(text);
    if (!Number.isFinite(n) || String(text).trim() === '') return false;
    return String(text) === String(Math.round(n));
  }

  function isFlashNumber(text) {
    const s = String(text).trim();
    if (!/^\d+(\.\d+)?$/.test(s)) return false;
    return Number.isFinite(Number(s));
  }

  function restrictPrice(v) {
    return String(v ?? '').replace(/[^0-9.]/g, '');
  }

  function restrictCount(v) {
    return String(v ?? '').replace(/[^0-9]/g, '');
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

  function clearDetail() {
    money = '';
    maxcnt = '0';
    canbay = false;
    cansell = false;
    bayMin = '';
    bayAvg = '';
    bayMax = '';
    bayCnt = '0';
    bayPrice = '0';
    baySum = '';
    bayCntGlow = '';
    bayPriceGlow = '';
    sellMin = '';
    sellAvg = '';
    sellMax = '';
    sellCnt = '0';
    sellPrice = '0';
    sellSum = '';
    sellCntGlow = '';
    sellPriceGlow = '';
    showSave = false;
  }

  function recountForms() {
    let bayOk = !canbay;
    let sellOk = !cansell;

    if (canbay) {
      const cntOk = isFlashInt(bayCnt);
      const priceOk = isFlashNumber(bayPrice);
      bayCntGlow = cntOk ? 'ok' : 'fail';
      bayPriceGlow = priceOk ? 'ok' : 'fail';
      if (cntOk && priceOk) {
        const sum = Math.round(num(bayCnt) * num(bayPrice) * 100) / 100;
        baySum = String(sum);
        if (sum > num(money)) {
          bayOk = false;
          bayCntGlow = 'fail';
          bayPriceGlow = 'fail';
        } else {
          bayOk = true;
        }
      } else {
        baySum = '';
        bayOk = false;
      }
    }

    if (cansell) {
      const cntOk = isFlashInt(sellCnt) && num(sellCnt) <= num(maxcnt);
      const priceOk = isFlashNumber(sellPrice);
      sellCntGlow = cntOk ? 'ok' : 'fail';
      sellPriceGlow = priceOk ? 'ok' : 'fail';
      if (cntOk && priceOk) {
        sellSum = String(Math.round(num(sellCnt) * num(sellPrice) * 100) / 100);
        sellOk = true;
      } else {
        sellSum = '';
        sellOk = false;
      }
    }

    showSave = (canbay || cansell) && bayOk && sellOk;
  }

  async function refreshLots() {
    const data = await loadStationLots(filterRf);
    lots = data.lots || [];
    if (goodsValue) {
      const idx = lots.findIndex((r) => String(r.id) === String(goodsValue));
      lotIdx = idx;
    } else {
      lotIdx = -1;
    }
  }

  async function refreshGoods() {
    const data = await loadStationGoods(filterRf);
    goods = (data.items || []).map((g) => ({
      value: String(g.id),
      label: g.name || String(g.id),
    }));
    if (!goods.length) {
      goodsValue = '';
      return;
    }
    if (!goods.some((g) => g.value === String(goodsValue))) {
      goodsValue = goods[0].value;
    }
  }

  async function loadDetail(oid) {
    if (!oid) {
      clearDetail();
      return;
    }
    const data = await loadStationTradeInfo(oid);
    if (data.err !== '0') {
      clearDetail();
      errorText = 'Не удалось загрузить товар';
      return;
    }
    money = data.money || '';
    maxcnt = data.maxcnt || '0';
    canbay = data.canbay;
    cansell = data.cansell;
    bayMin = data.i_min || '';
    bayAvg = data.i_avg || '';
    bayMax = data.i_max || '';
    bayCnt = String(data.i_cnt ?? '0');
    bayPrice = String(data.i_price ?? '0');
    sellMin = data.o_min || '';
    sellAvg = data.o_avg || '';
    sellMax = data.o_max || '';
    sellCnt = String(data.o_cnt ?? '0');
    sellPrice = String(data.o_price ?? '0');
    recountForms();
  }

  async function onFilterChange() {
    if (busy) return;
    busy = true;
    errorText = '';
    goodsValue = '';
    lotIdx = -1;
    clearDetail();
    try {
      await Promise.all([refreshLots(), refreshGoods()]);
      if (goodsValue) {
        playSelect();
        await loadDetail(goodsValue);
        const idx = lots.findIndex((r) => String(r.id) === String(goodsValue));
        lotIdx = idx;
      }
    } finally {
      busy = false;
    }
  }

  async function onGoodsChange() {
    if (busy || !goodsValue) return;
    busy = true;
    errorText = '';
    playSelect();
    try {
      const idx = lots.findIndex((r) => String(r.id) === String(goodsValue));
      lotIdx = idx;
      await loadDetail(goodsValue);
    } finally {
      busy = false;
    }
  }

  async function onLotRow(idx) {
    if (busy || idx < 0 || idx >= lots.length) return;
    const row = lots[idx];
    lotIdx = idx;
    goodsValue = String(row.id);
    playSelect();
    busy = true;
    errorText = '';
    try {
      if (filterRf !== '0') {
        await refreshGoods();
        if (!goods.some((g) => g.value === String(row.id))) {
          goods = [{ value: String(row.id), label: row.name }, ...goods];
        }
        goodsValue = String(row.id);
      }
      await loadDetail(row.id);
    } finally {
      busy = false;
    }
  }

  async function onSave() {
    if (!showSave || !goodsValue || busy) return;
    busy = true;
    errorText = '';
    playBuzz();
    try {
      const res = await saveStationTrade({
        oid: goodsValue,
        iprice: canbay ? bayPrice : '0',
        icnt: canbay ? bayCnt : '0',
        oprice: cansell ? sellPrice : '0',
        ocnt: cansell ? sellCnt : '0',
      });
      if (res.err !== '0') {
        errorText = SAVE_ERR[res.err] || `Ошибка сохранения (${res.err})`;
      }
      await refreshLots();
      await loadDetail(goodsValue);
      const idx = lots.findIndex((r) => String(r.id) === String(goodsValue));
      lotIdx = idx;
    } finally {
      busy = false;
    }
  }

  onMount(() => {
    scratchAudio = new Audio(`${IMG}/sounds/scratch.mp3`);
    buzzAudio = new Audio(`${IMG}/sounds/buzz.mp3`);
    (async () => {
      if (!starName && !planetName) {
        const info = await getUserInfo();
        starName = info.sname || '';
        planetName = info.pname || '';
      }
      if (initialGoods?.items?.length) {
        goods = initialGoods.items.map((g) => ({
          value: String(g.id),
          label: g.name || String(g.id),
        }));
        if (goods.length) goodsValue = goods[0].value;
      } else {
        await refreshGoods();
      }
      await refreshLots();
      if (goodsValue) {
        await loadDetail(goodsValue);
        const idx = lots.findIndex((r) => String(r.id) === String(goodsValue));
        lotIdx = idx;
      }
    })();
  });
</script>

<div class="station-screen">
  <div class="station-grid">
    <ScifiPanel title="Сделка" className="pane detail-pane">
      <label class="field">
        <span>Фильтр:</span>
        <ScifiSelect
          className="class-select"
          bind:value={filterRf}
          options={CLASS_FILTERS}
          on:change={onFilterChange}
          disabled={busy}
        />
      </label>
      <label class="field">
        <span>Продукт:</span>
        <ScifiSelect
          className="goods-select"
          bind:value={goodsValue}
          options={goods}
          on:change={onGoodsChange}
          disabled={busy || !goods.length}
        />
      </label>

      <div class="order-block" class:is-disabled={!canbay}>
        <h3>Покупка</h3>
        <div class="stat-line">мин {bayMin || '—'} · сред {bayAvg || '—'} · макс {bayMax || '—'}</div>
        <div class="form-row">
          <label class="field">
            <span>Цена:</span>
            <input
              class="scifi-input"
              class:glow-ok={canbay && bayPriceGlow === 'ok'}
              class:glow-fail={canbay && bayPriceGlow === 'fail'}
              type="text"
              value={bayPrice}
              disabled={busy || !canbay}
              on:input={(e) => {
                bayPrice = restrictPrice(e.currentTarget.value);
                recountForms();
              }}
            />
          </label>
          <label class="field">
            <span>Количество:</span>
            <input
              class="scifi-input"
              class:glow-ok={canbay && bayCntGlow === 'ok'}
              class:glow-fail={canbay && bayCntGlow === 'fail'}
              type="text"
              value={bayCnt}
              disabled={busy || !canbay}
              on:input={(e) => {
                bayCnt = restrictCount(e.currentTarget.value);
                recountForms();
              }}
            />
          </label>
          <div class="sum-box sum-row">
            <span>Сумма покупки: {baySum || '—'}</span>
            <span>Кредиты: {money || '0'}</span>
          </div>
        </div>
      </div>

      <div class="order-block" class:is-disabled={!cansell}>
        <h3>Продажа</h3>
        <div class="stat-line">мин {sellMin || '—'} · сред {sellAvg || '—'} · макс {sellMax || '—'}</div>
        <div class="form-row">
          <label class="field">
            <span>Цена:</span>
            <input
              class="scifi-input"
              class:glow-ok={cansell && sellPriceGlow === 'ok'}
              class:glow-fail={cansell && sellPriceGlow === 'fail'}
              type="text"
              value={sellPrice}
              disabled={busy || !cansell}
              on:input={(e) => {
                sellPrice = restrictPrice(e.currentTarget.value);
                recountForms();
              }}
            />
          </label>
          <label class="field">
            <span>Количество:</span>
            <input
              class="scifi-input"
              class:glow-ok={cansell && sellCntGlow === 'ok'}
              class:glow-fail={cansell && sellCntGlow === 'fail'}
              type="text"
              value={sellCnt}
              disabled={busy || !cansell}
              on:input={(e) => {
                sellCnt = restrictCount(e.currentTarget.value);
                recountForms();
              }}
            />
          </label>
          <div class="sum-box sum-row">
            <span>Сумма продажи: {sellSum || '—'}</span>
            <span>{goodsLabel || 'Товар'}: {maxcnt || '0'}</span>
          </div>
        </div>
      </div>

      <div class="save-row">
        <ScifiButton variant="primary" disabled={busy || !showSave} on:click={onSave}>Сохранить</ScifiButton>
      </div>
      {#if errorText}
        <p class="place-error">{errorText}</p>
      {/if}
    </ScifiPanel>

    <ScifiPanel title={lotsTitle} className="pane lots-pane">
      <div class="table-wrap">
        <table class="scifi-table">
          <thead>
            <tr>
              <th>Наименование</th>
              <th class="num">Покуп.</th>
              <th class="num">кол.</th>
              <th class="num">Прод.</th>
              <th class="num">кол.</th>
              <th class="num">мин.</th>
              <th class="num">сред.</th>
              <th class="num">макс.</th>
            </tr>
          </thead>
          <tbody>
            {#each lots as row, i}
              <tr
                class:active-row={lotIdx === i}
                style={flashColor(row.bgColor) ? `background:${flashColor(row.bgColor)}` : ''}
                on:click={() => onLotRow(i)}
              >
                <td>{row.name}</td>
                <td class="num">{row.buyPrice}</td>
                <td class="num">{row.buyCnt}</td>
                <td class="num">{row.sellPrice}</td>
                <td class="num">{row.sellCnt}</td>
                <td class="num">{row.min}</td>
                <td class="num">{row.avg}</td>
                <td class="num">{row.max}</td>
              </tr>
            {:else}
              <tr><td colspan="8" class="empty">Нет сделок</td></tr>
            {/each}
          </tbody>
        </table>
      </div>
    </ScifiPanel>
  </div>
</div>

<style>
  .station-screen {
    display: flex;
    flex-direction: column;
    gap: 10px;
    min-height: 0;
    height: 100%;
  }

  .field {
    display: flex;
    flex-direction: column;
    gap: 4px;
    font-size: 0.8rem;
    color: var(--text-muted);
  }

  .station-grid {
    display: grid;
    grid-template-columns: minmax(280px, 0.9fr) minmax(0, 1.4fr);
    gap: 12px;
    min-height: 0;
    flex: 1;
  }

  .pane :global(.panel-content) {
    display: flex;
    flex-direction: column;
    gap: 10px;
    min-height: 0;
  }

  .lots-pane :global(.panel-content) {
    padding: 0;
  }

  .table-wrap {
    overflow: auto;
    min-height: 0;
    flex: 1;
  }

  .scifi-table th.num,
  .scifi-table td.num {
    text-align: right;
    font-variant-numeric: tabular-nums;
  }

  .scifi-table .empty {
    text-align: center;
    color: var(--text-muted);
    padding: 16px;
  }

  .order-block {
    border: 1px solid var(--border-light);
    border-radius: var(--radius-panel);
    padding: 10px 12px;
    margin-top: 12px;
    background: rgba(0, 229, 255, 0.03);
    box-shadow: inset 0 0 18px rgba(0, 229, 255, 0.04);
  }

  .order-block.is-disabled {
    opacity: 0.45;
    border-color: rgba(122, 155, 176, 0.35);
    background: rgba(8, 18, 36, 0.35);
    box-shadow: none;
  }

  .order-block.is-disabled h3 {
    color: var(--text-muted);
  }

  .order-block h3 {
    margin: 0 0 6px;
    font-size: 0.95rem;
    color: var(--neon-cyan);
    font-weight: 600;
  }

  .stat-line {
    font-size: 0.75rem;
    color: var(--text-muted);
    margin-bottom: 8px;
  }

  .form-row {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 8px;
  }

  .sum-box {
    grid-column: 1 / -1;
    font-family: var(--font-mono);
    font-size: 0.85rem;
    color: var(--text-main);
  }

  .sum-row {
    display: flex;
    flex-wrap: wrap;
    justify-content: space-between;
    gap: 12px;
  }

  .glow-ok {
    box-shadow: 0 0 8px rgba(0, 255, 255, 0.35);
    border-color: rgba(0, 255, 255, 0.55);
  }

  .glow-fail {
    box-shadow: 0 0 8px rgba(255, 60, 60, 0.4);
    border-color: rgba(255, 80, 80, 0.7);
  }

  .save-row {
    display: flex;
    gap: 8px;
    margin-top: 14px;
    padding-top: 2px;
  }

  .place-error {
    margin: 4px 0 0;
    color: #ff6a6a;
    font-size: 0.85rem;
  }

  @media (max-width: 500px) {
    .station-grid {
      grid-template-columns: 1fr;
    }
  }
</style>
