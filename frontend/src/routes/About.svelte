<script>
  import { onMount, tick } from 'svelte';
  import { push, querystring } from 'svelte-spa-router';
  import {
    checkMailTo,
    getAboutInfo,
    getMedalInfo,
    getMedalParam,
    getNoonConfig,
    medalOrder,
    setIgnore,
    setPremium,
    setRelation,
  } from '../lib/api.js';
  import ScifiPanel from '../lib/ui/ScifiPanel.svelte';
  import ScifiButton from '../lib/ui/ScifiButton.svelte';

  const IMG = '/app/img/about';

  const profileRows = [
    { key: 'online', label: 'Посещение' },
    { key: 'reg', label: 'Регистрация' },
    { key: 'aliance', label: 'Альянс' },
    { key: 'titul', label: 'Титул' },
    { key: 'star', label: 'Родная звезда' },
    { key: 'war', label: 'Звание' },
    { key: 'status', label: 'Статус' },
    { key: 'level', label: 'Опыт' },
    { key: 'ships', label: 'Кораблей во флоте' },
    { key: 'power', label: 'Сила флота' },
    { key: 'relation', label: 'Ваше отношение' },
  ];

  let login = '';
  let loginDraft = '';
  let loginGlow = '';
  let profile = {};
  let profileLoaded = false;
  let medals = [];
  let available = [];
  let ignore = '0';
  let clonsHtml = '';
  let selectedMedalIdx = -1;
  let comboValue = '';
  let comboOpen = false;
  let medalText = '';
  let medalPic = '';
  let medalFine = '0';
  let showRemove = false;
  let showMedalBtn = false;
  let showMedalImg = false;
  let modalOpen = false;
  let modalText = '';
  let premium = '0';
  let buzzAudio;
  let mounted = false;
  let lastQsLogin = '';
  let checkRequest = 0;
  let profileRequest = 0;

  $: qsLogin = (new URLSearchParams($querystring || '').get('login') || '').trim();
  $: comboLabel = available.find((item) => String(item.id) === String(comboValue))?.label || 'Выберите медаль';

  function playBuzz() {
    const { sv } = getNoonConfig();
    if (!buzzAudio) return;
    buzzAudio.volume = Math.max(0, Math.min(1, sv / 100));
    buzzAudio.currentTime = 0;
    buzzAudio.play().catch(() => {});
  }

  function clearMedalView() {
    medalText = '';
    medalPic = '';
    medalFine = '0';
    showRemove = false;
    showMedalBtn = false;
    showMedalImg = false;
  }

  function clearProfile() {
    profile = {};
    profileLoaded = false;
    medals = [];
    available = [];
    ignore = '0';
    clonsHtml = '';
    selectedMedalIdx = -1;
    comboValue = '';
    comboOpen = false;
    clearMedalView();
  }

  async function loadProfile(name, updateGlow = false) {
    const request = ++profileRequest;
    const data = await getAboutInfo(name);
    if (request !== profileRequest) return;
    if (String(data.err) !== '0') {
      clearProfile();
      if (updateGlow) loginGlow = 'fail';
      return;
    }
    profile = data;
    profileLoaded = true;
    medals = data.medals || [];
    available = data.available || [];
    ignore = String(data.ignore || '0');
    clonsHtml = data.clons || '';
    selectedMedalIdx = -1;
    comboValue = '';
    comboOpen = false;
    clearMedalView();
    medalText = clonsHtml;
    if (updateGlow) loginGlow = 'ok';
  }

  async function checkLogin() {
    const name = loginDraft.trim();
    const request = ++checkRequest;
    if (!name) {
      loginGlow = 'fail';
      clearProfile();
      return;
    }
    const data = await checkMailTo(name);
    if (request !== checkRequest) return;
    if (String(data.err) !== '0') {
      loginGlow = 'fail';
      clearProfile();
      return;
    }
    login = name;
    await loadProfile(name, true);
  }

  async function afterAction() {
    if (login) await loadProfile(login);
  }

  async function doRelation(relation) {
    playBuzz();
    await setRelation(login, relation);
    await afterAction();
  }

  async function doIgnore(value) {
    playBuzz();
    await setIgnore(login, value);
    await afterAction();
  }

  async function doPremium() {
    playBuzz();
    await setPremium(login, premium);
    premium = '0';
    await afterAction();
  }

  function doSend() {
    playBuzz();
    push(`/mail?to=${encodeURIComponent(login)}`);
  }

  async function selectMedalRow(index) {
    selectedMedalIdx = index;
    comboValue = '';
    comboOpen = false;
    clearMedalView();
    const mid = medals[index]?.mid;
    if (!mid) return;
    const data = await getMedalInfo(mid);
    if (String(data.err) !== '0') return;
    showRemove = String(data.btnr) === '1';
    showMedalBtn = String(data.btnm) === '1';
    medalText = data.txt || '';
    medalFine = data.fine || '0';
    medalPic = data.pic || '';
    showMedalImg = Boolean(medalPic);
  }

  async function selectAvailable(value) {
    comboValue = value;
    comboOpen = false;
    selectedMedalIdx = -1;
    clearMedalView();
    if (!value) {
      medalText = clonsHtml;
      return;
    }
    const data = await getMedalParam(value);
    if (String(data.err) !== '0') return;
    showRemove = String(data.btnr) === '1';
    showMedalBtn = String(data.btnm) === '1';
    medalText = data.txt || '';
    medalFine = data.fine || '0';
    medalPic = data.pic || '';
    showMedalImg = Boolean(medalPic);
  }

  async function removeMedal() {
    if (selectedMedalIdx < 0) return;
    const mid = medals[selectedMedalIdx]?.mid;
    if (!mid) return;
    await medalOrder('1', mid);
    await afterAction();
  }

  async function openModal() {
    modalText = '';
    modalOpen = true;
    await tick();
  }

  function closeModal() {
    modalOpen = false;
  }

  async function confirmAward() {
    if (!comboValue) return;
    playBuzz();
    closeModal();
    await medalOrder('2', comboValue, login, modalText);
    await afterAction();
  }

  onMount(() => {
    mounted = true;
    lastQsLogin = qsLogin;
    buzzAudio = new Audio(`${IMG}/buzz.mp3`);
    loginDraft = qsLogin;
    login = qsLogin;
    if (qsLogin) loadProfile(qsLogin);
    return () => {
      checkRequest += 1;
      profileRequest += 1;
    };
  });

  $: if (mounted && qsLogin !== lastQsLogin) {
    lastQsLogin = qsLogin;
    loginDraft = qsLogin;
    login = qsLogin;
    loginGlow = '';
    clearProfile();
    if (qsLogin) loadProfile(qsLogin);
  }
