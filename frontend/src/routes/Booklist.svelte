<script>
  import { onDestroy, onMount, tick } from 'svelte';
  import { push, querystring } from 'svelte-spa-router';
  import {
    checkMailTo,
    deleteMail,
    deleteMailAll,
    deleteQuest,
    getBookDesc,
    getBooklistHint,
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

  export let initialTab = 'messages';

  const IMG = '/app/img/booklist';
  const TABS = ['messages', 'learn', 'quest', 'stat', 'relation'];
  const TAB_Z = {
    messages: { messages: 5, learn: 4, quest: 3, stat: 2, relation: 1 },
    learn: { learn: 5, quest: 4, messages: 3, stat: 2, relation: 1 },
    quest: { quest: 5, learn: 4, messages: 3, stat: 2, relation: 1 },
    stat: { stat: 5, relation: 4, quest: 3, learn: 2, messages: 1 },
    relation: { relation: 5, stat: 4, quest: 3, learn: 2, messages: 1 },
  };
  const TAB_BUTTONS = [
    { id: 'messages', left: 304, width: 137, height: 25, img: '213.png', alt: 'Сообщения' },
    { id: 'learn', left: 444, width: 123, height: 25, img: '205.png', alt: 'Обучение' },
    { id: 'quest', left: 570, width: 108, height: 25, img: '194.png', alt: 'Задания' },
    { id: 'stat', left: 681, width: 149, height: 25, img: '143.png', alt: 'Статистика' },
    { id: 'relation', left: 832, width: 136, height: 25, img: '136.png', alt: 'отношения' },
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
  let sendAlpha = 0;
  let sendTo = '';
  let sendText = '';
  let sendGlow = 'ok';
  let sendCanSubmit = false;

  let renameOpen = false;
  let renameAlpha = 0;
  let renameName = '';

  let sureOpen = false;
  let sureAlpha = 0;

  let hintVisible = false;
  let hintHtml = '';
  let hintX = 16;
  let hintY = 4;
  let hintTimer;
  let hintTarget = '';

  let scratchAudio;
  let buzzAudio;

  $: qs = new URLSearchParams($querystring || '');
  $: tabFromQs = (qs.get('tab') || '').trim();
  $: msgtoQs = (qs.get('msgto') || qs.get('to') || '').trim();

  function swfColor(hex) {
    if (!hex) return '#000033';
    const v = String(hex).replace(/^0x/i, '');
    return v.length === 6 ? `#${v}` : '#000033';
  }

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

  $: tabLayer = TAB_Z[activeTab] ?? TAB_Z.messages;
  $: topTabZ = tabLayer[activeTab];

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

  function showWrite() {
    playBuzz();
    sendTo = '';
    sendText = '';
    sendGlow = 'ok';
    sendCanSubmit = false;
    sendOpen = true;
    requestAnimationFrame(() => {
      sendAlpha = 1;
    });
  }

  function showReply() {
    if (mailLastSelected < 0) return;
    msgTo = messages[mailLastSelected]?.from || '';
    sendTo = msgTo;
    sendText = '';
    checkSendTo();
    sendOpen = true;
    requestAnimationFrame(() => {
      sendAlpha = 1;
    });
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
    sendAlpha = 0;
    setTimeout(() => {
      sendOpen = false;
    }, 1000);
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
    requestAnimationFrame(() => {
      renameAlpha = 1;
    });
  }

  function hideRename() {
    playBuzz();
    renameAlpha = 0;
    setTimeout(() => {
      renameOpen = false;
    }, 1000);
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
    requestAnimationFrame(() => {
      sureAlpha = 1;
    });
  }

  function hideSure() {
    sureAlpha = 0;
    setTimeout(() => {
      sureOpen = false;
    }, 1000);
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

  function onHintEnter(name, event) {
    hintTarget = name;
    clearTimeout(hintTimer);
    const rect = event.currentTarget.getBoundingClientRect();
    const stage = event.currentTarget.closest('.booklist-stage')?.getBoundingClientRect();
    if (stage) {
      const mx = rect.left - stage.left + rect.width / 2;
      const my = rect.top - stage.top;
      hintX = mx < 700 ? 16 : -300;
      hintY = my < 60 ? 4 : -64;
    }
    hintTimer = setTimeout(async () => {
      hintVisible = true;
      hintHtml = '';
      const data = await getBooklistHint(name);
      if (String(data.err) === '0') hintHtml = data.hint || '';
      else hintVisible = false;
    }, 3000);
  }

  function onHintLeave() {
    clearTimeout(hintTimer);
    hintVisible = false;
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
  $: showLearnInstall =
    learnSelected >= 0 && !!learnItems[learnSelected]?.inst;

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

  onMount(async () => {
    scratchAudio = new Audio(`${IMG}/sounds/scratch.mp3`);
    buzzAudio = new Audio(`${IMG}/sounds/buzz.mp3`);
    if (tabFromQs && TABS.includes(tabFromQs)) activeTab = tabFromQs;
    else if (initialTab && TABS.includes(initialTab)) activeTab = initialTab;
    if (qs.get('sp') === '2') activeTab = 'learn';
    await loadAll();
    learnTimer = setInterval(onLearnTick, 1000);
    if (msgtoQs) {
      sendTo = msgtoQs;
      showWrite();
      checkSendTo();
    }
  });

  onDestroy(() => {
    clearInterval(learnTimer);
    clearTimeout(hintTimer);
  });
</script>

<div class="booklist-stage">
  <aside class="left-panel" style="background-image: url('{IMG}/left-panel.png')">
    <span class="techno value" style="left:127px;top:22px;width:160px">{userInfo.hstar || ''}</span>
    <span class="techno value" style="left:134px;top:42px;width:150px">{userInfo.hplanet || ''}</span>
    <span class="techno value" style="left:76px;top:62px;width:210px">{userInfo.sname || ''}</span>
    <span class="techno value" style="left:85px;top:82px;width:200px">{userInfo.pname || ''}</span>
    <span class="techno value" style="left:93px;top:102px;width:190px">{userInfo.summ || ''}</span>
    <span class="techno value yellow" style="left:128px;top:122px;width:70px">{userInfo.conf || ''}</span>
    <span class="techno value" style="left:84px;top:142px;width:200px">{userInfo.robots || ''}</span>
    <span class="techno value insur" style="left:103px;top:162px;width:180px">{@html userInfo.insur || ''}</span>
    <span class="techno value" style="left:17px;top:215px;width:270px;white-space:normal;line-height:1.3">{userInfo.referal || ''}</span>
    <span class="techno value" style="left:103px;top:290px;width:80px">{userInfo.refcnt || ''}</span>
    <span class="techno value" style="left:17px;top:357px;width:270px">{userInfo.c_wr || ''}</span>
    <span class="techno value" style="left:17px;top:407px;width:270px">{userInfo.c_st || ''}</span>
    <span class="techno value" style="left:17px;top:457px;width:270px">{userInfo.c_lv || ''}</span>
  </aside>

  <!-- messages -->
  <section
    class="page"
    class:page-active={activeTab === 'messages'}
    style="left:300px;opacity:{activeTab === 'messages' ? 1 : tabLayer.messages >= topTabZ - 1 ? 0.5 : 0};z-index:{tabLayer.messages}"
  >
    <div class="grid-wrap messages-grid" style="left:9px;top:40px;width:681px;height:240px">
      <table class="dg">
        <thead>
          <tr>
            <th style="width:100px">От</th>
            <th style="width:140px">Дата сообщения</th>
            <th style="width:432px">Текст</th>
          </tr>
        </thead>
        <tbody>
          {#each messages as msg, i}
            <tr
              class:selected={mailSelected.has(i)}
              style="background:{swfColor(msg.read === 0 ? '0x000066' : '0x000033')}"
              on:click={(e) => selectMail(i, e)}
            >
              <td>{msg.from}</td>
              <td>{msg.time}</td>
              <td>{msg.preview}</td>
            </tr>
          {/each}
        </tbody>
      </table>
    </div>
    <div class="html-box verdana11" style="left:13px;top:288px;width:655px;height:155px">{@html mailBody}</div>
    {#if showMailWrite}
      <button type="button" class="action-btn" style="left:16px;top:452px" on:click={showWrite}>
        <img src="{IMG}/buttons/220.png" width="160" height="33" alt="написать" />
      </button>
    {/if}
    {#if showMailReply}
      <button type="button" class="action-btn" style="left:16px;top:452px" on:click={showReply}>
        <img src="{IMG}/buttons/218.png" width="160" height="33" alt="ответить" />
      </button>
    {/if}
    {#if showMailDelete}
      <button type="button" class="action-btn" style="left:256px;top:452px" on:click={removeMail}>
        <img src="{IMG}/buttons/201.png" width="160" height="33" alt="удалить" />
      </button>
    {/if}
    {#if showMailDeleteAll}
      <button type="button" class="action-btn" style="left:426px;top:452px" on:click={removeAllMail}>
        <img src="{IMG}/buttons/216.png" width="257" height="33" alt="удалить все" />
      </button>
    {/if}
  </section>

  <!-- learn -->
  <section
    class="page"
    class:page-active={activeTab === 'learn'}
    style="left:300px;opacity:{activeTab === 'learn' ? 1 : tabLayer.learn >= topTabZ - 1 ? 0.5 : 0};z-index:{tabLayer.learn}"
  >
    <div class="grid-wrap" style="left:14px;top:72px;width:672px;height:210px">
      <table class="dg">
        <thead>
          <tr>
            <th style="width:460px">Наименование</th>
            <th style="width:80px">Уровень</th>
            <th style="width:150px">Время обучения</th>
          </tr>
        </thead>
        <tbody>
          {#each learnItems as item, i}
            <tr
              class:selected={learnSelected === i}
              style="background:{swfColor(item.bgColor)}"
              on:click={() => selectLearn(i)}
            >
              <td>{item.name}</td>
              <td class="num">{item.level}</td>
              <td>{item.timeLabel}</td>
            </tr>
          {/each}
        </tbody>
      </table>
    </div>
    <div class="html-box verdana11" style="left:16px;top:289px;width:655px;height:155px">{@html learnDesc}</div>
    {#if showLearnStart}
      <button type="button" class="action-btn" style="left:20px;top:452px" on:click={doStartLearn}>
        <img src="{IMG}/buttons/208.png" width="257" height="33" alt="изучить" />
      </button>
    {/if}
    {#if showLearnInstall}
      <button type="button" class="action-btn" style="left:290px;top:452px" on:click={doStartLearn}>
        <img src="{IMG}/buttons/209.png" width="257" height="33" alt="установить" />
      </button>
    {/if}
  </section>

  <!-- quest -->
  <section
    class="page"
    class:page-active={activeTab === 'quest'}
    style="left:300px;opacity:{activeTab === 'quest' ? 1 : tabLayer.quest >= topTabZ - 1 ? 0.5 : 0};z-index:{tabLayer.quest}"
  >
    <div class="grid-wrap" style="left:14px;top:40px;width:672px;height:240px">
      <table class="dg">
        <thead>
          <tr><th>Краткое описание</th></tr>
        </thead>
        <tbody>
          {#each questItems as item, i}
            <tr
              class:selected={questSelected === i}
              style="background:{swfColor(item.bgColor)}"
              on:click={() => selectQuest(i)}
            >
              <td>{item.name}</td>
            </tr>
          {/each}
        </tbody>
      </table>
    </div>
    <div class="html-box verdana11" style="left:16px;top:289px;width:655px;height:155px">{@html questDesc}</div>
    {#if showQuestStart}
      <button type="button" class="action-btn" style="left:12px;top:452px" on:click={() => doQuestAction('start')}>
        <img src="{IMG}/buttons/197.png" width="200" height="33" alt="выполнить" />
      </button>
    {/if}
    {#if showQuestDelete}
      <button type="button" class="action-btn" style="left:242px;top:452px" on:click={() => doQuestAction('delete')}>
        <img src="{IMG}/buttons/201.png" width="160" height="33" alt="удалить" />
      </button>
    {/if}
    {#if showQuestStop}
      <button type="button" class="action-btn" style="left:430px;top:452px" on:click={() => doQuestAction('stop')}>
        <img src="{IMG}/buttons/199.png" width="257" height="33" alt="отказаться" />
      </button>
    {/if}
  </section>

  <!-- stat -->
  <section
    class="page"
    class:page-active={activeTab === 'stat'}
    style="left:300px;opacity:{activeTab === 'stat' ? 1 : tabLayer.stat >= topTabZ - 1 ? 0.5 : 0};z-index:{tabLayer.stat}"
  >
    <div class="grid-wrap" style="left:8px;top:38px;width:242px;height:450px">
      <table class="dg">
        <thead><tr><th>Объекты владения</th></tr></thead>
        <tbody>
          {#each statItems as item, i}
            <tr
              class:selected={statSelected === i}
              style="background:{swfColor(item.bgColor)}"
              on:click={() => selectStat(i)}
            >
              <td>{item.name}</td>
            </tr>
          {/each}
        </tbody>
      </table>
    </div>
    <span class="techno label" style="left:259px;top:42px">Наименование :</span>
    <span class="techno label" style="left:258px;top:62px">Режим защиты :</span>
    <span class="techno label" style="left:256px;top:83px">Всего планетарных построек :</span>
    <span class="techno label" style="left:256px;top:103px">Всего орбитальных построек :</span>
    <span class="techno label" style="left:256px;top:122px">Общая сила планетарных щитов :</span>
    <span class="techno label" style="left:256px;top:142px">Общая сила планетарной атаки :</span>
    <span class="techno label" style="left:256px;top:162px">Кораблей на планете :</span>
    <span class="techno label" style="left:256px;top:182px">Склад на планете :</span>
    <span class="techno label" style="left:256px;top:202px">Общая сила орбитальных щитов :</span>
    <span class="techno label" style="left:256px;top:222px">Общая сила орбитальной атаки :</span>
    <span class="techno label" style="left:256px;top:242px">Кораблей на орбите :</span>
    <span class="techno label" style="left:256px;top:262px">Склад на орбите :</span>
    <span class="techno label" style="left:256px;top:282px">Защита конфедерации стоимость 5 конфедерат</span>
    <div class="techno value" style="left:372px;top:42px;width:300px">{statItems[statSelected]?.name || ''}</div>
    <div class="techno value" style="left:376px;top:62px;width:300px">{@html statInfo.defType || ''}</div>
    <div class="techno value" style="left:469px;top:83px;width:200px">{statInfo.pbcnt ?? ''}</div>
    <div class="techno value" style="left:471px;top:103px;width:200px">{statInfo.obcnt ?? ''}</div>
    <div class="techno value" style="left:489px;top:122px;width:180px">{statInfo.pshld ?? ''}</div>
    <div class="techno value" style="left:483px;top:142px;width:190px">{statInfo.patck ?? ''}</div>
    <div class="techno value" style="left:411px;top:162px;width:260px">{statInfo.pship ?? ''}</div>
    <div class="techno value" style="left:389px;top:182px;width:280px">{statInfo.pware || ''}</div>
    <div class="techno value" style="left:489px;top:202px;width:180px">{statInfo.oshld ?? ''}</div>
    <div class="techno value" style="left:482px;top:222px;width:190px">{statInfo.oatck ?? ''}</div>
    <div class="techno value" style="left:403px;top:242px;width:270px">{statInfo.oship ?? ''}</div>
    <div class="techno value" style="left:381px;top:262px;width:290px">{statInfo.oware || ''}</div>
    <div class="techno value" style="left:591px;top:282px;width:90px">{@html statInfo.defence || ''}</div>
    <div class="techno value stat-note" style="left:257px;top:347px;width:420px">{@html statInfo.tren || ''}</div>
    {#if showDefence}
      <button type="button" class="action-btn" style="left:254px;top:306px" on:click={showSure}>
        <img src="{IMG}/buttons/175.png" width="160" height="33" alt="защита" />
      </button>
    {/if}
    {#if showRenameBtn}
      <button type="button" class="action-btn" style="left:431px;top:306px" on:click={showRename}>
        <img src="{IMG}/buttons/169.png" width="257" height="33" alt="переименовать" />
      </button>
    {/if}
    {#if showMine}
      <button type="button" class="action-btn" style="left:257px;top:370px" on:click={() => statOrder(2)}>
        <img src="{IMG}/buttons/153.png" width="200" height="33" alt="старт добычи" />
      </button>
    {/if}
    {#if showStop}
      <button type="button" class="action-btn" style="left:486px;top:370px" on:click={() => statOrder(6)}>
        <img src="{IMG}/buttons/182.png" width="200" height="33" alt="стоп добычи" />
      </button>
    {/if}
    {#if showDispAll}
      <button type="button" class="action-btn" style="left:257px;top:411px" on:click={() => statOrder(3)}>
        <img src="{IMG}/buttons/167.png" width="257" height="33" alt="переработать все" />
      </button>
    {/if}
    {#if showDisp}
      <button type="button" class="action-btn" style="left:257px;top:451px" on:click={() => statOrder(4)}>
        <img src="{IMG}/buttons/165.png" width="321" height="33" alt="переработать" />
      </button>
    {/if}
    {#if sureOpen}
      <div class="sure-modal" style="left:97px;top:184px;opacity:{sureAlpha}">
        <button type="button" class="action-btn" style="left:143px;top:72px" on:click={confirmDefence}>
          <img src="{IMG}/buttons/188.png" width="257" height="33" alt="установить" />
        </button>
        <button type="button" class="action-btn" style="left:463px;top:72px" on:click={hideSure}>
          <img src="{IMG}/buttons/190.png" width="200" height="33" alt="отмена" />
        </button>
      </div>
    {/if}
  </section>

  <!-- relation -->
  <section
    class="page"
    class:page-active={activeTab === 'relation'}
    style="left:300px;opacity:{activeTab === 'relation' ? 1 : tabLayer.relation >= topTabZ - 1 ? 0.5 : 0};z-index:{tabLayer.relation}"
  >
    <div class="grid-wrap" style="left:9px;top:40px;width:220px;height:410px">
      <table class="dg">
        <thead><tr><th>Друзья</th></tr></thead>
        <tbody>
          {#each relations.friends as item, i}
            <tr
              class:selected={relFriend === i}
              style="background:{swfColor(item.bgColor)}"
              on:click={() => { relFriend = i; relFoe = -1; relIgnore = -1; }}
            >
              <td>{item.login}</td>
            </tr>
          {/each}
        </tbody>
      </table>
    </div>
    <div class="grid-wrap" style="left:240px;top:40px;width:220px;height:410px">
      <table class="dg">
        <thead><tr><th>Враги</th></tr></thead>
        <tbody>
          {#each relations.foes as item, i}
            <tr
              class:selected={relFoe === i}
              style="background:{swfColor(item.bgColor)}"
              on:click={() => { relFoe = i; relFriend = -1; relIgnore = -1; }}
            >
              <td>{item.login}</td>
            </tr>
          {/each}
        </tbody>
      </table>
    </div>
    <div class="grid-wrap" style="left:470px;top:40px;width:220px;height:410px">
      <table class="dg">
        <thead><tr><th>Игнорирование</th></tr></thead>
        <tbody>
          {#each relations.ignores as item, i}
            <tr
              class:selected={relIgnore === i}
              style="background:{swfColor(item.bgColor)}"
              on:click={() => { relIgnore = i; relFriend = -1; relFoe = -1; }}
            >
              <td>{item.login}</td>
            </tr>
          {/each}
        </tbody>
      </table>
    </div>
    {#if relFriend >= 0 || relFoe >= 0 || relIgnore >= 0}
      <button type="button" class="action-btn" style="left:220px;top:455px" on:click={relInfo}>
        <img src="{IMG}/buttons/140.png" width="257" height="33" alt="информация" />
      </button>
    {/if}
  </section>

  <nav class="tab-bar" aria-label="Вкладки booklist">
    {#each TAB_BUTTONS as tab}
      <button
        type="button"
        class="tab-btn"
        class:tab-active={activeTab === tab.id}
        style="left:{tab.left}px;width:{tab.width}px;height:{tab.height}px"
        on:click|stopPropagation={() => switchTab(tab.id)}
        on:mousedown|stopPropagation
        on:mouseenter={onHintLeave}
      >
        <img src="{IMG}/buttons/{tab.img}" width={tab.width} height={tab.height} alt={tab.alt} draggable="false" />
      </button>
    {/each}
  </nav>

  {#if sendOpen}
    <div class="modal send-modal" style="opacity:{sendAlpha}">
      <label class="send-to glow-{sendGlow}">
        <input class="verdana12" type="text" bind:value={sendTo} on:input={checkSendTo} />
      </label>
      <textarea class="verdana12 send-text" bind:value={sendText}></textarea>
      {#if sendCanSubmit}
        <button type="button" class="action-btn modal-send" on:click={submitSend}>
          <img src="{IMG}/buttons/230.png" width="257" height="33" alt="отправить" />
        </button>
      {/if}
      <button type="button" class="action-btn modal-cancel" on:click={hideSend}>
        <img src="{IMG}/buttons/190.png" width="200" height="33" alt="отмена" />
      </button>
    </div>
  {/if}

  {#if renameOpen}
    <div class="modal rename-modal" style="background-image:url('{IMG}/modal-rename.png');opacity:{renameAlpha}">
      <input class="verdana12 rename-input" bind:value={renameName} />
      <button type="button" class="action-btn rename-ok" on:click={submitRename}>
        <img src="{IMG}/buttons/169.png" width="257" height="33" alt="переименовать" />
      </button>
      <button type="button" class="action-btn rename-cancel" on:click={hideRename}>
        <img src="{IMG}/buttons/190.png" width="200" height="33" alt="отмена" />
      </button>
    </div>
  {/if}

  {#if hintVisible}
    <div class="hint" style="left:{310 + hintX}px;top:{hintY}px">
      <div class="hint-body verdana11">{@html hintHtml}</div>
    </div>
  {/if}
</div>

<style>
  @font-face {
    font-family: 'NoonTechno';
    src: url('/app/fonts/99_Techno.ttf') format('truetype');
  }

  @font-face {
    font-family: 'TerminatorCyr';
    src: url('/app/fonts/133_TerminatorCyr.ttf') format('truetype');
  }

  .booklist-stage {
    position: relative;
    width: 1000px;
    height: 500px;
    margin: 0 auto;
    overflow: hidden;
    background: #000;
    color: #ccc;
  }

  .left-panel {
    position: absolute;
    left: 0;
    top: 0;
    width: 300px;
    height: 500px;
    z-index: 2;
    background-repeat: no-repeat;
    background-size: 300px 500px;
  }

  .page {
    position: absolute;
    top: 0;
    left: 300px;
    width: 700px;
    height: 500px;
    background-color: #000;
    pointer-events: none;
    transition: opacity 1s cubic-bezier(0.33, 1, 0.68, 1);
    background-image: url('/app/img/booklist/controls/panel-skin.png');
    background-position: 6px 37px;
    background-repeat: no-repeat;
    background-size: 688px 47px;
  }

  .page.page-active {
    pointer-events: auto;
  }

  .tab-bar {
    position: absolute;
    left: 0;
    top: 0;
    width: 1000px;
    height: 25px;
    z-index: 50;
    margin: 0;
    padding: 0;
    border: 0;
  }

  .tab-bar .tab-btn {
    position: absolute;
    top: 0;
    padding: 0;
    border: 0;
    background: transparent;
    cursor: pointer;
    z-index: 51;
  }

  .tab-bar .tab-btn img {
    display: block;
    pointer-events: none;
    user-select: none;
  }

  .techno {
    position: absolute;
    font: 16px/1.2 NoonTechno, Techno, sans-serif;
    color: #ccc;
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
  }

  .techno.label {
    text-overflow: clip;
  }

  .techno.yellow {
    color: #ff0;
  }

  .stat-note {
    white-space: normal;
    line-height: 1.25;
    overflow: hidden;
  }

  .verdana11 {
    font: 11px/1.35 Verdana, sans-serif;
    color: #ccc;
  }

  .verdana12 {
    font: 12px Verdana, sans-serif;
    color: #fff;
    background: transparent;
    border: 0;
    outline: none;
  }

  .value {
    display: block;
  }

  .tab-btn,
  .action-btn {
    position: absolute;
    padding: 0;
    border: 0;
    background: transparent;
    cursor: pointer;
  }

  .tab-btn:hover img,
  .action-btn:hover img {
    filter: drop-shadow(0 0 5px #f00) drop-shadow(0 0 10px #0ff);
  }

  .grid-wrap {
    position: absolute;
    overflow: auto;
    border: 1px solid #999;
    background: #000033;
  }

  .dg {
    width: 100%;
    border-collapse: collapse;
    font: 12px Verdana, sans-serif;
    color: #fff;
  }

  .dg th {
    font-weight: bold;
    color: #bfbfff;
    text-align: left;
    padding: 2px 4px;
    border-bottom: 1px solid #999;
    background: #000033;
    position: sticky;
    top: 0;
  }

  .dg td {
    padding: 2px 4px;
    border-bottom: 1px solid #333;
    cursor: pointer;
  }

  .dg tr.selected td {
    outline: 1px solid #0ff;
  }

  .dg td.num {
    text-align: right;
  }

  .html-box {
    position: absolute;
    overflow: auto;
    padding: 4px;
    border: 1px solid #333;
    background: rgba(0, 0, 51, 0.85);
  }

  .modal {
    position: absolute;
    left: 0;
    top: 0;
    width: 1000px;
    height: 500px;
    z-index: 20;
    transition: opacity 1s cubic-bezier(0.33, 1, 0.68, 1);
    background: rgba(0, 0, 0, 0.3);
  }

  .send-modal {
    background: rgba(0, 0, 0, 0.3) url('/app/img/booklist/modal-send.png') 0 0 / 1000px 500px no-repeat;
  }

  .send-to {
    position: absolute;
    left: 118px;
    top: 65px;
    width: 400px;
    height: 22px;
    padding: 2px 4px;
    background: url('/app/img/booklist/controls/input-skin.png') 0 0 / 198px 33px no-repeat;
  }

  .glow-ok {
    box-shadow: 0 0 5px #00f, inset 0 0 10px rgba(0, 255, 255, 0.4);
  }

  .glow-fail {
    box-shadow: 0 0 5px #00f, inset 0 0 10px rgba(255, 0, 0, 0.6);
  }

  .send-text {
    position: absolute;
    left: 65px;
    top: 98px;
    width: 870px;
    height: 300px;
    resize: none;
    padding: 4px;
    background: rgba(0, 0, 51, 0.9);
    border: 1px solid #333;
  }

  .modal-send {
    left: 60px;
    top: 408px;
  }

  .modal-cancel {
    left: 686px;
    top: 408px;
  }

  .rename-modal {
    background-size: 1000px 500px;
  }

  .rename-input {
    position: absolute;
    left: 352px;
    top: 244px;
    width: 300px;
    padding: 2px 4px;
    background: rgba(0, 0, 51, 0.9);
    border: 1px solid #333;
  }

  .rename-ok {
    left: 240px;
    top: 288px;
  }

  .rename-cancel {
    left: 506px;
    top: 288px;
  }

  .sure-modal {
    position: absolute;
    width: 506px;
    height: 120px;
    background: rgba(0, 0, 102, 0.95);
    border: 1px solid #0ff;
    transition: opacity 1s cubic-bezier(0.33, 1, 0.68, 1);
    z-index: 6;
  }

  .hint {
    position: absolute;
    z-index: 30;
    max-width: 280px;
    padding: 8px;
    background: rgba(0, 0, 102, 0.95);
    border: 1px solid #0ff;
  }

  .hint-body :global(a) {
    color: #0ff;
  }
</style>
