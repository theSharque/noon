<script>
  import { onDestroy, onMount } from 'svelte';
  import { push, querystring } from 'svelte-spa-router';
  import {
    checkMailTo,
    deleteMail,
    deleteMailAll,
    deleteQuest,
    getBookDesc,
    getNoonConfig,
    getObjectInfo,
    getQuestDesc,
    getUserInfo,
    listLearn,
    listMail,
    listObjects,
    listQuests,
    listRelations,
    objectOrder,
    readMail,
    sendMail,
    setObjectDefence,
    startLearn,
    startQuest,
    stopQuest,
  } from '../lib/api.js';
  import { markMailSeen } from '../lib/mailStore.js';
  import ScifiPanel from '../lib/ui/ScifiPanel.svelte';
  import ScifiButton from '../lib/ui/ScifiButton.svelte';
  import ScifiTabs from '../lib/ui/ScifiTabs.svelte';
  import ProgressBar from '../lib/ui/ProgressBar.svelte';
  import StatRow from '../lib/ui/StatRow.svelte';

  export let initialTab = 'messages';

  const IMG = '/app/img/booklist';
  const TABS = ['messages', 'learn', 'quest', 'stat', 'relation'];
  const TAB_DEFS = [
    { id: 'messages', label: 'Сообщения' },
    { id: 'learn', label: 'Обучение' },
    { id: 'quest', label: 'Задания' },
    { id: 'stat', label: 'Статистика' },
    { id: 'relation', label: 'Отношения' },
  ];

  let activeTab = initialTab;
  let userInfo = {};
  let messages = [];
  let mailBody = '';
  let mailReply = false;
  let mailSelected = new Set();
  let mailLastSelected = -1;
  let msgTo = '';

  let learnItems = [];
  let learnMeta = { lmax: 0, bid: 0 };
  let learnDesc = '';
  let learnSelected = -1;
  let learnStartTime = 0;
  let learnTimer;

  let questItems = [];
  let questMeta = { activeIndex: -1, hidetype: 0, decline: false };
  let questDesc = '';
  let questSelected = -1;

  let statItems = [];
  let statSelected = -1;
  let statInfo = {};
  let statObjectIds = [];

  let relations = { friends: [], foes: [], ignores: [] };
  let relFriend = -1;
  let relFoe = -1;
  let relIgnore = -1;

  let sendOpen = false;
  let sendTo = '';
  let sendText = '';
  let sendGlow = 'ok';
  let sendCanSubmit = false;

  let renameOpen = false;
  let renameName = '';

  let sureOpen = false;

  let scratchAudio;
  let buzzAudio;

  $: qs = new URLSearchParams($querystring || '');
  $: tabFromQs = (qs.get('tab') || '').trim();
  $: msgtoQs = (qs.get('msgto') || qs.get('to') || '').trim();

  function parseBar(text) {
    const raw = String(text || '').replace(/<[^>]+>/g, '').trim();
    const m = raw.match(/(-?\d+(?:\.\d+)?)\s*\/\s*(-?\d+(?:\.\d+)?)/);
    if (m) {
      const cur = Number(m[1]);
      const max = Number(m[2]);
      if (max > 0) return { value: raw, percent: Math.max(0, Math.min(100, (cur / max) * 100)) };
    }
    const n = Number(raw.replace(/[^\d.-]/g, ''));
    if (!Number.isNaN(n) && n >= 0 && n <= 100) return { value: raw, percent: n };
    return { value: raw || '—', percent: 0 };
  }

  $: barWr = parseBar(userInfo.c_wr);
  $: barSt = parseBar(userInfo.c_st);
  $: barLv = parseBar(userInfo.c_lv);

  function playScratch() {
    const { sv } = getNoonConfig();
    if (!scratchAudio) return;
    scratchAudio.volume = Math.max(0, Math.min(1, sv / 100));
    scratchAudio.currentTime = 0;
    scratchAudio.play().catch(() => {});
  }

  function playBuzz() {
    const { sv } = getNoonConfig();
    if (!buzzAudio) return;
    buzzAudio.volume = Math.max(0, Math.min(1, sv / 100));
    buzzAudio.currentTime = 0;
    buzzAudio.play().catch(() => {});
  }

  function switchTab(tab) {
    if (tab === activeTab) return;
    playScratch();
    activeTab = tab;
  }

  async function loadAll() {
    const [u, m, l, q, s, r] = await Promise.all([
      getUserInfo(),
      listMail(),
      listLearn(),
      listQuests(),
      listObjects(),
      listRelations(),
    ]);
    if (String(u.err) === '0') userInfo = u;
    if (String(m.err) === '0') {
      messages = m.messages;
      syncMailSeen();
    }
    if (String(l.err) === '0') {
      learnStartTime = Date.now();
      learnMeta = { lmax: l.lmax, bid: l.bid || 0 };
      learnItems = formatLearnItems(l);
    }
    if (String(q.err) === '0') {
      questItems = q.items.map((item, i) => ({
        ...item,
        bgColor: q.activeIndex === i ? '0x006600' : item.manual === '1' ? '0x000066' : '',
      }));
      questMeta = { activeIndex: q.activeIndex, hidetype: q.hidetype, decline: q.decline };
    }
    if (String(s.err) === '0') {
      statItems = s.items;
      statObjectIds = s.items.map((item) => item.id);
      if (statSelected < 0 && s.items.length) {
        statSelected = 0;
        await loadStatInfo(0);
      }
    }
    if (String(r.err) === '0') relations = r;
  }

  function syncMailSeen() {
    const maxId = messages.reduce((max, m) => Math.max(max, m.id), 0);
    markMailSeen(maxId);
  }

  function formatLearnItems(data) {
    const now = Date.now();
    return data.items.map((item) => {
      let timeLabel = String(item.time ?? '');
      let bgColor = '';
      const t = String(item.time);
      if (t === '0') {
        timeLabel = 'Изучено';
        bgColor = '0x666666';
      } else if (t === '-100') {
        timeLabel = 'Имплантант';
        bgColor = '0x006600';
      } else if (t === '-200') {
        timeLabel = 'Установлен';
        bgColor = '0x336633';
      } else if (t === '-1000') {
        timeLabel = 'Недоступно';
        bgColor = '0x000000';
      } else if (item.tp !== undefined && item.tp !== '' && !Number.isNaN(Number(item.tp))) {
        const remainingSec = Math.floor((Number(item.tp) * 1000 - (now - learnStartTime)) / 1000);
        if (remainingSec > 0) {
          timeLabel = formatCountdown(remainingSec);
          bgColor = '0x006600';
        } else {
          timeLabel = '00:00:00';
          bgColor = '0x006600';
        }
      }
      return { ...item, timeLabel, bgColor };
    });
  }

  function formatCountdown(sec) {
    let diff = Math.max(0, Math.floor(sec));
    const vD = Math.floor(diff / 86400);
    diff %= 86400;
    const vH = Math.floor(diff / 3600);
    diff %= 3600;
    const vM = Math.floor(diff / 60);
    const vS = diff % 60;
    let out = '';
    if (vD > 0) out = `${vD}.`;
    out += `${vH >= 10 ? vH : `0${vH}`}:`;
    out += `${vM >= 10 ? vM : `0${vM}`}:`;
    out += vS >= 10 ? vS : `0${vS}`;
    return out;
  }

  async function refreshLearn() {
    const selectedId = learnSelected >= 0 ? learnItems[learnSelected]?.id : null;
    const l = await listLearn();
    if (String(l.err) !== '0') return;
    learnStartTime = Date.now();
    learnMeta = { lmax: l.lmax, bid: l.bid || 0 };
    learnItems = formatLearnItems(l);
    if (selectedId != null) {
      const idx = learnItems.findIndex((item) => String(item.id) === String(selectedId));
      learnSelected = idx;
    }
  }

  function onLearnTick() {
    let expired = false;
    const now = Date.now();
    const next = learnItems.map((item) => {
      if (item.tp === undefined || item.tp === '' || Number.isNaN(Number(item.tp))) {
        return item;
      }
      if (['0', '-100', '-200', '-1000'].includes(String(item.time))) {
        return item;
      }
      const remainingSec = Math.floor((Number(item.tp) * 1000 - (now - learnStartTime)) / 1000);
      if (remainingSec <= 0) {
        expired = true;
        return { ...item, timeLabel: '00:00:00', bgColor: '0x006600' };
      }
      return { ...item, timeLabel: formatCountdown(remainingSec), bgColor: '0x006600' };
    });
    learnItems = next;
    if (expired) refreshLearn();
  }

  async function selectMail(idx, event) {
    if (event?.ctrlKey || event?.metaKey) {
      if (mailSelected.has(idx)) mailSelected.delete(idx);
      else mailSelected.add(idx);
      mailSelected = mailSelected;
    } else {
      mailSelected = new Set([idx]);
    }
    mailLastSelected = idx;
    mailBody = 'Загрузка...';
    const msg = messages[idx];
    const data = await readMail(msg.id);
    if (String(data.err) === '0') {
      mailBody = data.text || '';
      mailReply = data.reply === '1';
      messages = messages.map((m, i) => (i === idx ? { ...m, read: 1 } : m));
      syncMailSeen();
    }
  }

  function showWrite(to = '') {
    playBuzz();
    sendTo = to;
    sendText = '';
    sendGlow = 'ok';
    sendCanSubmit = false;
    sendOpen = true;
    if (to) checkSendTo();
  }

  function showReply() {
    if (mailLastSelected < 0) return;
    msgTo = messages[mailLastSelected]?.from || '';
    showWrite(msgTo);
  }

  async function checkSendTo() {
    const data = await checkMailTo(sendTo);
    if (String(data.err) !== '0') {
      sendGlow = 'fail';
      sendCanSubmit = false;
    } else {
      sendGlow = 'ok';
      sendCanSubmit = true;
    }
  }

  function hideSend() {
    playBuzz();
    sendOpen = false;
  }

  async function submitSend() {
    if (!sendCanSubmit) return;
    playBuzz();
    await sendMail(sendTo, sendText);
    hideSend();
    messages = (await listMail()).messages || [];
    syncMailSeen();
    await loadAll();
  }

  async function removeMail() {
    if (!mailSelected.size) return;
    playBuzz();
    const ids = [...mailSelected].map((i) => messages[i]?.id).filter(Boolean);
    await deleteMail(ids);
    mailBody = '';
    mailSelected = new Set();
    messages = (await listMail()).messages || [];
    syncMailSeen();
  }

  async function removeAllMail() {
    playBuzz();
    await deleteMailAll();
    mailBody = '';
    messages = (await listMail()).messages || [];
    syncMailSeen();
  }

  async function selectLearn(idx) {
    learnSelected = idx;
    learnDesc = 'Загрузка...';
    const item = learnItems[idx];
    const data = await getBookDesc(item.id);
    learnDesc = String(data.err) === '0' ? data.desc || '' : '';
  }

  async function doStartLearn() {
    if (learnSelected < 0) return;
    playBuzz();
    const bookId = learnItems[learnSelected].id;
    learnDesc = '';
    const res = await startLearn(bookId);
    if (String(res.err) !== '0') return;
    await refreshLearn();
  }

  async function selectQuest(idx) {
    questSelected = idx;
    questDesc = 'Загрузка...';
    const item = questItems[idx];
    const data = await getQuestDesc(item.id);
    questDesc = String(data.err) === '0' ? data.desc || '' : '';
  }

  async function doQuestAction(action) {
    if (questSelected < 0) return;
    playBuzz();
    const id = questItems[questSelected].id;
    if (action === 'start') await startQuest(id);
    if (action === 'stop') await stopQuest(id);
    if (action === 'delete') await deleteQuest(id);
    questDesc = '';
    const q = await listQuests();
    if (String(q.err) === '0') {
      questItems = q.items.map((item, i) => ({
        ...item,
        bgColor: q.activeIndex === i ? '0x006600' : item.manual === '1' ? '0x000066' : '',
      }));
      questMeta = { activeIndex: q.activeIndex, hidetype: q.hidetype, decline: q.decline };
    }
  }

  async function loadStatInfo(idx) {
    if (idx < 0 || !statObjectIds[idx]) return;
    const data = await getObjectInfo(statObjectIds[idx]);
    if (String(data.err) === '0') statInfo = data;
  }

  async function selectStat(idx) {
    statSelected = idx;
    await loadStatInfo(idx);
  }

  async function statOrder(ord) {
    if (statSelected < 0) return;
    playBuzz();
    await objectOrder(ord, statObjectIds[statSelected]);
    await loadAll();
    await selectStat(statSelected);
  }

  function showRename() {
    renameName = '';
    renameOpen = true;
  }

  function hideRename() {
    playBuzz();
    renameOpen = false;
  }

  async function submitRename() {
    if (statSelected < 0) return;
    playBuzz();
    await objectOrder(1, statObjectIds[statSelected], renameName);
    hideRename();
    await loadAll();
  }

  function showSure() {
    sureOpen = true;
  }

  function hideSure() {
    sureOpen = false;
  }

  async function confirmDefence() {
    if (statSelected < 0) return;
    playBuzz();
    await setObjectDefence(statObjectIds[statSelected]);
    hideSure();
    await loadAll();
    await selectStat(statSelected);
  }

  function openAbout(login) {
    push(`/about?login=${encodeURIComponent(login)}`);
  }

  function relInfo() {
    playBuzz();
    if (relFoe >= 0) openAbout(relations.foes[relFoe].login);
    else if (relFriend >= 0) openAbout(relations.friends[relFriend].login);
    else if (relIgnore >= 0) openAbout(relations.ignores[relIgnore].login);
  }

  $: showQuestStart = questMeta.activeIndex < 0 && questSelected >= 0;
  $: showQuestStop =
    questMeta.hidetype !== 1 && questMeta.activeIndex >= 0 && questSelected === questMeta.activeIndex;
  $: showQuestDelete = questSelected >= 0 && questItems[questSelected]?.manual === '1';

  $: showLearnStart = (() => {
    if (learnSelected < 0 || !learnItems[learnSelected]) return false;
    const item = learnItems[learnSelected];
    const timeNum = Number(item.time);
    if (!Number.isNaN(timeNum) && timeNum <= 0) return false;
    if (item.tp !== undefined && item.tp !== '' && Number(item.tp) > 0) return false;
    if (learnMeta.bid > learnMeta.lmax) return false;
    return true;
  })();
  $: showLearnInstall = learnSelected >= 0 && !!learnItems[learnSelected]?.inst;

  $: statAuto = parseInt(statInfo.auto || '0', 10);
  $: showMine = statAuto === 1 || statAuto === 3;
  $: showStop = showMine;
  $: showDisp = statAuto === 3;
  $: showDispAll = statAuto === 3;
  $: showDefence = statInfo.def === '1';
  $: showRenameBtn = statInfo.ren === '1';

  $: showMailReply = mailReply && mailLastSelected >= 0;
  $: showMailWrite = !showMailReply;
  $: showMailDelete = mailSelected.size > 0;
  $: showMailDeleteAll = messages.length > 0;

  $: detailTitle =
    activeTab === 'messages'
      ? 'Сообщение'
      : activeTab === 'learn'
        ? learnItems[learnSelected]?.name || 'Описание'
        : activeTab === 'quest'
          ? questItems[questSelected]?.name || 'Задание'
          : activeTab === 'stat'
            ? statItems[statSelected]?.name || 'Объект'
            : 'Информация';

  onMount(async () => {
    scratchAudio = new Audio(`${IMG}/sounds/scratch.mp3`);
    buzzAudio = new Audio(`${IMG}/sounds/buzz.mp3`);
    if (tabFromQs && TABS.includes(tabFromQs)) activeTab = tabFromQs;
    else if (initialTab && TABS.includes(initialTab)) activeTab = initialTab;
    if (qs.get('sp') === '2') activeTab = 'learn';
    await loadAll();
    learnTimer = setInterval(onLearnTick, 1000);
    if (msgtoQs) {
      showWrite(msgtoQs);
    }
  });

  onDestroy(() => {
    clearInterval(learnTimer);
  });