</script>

<div class="about">
  <div class="about-grid">
    <ScifiPanel title="Профиль командира" className="profile-panel">
      <label class="login-field">
        Логин
        <input
          class="scifi-input glow-{loginGlow}"
          type="text"
          maxlength="40"
          bind:value={loginDraft}
          on:input={checkLogin}
          on:change={checkLogin}
        />
      </label>

      <div class="profile-facts html-rich">
        {#each profileRows as row}
          <div class="fact">
            <span>{row.label}</span>
            <b>{@html profile[row.key] || (profileLoaded ? '—' : '')}</b>
          </div>
        {/each}
      </div>

      <div class="actions">
        <ScifiButton variant="danger" disabled={!profileLoaded} on:click={() => doRelation('foe')}>Враг</ScifiButton>
        <ScifiButton variant="ghost" disabled={!profileLoaded} on:click={() => doRelation('neutral')}>Нейтрален</ScifiButton>
        <ScifiButton variant="primary" disabled={!profileLoaded} on:click={() => doRelation('friend')}>Друг</ScifiButton>
        {#if profileLoaded && ignore === '1'}
          <ScifiButton variant="warn" on:click={() => doIgnore('0')}>Снять игнор</ScifiButton>
        {:else if profileLoaded}
          <ScifiButton variant="warn" on:click={() => doIgnore('1')}>Игнорировать</ScifiButton>
        {/if}
        <ScifiButton variant="primary" disabled={!profileLoaded} on:click={doSend}>Написать</ScifiButton>
      </div>

      <div class="premium-row">
        <label>
          Назначить
          <input class="scifi-input" type="text" bind:value={premium} />
        </label>
        <ScifiButton variant="ghost" disabled={!profileLoaded} on:click={doPremium}>Применить</ScifiButton>
      </div>
    </ScifiPanel>

    <ScifiPanel title="Ордена и медали" className="medals-panel">
      <div class="medals-layout">
        <div class="table-container medals-list">
          <table class="scifi-table">
            <thead>
              <tr><th>Наименование</th></tr>
            </thead>
            <tbody>
              {#each medals as medal, index}
                <tr class:active-row={selectedMedalIdx === index} on:click={() => selectMedalRow(index)}>
                  <td>{medal.name}</td>
                </tr>
              {/each}
            </tbody>
          </table>
        </div>

        <div class="medal-side">
          <div class="combo">
            <button type="button" class="scifi-btn ghost combo-trigger" on:click={() => (comboOpen = !comboOpen)}>
              {available.length ? comboLabel : 'Нет доступных наград'}
            </button>
            {#if comboOpen && available.length}
              <div class="combo-dropdown">
                <button type="button" class="combo-option" on:click={() => selectAvailable('')}>Выберите медаль</button>
                {#each available as item}
                  <button type="button" class="combo-option" on:click={() => selectAvailable(item.id)}>{item.label}</button>
                {/each}
              </div>
            {/if}
          </div>

          <div class="fine">Штраф: <span class="num">{medalFine}</span></div>

          {#if showMedalImg}
            <img class="medal-pic" src={`/img/medals/${medalPic}.png`} alt="" />
          {/if}

          <div class="html-rich medal-text">{@html medalText || ''}</div>

          <div class="actions">
            {#if showRemove}
              <ScifiButton variant="danger" on:click={removeMedal}>Снять</ScifiButton>
            {/if}
            {#if showMedalBtn}
              <ScifiButton variant="primary" on:click={openModal}>Наградить</ScifiButton>
            {/if}
          </div>
        </div>
      </div>
    </ScifiPanel>
  </div>

  {#if modalOpen}
    <div class="scifi-modal-backdrop">
      <div class="scifi-panel scifi-modal">
        <div class="panel-header">Текст награждения</div>
        <div class="panel-content modal-form">
          <textarea class="scifi-textarea" maxlength="2000" bind:value={modalText}></textarea>
          <div class="actions">
            <ScifiButton variant="primary" on:click={confirmAward}>Наградить</ScifiButton>
            <ScifiButton variant="ghost" on:click={closeModal}>Отмена</ScifiButton>
          </div>
        </div>
      </div>
    </div>
  {/if}
</div>

<style>
  .about {
    position: relative;
    height: 100%;
    min-height: 420px;
  }

  .about-grid {
    display: grid;
    grid-template-columns: var(--layout-side) minmax(0, 1fr);
    gap: 10px;
    height: 100%;
    min-height: 0;
  }

  .about :global(.profile-panel),
  .about :global(.medals-panel) {
    min-height: 0;
    height: 100%;
  }

  .about :global(.profile-panel .panel-content),
  .about :global(.medals-panel .panel-content) {
    display: flex;
    flex-direction: column;
    gap: 12px;
    min-height: 0;
  }

  .login-field {
    display: flex;
    flex-direction: column;
    gap: 6px;
    font-size: 0.72rem;
    letter-spacing: 0.6px;
    text-transform: uppercase;
    color: var(--text-muted);
  }

  .profile-facts {
    flex: 1 1 auto;
    overflow: auto;
    display: flex;
    flex-direction: column;
    gap: 6px;
  }

  .fact {
    display: flex;
    justify-content: space-between;
    gap: 12px;
    font-size: 0.85rem;
    border-bottom: 1px solid rgba(255, 255, 255, 0.04);
    padding-bottom: 4px;
  }

  .fact span {
    color: var(--text-muted);
  }

  .fact b {
    font-weight: 500;
    text-align: right;
    font-family: var(--font-mono);
  }

  .actions {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
  }

  .premium-row {
    display: flex;
    gap: 8px;
    align-items: flex-end;
  }

  .premium-row label {
    flex: 1 1 auto;
    display: flex;
    flex-direction: column;
    gap: 6px;
    font-size: 0.72rem;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    color: var(--text-muted);
  }

  .medals-layout {
    display: grid;
    grid-template-columns: var(--layout-side) minmax(0, 1fr);
    gap: 12px;
    min-height: 0;
    flex: 1 1 auto;
  }

  .medals-list {
    max-height: 100%;
  }

  .medal-side {
    display: flex;
    flex-direction: column;
    gap: 10px;
    min-height: 0;
  }

  .combo {
    position: relative;
  }

  .combo-trigger {
    width: 100%;
  }

  .combo-dropdown {
    position: absolute;
    z-index: 5;
    left: 0;
    right: 0;
    top: calc(100% + 4px);
    max-height: 220px;
    overflow: auto;
    background: var(--panel-bg-strong);
    border: 1px solid var(--border-light);
    box-shadow: var(--glow-soft);
  }

  .combo-option {
    display: block;
    width: 100%;
    text-align: left;
    padding: 8px 10px;
    border: 0;
    background: transparent;
    color: var(--text-main);
    font-family: var(--font-ui);
    font-size: 0.85rem;
    cursor: pointer;
  }

  .combo-option:hover {
    background: rgba(0, 229, 255, 0.1);
    color: var(--neon-cyan);
  }

  .fine {
    font-size: 0.8rem;
    color: var(--text-muted);
  }

  .fine .num {
    font-family: var(--font-mono);
    color: var(--accent-warn);
  }

  .medal-pic {
    width: 64px;
    height: 64px;
    object-fit: contain;
  }

  .medal-text {
    flex: 1 1 auto;
    overflow: auto;
    min-height: 80px;
  }

  .modal-form {
    display: flex;
    flex-direction: column;
    gap: 12px;
  }

  @media (max-width: 500px) {
    .about-grid {
      grid-template-columns: 1fr;
      overflow: auto;
    }

    .medals-layout {
      grid-template-columns: 1fr;
    }
  }
</style>
