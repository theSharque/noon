<script>
  import { onMount, tick } from 'svelte';
  import { push, querystring } from 'svelte-spa-router';
  import {
    addHireQuest,
    alianceOrder,
    alianceUserOrder,
    clearStarHint,
    getAlianceInfo,
    getAlianceUserInfo,
    getEncyclopediaDesc,
    getMiscSettings,
    getNoonConfig,
    getStarCoord,
    killUserAccount,
    listAliances,
    listAlianceUsers,
    listEncyclopedia,
    listHireQuests,
    listRobots,
    loadHireQuest,
    loadStarMap,
    loadTops,
    saveMiscSettings,
    saveMusicVolume,
    saveStarHint,
    validateHireField,
    validateHireQuest,
  } from '../lib/api.js';
  import ScifiPanel from '../lib/ui/ScifiPanel.svelte';
  import ScifiButton from '../lib/ui/ScifiButton.svelte';
  import ScifiTabs from '../lib/ui/ScifiTabs.svelte';
  import ScifiSelect from '../lib/ui/ScifiSelect.svelte';
  import { setMusicVolumeLocal, setSoundVolumeLocal } from '../lib/audioStore.js';
  import { askYesNo } from '../lib/confirmStore.js';

  const IMG = '/app/img/booklist';
  const GALAXY_BG = '/app/img/ships/galaxy-bg.jpg';
  const GALAXY_BG_SIZE = 2000;
  const GALAXY_BG_HALF = GALAXY_BG_SIZE / 2;
  const TAB_DEFS = [
    { id: 'enc', label: 'Энциклопедия' },
    { id: 'atlas', label: 'Атлас' },
    { id: 'aliance', label: 'Альянс' },
    { id: 'hire', label: 'Наём' },
    { id: 'robots', label: 'Роботы' },
    { id: 'top', label: 'Топ' },
    { id: 'settings', label: 'Настройки' },
  ];
  const HIRE_VIS = [
    { data: 0, label: 'Всем' },
    { data: 1, label: 'Кроме врагов' },
    { data: 2, label: 'Друзьям' },
    { data: 3, label: 'Альянсу' },
    { data: 4, label: 'Личное' },
  ];
  const HINT_COLORS = [
    { data: 0, label: 'Зелёная' },
    { data: 1, label: 'Жёлтая' },
    { data: 2, label: 'Красная' },
  ];

  $: hireQuestOptions = hireItems.map((item) => ({
    value: item.id,
    label: item.name,
  }));
  $: hireVisOptions = HIRE_VIS.map((v) => ({ value: v.data, label: v.label }));
  $: atlasColorOptions = HINT_COLORS.map((c) => ({
    value: c.data,
    label: c.label,
  }));

  let activeTab = 'enc';
  let loaded = {
    enc: false,
    atlas: false,
    aliance: false,
    hire: false,
    robots: false,
    top: false,
    settings: false,
  };

  let encItems = [];
  let encSelected = -1;
  let encDesc = '';
  let encIds = [];

  let aliances = [];
  let alianceSelected = -1;
  let alianceIds = [];
  let alianceUa = 0;
  let alianceFlags = {};
  let alianceDesc = '';
  let alianceName = '';
  let alianceDescOpen = false;
  let alianceDescEdit = '';
  let users = [];
  let userSelected = -1;
  let userIds = [];
  let userNames = [];
  let userFlags = {};

  let robots = [];

  let settingsItems = [];
  let settingsMv = Number(getNoonConfig().mv) || 0;
  let settingsSv = Number.isFinite(Number(getNoonConfig().sv)) ? Number(getNoonConfig().sv) : 50;

  let hireItems = [];
  let hireQuest = 0;
  let hireCred = '';
  let hireConf = '';
  let hireArgs = [];
  let hireVals = {};
  let hireTester = {};
  let hireSumm = '';
  let hireTime = '';
  let hireInConf = false;
  let hireVis = 0;
  let hireError = '';
  let hireCanSave = false;
  let hireGlow = {};

  let topTables = [];

  let atlasDesc = '';
  let atlasStars = [];
  let atlasYellow = [];
  let atlasHome = null;
  let atlasQuest = null;
  let atlasOffset = { x: 0, y: 0 };
  let atlasCross = null;
  let atlasHint = '';
  let atlasHintType = 0;
  let atlasHintAliance = false;
  let atlasCanCreate = false;
  let atlasCanClear = false;
  let atlasPlace = { x: 0, y: 0 };
  let atlasHover = '';
  let atlasViewport;
  let atlasDragging = false;
  let atlasDragMoved = false;
  let atlasDragStart = { x: 0, y: 0, ox: 0, oy: 0 };
  let atlasBounds = { minX: 0, minY: 0, maxX: 800, maxY: 600 };

  let scratchAudio;
  let buzzAudio;

  $: qs = new URLSearchParams($querystring || '');
  $: itmQs = (qs.get('itm') || '').trim();

  function flashColor(hex) {
    const raw = String(hex || '').replace(/^0x/i, '');
    if (!/^[0-9a-fA-F]{6}$/.test(raw)) return null;
    const r = parseInt(raw.slice(0, 2), 16);
    const g = parseInt(raw.slice(2, 4), 16);
    const b = parseInt(raw.slice(4, 6), 16);
    return `rgba(${r}, ${g}, ${b}, 0.35)`;
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

  async function switchTab(tab) {
    if (tab === activeTab) return;
    playScratch();
    activeTab = tab;
    await ensureTab(tab);
  }

  async function ensureTab(tab) {
    if (loaded[tab]) {
      if (tab === 'atlas') await tick().then(centerAtlas);
      return;
    }
    switch (tab) {
      case 'enc':
        await loadEnc();
        break;
      case 'atlas':
        await loadAtlas();
        break;
      case 'aliance':
        await loadAliance();
        break;
      case 'hire':
        await loadHire();
        break;
      case 'robots':
        await loadRobotsTab();
        break;
      case 'top':
        await loadTopTab();
        break;
      case 'settings':
        await loadSettingsTab();
        break;
    }
  }

  async function loadEnc(preferName = '') {
    const data = await listEncyclopedia();
    encItems = data.items || [];
    encIds = encItems.map((i) => i.id);
    loaded.enc = true;
    const want = preferName || itmQs;
    let idx = 0;
    if (want) {
      const found = encItems.findIndex((i) => i.name === want);
      if (found >= 0) idx = found;
    }
    if (encItems.length) await selectEnc(idx);
  }

  async function selectEnc(i) {
    encSelected = i;
    encDesc = 'Загрузка...';
    const oid = encIds[i];
    if (!oid) {
      encDesc = 'Нет данных';
      return;
    }
    const data = await getEncyclopediaDesc(oid);
    encDesc =
      String(data.err) === '0' ? formatEncHtml(data.desc || 'Нет данных') : 'Нет данных';
    await tick();
    const row = document.querySelector('.misc tr.active-row');
    if (row) row.scrollIntoView({ block: 'nearest' });
  }

  function formatEncHtml(raw) {
    let html = String(raw || '');
    html = formatEncLinkTable(html, 'Для изготовления необходимо:', 'qty-first');
    html = formatEncLinkTable(html, 'Используется при постройке:', 'qty-first');
    html = formatEncLinkTable(html, 'Содержится в минералах:', 'name-first');
    html = formatEncKvTable(html, 'ТТХ корабля:');
    return html;
  }

  function formatEncLinkTable(html, title, mode) {
    const idx = html.indexOf(title);
    if (idx < 0) return html;
    const afterTitle = idx + title.length;
    let pos = afterTitle;
    while (pos < html.length && (html[pos] === '\n' || html[pos] === '\r')) pos += 1;

    const qtyFirst =
      /^(\d+)\t+<u><a href='([^']*)'>([^<]*)<\/a><\/u>\n?/;
    const nameFirst =
      /^<u><a href='([^']*)'>([^<]*)<\/a><\/u>\t+(\d+)\n?/;

    const rows = [];
    let cursor = pos;
    while (cursor < html.length) {
      const rest = html.slice(cursor);
      if (rest.startsWith('\n')) break;
      const m =
        mode === 'name-first' ? rest.match(nameFirst) : rest.match(qtyFirst);
      if (!m) break;
      if (mode === 'name-first') {
        rows.push({ qty: m[3], href: m[1], name: m[2] });
      } else {
        rows.push({ qty: m[1], href: m[2], name: m[3] });
      }
      cursor += m[0].length;
    }
    if (!rows.length) return html;

    const body = rows
      .map(
        (r) =>
          `<tr><td class="enc-qty">${r.qty}</td><td><a href="${r.href}">${r.name}</a></td></tr>`,
      )
      .join('');
    const table =
      `<div class="enc-section"><div class="enc-section-title">${title}</div>` +
      `<table class="enc-table"><tbody>${body}</tbody></table></div>`;
    return html.slice(0, idx) + table + html.slice(cursor);
  }

  function formatEncKvTable(html, title) {
    const idx = html.indexOf(title);
    if (idx < 0) return html;
    let pos = idx + title.length;
    while (pos < html.length && (html[pos] === '\n' || html[pos] === '\r')) pos += 1;

    const rows = [];
    let cursor = pos;
    while (cursor < html.length) {
      const rest = html.slice(cursor);
      if (rest.startsWith('\n')) break;
      const m = rest.match(/^([^:\n]+):\s*([^\n]*)\n?/);
      if (!m) break;
      rows.push({ key: m[1].trim(), val: m[2].trim() });
      cursor += m[0].length;
    }
    if (!rows.length) return html;

    const body = rows
      .map((r) => `<tr><td class="enc-key">${r.key}</td><td>${r.val}</td></tr>`)
      .join('');
    const table =
      `<div class="enc-section"><div class="enc-section-title">${title}</div>` +
      `<table class="enc-table enc-ttx"><tbody>${body}</tbody></table></div>`;
    return html.slice(0, idx) + table + html.slice(cursor);
  }

  function onEncHtmlClick(e) {
    const a = e.target.closest('a');
    if (!a) return;
    const href = a.getAttribute('href') || '';
    const m = href.match(/page\.php\?id=6(?:%26|&)itm=([^&'"]+)/i);
    if (!m) return;
    e.preventDefault();
    const name = decodeURIComponent(m[1].replace(/\+/g, ' '));
    push(`/misc?itm=${encodeURIComponent(name)}`);
    activeTab = 'enc';
    loadEnc(name);
  }

  async function loadAliance() {
    const data = await listAliances();
    aliances = data.items || [];
    alianceIds = aliances.map((i) => i.id);
    alianceUa = data.ua || 0;
    loaded.aliance = true;
    let idx = aliances.findIndex((i) => String(i.id) === String(alianceUa));
    if (idx < 0) idx = aliances.length ? 0 : -1;
    if (idx >= 0) await selectAliance(idx);
    else {
      const info = await getAlianceInfo(0);
      if (String(info.err) === '0') {
        alianceFlags = {
          ba1: info.ba1 === '1',
          ba2: false,
          ba3: false,
          ba4: false,
          ba5: false,
          ba6: false,
          ba7: false,
        };
      }
      users = [];
      userIds = [];
      userNames = [];
    }
  }

  async function selectAliance(i) {
    alianceSelected = i;
    userSelected = -1;
    userFlags = {};
    alianceFlags = {};
    alianceDesc = '';
    const aid = alianceIds[i];
    if (!aid) return;
    const [info, userData] = await Promise.all([getAlianceInfo(aid), listAlianceUsers(aid)]);
    if (String(info.err) === '0') {
      alianceDesc = info.txt || '';
      alianceFlags = {
        ba1: info.ba1 === '1',
        ba2: info.ba2 === '1',
        ba3: info.ba3 === '1',
        ba4: info.ba4 === '1',
        ba5: info.ba5 === '1',
        ba6: info.ba6 === '1',
        ba7: info.ba7 === '1',
      };
    }
    users = userData.items || [];
    userIds = users.map((u) => u.id);
    userNames = users.map((u) => u.name);
  }

  async function selectUser(i) {
    userSelected = i;
    userFlags = {};
    const aid = alianceIds[alianceSelected];
    const uid = userIds[i];
    if (!aid || !uid) return;
    const info = await getAlianceUserInfo(aid, uid);
    if (String(info.err) === '0') {
      userFlags = {
        bu1: info.bu1 === '1',
        bu2: info.bu2 === '1',
        bu3: info.bu3 === '1',
        bu4: info.bu4 === '1',
        bu5: info.bu5 === '1',
      };
    }
  }

  async function doAlianceOrder(kind) {
    playBuzz();
    const aid = alianceIds[alianceSelected];
    if (!aid && kind !== 'create') return;
    if (kind === 'mail') {
      push('/character?msgto=Aliance');
      return;
    }
    let ord = '';
    let extra = '';
    switch (kind) {
      case 'create':
        ord = '1';
        extra = `&name=${encodeURIComponent(alianceName)}`;
        break;
      case 'enter':
        ord = '2';
        break;
      case 'upgrade':
        ord = '3';
        break;
      case 'leave':
        ord = '5';
        break;
      case 'cancel':
        ord = '6';
        break;
      default:
        return;
    }
    await alianceOrder(ord, aid || 0, extra);
    await loadAliance();
  }

  async function doUserOrder(kind) {
    playBuzz();
    const uid = userIds[userSelected];
    const name = userNames[userSelected];
    if (!uid) return;
    switch (kind) {
      case 'mail':
        push(`/character?msgto=${encodeURIComponent(name)}`);
        return;
      case 'info':
        push(`/about?login=${encodeURIComponent(name)}`);
        return;
      case 'accept':
        await alianceUserOrder('1', uid);
        break;
      case 'delegate':
        await alianceUserOrder('2', uid);
        break;
      case 'decline':
        await alianceUserOrder('4', uid);
        break;
      case 'kick':
        await alianceUserOrder('5', uid);
        break;
      default:
        return;
    }
    await loadAliance();
  }

  function openAlianceDesc() {
    alianceDescEdit = alianceDesc;
    alianceDescOpen = true;
  }

  async function saveAlianceDesc() {
    playBuzz();
    const aid = alianceIds[alianceSelected];
    if (!aid) return;
    await alianceOrder(7, aid, `&txt=${encodeURIComponent(alianceDescEdit)}`);
    alianceDescOpen = false;
    await selectAliance(alianceSelected);
  }

  async function loadRobotsTab() {
    const data = await listRobots();
    robots = data.items || [];
    loaded.robots = true;
  }

  async function loadSettingsTab() {
    const data = await getMiscSettings();
    const noon = getNoonConfig();
    settingsItems = (data.items || []).map((row) => ({
      ...row,
      chat: row.chat === '1' || row.chat === 1,
      mail: row.mail === '1' || row.mail === 1,
    }));
    settingsMv = Number.isFinite(Number(data.mv))
      ? Number(data.mv)
      : Number.isFinite(Number(noon.mv))
        ? Number(noon.mv)
        : 0;
    settingsSv = Number.isFinite(Number(data.sv))
      ? Number(data.sv)
      : Number.isFinite(Number(noon.sv))
        ? Number(noon.sv)
        : 50;
    setMusicVolumeLocal(settingsMv);
    setSoundVolumeLocal(settingsSv);
    loaded.settings = true;
  }

  async function onMusicChange() {
    const vol = setMusicVolumeLocal(settingsMv);
    settingsMv = vol;
    await saveMusicVolume(vol);
  }

  function onMusicInput() {
    setMusicVolumeLocal(settingsMv);
  }

  function onSoundChange() {
    setSoundVolumeLocal(settingsSv);
    playBuzz();
  }

  async function doSaveSettings() {
    playBuzz();
    const mv = setMusicVolumeLocal(settingsMv);
    const sv = setSoundVolumeLocal(settingsSv);
    settingsMv = mv;
    settingsSv = sv;
    await saveMiscSettings({
      cnt: settingsItems.length,
      mv,
      sv,
      items: settingsItems,
    });
  }

  async function doKillUser() {
    const ok = await askYesNo({
      title: 'Удаление персонажа',
      message:
        'Удаление подтверждается через почту.\n\n' +
        'На ваш email и во внутриигровую почту будет отправлена ссылка.\n' +
        'Персонаж удалится только после перехода по ней.\n' +
        'Текущая сессия будет завершена.\n\n' +
        'Продолжить?',
      danger: true,
    });
    if (!ok) return;
    playBuzz();
    killUserAccount();
  }

  async function loadHire() {
    const data = await listHireQuests();
    hireItems = data.items || [];
    hireCred = data.cred || '';
    hireConf = data.conf || '';
    loaded.hire = true;
    if (hireItems.length) {
      hireQuest = hireItems[0].id;
      await onHireQuestChange();
    }
  }

  function resetHireFields() {
    hireArgs = [];
    hireVals = {};
    hireTester = {};
    hireGlow = {};
    hireSumm = '';
    hireTime = '';
    hireInConf = false;
    hireError = '';
    hireCanSave = false;
  }

  async function onHireQuestChange() {
    resetHireFields();
    if (!hireQuest) return;
    const data = await loadHireQuest(hireQuest);
    if (String(data.err) !== '0') return;
    const args = [];
    for (let i = 0; i < 10; i++) {
      if (data[`n${i}`]) {
        args.push({ i, name: data[`n${i}`], type: data[`t${i}`], label: data[`n${i}`] });
        hireTester[i] = false;
      } else {
        hireTester[i] = true;
      }
    }
    hireArgs = args;
  }

  async function checkHireField(kind, i = -1) {
    let fi;
    let ft;
    let fv;
    switch (kind) {
      case 'arg':
        fi = i;
        ft = hireArgs.find((a) => a.i === i)?.type;
        fv = hireVals[i] || '';
        break;
      case 'money':
        fi = 'm';
        ft = hireInConf ? 5 : 4;
        fv = hireSumm;
        break;
      case 'time':
        fi = 't';
        ft = 7;
        fv = hireTime;
        break;
      default:
        return;
    }

    const data = await validateHireField(fi, ft, fv);
    const key = kind === 'arg' ? `arg${i}` : kind;
    if (String(data.err) !== '0') {
      hireTester[kind === 'arg' ? i : kind] = false;
      hireGlow[key] = 'fail';
      if (data.errtext) hireError = data.errtext;
      if (String(data.t) === '3' && kind === 'arg') {
        const arg = hireArgs.find((a) => a.i === i);
        if (arg) arg.label = hireArgs.find((a) => a.i === i).name;
        hireArgs = [...hireArgs];
      }
      hireCanSave = false;
      return;
    }

    hireTester[kind === 'arg' ? i : kind] = true;
    hireGlow[key] = 'ok';
    if (data.errtext) hireError = data.errtext;
    else hireError = '';
    if (String(data.t) === '3' && kind === 'arg' && data.sname) {
      const arg = hireArgs.find((a) => a.i === i);
      if (arg) {
        arg.label = `${data.sname} ${arg.name}`;
        hireArgs = [...hireArgs];
      }
    }

    let ok = 0;
    let params = `qt=${encodeURIComponent(hireQuest)}`;
    params += `&vis=${encodeURIComponent(hireVis)}`;
    params += `&long=${encodeURIComponent(hireTime)}`;
    params += `&conf=${hireInConf ? 1 : 0}`;
    params += `&price=${encodeURIComponent(hireSumm)}`;
    for (let t = 0; t < 10; t++) {
      if (hireVals[t] === undefined) ok++;
      else if (hireTester[t]) {
        ok++;
        params += `&v${t}=${encodeURIComponent(hireVals[t])}`;
      }
    }
    if (ok === 10) {
      const v = await validateHireQuest(params);
      if (String(v.err) !== '0') {
        hireCanSave = false;
        if (v.errtext) hireError = v.errtext;
      } else {
        hireCanSave = true;
        if (v.errtext) hireError = v.errtext;
        else hireError = '';
      }
    } else {
      hireCanSave = false;
    }
  }

  async function doSaveHire() {
    playBuzz();
    if (!hireCanSave) return;
    let params = `qt=${encodeURIComponent(hireQuest)}`;
    params += `&vis=${encodeURIComponent(hireVis)}`;
    params += `&long=${encodeURIComponent(hireTime)}`;
    params += `&conf=${hireInConf ? 1 : 0}`;
    params += `&price=${encodeURIComponent(hireSumm)}`;
    for (let t = 0; t < 10; t++) {
      if (hireVals[t] !== undefined && hireTester[t]) {
        params += `&v${t}=${encodeURIComponent(hireVals[t])}`;
      }
    }
    await addHireQuest(params);
    await loadHire();
  }

  async function loadTopTab() {
    const data = await loadTops();
    topTables = data.tables || [];
    loaded.top = true;
  }

  function starFill(type) {
    if (type === 'h') return '#ffffff';
    if (type === 'e') return '#00ff00';
    if (type === 'r') return '#ff4040';
    if (type === 's') return '#7ec8ff';
    if (type === 'f') return '#c77dff';
    const n = parseInt(type, 10);
    if (n === 1) return '#00ccff';
    if (n === 2) return '#ffff00';
    if (n === 3) return '#ff2020';
    if (n === 4) return '#c800ff';
    if (n === 5) return '#b8c4ff';
    return '#e8f6ff';
  }

  function starGlowR(type) {
    const n = parseInt(type, 10);
    if (n === 3 || n === 4) return 3.5;
    if (type === 'h' || type === 'e' || type === 'r') return 4;
    return 2.8;
  }

  async function loadAtlas() {
    const data = await loadStarMap();
    atlasDesc = data.desc || '';
    atlasStars = data.stars || [];
    atlasYellow = data.yellow || [];
    atlasHome =
      data.hstx != null && data.hsty != null ? { x: data.hstx, y: data.hsty } : null;
    atlasQuest =
      data.quest && data.qsx != null && data.qsy != null
        ? { x: data.qsx, y: data.qsy }
        : null;
    let minX = -GALAXY_BG_HALF;
    let minY = -GALAXY_BG_HALF;
    let maxX = GALAXY_BG_HALF;
    let maxY = GALAXY_BG_HALF;
    for (const s of atlasStars) {
      minX = Math.min(minX, s.x - 40);
      minY = Math.min(minY, s.y - 40);
      maxX = Math.max(maxX, s.x + 40);
      maxY = Math.max(maxY, s.y + 40);
    }
    atlasBounds = { minX, minY, maxX, maxY };
    loaded.atlas = true;
    await tick();
    centerAtlas(data.shx, data.shy);
  }

  function centerAtlas(shx, shy) {
    const vp = atlasViewport;
    if (!vp) return;
    const cx = shx ?? atlasHome?.x ?? (atlasBounds.minX + atlasBounds.maxX) / 2;
    const cy = shy ?? atlasHome?.y ?? (atlasBounds.minY + atlasBounds.maxY) / 2;
    atlasOffset = {
      x: vp.clientWidth / 2 - (cx - atlasBounds.minX),
      y: vp.clientHeight / 2 - (cy - atlasBounds.minY),
    };
  }

  function atlasPointerDown(e) {
    atlasDragging = true;
    atlasDragMoved = false;
    atlasDragStart = {
      x: e.clientX,
      y: e.clientY,
      ox: atlasOffset.x,
      oy: atlasOffset.y,
    };
  }

  function atlasPointerMove(e) {
    if (!atlasDragging) {
      const pt = atlasLocal(e);
      if (pt) atlasHover = `${Math.round(pt.x)}:${Math.round(pt.y)}`;
      return;
    }
    const dx = e.clientX - atlasDragStart.x;
    const dy = e.clientY - atlasDragStart.y;
    if (Math.abs(dx) > 3 || Math.abs(dy) > 3) atlasDragMoved = true;
    atlasOffset = {
      x: atlasDragStart.ox + dx,
      y: atlasDragStart.oy + dy,
    };
  }

  function snapAtlasPoint(x, y, radius = 3) {
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
    for (const s of atlasStars) consider(s.x, s.y);
    for (const y of atlasYellow) consider(y.x, y.y);
    if (atlasHome) consider(atlasHome.x, atlasHome.y);
    if (atlasQuest) consider(atlasQuest.x, atlasQuest.y);
    return best || { x: Math.round(x), y: Math.round(y) };
  }

  async function atlasPointerUp(e) {
    if (!atlasDragging) return;
    atlasDragging = false;
    if (atlasDragMoved) return;
    const pt = atlasLocal(e);
    if (!pt) return;
    atlasPlace = snapAtlasPoint(pt.x, pt.y);
    const data = await getStarCoord(atlasPlace.x, atlasPlace.y);
    if (String(data.err) !== '0') return;
    atlasPlace = {
      x: parseInt(data.rx || atlasPlace.x, 10),
      y: parseInt(data.ry || atlasPlace.y, 10),
    };
    atlasCross = { ...atlasPlace };
    atlasDesc = data.desc || '';
    if (data.hint) {
      atlasHint = data.hint;
      atlasCanCreate = false;
      atlasCanClear = true;
    } else {
      atlasHint = '';
      atlasCanCreate = true;
      atlasCanClear = false;
    }
  }

  function atlasLocal(e) {
    const vp = atlasViewport;
    if (!vp) return null;
    const rect = vp.getBoundingClientRect();
    return {
      x: e.clientX - rect.left - atlasOffset.x + atlasBounds.minX - 2,
      y: e.clientY - rect.top - atlasOffset.y + atlasBounds.minY - 1,
    };
  }

  async function doHintSave() {
    playBuzz();
    await saveStarHint(
      atlasPlace.x,
      atlasPlace.y,
      atlasHint,
      atlasHintType,
      atlasHintAliance,
    );
    atlasCanCreate = false;
    atlasCanClear = false;
    atlasHint = '';
    await loadAtlas();
  }

  async function doHintClear() {
    playBuzz();
    await clearStarHint(atlasPlace.x, atlasPlace.y);
    atlasCanCreate = false;
    atlasCanClear = false;
    atlasHint = '';
    await loadAtlas();
  }

  onMount(() => {
    scratchAudio = new Audio(`${IMG}/sounds/scratch.mp3`);
    buzzAudio = new Audio(`${IMG}/sounds/buzz.mp3`);
    loadEnc();
  });
</script>

<div class="misc">
  <div class="tabs-row">
    <ScifiTabs tabs={TAB_DEFS} active={activeTab} on:change={(e) => switchTab(e.detail)} />
  </div>

  <div class="layout" class:layout-atlas={activeTab === 'atlas'} class:layout-top={activeTab === 'top'}>
    {#if activeTab === 'enc'}
      <ScifiPanel title="Объекты" className="col-list">
        <div class="table-container">
          <table class="scifi-table">
            <thead><tr><th>Наименование</th></tr></thead>
            <tbody>
              {#each encItems as item, i}
                <tr
                  class:active-row={encSelected === i}
                  style={flashColor(item.bgColor) ? `background:${flashColor(item.bgColor)}` : ''}
                  on:click={() => selectEnc(i)}
                >
                  <td>{item.name}</td>
                </tr>
              {/each}
            </tbody>
          </table>
        </div>
      </ScifiPanel>
      <ScifiPanel title="Описание" className="col-detail">
        <!-- svelte-ignore a11y-click-events-have-key-events a11y-no-static-element-interactions -->
        <div class="html-rich detail-body pre-wrap" on:click={onEncHtmlClick}>
          {@html encDesc || 'Выберите объект'}
        </div>
      </ScifiPanel>

    {:else if activeTab === 'atlas'}
      <ScifiPanel title="Карта галактики" className="col-atlas">
        <div
          class="atlas-viewport"
          bind:this={atlasViewport}
          on:pointerdown={atlasPointerDown}
          on:pointermove={atlasPointerMove}
          on:pointerup={atlasPointerUp}
          on:pointerleave={() => {
            atlasDragging = false;
            atlasHover = '';
          }}
        >
          <svg
            class="atlas-svg"
            style={`transform:translate(${atlasOffset.x}px,${atlasOffset.y}px)`}
            width={atlasBounds.maxX - atlasBounds.minX}
            height={atlasBounds.maxY - atlasBounds.minY}
            viewBox={`${atlasBounds.minX} ${atlasBounds.minY} ${atlasBounds.maxX - atlasBounds.minX} ${atlasBounds.maxY - atlasBounds.minY}`}
          >
            <image
              href={GALAXY_BG}
              x={-GALAXY_BG_HALF}
              y={-GALAXY_BG_HALF}
              width={GALAXY_BG_SIZE}
              height={GALAXY_BG_SIZE}
              opacity="0.5"
              preserveAspectRatio="none"
            />
            {#each atlasYellow as y}
              <circle cx={y.x} cy={y.y} r="6.5" fill="none" stroke="#3366ff" stroke-width="1.2" />
            {/each}
            {#each atlasStars as s}
              {#if s.friend}
                <circle cx={s.x} cy={s.y} r="5.5" fill="none" stroke="#00ff00" stroke-width="1" />
              {/if}
              {#if s.foe}
                <circle cx={s.x} cy={s.y} r="5.5" fill="none" stroke="#ff0000" stroke-width="1" />
              {/if}
              {#if s.aliance}
                <circle cx={s.x} cy={s.y} r="6.5" fill="none" stroke="#ffff00" stroke-width="1" />
              {/if}
              <circle
                cx={s.x}
                cy={s.y}
                r={starGlowR(s.type)}
                fill={starFill(s.type)}
                opacity="0.35"
              />
              <circle cx={s.x} cy={s.y} r="0.7" fill={starFill(s.type)} />
            {/each}
            {#if atlasHome}
              <circle cx={atlasHome.x} cy={atlasHome.y} r="6.5" fill="none" stroke="#00ff00" stroke-width="1.2" />
            {/if}
            {#if atlasQuest}
              <rect
                x={atlasQuest.x - 4}
                y={atlasQuest.y - 4}
                width="8"
                height="8"
                fill="none"
                stroke="#ffffff"
                stroke-width="1"
              />
            {/if}
            {#if atlasCross}
              <g stroke="var(--neon-cyan)" stroke-width="1.5">
                <line x1={atlasCross.x - 8} y1={atlasCross.y} x2={atlasCross.x + 8} y2={atlasCross.y} />
                <line x1={atlasCross.x} y1={atlasCross.y - 8} x2={atlasCross.x} y2={atlasCross.y + 8} />
              </g>
            {/if}
          </svg>
          {#if atlasHover}
            <div class="atlas-hover">{atlasHover}</div>
          {/if}
        </div>
      </ScifiPanel>
      <ScifiPanel title="Метка" className="col-atlas-side">
        <div class="html-rich detail-body">{@html atlasDesc || 'Кликните по карте'}</div>
        <label class="field">
          Текст метки
          <input class="scifi-input" type="text" bind:value={atlasHint} />
        </label>
        <label class="field">
          Цвет
          <ScifiSelect bind:value={atlasHintType} options={atlasColorOptions} />
        </label>
        <label class="check">
          <input type="checkbox" bind:checked={atlasHintAliance} />
          Видна альянсу
        </label>
        <div class="actions">
          {#if atlasCanCreate}
            <ScifiButton variant="primary" on:click={doHintSave}>Создать</ScifiButton>
          {/if}
          {#if atlasCanClear}
            <ScifiButton variant="danger" on:click={doHintClear}>Очистить</ScifiButton>
          {/if}
        </div>
      </ScifiPanel>

    {:else if activeTab === 'aliance'}
      <ScifiPanel title="Альянсы" className="col-list">
        <div class="table-container">
          <table class="scifi-table">
            <thead>
              <tr><th>Наименование</th><th>Уровень</th></tr>
            </thead>
            <tbody>
              {#each aliances as item, i}
                <tr
                  class:active-row={alianceSelected === i}
                  style={flashColor(item.bgColor) ? `background:${flashColor(item.bgColor)}` : ''}
                  on:click={() => selectAliance(i)}
                >
                  <td>{item.name}</td>
                  <td class="num">{item.level}</td>
                </tr>
              {/each}
            </tbody>
          </table>
        </div>
        <div class="actions wrap">
          {#if alianceFlags.ba1}
            <input class="scifi-input grow" type="text" placeholder="Имя альянса" bind:value={alianceName} />
            <ScifiButton variant="primary" on:click={() => doAlianceOrder('create')}>Создать</ScifiButton>
          {/if}
          {#if alianceFlags.ba2}
            <ScifiButton variant="primary" on:click={() => doAlianceOrder('enter')}>Вступить</ScifiButton>
          {/if}
          {#if alianceFlags.ba3}
            <ScifiButton variant="warn" on:click={() => doAlianceOrder('upgrade')}>Улучшить (5 кр.)</ScifiButton>
          {/if}
          {#if alianceFlags.ba4}
            <ScifiButton variant="ghost" on:click={() => doAlianceOrder('mail')}>Почта</ScifiButton>
          {/if}
          {#if alianceFlags.ba5}
            <ScifiButton variant="danger" on:click={() => doAlianceOrder('leave')}>Покинуть</ScifiButton>
          {/if}
          {#if alianceFlags.ba6}
            <ScifiButton variant="danger" on:click={() => doAlianceOrder('cancel')}>Распустить</ScifiButton>
          {/if}
          {#if alianceFlags.ba7 || alianceFlags.ba4 || alianceSelected >= 0}
            <ScifiButton variant="ghost" on:click={openAlianceDesc}>Описание</ScifiButton>
          {/if}
        </div>
      </ScifiPanel>
      <div class="col-right">
        <ScifiPanel title="Участники" className="col-main">
          <div class="table-container">
            <table class="scifi-table">
              <thead><tr><th>Имя</th></tr></thead>
              <tbody>
                {#each users as item, i}
                  <tr
                    class:active-row={userSelected === i}
                    style={flashColor(item.bgColor) ? `background:${flashColor(item.bgColor)}` : ''}
                    on:click={() => selectUser(i)}
                  >
                    <td>{item.name}</td>
                  </tr>
                {/each}
              </tbody>
            </table>
          </div>
        </ScifiPanel>
        <ScifiPanel title="Действия" className="col-detail">
          <div class="detail-body muted">{alianceDesc ? 'Описание загружено' : 'Выберите альянс'}</div>
          <div class="actions wrap">
            {#if userFlags.bu1}
              <ScifiButton variant="primary" on:click={() => doUserOrder('accept')}>Принять</ScifiButton>
            {/if}
            {#if userFlags.bu2}
              <ScifiButton variant="warn" on:click={() => doUserOrder('delegate')}>Делегировать</ScifiButton>
            {/if}
            {#if userFlags.bu3}
              <ScifiButton variant="ghost" on:click={() => doUserOrder('mail')}>Почта</ScifiButton>
              <ScifiButton variant="ghost" on:click={() => doUserOrder('info')}>Инфо</ScifiButton>
            {/if}
            {#if userFlags.bu4}
              <ScifiButton variant="danger" on:click={() => doUserOrder('decline')}>Отклонить</ScifiButton>
            {/if}
            {#if userFlags.bu5}
              <ScifiButton variant="danger" on:click={() => doUserOrder('kick')}>Исключить</ScifiButton>
            {/if}
          </div>
        </ScifiPanel>
      </div>

    {:else if activeTab === 'hire'}
      <ScifiPanel title="Свободное задание" className="col-hire">
        <div class="hire-meta">
          <span>Кредиты: {hireCred || '—'}</span>
          <span>Конфедераты: {hireConf || '—'}</span>
        </div>
        <label class="field">
          Тип задания
          <ScifiSelect
            bind:value={hireQuest}
            options={hireQuestOptions}
            on:change={onHireQuestChange}
          />
        </label>
        <label class="field">
          Видимость
          <ScifiSelect bind:value={hireVis} options={hireVisOptions} />
        </label>
        <div class="hire-args">
          {#each hireArgs as arg}
            <label class="field">
              {arg.label}
              <input
                class="scifi-input glow-{hireGlow[`arg${arg.i}`] || 'idle'}"
                type="text"
                bind:value={hireVals[arg.i]}
                on:change={() => checkHireField('arg', arg.i)}
              />
            </label>
          {/each}
        </div>
        <div class="hire-money">
          <label class="field">
            Сумма
            <input
              class="scifi-input glow-{hireGlow.money || 'idle'}"
              type="text"
              bind:value={hireSumm}
              on:change={() => checkHireField('money')}
            />
          </label>
          <label class="check">
            <input type="checkbox" bind:checked={hireInConf} on:change={() => checkHireField('money')} />
            Конфедераты
          </label>
          <label class="field">
            Срок (часов)
            <input
              class="scifi-input glow-{hireGlow.time || 'idle'}"
              type="text"
              bind:value={hireTime}
              on:change={() => checkHireField('time')}
            />
          </label>
        </div>
        {#if hireError}
          <div class="hire-error">{@html hireError}</div>
        {/if}
        <div class="actions">
          {#if hireCanSave}
            <ScifiButton variant="primary" on:click={doSaveHire}>Сохранить</ScifiButton>
          {/if}
        </div>
      </ScifiPanel>

    {:else if activeTab === 'robots'}
      <ScifiPanel title="Роботы" className="col-full">
        <div class="table-container">
          <table class="scifi-table">
            <thead>
              <tr>
                <th>Оставшееся время</th>
                <th>Расположение</th>
                <th>Объект</th>
                <th>Координаты</th>
              </tr>
            </thead>
            <tbody>
              {#each robots as item}
                <tr style={flashColor(item.bgColor) ? `background:${flashColor(item.bgColor)}` : ''}>
                  <td>{item.usedTime || ''}</td>
                  <td>{item.place || ''}</td>
                  <td>{item.object || ''}</td>
                  <td class="num">{item.coords || ''}</td>
                </tr>
              {/each}
            </tbody>
          </table>
        </div>
      </ScifiPanel>

    {:else if activeTab === 'top'}
      <div class="top-grid">
        {#each topTables as table}
          <ScifiPanel title={table.title} className="top-card">
            <div class="table-container compact">
              <table class="scifi-table">
                <thead>
                  <tr><th>Имя</th><th class="num">Значение</th></tr>
                </thead>
                <tbody>
                  {#each table.rows as row}
                    <tr class:active-row={row.me}>
                      <td>{row.name}</td>
                      <td class="num">{row.value}</td>
                    </tr>
                  {/each}
                </tbody>
              </table>
            </div>
          </ScifiPanel>
        {/each}
      </div>

    {:else if activeTab === 'settings'}
      <ScifiPanel title="Звук" className="col-settings-side">
        <label class="field">
          Музыка: {settingsMv}
          <input type="range" min="0" max="100" bind:value={settingsMv} on:input={onMusicInput} on:change={onMusicChange} />
        </label>
        <label class="field">
          Звуки: {settingsSv}
          <input type="range" min="0" max="100" bind:value={settingsSv} on:input={onSoundChange} on:change={onSoundChange} />
        </label>
        <div class="actions wrap">
          <ScifiButton variant="primary" on:click={doSaveSettings}>Сохранить</ScifiButton>
          <ScifiButton variant="danger" on:click={doKillUser}>Удалить персонажа</ScifiButton>
        </div>
      </ScifiPanel>
      <ScifiPanel title="Уведомления" className="col-settings-main">
        <div class="settings-list">
          {#each settingsItems as item}
            <div class="settings-row">
              <div class="settings-desc">{item.desc}</div>
              <label class="check"><input type="checkbox" bind:checked={item.chat} /> Чат</label>
              <label class="check"><input type="checkbox" bind:checked={item.mail} /> Почта</label>
            </div>
          {/each}
        </div>
      </ScifiPanel>
    {/if}
  </div>

  {#if alianceDescOpen}
    <div class="scifi-modal-backdrop">
      <div class="scifi-panel scifi-modal">
        <div class="panel-header">Описание альянса</div>
        <div class="panel-content modal-form">
          {#if alianceFlags.ba7}
            <textarea class="scifi-textarea" bind:value={alianceDescEdit}></textarea>
            <div class="actions">
              <ScifiButton variant="primary" on:click={saveAlianceDesc}>OK</ScifiButton>
              <ScifiButton variant="ghost" on:click={() => (alianceDescOpen = false)}>Отмена</ScifiButton>
            </div>
          {:else}
            <div class="html-rich pre-wrap">{alianceDescEdit || '—'}</div>
            <div class="actions">
              <ScifiButton variant="ghost" on:click={() => (alianceDescOpen = false)}>Закрыть</ScifiButton>
            </div>
          {/if}
        </div>
      </div>
    </div>
  {/if}
</div>

<style>
  .misc {
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
    grid-template-columns: var(--layout-side) minmax(0, 1.2fr);
    gap: 10px;
  }

  .layout-atlas {
    grid-template-columns: minmax(0, 1.6fr) minmax(220px, 320px);
  }

  .layout-top {
    grid-template-columns: 1fr;
  }

  .col-right {
    min-height: 0;
    display: grid;
    grid-template-rows: minmax(0, 1fr) auto;
    gap: 10px;
  }

  .col-full,
  .col-hire,
  .col-atlas,
  .col-list,
  .col-detail,
  .col-settings-side,
  .col-settings-main {
    min-height: 0;
  }

  .table-container {
    overflow: auto;
    max-height: 100%;
  }

  .table-container.compact {
    max-height: 220px;
  }

  .detail-body {
    min-height: 120px;
    margin-bottom: 10px;
  }

  .pre-wrap {
    white-space: pre-wrap;
  }

  .muted {
    color: var(--text-muted);
  }

  .actions {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
  }

  .actions.wrap {
    margin-top: 10px;
  }

  .grow {
    flex: 1 1 140px;
  }

  .field {
    display: flex;
    flex-direction: column;
    gap: 4px;
    margin-bottom: 8px;
    color: var(--text-muted);
    font-size: 0.85rem;
  }

  .check {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    margin: 4px 0 10px;
    color: var(--text-main);
    font-size: 0.9rem;
  }

  .hire-meta {
    display: flex;
    gap: 16px;
    margin-bottom: 10px;
    color: var(--text-muted);
    font-size: 0.85rem;
  }

  .hire-args,
  .hire-money {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
    gap: 8px;
  }

  .hire-error {
    margin: 8px 0;
    color: var(--accent-danger);
  }

  .glow-ok {
    box-shadow: 0 0 0 1px var(--neon-cyan), var(--glow-soft);
  }

  .glow-fail {
    box-shadow: 0 0 0 1px var(--accent-danger), 0 0 12px rgba(255, 80, 80, 0.35);
  }

  .glow-idle {
    box-shadow: none;
  }

  .top-grid {
    display: grid;
    grid-template-columns: repeat(4, minmax(0, 1fr));
    gap: 10px;
    min-height: 0;
    overflow: auto;
  }

  .atlas-viewport {
    position: relative;
    height: min(55vh, 480px);
    overflow: hidden;
    border: 1px solid var(--border-light);
    border-radius: var(--radius-panel);
    background: #000;
    cursor: crosshair;
    touch-action: none;
  }

  .atlas-viewport:active {
    cursor: crosshair;
  }

  .atlas-svg {
    position: absolute;
    left: 0;
    top: 0;
    overflow: visible;
  }

  .atlas-hover {
    position: absolute;
    right: 8px;
    top: 8px;
    padding: 2px 8px;
    border-radius: 4px;
    background: rgba(0, 0, 0, 0.55);
    color: var(--neon-cyan);
    font-family: var(--font-mono);
    font-size: 0.75rem;
    pointer-events: none;
  }

  .settings-list {
    display: flex;
    flex-direction: column;
    gap: 8px;
    overflow: auto;
    max-height: 100%;
  }

  .settings-row {
    display: grid;
    grid-template-columns: minmax(0, 1fr) auto auto;
    gap: 10px;
    align-items: center;
    padding: 6px 8px;
    border: 1px solid var(--border-light);
    border-radius: 6px;
    background: rgba(255, 255, 255, 0.02);
  }

  .settings-desc {
    color: var(--text-main);
    font-size: 0.85rem;
  }

  .modal-form {
    display: flex;
    flex-direction: column;
    gap: 10px;
  }

  @media (max-width: 900px) {
    .top-grid {
      grid-template-columns: repeat(2, minmax(0, 1fr));
    }
  }

  @media (max-width: 500px) {
    .layout,
    .layout-atlas {
      grid-template-columns: 1fr;
    }

    .top-grid {
      grid-template-columns: 1fr;
    }

    .settings-row {
      grid-template-columns: 1fr;
    }
  }
</style>