</script>

<div class="booklist">
  <div class="tabs-row">
    <ScifiTabs tabs={TAB_DEFS} active={activeTab} on:change={(e) => switchTab(e.detail)} />
  </div>

  <div class="layout">
    <ScifiPanel title="Статус командира" className="col-status">
      <StatRow icon="star" label="Родная звезда" value={userInfo.hstar || '—'} />
      <StatRow icon="planet" label="Родная планета" value={userInfo.hplanet || '—'} />
      <StatRow icon="star" label="Текущая звезда" value={userInfo.sname || '—'} />
      <StatRow icon="planet" label="Текущая планета" value={userInfo.pname || '—'} />
      <StatRow icon="credits" label="Кредиты" value={userInfo.summ || '—'} />
      <StatRow icon="people" label="Конфедераты" value={userInfo.conf || '—'} warn />
      <StatRow icon="robot" label="Роботы" value={userInfo.robots || '—'} />
      <StatRow icon="shield" label="Страховка">
        {@html userInfo.insur || '—'}
      </StatRow>

      {#if userInfo.referal}
        <div class="referral">
          <div class="referral-label">Реферальная ссылка</div>
          <div class="referral-link">{userInfo.referal}</div>
          {#if userInfo.refcnt}
            <div class="referral-meta">Приглашено: {userInfo.refcnt}</div>
          {/if}
        </div>
      {/if}

      <div class="bars">
        <ProgressBar label="Военное обучение" value={barWr.value} percent={barWr.percent} />
        <ProgressBar label="Ответственность" value={barSt.value} percent={barSt.percent} />
        <ProgressBar label="Опыт" value={barLv.value} percent={barLv.percent} />
      </div>
    </ScifiPanel>

    <div class="col-right">
    <ScifiPanel className="col-main">
      <div slot="header">
        {#if activeTab === 'messages'}Сообщения
        {:else if activeTab === 'learn'}Обучение
        {:else if activeTab === 'quest'}Задания
        {:else if activeTab === 'stat'}Статистика владений
        {:else}Отношения{/if}
      </div>

      {#if activeTab === 'messages'}
        <div class="table-container">
          <table class="scifi-table">
            <thead>
              <tr>
                <th>От</th>
                <th>Дата</th>
                <th>Текст</th>
              </tr>
            </thead>
            <tbody>
              {#each messages as msg, i}
                <tr
                  class:active-row={mailSelected.has(i)}
                  class:unread={msg.read === 0}
                  on:click={(e) => selectMail(i, e)}
                >
                  <td>{msg.from}</td>
                  <td class="num">{msg.time}</td>
                  <td>{msg.preview}</td>
                </tr>
              {/each}
            </tbody>
          </table>
        </div>
      {:else if activeTab === 'learn'}
        <div class="table-container">
          <table class="scifi-table">
            <thead>
              <tr>
                <th>Наименование</th>
                <th class="num">Уровень</th>
                <th>Статус</th>
              </tr>
            </thead>
            <tbody>
              {#each learnItems as item, i}
                <tr class:active-row={learnSelected === i} on:click={() => selectLearn(i)}>
                  <td>{item.name}</td>
                  <td class="num">{item.level}</td>
                  <td>{item.timeLabel}</td>
                </tr>
              {/each}
            </tbody>
          </table>
        </div>
      {:else if activeTab === 'quest'}
        <div class="table-container">
          <table class="scifi-table">
            <thead>
              <tr><th>Краткое описание</th></tr>
            </thead>
            <tbody>
              {#each questItems as item, i}
                <tr class:active-row={questSelected === i} on:click={() => selectQuest(i)}>
                  <td>{item.name}</td>
                </tr>
              {/each}
            </tbody>
          </table>
        </div>
      {:else if activeTab === 'stat'}
        <div class="stat-split">
          <div class="table-container stat-list">
            <table class="scifi-table">
              <thead>
                <tr><th>Объекты владения</th></tr>
              </thead>
              <tbody>
                {#each statItems as item, i}
                  <tr class:active-row={statSelected === i} on:click={() => selectStat(i)}>
                    <td>{item.name}</td>
                  </tr>
                {/each}
              </tbody>
            </table>
          </div>
          <div class="stat-facts html-rich">
            <div class="fact"><span>Наименование</span><b>{statItems[statSelected]?.name || '—'}</b></div>
            <div class="fact"><span>Режим защиты</span><b>{@html statInfo.defType || '—'}</b></div>
            <div class="fact"><span>Планетарные постройки</span><b>{statInfo.pbcnt ?? '—'}</b></div>
            <div class="fact"><span>Орбитальные постройки</span><b>{statInfo.obcnt ?? '—'}</b></div>
            <div class="fact"><span>Сила планетарных щитов</span><b>{statInfo.pshld ?? '—'}</b></div>
            <div class="fact"><span>Сила планетарной атаки</span><b>{statInfo.patck ?? '—'}</b></div>
            <div class="fact"><span>Кораблей на планете</span><b>{statInfo.pship ?? '—'}</b></div>
            <div class="fact"><span>Склад на планете</span><b>{statInfo.pware || '—'}</b></div>
            <div class="fact"><span>Сила орбитальных щитов</span><b>{statInfo.oshld ?? '—'}</b></div>
            <div class="fact"><span>Сила орбитальной атаки</span><b>{statInfo.oatck ?? '—'}</b></div>
            <div class="fact"><span>Кораблей на орбите</span><b>{statInfo.oship ?? '—'}</b></div>
            <div class="fact"><span>Склад на орбите</span><b>{statInfo.oware || '—'}</b></div>
            <div class="fact"><span>Защита конфедерации</span><b>{@html statInfo.defence || '—'}</b></div>
            {#if statInfo.tren}
              <div class="stat-note">{@html statInfo.tren}</div>
            {/if}
          </div>
        </div>
      {:else}
        <div class="rel-grid">
          <div class="table-container">
            <table class="scifi-table">
              <thead><tr><th>Друзья</th></tr></thead>
              <tbody>
                {#each relations.friends as item, i}
                  <tr
                    class:active-row={relFriend === i}
                    on:click={() => {
                      relFriend = i;
                      relFoe = -1;
                      relIgnore = -1;
                    }}
                  >
                    <td>{item.login}</td>
                  </tr>
                {/each}
              </tbody>
            </table>
          </div>
          <div class="table-container">
            <table class="scifi-table">
              <thead><tr><th>Враги</th></tr></thead>
              <tbody>
                {#each relations.foes as item, i}
                  <tr
                    class:active-row={relFoe === i}
                    on:click={() => {
                      relFoe = i;
                      relFriend = -1;
                      relIgnore = -1;
                    }}
                  >
                    <td>{item.login}</td>
                  </tr>
                {/each}
              </tbody>
            </table>
          </div>
          <div class="table-container">
            <table class="scifi-table">
              <thead><tr><th>Игнор</th></tr></thead>
              <tbody>
                {#each relations.ignores as item, i}
                  <tr
                    class:active-row={relIgnore === i}
                    on:click={() => {
                      relIgnore = i;
                      relFriend = -1;
                      relFoe = -1;
                    }}
                  >
                    <td>{item.login}</td>
                  </tr>
                {/each}
              </tbody>
            </table>
          </div>
        </div>
      {/if}
    </ScifiPanel>

    <ScifiPanel title={detailTitle} className="col-detail">
      {#if activeTab === 'messages'}
        <div class="html-rich detail-body">{@html mailBody || 'Выберите сообщение'}</div>
        <div class="actions">
          {#if showMailWrite}
            <ScifiButton variant="primary" on:click={showWrite}>Написать</ScifiButton>
          {/if}
          {#if showMailReply}
            <ScifiButton variant="primary" on:click={showReply}>Ответить</ScifiButton>
          {/if}
          {#if showMailDelete}
            <ScifiButton variant="danger" on:click={removeMail}>Удалить</ScifiButton>
          {/if}
          {#if showMailDeleteAll}
            <ScifiButton variant="ghost" on:click={removeAllMail}>Удалить все</ScifiButton>
          {/if}
        </div>
      {:else if activeTab === 'learn'}
        <div class="html-rich detail-body">{@html learnDesc || 'Выберите навык'}</div>
        <div class="actions">
          {#if showLearnStart}
            <ScifiButton variant="primary" on:click={doStartLearn}>Изучить</ScifiButton>
          {/if}
          {#if showLearnInstall}
            <ScifiButton variant="primary" on:click={doStartLearn}>Установить</ScifiButton>
          {/if}
        </div>
      {:else if activeTab === 'quest'}
        <div class="html-rich detail-body">{@html questDesc || 'Выберите задание'}</div>
        <div class="actions">
          {#if showQuestStart}
            <ScifiButton variant="primary" on:click={() => doQuestAction('start')}>Выполнить</ScifiButton>
          {/if}
          {#if showQuestDelete}
            <ScifiButton variant="danger" on:click={() => doQuestAction('delete')}>Удалить</ScifiButton>
          {/if}
          {#if showQuestStop}
            <ScifiButton variant="warn" on:click={() => doQuestAction('stop')}>Отказаться</ScifiButton>
          {/if}
        </div>
      {:else if activeTab === 'stat'}
        <div class="detail-body muted">Управление выбранным объектом</div>
        <div class="actions">
          {#if showDefence}
            <ScifiButton variant="warn" on:click={showSure}>Защита</ScifiButton>
          {/if}
          {#if showRenameBtn}
            <ScifiButton variant="ghost" on:click={showRename}>Переименовать</ScifiButton>
          {/if}
          {#if showMine}
            <ScifiButton variant="primary" on:click={() => statOrder(2)}>Старт добычи</ScifiButton>
          {/if}
          {#if showStop}
            <ScifiButton variant="ghost" on:click={() => statOrder(6)}>Стоп добычи</ScifiButton>
          {/if}
          {#if showDispAll}
            <ScifiButton variant="ghost" on:click={() => statOrder(3)}>Переработать все</ScifiButton>
          {/if}
          {#if showDisp}
            <ScifiButton variant="ghost" on:click={() => statOrder(4)}>Переработать</ScifiButton>
          {/if}
        </div>
      {:else}
        <div class="detail-body muted">Выберите игрока в списках</div>
        <div class="actions">
          {#if relFriend >= 0 || relFoe >= 0 || relIgnore >= 0}
            <ScifiButton variant="primary" on:click={relInfo}>Информация</ScifiButton>
          {/if}
        </div>
      {/if}
    </ScifiPanel>
    </div>
  </div>

  {#if sendOpen}
    <div class="scifi-modal-backdrop">
      <div class="scifi-panel scifi-modal">
        <div class="panel-header">Новое сообщение</div>
        <div class="panel-content modal-form">
          <label>
            Кому
            <input class="scifi-input glow-{sendGlow}" type="text" bind:value={sendTo} on:input={checkSendTo} />
          </label>
          <label>
            Текст
            <textarea class="scifi-textarea" bind:value={sendText}></textarea>
          </label>
          <div class="actions">
            <ScifiButton variant="primary" disabled={!sendCanSubmit} on:click={submitSend}>Отправить</ScifiButton>
            <ScifiButton variant="ghost" on:click={hideSend}>Отмена</ScifiButton>
          </div>
        </div>
      </div>
    </div>
  {/if}

  {#if renameOpen}
    <div class="scifi-modal-backdrop">
      <div class="scifi-panel scifi-modal">
        <div class="panel-header">Переименовать объект</div>
        <div class="panel-content modal-form">
          <input class="scifi-input" type="text" bind:value={renameName} />
          <div class="actions">
            <ScifiButton variant="primary" on:click={submitRename}>Сохранить</ScifiButton>
            <ScifiButton variant="ghost" on:click={hideRename}>Отмена</ScifiButton>
          </div>
        </div>
      </div>
    </div>
  {/if}

  {#if sureOpen}
    <div class="scifi-modal-backdrop">
      <div class="scifi-panel scifi-modal">
        <div class="panel-header">Защита конфедерации</div>
        <div class="panel-content modal-form">
          <p class="muted">Установить защиту стоимостью 5 конфедерат?</p>
          <div class="actions">
            <ScifiButton variant="warn" on:click={confirmDefence}>Установить</ScifiButton>
            <ScifiButton variant="ghost" on:click={hideSure}>Отмена</ScifiButton>
          </div>
        </div>
      </div>
    </div>
  {/if}
</div>

<style>
  .booklist {
    position: relative;
    display: flex;
    flex-direction: column;
    gap: 10px;
    height: 100%;
    min-height: 420px;
  }

  .tabs-row {
    flex: 0 0 auto;
  }

  .layout {
    flex: 1 1 auto;
    min-height: 0;
    display: grid;
    grid-template-columns: minmax(220px, 280px) minmax(0, 1fr);
    gap: 10px;
  }

  .col-right {
    min-height: 0;
    display: grid;
    grid-template-rows: minmax(0, 1fr) minmax(210px, 0.42fr);
    gap: 10px;
  }

  .booklist :global(.col-status),
  .booklist :global(.col-main),
  .booklist :global(.col-detail) {
    min-height: 0;
    height: 100%;
  }

  .booklist :global(.col-main .panel-content),
  .booklist :global(.col-detail .panel-content) {
    display: flex;
    flex-direction: column;
    gap: 10px;
    min-height: 0;
    overflow: hidden;
  }

  .referral {
    margin: 10px 0;
    padding: 10px;
    border: 1px solid var(--border-light);
    background: rgba(0, 229, 255, 0.05);
  }

  .referral-label {
    font-size: 0.68rem;
    text-transform: uppercase;
    letter-spacing: 0.6px;
    color: var(--text-muted);
    margin-bottom: 4px;
  }

  .referral-link {
    font-family: var(--font-mono);
    font-size: 0.75rem;
    color: var(--neon-cyan);
    word-break: break-all;
  }

  .referral-meta {
    margin-top: 6px;
    font-size: 0.75rem;
    color: var(--text-muted);
  }

  .bars {
    margin-top: 12px;
  }

  .detail-body {
    flex: 1 1 auto;
    min-height: 0;
    overflow: auto;
  }

  .detail-body.muted,
  .muted {
    color: var(--text-muted);
  }

  .actions {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
    flex: 0 0 auto;
    flex-shrink: 0;
  }

  .stat-split {
    display: grid;
    grid-template-columns: minmax(160px, 220px) minmax(0, 1fr);
    gap: 10px;
    min-height: 0;
    flex: 1 1 auto;
  }

  .stat-list {
    max-height: 100%;
  }

  .stat-facts {
    overflow: auto;
    display: flex;
    flex-direction: column;
    gap: 6px;
  }

  .fact {
    display: flex;
    justify-content: space-between;
    gap: 12px;
    font-size: 0.8rem;
    border-bottom: 1px solid rgba(255, 255, 255, 0.04);
    padding-bottom: 4px;
  }

  .fact span {
    color: var(--text-muted);
  }

  .fact b {
    font-weight: 500;
    font-family: var(--font-mono);
    text-align: right;
  }

  .stat-note {
    margin-top: 8px;
    font-size: 0.8rem;
    color: var(--text-muted);
  }

  .rel-grid {
    display: grid;
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 8px;
    min-height: 0;
    flex: 1 1 auto;
  }

  .rel-grid .table-container {
    max-height: 100%;
  }

  tr.unread td {
    color: var(--neon-cyan-dim);
  }

  .modal-form {
    display: flex;
    flex-direction: column;
    gap: 12px;
  }

  .modal-form label {
    display: flex;
    flex-direction: column;
    gap: 6px;
    font-size: 0.75rem;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    color: var(--text-muted);
  }

  @media (max-width: 500px) {
    .layout {
      grid-template-columns: 1fr;
      overflow: auto;
    }

    .col-right {
      grid-template-rows: minmax(280px, 1fr) auto;
    }

    .rel-grid {
      grid-template-columns: 1fr;
    }

    .stat-split {
      grid-template-columns: 1fr;
    }
  }
</style>
