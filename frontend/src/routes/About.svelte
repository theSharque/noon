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

  const IMG = '/app/img/about';

  const statFields = [
    { key: 'online', x: 102, y: 64, width: 146 },
    { key: 'reg', x: 352, y: 65, width: 155 },
    { key: 'aliance', x: 77, y: 94, width: 174 },
    { key: 'titul', x: 308, y: 95, width: 193 },
    { key: 'star', x: 128, y: 124, width: 377 },
    { key: 'war', x: 219, y: 154, width: 287 },
    { key: 'status', x: 207, y: 184, width: 299 },
    { key: 'level', x: 175, y: 214, width: 330 },
    { key: 'ships', x: 234, y: 244, width: 271 },
    { key: 'power', x: 157, y: 274, width: 348 },
    { key: 'relation', x: 206, y: 304, width: 300 },
  ];

  const statLabels = [
    { text: 'Посещение :', x: 14, y: 65 },
    { text: 'Регистрация :', x: 253, y: 65 },
    { text: 'Альянс :', x: 14, y: 95 },
    { text: 'Титул :', x: 253, y: 95 },
    { text: 'Родная звезда :', x: 14, y: 125 },
    { text: 'Уровень военного обучения :', x: 14, y: 155 },
    { text: 'Уровень ответственности :', x: 14, y: 185 },
    { text: 'Приобретенный опыт :', x: 14, y: 215 },
    { text: 'Количество кораблей в флоте :', x: 14, y: 245 },
    { text: 'Общая сила флота :', x: 14, y: 275 },
    { text: 'Ваше отношение к игроку :', x: 14, y: 305 },
  ];

  const statRows = [60, 90, 120, 150, 180, 210, 240, 270, 300];

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
  let modalVisible = false;
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

  function medalBg(hex) {
    if (!hex) return '#000033';
    const value = String(hex).replace(/^0x/i, '#');
    return value.length === 7 ? value : '#000033';
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
    requestAnimationFrame(() => {
      modalVisible = true;
    });
  }

  function closeModal() {
    modalVisible = false;
    setTimeout(() => {
      modalOpen = false;
    }, 1000);
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

<div class="about-root">
  <div class="about-stage">
    <div class="panel-skin login-panel" class:ok={loginGlow === 'ok'} class:fail={loginGlow === 'fail'}></div>
    <input
      class="login-input"
      type="text"
      maxlength="40"
      bind:value={loginDraft}
      on:input={checkLogin}
      on:change={checkLogin}
    />

    {#each statRows as y}
      <div class="panel-skin stat-panel" style={`top:${y}px`}></div>
    {/each}

    {#each statLabels as field}
      <div class="stat-label" style={`left:${field.x}px;top:${field.y}px`}>{field.text}</div>
    {/each}

    {#each statFields as field}
      <div class="stat-value" style={`left:${field.x}px;top:${field.y}px;width:${field.width}px`}>
        {@html profile[field.key] || ''}
      </div>
    {/each}

    <div class="medals-title">ОРДЕНА И МЕДАЛИ ИГРОКА</div>

    <div class="medals-grid">
      <div class="grid-header">Наименование</div>
      <div class="grid-body">
        {#each medals as medal, index}
          <button
            type="button"
            class="grid-row"
            class:selected={selectedMedalIdx === index}
            style={`background-color:${medalBg(medal.bgColor)}`}
            on:click={() => selectMedalRow(index)}
          >
            {medal.name}
          </button>
        {/each}
      </div>
    </div>

    <div class="medal-combo" class:open={comboOpen}>
      <button type="button" class="combo-trigger" on:click={() => (comboOpen = !comboOpen)}>
        <span>{available.length ? comboLabel : ''}</span>
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

    <div class="fine-label">Штраф:</div>
    <div class="fine-value">{medalFine}</div>

    {#if showRemove}
      <button type="button" class="flash-button btn-remove" on:click={removeMedal}>
        <img src={`${IMG}/btn-remove.png`} alt="Снять награду" />
      </button>
    {/if}

    {#if showMedalBtn}
      <button type="button" class="flash-button btn-medal" on:click={openModal}>
        <img src={`${IMG}/btn-medal.png`} alt="Наградить" />
      </button>
    {/if}

    {#if showMedalImg}
      <img class="medal-picture" src={`/img/medals/${medalPic}.png`} alt="" />
    {/if}

    <div class="panel-skin description-panel"></div>
    <div class="medal-description">{@html medalText || ''}</div>

    <div class="premium-label">Назначить:</div>
    <input class="premium-input" type="text" bind:value={premium} />

    <button type="button" class="flash-button btn-foe" on:click={() => doRelation('foe')}>
      <img src={`${IMG}/btn-foe.png`} alt="Сделать врагом" />
    </button>

    <button type="button" class="flash-button btn-premium" on:click={doPremium}>
      <img src={`${IMG}/btn-premium.png`} alt="Назначить" />
    </button>

    <button type="button" class="flash-button btn-neutral" on:click={() => doRelation('neutral')}>
      <img src={`${IMG}/btn-neutral.png`} alt="Нейтрален" />
    </button>

    {#if profileLoaded && ignore === '1'}
      <button type="button" class="flash-button btn-ignore" on:click={() => doIgnore('0')}>
        <img src={`${IMG}/btn-ignore-off.png`} alt="Отменить игнор" />
      </button>
    {:else if profileLoaded}
      <button type="button" class="flash-button btn-ignore" on:click={() => doIgnore('1')}>
        <img src={`${IMG}/btn-ignore-on.png`} alt="Игнорировать" />
      </button>
    {/if}

    <button type="button" class="flash-button btn-friend" on:click={() => doRelation('friend')}>
      <img src={`${IMG}/btn-friend.png`} alt="Сделать другом" />
    </button>

    <button type="button" class="flash-button btn-send" on:click={doSend}>
      <img src={`${IMG}/btn-send.png`} alt="Написать сообщение" />
    </button>

    {#if modalOpen}
      <div class="medal-modal" class:visible={modalVisible}>
        <img class="modal-frame" src={`${IMG}/modal-frame.png`} alt="" />
        <textarea class="modal-text" maxlength="2000" bind:value={modalText}></textarea>
        <button type="button" class="flash-button modal-ok" on:click={confirmAward}>
          <img src={`${IMG}/btn-award.png`} alt="Наградить" />
        </button>
        <button type="button" class="flash-button modal-cancel" on:click={closeModal}>
          <img src={`${IMG}/btn-cancel.png`} alt="Отмена" />
        </button>
      </div>
    {/if}
  </div>
</div>

<style>
  @font-face {
    font-family: 'NoonTechno';
    src: url('/app/fonts/96_Techno.ttf') format('truetype');
  }

  .about-root {
    min-width: 1000px;
    min-height: 500px;
    width: 100%;
    height: 100%;
    overflow: auto;
    background: #000;
  }

  .about-stage {
    position: relative;
    width: 1000px;
    height: 500px;
    overflow: hidden;
    color: #fff;
    background: #000033;
    font-family: 'NoonTechno', sans-serif;
  }

  .panel-skin {
    position: absolute;
    background: url('/app/img/about/panel-skin.png') center / 100% 100% no-repeat;
    pointer-events: none;
  }

  .login-panel {
    left: 10px;
    top: 10px;
    width: 502px;
    height: 41px;
  }

  .login-panel.ok {
    filter: drop-shadow(0 0 5px #0000ff);
    box-shadow: inset 0 0 10px rgba(0, 255, 255, 0.4);
  }

  .login-panel.fail {
    filter: drop-shadow(0 0 5px #0000ff);
    box-shadow: inset 0 0 10px rgba(255, 0, 0, 0.4);
  }

  .login-input {
    position: absolute;
    left: 13px;
    top: 13px;
    width: 495px;
    height: 35px;
    box-sizing: border-box;
    padding: 0 4px;
    border: 0;
    outline: 0;
    color: #fff;
    background: transparent;
    font: 18px/35px 'NoonTechno', sans-serif;
    text-align: center;
  }

  .stat-panel {
    left: 10px;
    width: 502px;
    height: 24px;
    opacity: 0.95;
  }

  .stat-label {
    position: absolute;
    height: 16px;
    color: #ccc;
    font: 16px/16px 'NoonTechno', sans-serif;
    white-space: nowrap;
  }

  .stat-value {
    position: absolute;
    height: 16px;
    overflow: hidden;
    color: #fff;
    font: 16px/16px 'NoonTechno', sans-serif;
    white-space: nowrap;
  }

  .stat-value :global(font) {
    color: inherit;
  }

  .medals-title {
    position: absolute;
    left: 533px;
    top: 7px;
    width: 456px;
    height: 15px;
    color: #ccc;
    font: 12px/15px 'TerminatorCyr', sans-serif;
    text-align: center;
    white-space: nowrap;
  }

  .medals-grid {
    position: absolute;
    left: 519px;
    top: 25px;
    width: 230px;
    height: 108px;
    box-sizing: border-box;
    overflow: hidden;
    border: 1px solid #0000ff;
    background: #000033;
    font: 12px/18px Verdana, sans-serif;
  }

  .grid-header {
    height: 20px;
    box-sizing: border-box;
    padding: 0 5px;
    border-bottom: 1px solid #777;
    color: #bfbfff;
    background: #c8c8d8;
    font-weight: 700;
    line-height: 20px;
  }

  .grid-body {
    height: 87px;
    overflow-y: auto;
    scrollbar-color: #fff #000033;
    scrollbar-width: thin;
  }

  .grid-row {
    display: block;
    width: 100%;
    height: 18px;
    box-sizing: border-box;
    padding: 0 5px;
    overflow: hidden;
    border: 0;
    outline: 0;
    color: #fff;
    font: inherit;
    line-height: 18px;
    text-align: left;
    white-space: nowrap;
    cursor: default;
  }

  .grid-row:hover,
  .grid-row.selected {
    color: #000;
    background-color: #00aeef !important;
  }

  .medal-combo {
    position: absolute;
    left: 759px;
    top: 25px;
    z-index: 5;
    width: 230px;
    font: 12px/22px Verdana, sans-serif;
  }

  .combo-trigger {
    width: 230px;
    height: 22px;
    box-sizing: border-box;
    padding: 0 28px 0 6px;
    overflow: hidden;
    border: 0;
    color: #bfbfff;
    background: url('/app/img/about/combo-up.png') center / 100% 100% no-repeat;
    font: 700 12px/22px Verdana, sans-serif;
    text-align: left;
    white-space: nowrap;
  }

  .combo-trigger:hover {
    background-image: url('/app/img/about/combo-over.png');
  }

  .medal-combo.open .combo-trigger {
    background-image: url('/app/img/about/combo-down.png');
  }

  .combo-dropdown {
    max-height: 264px;
    overflow-y: auto;
    border: 1px solid #6f6f8f;
    background: #000033;
  }

  .combo-option {
    display: block;
    width: 100%;
    height: 22px;
    padding: 0 5px;
    overflow: hidden;
    border: 0;
    color: #fff;
    background: #000033;
    font: 12px/22px Verdana, sans-serif;
    text-align: left;
    white-space: nowrap;
  }

  .combo-option:hover {
    color: #000;
    background: #00aeef;
  }

  .fine-label,
  .fine-value {
    position: absolute;
    top: 59px;
    height: 19px;
  }

  .fine-label {
    left: 790px;
    color: #ccc;
    font: 16px/19px 'NoonTechno', sans-serif;
  }

  .fine-value {
    left: 851px;
    width: 120px;
    color: #fff;
    font: 12px/19px Verdana, sans-serif;
  }

  .flash-button {
    position: absolute;
    padding: 0;
    overflow: visible;
    border: 0;
    outline: 0;
    background: transparent;
    line-height: 0;
    cursor: pointer;
  }

  .flash-button img {
    display: block;
    width: auto;
    height: auto;
  }

  .flash-button:not(:disabled):hover {
    filter: drop-shadow(0 0 5px #00ffff);
  }

  .flash-button:not(:disabled):active {
    transform: translateY(1px);
  }

  .flash-button:disabled {
    cursor: default;
    filter: grayscale(0.45) brightness(0.65);
  }

  .btn-remove,
  .btn-medal {
    left: 755px;
    top: 82px;
    width: 230px;
    height: 33px;
  }

  .btn-medal {
    top: 83px;
  }

  .medal-picture {
    position: absolute;
    left: 820px;
    top: 140px;
    width: 64px;
    height: 64px;
    object-fit: contain;
  }

  .description-panel {
    left: 520px;
    top: 320px;
    width: 472px;
    height: 173px;
    opacity: 0.5;
    filter: drop-shadow(0 0 3px #0000ff);
  }

  .medal-description {
    position: absolute;
    left: 526px;
    top: 325px;
    width: 456px;
    height: 158px;
    box-sizing: border-box;
    padding-right: 11px;
    overflow-y: auto;
    color: #fff;
    background: transparent;
    font: 12px/16px Verdana, sans-serif;
    scrollbar-color: #fff #000033;
    scrollbar-width: auto;
  }

  .medal-description::-webkit-scrollbar,
  .grid-body::-webkit-scrollbar,
  .combo-dropdown::-webkit-scrollbar {
    width: 15px;
  }

  .medal-description::-webkit-scrollbar-track,
  .grid-body::-webkit-scrollbar-track,
  .combo-dropdown::-webkit-scrollbar-track {
    background: #000033 url('/app/img/about/scroll-track.png') center / 15px 100% no-repeat;
  }

  .medal-description::-webkit-scrollbar-thumb,
  .grid-body::-webkit-scrollbar-thumb,
  .combo-dropdown::-webkit-scrollbar-thumb {
    border: 0;
    background: #fff url('/app/img/about/scroll-thumb.png') center / 15px 100% no-repeat;
  }

  .premium-label {
    position: absolute;
    left: 260px;
    top: 344px;
    width: 140px;
    height: 19px;
    color: #ccc;
    font: 16px/19px 'NoonTechno', sans-serif;
    text-align: right;
  }

  .premium-input {
    position: absolute;
    left: 405px;
    top: 344px;
    width: 99px;
    height: 19px;
    box-sizing: border-box;
    border: 0;
    outline: 0;
    color: #ccc;
    background: transparent;
    font: 12px/19px Verdana, sans-serif;
    text-align: center;
  }

  .btn-foe {
    left: 9px;
    top: 367px;
  }

  .btn-premium {
    left: 256px;
    top: 367px;
  }

  .btn-neutral {
    left: 10px;
    top: 407px;
  }

  .btn-ignore {
    left: 256px;
    top: 407px;
  }

  .btn-friend {
    left: 9px;
    top: 447px;
  }

  .btn-send {
    left: 256px;
    top: 447px;
  }

  .medal-modal {
    position: absolute;
    inset: 0;
    z-index: 20;
    width: 1000px;
    height: 500px;
    opacity: 0;
    transition: opacity 1s cubic-bezier(0.23, 1, 0.32, 1);
  }

  .medal-modal.visible {
    opacity: 1;
  }

  .modal-frame {
    position: absolute;
    inset: 0;
    width: 1000px;
    height: 500px;
    pointer-events: none;
  }

  .modal-text {
    position: absolute;
    left: 211px;
    top: 167px;
    width: 577px;
    height: 147px;
    box-sizing: border-box;
    padding: 4px;
    resize: none;
    border: 0;
    outline: 0;
    color: #fff;
    background: transparent;
    font: 12px/16px Verdana, sans-serif;
  }

  .modal-ok {
    left: 239px;
    top: 323px;
  }

  .modal-cancel {
    left: 507px;
    top: 323px;
  }
</style>
