<script>
  import { createEventDispatcher, onMount } from 'svelte';
  import { push } from 'svelte-spa-router';
  import {
    fetchActionUrl,
    getNoonConfig,
    loadPlanetActionDetail,
  } from '../api.js';
  import ScifiButton from './ScifiButton.svelte';
  import ScifiPanel from './ScifiPanel.svelte';
  import ScifiSelect from './ScifiSelect.svelte';
  import ScifiTabs from './ScifiTabs.svelte';

  export let coordLabel = '';
  export let loadInfo = async () => ({ err: '1' });
  export let loadUse = async () => ({ err: '1' });
  export let loadUpgrade = async () => ({ err: '1' });
  export let destroyTile = async () => ({ err: '1' });
  export let frameActions = { use: false, stop: false, upgrade: false };

  const dispatch = createEventDispatcher();
  const IMG = '/app/img/booklist';
  const TABS = [
    { id: 'info', label: 'Инфо' },
    { id: 'use', label: 'Действие' },
    { id: 'upgrade', label: 'Улучшение' },
  ];

  let activeTab = 'info';
  let busy = false;
  let errorText = '';
  let showSure = false;

  let infoHtml = '';
  let descHtml = '';
  let canDestroy = false;

  let useDetail = '';
  let useCombo = [];
  let useComboValue = '';
  let useCbHeader = '';
  let useBusyStop = false;
  let useClickUrl = '';
  let useShowStart = false;
  let useShowRobot = false;
  let useNsMax = null;
  let useCount = '1';
  let useCountGlow = '';
  let useDgHeader = '';
  let useCols = [];
  let useRows = [];

  let upgTitle = '';
  let upgLevel = '';
  let upgDesc = '';
  let upgHeader = '';
  let upgOnClick = '';
  let upgShowBtn = false;
  let upgCols = [];
  let upgRows = [];

  let scratchAudio;
  let buzzAudio;

  $: frameActions = {
    use: Boolean(useShowStart && useNsMax == null && !useBusyStop),
    stop: Boolean(useBusyStop),
    upgrade: Boolean(upgShowBtn),
  };

  export function playSelect() {
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

  function clearPanels() {
    infoHtml = '<i>Идёт загрузка…</i>';
    descHtml = '';
    canDestroy = false;
    useDetail = '<i>Идёт загрузка…</i>';
    useCombo = [];
    useComboValue = '';
    useCbHeader = '';
    useBusyStop = false;
    useClickUrl = '';
    useShowStart = false;
    useShowRobot = false;
    useNsMax = null;
    useCount = '1';
    useCountGlow = '';
    useDgHeader = '';
    useCols = [];
    useRows = [];
    upgTitle = '<i>Идёт загрузка…</i>';
    upgLevel = '';
    upgDesc = '';
    upgHeader = '';
    upgOnClick = '';
    upgShowBtn = false;
    upgCols = [];
    upgRows = [];
  }

  export async function refresh() {
    clearPanels();
    const [info, use, upg] = await Promise.all([loadInfo(), loadUse(), loadUpgrade()]);

    if (info.err === '0' || info.err === '-1') {
      infoHtml = info.info || '';
      descHtml = info.desc || '';
      canDestroy = Boolean(info.destroy);
    }

    useDetail = use.detail || '';
    if (use.busyStop) {
      useBusyStop = true;
      useClickUrl = use.btOnClick || '';
    }
    useCbHeader = use.cbHeader || '';
    useCombo = (use.combo || []).map((c) => ({
      value: c.value,
      label: c.label,
    }));
    if (useCombo.length) {
      useComboValue = useCombo[0].value;
      await loadUseDetail(useComboValue);
    }

    upgTitle = upg.title || '';
    upgLevel = upg.level || '';
    upgDesc = upg.desc || '';
    upgHeader = upg.header || '';
    upgOnClick = upg.upgOnClick || '';
    upgShowBtn = Boolean(upg.btLabel);
    upgCols = upg.cols || [];
    upgRows = upg.items || [];
  }

  async function loadUseDetail(url) {
    useShowStart = false;
    useShowRobot = false;
    useBusyStop = false;
    useNsMax = null;
    useDgHeader = '<i>Идёт загрузка…</i>';
    useCols = [];
    useRows = [];
    if (!url) return;
    const data = await loadPlanetActionDetail(url);
    if (data.btLabel !== undefined) {
      useShowStart = true;
      useClickUrl = data.btOnClick || '';
      if (data.btRobot > 0) useShowRobot = true;
    }
    if (data.nsMax != null) {
      useNsMax = data.nsMax;
      useCount = data.nsVal || '1';
      validateCount();
    }
    useDgHeader = data.dgHeader || '';
    useCols = data.cols || [];
    useRows = data.items || [];
  }

  function validateCount() {
    if (useNsMax == null) {
      useCountGlow = '';
      return;
    }
    const n = Number(useCount);
    const ok = Number.isFinite(n) && String(useCount) === String(Math.round(n)) && n >= 1 && n <= useNsMax;
    useCountGlow = ok ? 'ok' : 'fail';
  }

  function onTab(e) {
    activeTab = e.detail;
    playSelect();
  }

  async function onComboChange() {
    if (!useComboValue) return;
    playSelect();
    await loadUseDetail(useComboValue);
  }

  function isPlaceChangeUrl(url) {
    return /(?:[?&]|%26)id=225(?:&|%26|$)/.test(String(url || ''))
      || /page\.php\?id=225(?:&|%26|$)/.test(String(url || ''));
  }

  export async function runAction(kind) {
    if (busy) return;
    let url = useClickUrl;
    if (kind === 'upgrade') url = upgOnClick;
    if (!url) return;
    if (kind === 'use' || kind === 'stop') {
      if (useNsMax != null) {
        validateCount();
        if (useCountGlow === 'fail') return;
        url = `${url}${useCount}`;
      } else {
        url = `${url}&invis`;
      }
    }
    if (kind === 'robot') url = `${useClickUrl}&robot=1`;
    busy = true;
    errorText = '';
    playBuzz();
    try {
      await fetchActionUrl(url);
      if (isPlaceChangeUrl(url)) {
        dispatch('placeChanged');
        return;
      }
      dispatch('changed');
      await refresh();
    } finally {
      busy = false;
    }
  }

  async function onDestroy() {
    if (busy) return;
    busy = true;
    showSure = false;
    playBuzz();
    try {
      await destroyTile();
      dispatch('changed');
      await refresh();
    } finally {
      busy = false;
    }
  }

  function onHtmlClick(e) {
    const a = e.target.closest?.('a');
    if (!a) return;
    const href = a.getAttribute('href') || '';
    const m = href.match(/page\.php\?id=6(?:%26|&)itm=([^&'"]+)/i);
    if (m) {
      e.preventDefault();
      push(`/misc?itm=${encodeURIComponent(decodeURIComponent(m[1]))}`);
    }
  }

  onMount(() => {
    scratchAudio = new Audio(`${IMG}/sounds/scratch.mp3`);
    buzzAudio = new Audio(`${IMG}/sounds/buzz.mp3`);
  });
</script>

<aside class="place-side">
  <ScifiPanel className="pane place-pane">
    <div slot="header" class="pane-head">
      <ScifiTabs tabs={TABS} active={activeTab} on:change={onTab} />
      <div class="pane-title">
        {#if activeTab === 'info'}
          {coordLabel}
        {:else if activeTab === 'use'}
          Действие
        {:else}
          Улучшение
        {/if}
      </div>
    </div>

    {#if activeTab === 'info'}
      <div class="html-block" role="presentation" on:click={onHtmlClick}>{@html infoHtml}</div>
      <div class="html-block muted-html" role="presentation" on:click={onHtmlClick}>{@html descHtml}</div>
      {#if canDestroy}
        <div class="cta-row">
          <ScifiButton variant="danger" disabled={busy} on:click={() => (showSure = true)}>Снести</ScifiButton>
        </div>
      {/if}
    {:else if activeTab === 'use'}
      <div class="html-block" role="presentation" on:click={onHtmlClick}>{@html useDetail}</div>
      {#if useCbHeader}
        <p class="section-label">{@html useCbHeader}</p>
      {/if}
      {#if useCombo.length}
        <ScifiSelect
          bind:value={useComboValue}
          options={useCombo}
          on:change={onComboChange}
          disabled={busy}
        />
      {/if}
      {#if useDgHeader}
        <p class="section-label">{@html useDgHeader}</p>
      {/if}
      {#if useRows.length}
        <div class="table-wrap">
          <table class="scifi-table">
            <thead>
              <tr>
                {#each useCols as col}
                  <th>{col}</th>
                {/each}
              </tr>
            </thead>
            <tbody>
              {#each useRows as row}
                <tr>
                  {#each useCols as col}
                    <td>{row[col]}</td>
                  {/each}
                </tr>
              {/each}
            </tbody>
          </table>
        </div>
      {/if}
      {#if useNsMax != null}
        <label class="field">
          <span>Количество (1…{useNsMax}):</span>
          <div class="count-row">
            <button type="button" class="cnt-btn" on:click={() => { useCount = '1'; validateCount(); }}>«</button>
            <button type="button" class="cnt-btn" on:click={() => { useCount = String(Math.max(1, Number(useCount) - 1)); validateCount(); }}>−</button>
            <input
              class="scifi-input"
              class:glow-ok={useCountGlow === 'ok'}
              class:glow-fail={useCountGlow === 'fail'}
              type="text"
              bind:value={useCount}
              on:input={validateCount}
            />
            <button type="button" class="cnt-btn" on:click={() => { useCount = String(Math.min(useNsMax, Number(useCount) + 1)); validateCount(); }}>+</button>
            <button type="button" class="cnt-btn" on:click={() => { useCount = String(useNsMax); validateCount(); }}>»</button>
          </div>
        </label>
      {/if}
      <div class="cta-row">
        {#if useBusyStop}
          <ScifiButton variant="warn" disabled={busy} on:click={() => runAction('stop')}>Остановить</ScifiButton>
        {/if}
        {#if useShowStart}
          <ScifiButton variant="primary" disabled={busy || useCountGlow === 'fail'} on:click={() => runAction('use')}>Запустить</ScifiButton>
        {/if}
        {#if useShowRobot}
          <ScifiButton variant="ghost" disabled={busy} on:click={() => runAction('robot')}>Робот</ScifiButton>
        {/if}
      </div>
    {:else}
      <div class="html-block" role="presentation" on:click={onHtmlClick}>{@html upgTitle}</div>
      {#if upgLevel}
        <div class="html-block">{@html upgLevel}</div>
        <div class="html-block muted-html" role="presentation" on:click={onHtmlClick}>{@html upgDesc}</div>
      {/if}
      {#if upgHeader}
        <p class="section-label">{@html upgHeader}</p>
      {/if}
      {#if upgRows.length}
        <div class="table-wrap">
          <table class="scifi-table">
            <thead>
              <tr>
                {#each upgCols as col}
                  <th>{col}</th>
                {/each}
              </tr>
            </thead>
            <tbody>
              {#each upgRows as row}
                <tr>
                  {#each upgCols as col}
                    <td>{row[col]}</td>
                  {/each}
                </tr>
              {/each}
            </tbody>
          </table>
        </div>
      {/if}
      {#if upgShowBtn}
        <div class="cta-row">
          <ScifiButton variant="primary" disabled={busy} on:click={() => runAction('upgrade')}>Улучшить</ScifiButton>
        </div>
      {/if}
    {/if}

    {#if errorText}
      <p class="err">{errorText}</p>
    {/if}
  </ScifiPanel>
</aside>

{#if showSure}
  <div class="modal-backdrop" on:click={() => (showSure = false)} role="presentation">
    <div class="modal scifi-panel" role="dialog" aria-modal="true">
      <div class="panel-header">Снос</div>
      <div class="panel-content">
        <p>Вы уверены, что хотите снести эту постройку? Только половина затраченных ресурсов вернётся после сноса.</p>
        <div class="cta-row">
          <ScifiButton variant="danger" disabled={busy} on:click={onDestroy}>Снести</ScifiButton>
          <ScifiButton variant="ghost" on:click={() => (showSure = false)}>Отмена</ScifiButton>
        </div>
      </div>
    </div>
  </div>
{/if}

<style>
  .place-side {
    position: absolute;
    z-index: 12;
    left: 10px;
    top: 10px;
    bottom: 10px;
    width: min(340px, calc(100% - 20px));
    display: flex;
    flex-direction: column;
    min-height: 0;
    pointer-events: none;
  }

  .place-side :global(.place-pane) {
    pointer-events: auto;
    flex: 1 1 auto;
    min-height: 0;
    max-height: 100%;
    background: rgba(4, 10, 22, 0.78);
    backdrop-filter: blur(10px);
    overflow: hidden;
  }

  .place-side :global(.place-pane > .panel-header) {
    display: flex;
    flex-direction: column;
    gap: 8px;
    padding: 8px 10px;
    background: linear-gradient(90deg, rgba(0, 229, 255, 0.12) 0%, transparent 70%);
  }

  .place-side :global(.place-pane > .panel-content) {
    overflow: auto;
    min-height: 0;
    display: flex;
    flex-direction: column;
    gap: 8px;
  }

  .pane-head {
    display: flex;
    flex-direction: column;
    gap: 8px;
    width: 100%;
  }

  .pane-head :global(.scifi-tabs) {
    width: 100%;
    background: transparent;
    backdrop-filter: none;
  }

  .pane-title {
    font-size: inherit;
    font-weight: inherit;
    letter-spacing: inherit;
    color: inherit;
    text-transform: inherit;
  }

  .html-block {
    font-size: 0.85rem;
    line-height: 1.35;
    color: var(--text-main);
  }

  .html-block :global(a) {
    color: inherit;
  }

  .muted-html {
    color: var(--text-muted);
    white-space: pre-wrap;
  }

  .section-label {
    margin: 4px 0;
    font-size: 0.8rem;
    color: var(--neon-cyan);
  }

  .table-wrap {
    overflow: auto;
    max-height: 220px;
  }

  .field {
    display: flex;
    flex-direction: column;
    gap: 4px;
    font-size: 0.8rem;
    color: var(--text-muted);
  }

  .count-row {
    display: flex;
    gap: 4px;
    align-items: center;
  }

  .cnt-btn {
    width: 28px;
    height: 28px;
    border: 1px solid var(--border-light);
    background: transparent;
    color: var(--text-main);
    cursor: pointer;
  }

  .glow-ok {
    box-shadow: 0 0 8px rgba(0, 255, 255, 0.35);
    border-color: rgba(0, 255, 255, 0.55);
  }

  .glow-fail {
    box-shadow: 0 0 8px rgba(255, 60, 60, 0.4);
    border-color: rgba(255, 80, 80, 0.7);
  }

  .cta-row {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
    margin-top: 8px;
  }

  .err {
    color: #ff6a6a;
    font-size: 0.85rem;
  }

  .modal-backdrop {
    position: fixed;
    inset: 0;
    background: rgba(0, 0, 0, 0.55);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 40;
  }

  .modal {
    width: min(420px, 92vw);
  }

  @media (max-width: 500px) {
    .place-side {
      left: 6px;
      top: 6px;
      bottom: auto;
      max-height: min(48vh, 420px);
      width: calc(100% - 12px);
    }
  }
</style>
