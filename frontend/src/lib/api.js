export function getNoonConfig() {
  if (typeof window !== 'undefined' && window.__NOON__) {
    return window.__NOON__;
  }
  return { mv: 0, sv: 50 };
}

export function parseVars(text) {
  const out = {};
  text.replace(/&eof=1$/, '').split('&').forEach((pair) => {
    const i = pair.indexOf('=');
    if (i < 0) return;
    const key = pair.slice(0, i);
    const raw = pair.slice(i + 1);
    out[key] = decodeLoadVar(raw);
  });
  return out;
}

function decodeLoadVar(value) {
  const withSpaces = String(value).replace(/\+/g, ' ');
  try {
    return decodeURIComponent(withSpaces);
  } catch {
    return withSpaces.replace(/%([0-9A-Fa-f]{2})/g, (_, hex) =>
      String.fromCharCode(parseInt(hex, 16)),
    );
  }
}

export function parseChatPoll(text) {
  const raw = text.replace(/&eof=1$/, '');
  const data = { err: '1' };
  const errMatch = raw.match(/^err=(\d+)/);
  if (errMatch) data.err = errMatch[1];
  if (data.err !== '0') return data;

  const idMatch = raw.match(/&id=(\d+)/);
  if (idMatch) data.id = idMatch[1];

  const slice = (startKey, endKeys) => {
    const start = raw.indexOf(startKey);
    if (start < 0) return '';
    const from = start + startKey.length;
    let end = raw.length;
    for (const key of endKeys) {
      const idx = raw.indexOf(key, from);
      if (idx >= 0 && idx < end) end = idx;
    }
    return raw.slice(from, end);
  };

  data.msgs = slice('&msgs=', ['&msgp=', '&msgm=', '&users=', '&uh=']);
  data.msgp = slice('&msgp=', ['&msgm=', '&users=', '&uh=']);
  data.msgm = slice('&msgm=', ['&users=', '&uh=']);
  data.users = slice('&users=', ['&uh=']);
  const uhMatch = raw.match(/&uh=([a-f0-9]{32})/i);
  if (uhMatch) data.uh = uhMatch[1];

  return data;
}

function encodeChatText(text) {
  return encodeURIComponent(text).replace(/\+/g, '%u002B');
}

function parseMailRead(text) {
  const raw = text.replace(/&eof=1$/, '');
  const data = { err: '1' };
  const errMatch = raw.match(/^err=(\d+)/);
  if (errMatch) data.err = errMatch[1];
  if (data.err !== '0') return data;

  const textStart = raw.indexOf('&text=');
  if (textStart >= 0) {
    const from = textStart + 6;
    const replyIdx = raw.indexOf('&reply=', from);
    data.text = replyIdx >= 0 ? raw.slice(from, replyIdx) : raw.slice(from);
  }
  if (raw.includes('&reply=1')) data.reply = '1';
  return data;
}

function parseMailList(text) {
  const raw = text.replace(/&eof=1$/, '');
  const data = { err: '1', messages: [] };
  const errMatch = raw.match(/^err=(\d+)/);
  if (errMatch) data.err = errMatch[1];
  if (data.err !== '0') return data;

  const cnt = parseInt((raw.match(/&cnt=(\d+)/) || [])[1] || '0', 10);
  const messages = [];
  for (let i = 0; i < cnt; i++) {
    const id = (raw.match(new RegExp(`&id${i}=([^&]*)`)) || [])[1];
    if (!id) continue;
    messages.push({
      id: parseInt(id, 10),
      read: parseInt((raw.match(new RegExp(`&rd${i}=([^&]*)`)) || [])[1] || '0', 10),
      from: (raw.match(new RegExp(`&from${i}=([^&]*)`)) || [])[1] || '',
      time: (raw.match(new RegExp(`&time${i}=([^&]*)`)) || [])[1] || '',
      preview: (raw.match(new RegExp(`&text${i}=([^&]*)`)) || [])[1] || '',
    });
  }
  data.messages = messages;
  return data;
}

const MAX_CHAT_LINES = 60;

export function mergeChatHtml(prev, chunk) {
  if (!chunk) return prev;
  if (!prev) return chunk;
  const merged = chunk + prev;
  const lines = merged.split('<br>');
  if (lines.length <= MAX_CHAT_LINES) return merged;
  return lines.slice(0, MAX_CHAT_LINES).join('<br>') + (lines[MAX_CHAT_LINES - 1] ? '<br>' : '');
}

export async function pollChat(cid, uh) {
  const rnd = Date.now();
  const res = await fetch(`/reader.php?id=93&cid=${cid}&uh=${encodeURIComponent(uh)}&rnd=${rnd}`, {
    credentials: 'same-origin',
  });
  const text = await res.text();
  return parseChatPoll(text);
}

export async function sendChat(text) {
  const res = await fetch(`/page.php?id=94&text=${encodeChatText(text)}`, {
    credentials: 'same-origin',
  });
  const body = await res.text();
  return parseVars(body);
}

export async function deleteChatMessage(id) {
  const res = await fetch(`/page.php?id=91&del=${encodeURIComponent(id)}`, {
    credentials: 'same-origin',
  });
  await res.text();
}

export async function blockChatUser(id) {
  const res = await fetch(`/page.php?id=91&blk=${encodeURIComponent(id)}`, {
    credentials: 'same-origin',
  });
  await res.text();
}

export async function pollMail(mailId) {
  const ts = Date.now();
  const res = await fetch(`/page.php?id=15&li=${mailId}&p=${ts}`, {
    credentials: 'same-origin',
  });
  const text = await res.text();
  return { data: parseVars(text), ts };
}

export async function listMail() {
  const res = await fetch('/page.php?id=125', { credentials: 'same-origin' });
  return parseMailList(await res.text());
}

export async function readMail(msgid) {
  const res = await fetch(`/page.php?id=126&msgid=${encodeURIComponent(msgid)}`, {
    credentials: 'same-origin',
  });
  return parseMailRead(await res.text());
}

export async function deleteMail(ids) {
  const list = Array.isArray(ids) ? ids : [ids];
  const params = new URLSearchParams();
  params.set('cnt', String(list.length));
  list.forEach((id, i) => params.set(`mid${i}`, String(id)));
  const res = await fetch(`/page.php?id=127&${params}`, { credentials: 'same-origin' });
  return parseVars(await res.text());
}

export async function deleteMailAll() {
  const res = await fetch('/page.php?id=127&all=true', { credentials: 'same-origin' });
  return parseVars(await res.text());
}

export async function checkMailTo(login) {
  const res = await fetch(`/page.php?id=128&user=${encodeURIComponent(login)}`, {
    credentials: 'same-origin',
  });
  return parseVars(await res.text());
}

export async function sendMail(to, text) {
  const params = new URLSearchParams();
  params.set('to', to);
  params.set('text', encodeChatText(text));
  const res = await fetch(`/page.php?id=129&${params}`, { credentials: 'same-origin' });
  return parseVars(await res.text());
}

function encodeLogin(login) {
  return encodeURIComponent(login).replace(/\+/g, '%u002B');
}

function parseAboutInfo(text) {
  const data = parseVars(text);
  if (String(data.err) !== '0') {
    return { ...data, medals: [], available: [] };
  }
  const mcnt = parseInt(data.mcnt || '0', 10);
  const medals = [];
  for (let i = 0; i < mcnt; i++) {
    medals.push({
      mid: data[`mid${i}`],
      name: data[`mn${i}`] || '',
      bgColor: data[`mc${i}`] || '0x000000',
    });
  }
  const acnt = parseInt(data.acnt || '0', 10);
  const available = [];
  for (let i = 0; i < acnt; i++) {
    available.push({
      id: data[`aid${i}`],
      label: data[`an${i}`] || '',
    });
  }
  return { ...data, medals, available };
}

export async function getAboutInfo(login) {
  const res = await fetch(`/page.php?id=19&login=${encodeLogin(login)}`, {
    credentials: 'same-origin',
  });
  return parseAboutInfo(await res.text());
}

export async function setRelation(login, rel) {
  const res = await fetch(
    `/page.php?id=191&rel=${encodeURIComponent(rel)}&login=${encodeLogin(login)}`,
    { credentials: 'same-origin' },
  );
  return parseVars(await res.text());
}

export async function setIgnore(login, ign) {
  const res = await fetch(
    `/page.php?id=193&ign=${encodeURIComponent(ign)}&login=${encodeLogin(login)}`,
    { credentials: 'same-origin' },
  );
  return parseVars(await res.text());
}

export async function setPremium(login, premium) {
  const res = await fetch(
    `/page.php?id=192&premium=${encodeURIComponent(premium)}&login=${encodeLogin(login)}`,
    { credentials: 'same-origin' },
  );
  return parseVars(await res.text());
}

export async function getMedalInfo(mid) {
  const res = await fetch(`/page.php?id=181&mid=${encodeURIComponent(mid)}`, {
    credentials: 'same-origin',
  });
  return parseVars(await res.text());
}

export async function getMedalParam(mid) {
  const res = await fetch(`/page.php?id=182&mid=${encodeURIComponent(mid)}`, {
    credentials: 'same-origin',
  });
  return parseVars(await res.text());
}

export async function medalOrder(ord, mid, login = '', txt = '') {
  let url = `/page.php?id=183&ord=${encodeURIComponent(ord)}&mid=${encodeURIComponent(mid)}`;
  if (ord === '2' || ord === 2) {
    url += `&login=${encodeLogin(login)}&txt=${encodeURIComponent(txt)}`;
  }
  const res = await fetch(url, { credentials: 'same-origin' });
  return parseVars(await res.text());
}

async function fetchPage(id, params = '') {
  const qs = params ? (params.startsWith('&') ? params : `&${params}`) : '';
  const res = await fetch(`/page.php?id=${id}${qs}`, { credentials: 'same-origin' });
  return parseVars(await res.text());
}

function parseIndexedList(data, cntKey, fields) {
  const cnt = parseInt(data[cntKey] || '0', 10);
  const items = [];
  for (let i = 0; i < cnt; i++) {
    const row = {};
    for (const [outKey, inKey] of Object.entries(fields)) {
      const key = typeof inKey === 'function' ? inKey(i) : `${inKey}${i}`;
      if (data[key] !== undefined) row[outKey] = data[key];
    }
    items.push(row);
  }
  return items;
}

export async function getUserInfo() {
  return fetchPage(13);
}

export async function getBooklistHint(name) {
  const res = await fetch(`/page.php?id=8&asc=books_${encodeURIComponent(name)}`, {
    credentials: 'same-origin',
  });
  return parseVars(await res.text());
}

function parseLearnList(text) {
  const data = parseVars(text);
  if (String(data.err) !== '0') return { ...data, items: [] };
  const items = parseIndexedList(data, 'cnt', {
    id: 'id',
    name: 'name',
    level: 'lev',
    time: 'time',
    tp: 'tp',
    inst: 'inst',
  });
  return {
    ...data,
    items,
    lmax: parseInt(data.lmax || '0', 10),
    bid: parseInt(data.bid || '0', 10),
  };
}

export async function listLearn() {
  const res = await fetch('/page.php?id=122', { credentials: 'same-origin' });
  return parseLearnList(await res.text());
}

export async function getBookDesc(bookid) {
  return fetchPage(123, `bookid=${encodeURIComponent(bookid)}`);
}

export async function startLearn(bookId) {
  return fetchPage(124, `book_id=${encodeURIComponent(bookId)}`);
}

function parseQuestList(text) {
  const data = parseVars(text);
  if (String(data.err) !== '0') return { ...data, items: [] };
  const items = parseIndexedList(data, 'cnt', {
    id: 'id',
    name: 'n',
    manual: 'm',
  });
  return {
    ...data,
    items,
    activeIndex: data.p !== undefined ? parseInt(data.p, 10) : -1,
    hidetype: parseInt(data.hidetype || '0', 10),
    decline: data.decline === '1',
  };
}

export async function listQuests() {
  const res = await fetch('/page.php?id=11', { credentials: 'same-origin' });
  return parseQuestList(await res.text());
}

export async function getQuestDesc(qid) {
  return fetchPage(12, `qid=${encodeURIComponent(qid)}`);
}

export async function startQuest(qid) {
  return fetchPage(16, `qid=${encodeURIComponent(qid)}`);
}

export async function stopQuest(qid) {
  return fetchPage(17, `qid=${encodeURIComponent(qid)}`);
}

export async function deleteQuest(qid) {
  return fetchPage(161, `qid=${encodeURIComponent(qid)}`);
}

function parseObjectList(text) {
  const data = parseVars(text);
  if (String(data.err) !== '0') return { ...data, items: [] };
  const items = parseIndexedList(data, 'cnt', {
    id: 'id',
    name: 'n',
    bgColor: 'c',
  });
  return { ...data, items };
}

export async function listObjects() {
  const res = await fetch('/page.php?id=131', { credentials: 'same-origin' });
  return parseObjectList(await res.text());
}

export async function getObjectInfo(oid) {
  return fetchPage(132, `oid=${encodeURIComponent(oid)}`);
}

export async function objectOrder(ord, oid, name = '') {
  let params = `ord=${encodeURIComponent(ord)}&oid=${encodeURIComponent(oid)}`;
  if (name) params += `&name=${encodeURIComponent(name)}`;
  return fetchPage(133, params);
}

export async function setObjectDefence(oid) {
  return fetchPage(134, `oid=${encodeURIComponent(oid)}`);
}

function parseRelationList(text) {
  const data = parseVars(text);
  if (String(data.err) !== '0') {
    return { ...data, friends: [], foes: [], ignores: [] };
  }
  const friends = [];
  const frcnt = parseInt(data.frcnt || '0', 10);
  for (let i = 0; i < frcnt; i++) {
    friends.push({
      login: data[`fr${i}`] || '',
      bgColor: data[`frc${i}`] || '',
    });
  }
  const foes = [];
  const focnt = parseInt(data.focnt || '0', 10);
  for (let i = 0; i < focnt; i++) {
    foes.push({
      login: data[`fo${i}`] || '',
      bgColor: data[`foc${i}`] || '',
    });
  }
  const ignores = [];
  const cicnt = parseInt(data.cicnt || '0', 10);
  for (let i = 0; i < cicnt; i++) {
    ignores.push({
      login: data[`ci${i}`] || '',
      bgColor: data[`cic${i}`] || '',
    });
  }
  return { ...data, friends, foes, ignores };
}

export async function listRelations() {
  const res = await fetch('/page.php?id=151', { credentials: 'same-origin' });
  return parseRelationList(await res.text());
}

function parseEncList(data) {
  const items = parseIndexedList(data, 'cnt', {
    id: 'id',
    name: 'n',
    bgColor: 'c',
  });
  return { ...data, items };
}

export async function listEncyclopedia() {
  return parseEncList(await fetchPage(61));
}

export async function getEncyclopediaDesc(oid) {
  return fetchPage(62, `oid=${encodeURIComponent(oid)}`);
}

function parseAlianceList(data) {
  const items = parseIndexedList(data, 'cnt', {
    id: 'id',
    name: 'n',
    level: 'l',
    own: 'o',
    bgColor: 'c',
  });
  return {
    ...data,
    items,
    ua: parseInt(data.ua || '0', 10),
  };
}

export async function listAliances() {
  return parseAlianceList(await fetchPage(68));
}

export async function getAlianceInfo(aid) {
  return fetchPage(681, `aid=${encodeURIComponent(aid)}`);
}

export async function alianceOrder(ord, aid, extra = '') {
  let params = `ord=${ord}&aid=${encodeURIComponent(aid)}`;
  if (extra) params += extra.startsWith('&') ? extra : `&${extra}`;
  return fetchPage(682, params);
}

function parseAlianceUsers(data) {
  if (String(data.err) === '1') return { ...data, items: [] };
  const items = parseIndexedList(data, 'cnt', {
    id: 'id',
    name: 'n',
    bgColor: 'c',
  });
  return { ...data, items };
}

export async function listAlianceUsers(aid) {
  return parseAlianceUsers(await fetchPage(69, `aid=${encodeURIComponent(aid)}`));
}

export async function getAlianceUserInfo(aid, uid) {
  return fetchPage(691, `aid=${encodeURIComponent(aid)}&uid=${encodeURIComponent(uid)}`);
}

export async function alianceUserOrder(ord, uid) {
  return fetchPage(692, `ord=${encodeURIComponent(ord)}&uid=${encodeURIComponent(uid)}`);
}

function parseRobotsList(data) {
  const items = parseIndexedList(data, 'cnt', {
    id: 'id',
    usedTime: 'ut',
    place: 'pn',
    object: 'on',
    coords: 'xy',
    bgColor: 'c',
  });
  return { ...data, items };
}

export async function listRobots() {
  return parseRobotsList(await fetchPage(64));
}

function parseVolume(raw, fallback) {
  const n = parseInt(raw, 10);
  if (Number.isFinite(n)) return Math.max(0, Math.min(100, n));
  const fb = parseInt(fallback, 10);
  if (Number.isFinite(fb)) return Math.max(0, Math.min(100, fb));
  return 0;
}

export async function getMiscSettings() {
  const data = await fetchPage(66);
  const noon = getNoonConfig();
  const volumes = {
    mv: parseVolume(data.mv, noon.mv),
    sv: parseVolume(data.sv, noon.sv ?? 50),
  };
  if (String(data.err) !== '0') return { ...data, items: [], ...volumes };
  const items = parseIndexedList(data, 'cnt', {
    type: 't',
    desc: 'd',
    chat: 'c',
    mail: 'm',
  });
  return {
    ...data,
    items,
    ...volumes,
  };
}

export async function saveMiscSettings(payload) {
  const parts = [`cnt=${payload.cnt}`, `mv=${payload.mv}`, `sv=${payload.sv}`];
  for (let i = 0; i < payload.cnt; i++) {
    const row = payload.items[i];
    parts.push(`t${i}=${row.type}`);
    parts.push(`c${i}=${row.chat ? 'true' : 'false'}`);
    parts.push(`m${i}=${row.mail ? 'true' : 'false'}`);
  }
  return fetchPage(67, parts.join('&'));
}

export async function saveMusicVolume(mv) {
  return fetchPage(67, `mv=${encodeURIComponent(mv)}`);
}

export function killUserAccount() {
  window.location.href = '/page.php?id=674';
}

function parseHireList(data) {
  if (String(data.err) !== '0') return { ...data, items: [] };
  const items = parseIndexedList(data, 'cnt', {
    id: 'id',
    name: 'n',
    bgColor: 'c',
    enabled: 'en',
  }).map((item) => ({
    ...item,
    name: String(item.name || '')
      .replace(/\s*\(минимум\s+или\s*\)\s*$/i, '')
      .trim(),
  }));
  return {
    ...data,
    items,
    cred: data.cred || '',
    conf: data.conf || '',
  };
}

export async function listHireQuests() {
  return parseHireList(await fetchPage(642));
}

export async function loadHireQuest(qt) {
  return fetchPage(644, `qt=${encodeURIComponent(qt)}`);
}

export async function validateHireField(fi, ft, fv) {
  return fetchPage(
    641,
    `fi=${encodeURIComponent(fi)}&ft=${encodeURIComponent(ft)}&fv=${encodeURIComponent(fv)}`,
  );
}

export async function validateHireQuest(params) {
  return fetchPage(645, params);
}

export async function addHireQuest(params) {
  return fetchPage(643, params);
}

function parseTopTable(raw, meKey) {
  const rows = [];
  const lines = String(raw || '').split('|').filter(Boolean);
  for (let i = 0; i < lines.length; i++) {
    const idx = lines[i].indexOf(':');
    if (idx < 0) continue;
    rows.push({
      name: lines[i].slice(0, idx),
      value: lines[i].slice(idx + 1),
      me: parseInt(meKey, 10) === i,
    });
  }
  return rows;
}

export async function loadTops() {
  const data = await fetchPage(671);
  if (String(data.err) !== '0') {
    return {
      ...data,
      tables: [],
    };
  }
  const defs = [
    { id: 'a', title: 'Абандоны', key: 'at', me: 'atm' },
    { id: 'p', title: 'Пираты', key: 'pt', me: 'ptm' },
    { id: 'm', title: 'Добыча', key: 'mt', me: 'mtm' },
    { id: 'f', title: 'Флот', key: 'ft', me: 'ftm' },
    { id: 't', title: 'Уровень', key: 'tt', me: 'ttm' },
    { id: 'q', title: 'Задания', key: 'qt', me: 'qtm' },
    { id: 'r', title: 'Торговля', key: 'rt', me: 'rtm' },
    { id: 's', title: 'Корабли', key: 'st', me: 'stm' },
  ];
  const tables = defs.map((d) => ({
    ...d,
    rows: parseTopTable(data[d.key], data[d.me]),
  }));
  return { ...data, tables };
}

function parseStarMap(data) {
  if (String(data.err) !== '0') return { ...data, stars: [], yellow: [] };
  const cnt = parseInt(data.cnt || '0', 10);
  const stars = [];
  for (let i = 0; i < cnt; i++) {
    if (data[`st${i}`] === undefined) continue;
    stars.push({
      type: data[`st${i}`],
      x: parseInt(data[`sx${i}`] || '0', 10),
      y: parseInt(data[`sy${i}`] || '0', 10),
      friend: data[`fr${i}`] === '1',
      foe: data[`fo${i}`] === '1',
      aliance: data[`as${i}`] === '1',
    });
  }
  const ycnt = parseInt(data.ycnt || '0', 10);
  const yellow = [];
  for (let i = 0; i < ycnt; i++) {
    yellow.push({
      x: parseInt(data[`ysx${i}`] || '0', 10),
      y: parseInt(data[`ysy${i}`] || '0', 10),
    });
  }
  return {
    ...data,
    stars,
    yellow,
    shx: parseInt(data.shx || '0', 10),
    shy: parseInt(data.shy || '0', 10),
    hstx: data.hstx !== undefined ? parseInt(data.hstx, 10) : null,
    hsty: data.hsty !== undefined ? parseInt(data.hsty, 10) : null,
    quest: data.quest === 'true',
    qsx: data.qsx !== undefined ? parseInt(data.qsx, 10) : null,
    qsy: data.qsy !== undefined ? parseInt(data.qsy, 10) : null,
    desc: data.desc || '',
  };
}

export async function loadStarMap(shid = '') {
  const params = shid ? `shid=${encodeURIComponent(shid)}` : '';
  return parseStarMap(await fetchPage(371, params));
}

export async function getStarCoord(mx, my, shid = '') {
  const parts = [
    `mx=${encodeURIComponent(mx)}`,
    `my=${encodeURIComponent(my)}`,
  ];
  if (shid) parts.push(`shid=${encodeURIComponent(shid)}`);
  return fetchPage(372, parts.join('&'));
}

export async function shipsStarMove({ shid, x, y }) {
  return fetchPage(
    373,
    [
      `shid=${encodeURIComponent(shid)}`,
      `x=${encodeURIComponent(x)}`,
      `y=${encodeURIComponent(y)}`,
    ].join('&'),
  );
}

function parseSystemMap(data) {
  const cnt = parseInt(data.cnt || '0', 10);
  const planets = [];
  for (let i = 0; i < cnt; i++) {
    if (data[`or${i}`] === undefined) continue;
    planets.push({
      orb: parseInt(data[`or${i}`] || '0', 10),
      name: data[`pn${i}`] || '',
      angle: parseInt(data[`an${i}`] || '0', 10),
      type: parseInt(data[`ty${i}`] || '0', 10),
    });
  }
  const fcnt = parseInt(data.fcnt || '0', 10);
  const markers = [];
  for (let i = 0; i < fcnt; i++) {
    markers.push({
      ct: parseInt(data[`ct${i}`] || '0', 10),
      x: parseInt(data[`sx${i}`] || '0', 10),
      y: parseInt(data[`sy${i}`] || '0', 10),
    });
  }
  const bgid = parseInt(data.bgid || '0', 10);
  return {
    ...data,
    sname: data.sname || '',
    stype: parseInt(data.stype || '1', 10),
    bgid,
    bgUrl: `/img/n${String(bgid).padStart(2, '0')}.jpg`,
    pt: parseInt(data.pt || '0', 10),
    arg1: parseInt(data.arg1 || '0', 10),
    arg2: parseInt(data.arg2 || '0', 10),
    planets,
    markers,
    ftxt: data.ftxt || '',
    ok: Boolean(data.sname) || planets.length > 0,
  };
}

export async function loadSystemMap(shid = '') {
  const params = shid ? `shid=${encodeURIComponent(shid)}` : '';
  return parseSystemMap(await fetchPage(37, params));
}

export async function getSystemCoord(mx, my, shid = '') {
  const parts = [
    `mx=${encodeURIComponent(mx)}`,
    `my=${encodeURIComponent(my)}`,
  ];
  if (shid) parts.push(`shid=${encodeURIComponent(shid)}`);
  return fetchPage(38, parts.join('&'));
}

export async function shipsSystemMove({ shid, x, y }) {
  return fetchPage(
    39,
    [
      `shid=${encodeURIComponent(shid)}`,
      `x=${encodeURIComponent(x)}`,
      `y=${encodeURIComponent(y)}`,
    ].join('&'),
  );
}

export async function saveStarHint(x, y, text, type, vis) {
  return fetchPage(
    673,
    `x=${encodeURIComponent(x)}&y=${encodeURIComponent(y)}&text=${encodeURIComponent(text)}&type=${encodeURIComponent(type)}&vis=${vis ? 1 : 0}`,
  );
}

export async function clearStarHint(x, y) {
  return fetchPage(673, `x=${encodeURIComponent(x)}&y=${encodeURIComponent(y)}&clear=1`);
}

function parseWarePlaces(data) {
  const err = data.err !== undefined ? String(data.err) : '0';
  if (err !== '0') return { err, places: [], lastPlace: '' };
  const places = [
    { value: '*', label: 'Все' },
    ...parseIndexedList(data, 'cnt', {
      value: 'id',
      label: 'name',
    }),
  ];
  return {
    err: '0',
    places,
    lastPlace: data.lastPlace || '',
  };
}

export async function loadWarePlaces() {
  return parseWarePlaces(await fetchPage(46));
}

function parseWareShips(data) {
  const ships = parseIndexedList(data, 'cnt', {
    id: 'id',
    name: 'name',
    place: 'place',
    cargo: 'cargo',
    bgColor: 'c',
  });
  return {
    ...data,
    ships,
    pos: data.pos !== undefined ? parseInt(data.pos, 10) : 0,
  };
}

export async function loadWareShips(pl, shid = '') {
  const params = [
    `pl=${encodeURIComponent(pl == null ? '*' : pl)}`,
    `shid=${encodeURIComponent(shid || '')}`,
  ].join('&');
  return parseWareShips(await fetchPage(41, params));
}

function parseWareItems(data) {
  const errKey = data.err !== undefined ? 'err' : data.Err !== undefined ? 'Err' : null;
  if (errKey && String(data[errKey]) !== '0') {
    return { err: String(data[errKey]), items: [], free: '' };
  }
  const items = parseIndexedList(data, 'cnt', {
    id: 'id',
    name: 'n',
    count: 'c',
    mass: 'm',
    bgColor: 't',
  });
  return {
    err: '0',
    items,
    free: data.free || '',
  };
}

function shipSelectParams(rf, shipIds) {
  const ids = Array.isArray(shipIds) ? shipIds.filter(Boolean) : [];
  if (ids.length <= 1) {
    return `rf=${encodeURIComponent(rf)}&shid=${encodeURIComponent(ids[0] || '')}`;
  }
  const parts = [`rf=${encodeURIComponent(rf)}`, `scnt=${ids.length}`];
  ids.forEach((id, i) => parts.push(`sh${i}=${encodeURIComponent(id)}`));
  return parts.join('&');
}

export async function loadWareShipItems(rf, shipIds) {
  return parseWareItems(await fetchPage(42, shipSelectParams(rf, shipIds)));
}

function parseWareSilos(data) {
  const err = data.err !== undefined ? String(data.err) : '0';
  if (err !== '0') return { err, silos: [] };
  const silos = parseIndexedList(data, 'cnt', {
    id: 'id',
    tid: 'tid',
    name: 'name',
    place: 'place',
    cargo: 'cargo',
    bgColor: 'c',
  });
  return { err: '0', silos };
}

export async function loadWareSilos(shipIds) {
  const ids = Array.isArray(shipIds) ? shipIds.filter(Boolean) : [];
  if (!ids.length) return { err: '1', silos: [] };
  if (ids.length === 1) {
    return parseWareSilos(await fetchPage(43, `shid=${encodeURIComponent(ids[0])}`));
  }
  const parts = [`scnt=${ids.length}`];
  ids.forEach((id, i) => parts.push(`sh${i}=${encodeURIComponent(id)}`));
  return parseWareSilos(await fetchPage(43, parts.join('&')));
}

export async function loadWareSiloItems(rf, shid, tid) {
  return parseWareItems(
    await fetchPage(
      44,
      `rf=${encodeURIComponent(rf)}&shid=${encodeURIComponent(shid)}&tid=${encodeURIComponent(tid)}`,
    ),
  );
}

export async function moveWareItem({ shid, plid, tid, oid, ocnt, move }) {
  return fetchPage(
    45,
    [
      `shid=${encodeURIComponent(shid)}`,
      `plid=${encodeURIComponent(plid)}`,
      `tid=${encodeURIComponent(tid)}`,
      `oid=${encodeURIComponent(oid)}`,
      `ocnt=${encodeURIComponent(ocnt)}`,
      `move=${encodeURIComponent(move)}`,
    ].join('&'),
  );
}

export async function moveWareMult({ ships, plid, tid, objects, ocnt, move }) {
  return fetchPage(
    47,
    [
      `ships=${encodeURIComponent(ships)}`,
      `plid=${encodeURIComponent(plid)}`,
      `tid=${encodeURIComponent(tid)}`,
      `objects=${encodeURIComponent(objects)}`,
      `ocnt=${encodeURIComponent(ocnt)}`,
      `move=${encodeURIComponent(move)}`,
    ].join('&'),
  );
}

function parseTradeShips(data) {
  const ships = parseIndexedList(data, 'cnt', {
    id: 'id',
    name: 'name',
    place: 'place',
    cargo: 'cargo',
  });
  return { err: data.err !== undefined ? String(data.err) : '0', ships };
}

function parseTradeBayWare(data) {
  const err = data.err !== undefined ? String(data.err) : '0';
  if (err !== '0') {
    return { err, money: data.money || '', items: [] };
  }
  const items = parseIndexedList(data, 'cnt', {
    id: 'id',
    name: 'n',
    shipCnt: 'sc',
    offerCnt: 'oc',
    price: 'op',
    bgColor: 't',
  });
  return { err: '0', money: data.money || '', items };
}

function parseTradeSellWare(data) {
  const err = data.err !== undefined ? String(data.err) : '0';
  if (err !== '0') {
    return { err, money: data.money || '', items: [] };
  }
  const items = parseIndexedList(data, 'cnt', {
    id: 'id',
    name: 'n',
    shipCnt: 'sc',
    demandCnt: 'ic',
    price: 'ip',
    bgColor: 't',
  });
  return { err: '0', money: data.money || '', items };
}

export async function loadTradeComp({ min = 1, rf = '0', oid = '' } = {}) {
  const parts = [`rf=${encodeURIComponent(rf)}`];
  if (oid) {
    parts.push(`oid=${encodeURIComponent(oid)}`);
  } else {
    parts.push(`min=${encodeURIComponent(min)}`);
  }
  const data = await fetchPage(63, parts.join('&'));
  const items = parseIndexedList(data, 'cnt', {
    id: 'id',
    name: 'n',
    sellPrice: 'bm',
    sellCnt: 'bc',
    sellStar: 'bs',
    sellLogin: 'bl',
    buyPrice: 'sm',
    buyCnt: 'sc',
    buyStar: 'ss',
    buyLogin: 'sl',
    bgColor: 'c',
  });
  return { err: data.err !== undefined ? String(data.err) : '0', items };
}

export async function loadTradeBayShips() {
  return parseTradeShips(await fetchPage(55));
}

export async function loadTradeSellShips() {
  return parseTradeShips(await fetchPage(56));
}

export async function loadTradeBayWare(shid) {
  return parseTradeBayWare(await fetchPage(57, `shid=${encodeURIComponent(shid)}`));
}

export async function loadTradeSellWare(shid) {
  return parseTradeSellWare(await fetchPage(58, `shid=${encodeURIComponent(shid)}`));
}

export async function tradeBay({ shid, oid, ocnt }) {
  return fetchPage(
    53,
    [
      `shid=${encodeURIComponent(shid)}`,
      `oid=${encodeURIComponent(oid)}`,
      `ocnt=${encodeURIComponent(ocnt)}`,
    ].join('&'),
  );
}

export async function tradeSell({ shid, oid, ocnt }) {
  return fetchPage(
    54,
    [
      `shid=${encodeURIComponent(shid)}`,
      `oid=${encodeURIComponent(oid)}`,
      `ocnt=${encodeURIComponent(ocnt)}`,
    ].join('&'),
  );
}

export async function loadTradeConfList() {
  const data = await fetchPage(65);
  const items = parseIndexedList(data, 'cnt', {
    id: 'id',
    name: 'n',
    bgColor: 'c',
  });
  return { err: data.err !== undefined ? String(data.err) : '0', items };
}

export async function loadTradeConfDesc(oid) {
  const data = await fetchPage(651, `oid=${encodeURIComponent(oid)}`);
  const err = data.err !== undefined ? String(data.err) : '0';
  if (err !== '0') {
    return { err, desc: '', money: '', conf: '', price: '', confPrice: '', canBuyMoney: false, canBuyConf: false };
  }
  return {
    err: '0',
    desc: data.desc || '',
    money: data.money || '',
    conf: data.conf || '',
    price: data.pr || '',
    confPrice: data.cp || '',
    canBuyMoney: String(data.bb) === '1',
    canBuyConf: String(data.cb) === '1',
  };
}

export async function tradeConfBay({ tp, oid, ocnt }) {
  return fetchPage(
    652,
    [
      `tp=${encodeURIComponent(tp)}`,
      `oid=${encodeURIComponent(oid)}`,
      `ocnt=${encodeURIComponent(ocnt)}`,
    ].join('&'),
  );
}

function parseShipsPlaces(data) {
  const err = data.err !== undefined ? String(data.err) : '0';
  if (err !== '0') {
    return { err, places: [{ value: '*', label: 'Все' }], lastPlace: '', others: false };
  }
  const places = [
    { value: '*', label: 'Все' },
    ...parseIndexedList(data, 'cnt', {
      value: 'id',
      label: 'name',
    }),
  ];
  return {
    err: '0',
    places,
    lastPlace: data.lastPlace || '',
    others: data.others !== undefined ? String(data.others) !== '0' : false,
  };
}

export async function loadShipsPlaces() {
  return parseShipsPlaces(await fetchPage(311));
}

function parseShipsList(data) {
  const err = data.err !== undefined ? String(data.err) : '0';
  const ships = parseIndexedList(data, 'cnt', {
    id: 'id',
    name: 'name',
    place: 'place',
    group: 'group',
    bgColor: 'c',
    tp: 'tp',
    cnt: 'cnt',
  }).map((row) => ({
    ...row,
    tp: row.tp !== undefined && row.tp !== '' && !Number.isNaN(Number(row.tp)) ? Number(row.tp) : null,
    cnt: row.cnt !== undefined ? Number(row.cnt) : null,
  }));
  return {
    err,
    ships,
    fid: data.fid || '',
  };
}

export async function loadShipsList({ oth, pl, ord } = {}) {
  const parts = [
    `oth=${oth ? 'true' : 'false'}`,
    `pl=${encodeURIComponent(pl == null ? '*' : pl)}`,
  ];
  if (ord === 0 || ord === 1 || ord === '0' || ord === '1') {
    parts.push(`ord=${encodeURIComponent(ord)}`);
  }
  return parseShipsList(await fetchPage(31, parts.join('&')));
}

export async function loadShipsOrders(shid) {
  const data = await fetchPage(32, `shid=${encodeURIComponent(shid)}`);
  const orders = [
    { value: '100', label: 'Выберите приказ' },
    ...parseIndexedList(data, 'cnt', {
      value: 'id',
      label: 'name',
    }),
  ];
  return { err: data.err !== undefined ? String(data.err) : '0', orders };
}

export async function loadShipsFleetOrders(shipIds) {
  const ids = Array.isArray(shipIds) ? shipIds.filter(Boolean) : [];
  const parts = [`cnt=${ids.length}`];
  ids.forEach((id, i) => parts.push(`sh${i}=${encodeURIComponent(id)}`));
  const data = await fetchPage(34, parts.join('&'));
  const orders = [
    { value: '100', label: 'Выберите приказ' },
    ...parseIndexedList(data, 'cnt', {
      value: 'id',
      label: 'name',
    }),
  ];
  return { err: data.err !== undefined ? String(data.err) : '0', orders };
}

export async function loadShipsInfo(shid) {
  const data = await fetchPage(36, `shid=${encodeURIComponent(shid)}`);
  return {
    err: data.err !== undefined ? String(data.err) : '0',
    out: data.out || '',
    info: data.info || '',
    pic: data.pic || '',
  };
}

export async function loadShipsItems(shid) {
  const data = await fetchPage(321, `shid=${encodeURIComponent(shid)}`);
  const err = data.err !== undefined ? String(data.err) : '0';
  if (err !== '0') return { err, items: [] };
  const items = parseIndexedList(data, 'cnt', {
    name: 'n',
    count: 'c',
    mass: 'm',
    bgColor: 't',
  });
  return { err: '0', items };
}

export async function loadShipsFleetList(shid) {
  const data = await fetchPage(352, `shid=${encodeURIComponent(shid)}`);
  const err = data.err !== undefined ? String(data.err) : '0';
  if (err !== '0') return { err, ships: [], ms: '' };
  const ships = parseIndexedList(data, 'cnt', {
    id: 'id',
    name: 'n',
  });
  return { err: '0', ships, ms: data.ms || '' };
}

export async function loadShipsFleetOrderList(shid) {
  const data = await fetchPage(354, `shid=${encodeURIComponent(shid)}`);
  const err = data.err !== undefined ? String(data.err) : '0';
  if (err !== '0') return { err, ships: [], ms: '' };
  const ships = parseIndexedList(data, 'cnt', {
    id: 'id',
    name: 'n',
  });
  return { err: '0', ships, ms: data.ms || '' };
}

export async function loadShipsInterruptMsg(shid) {
  const data = await fetchPage(374, `shid=${encodeURIComponent(shid)}`);
  const err = data.err !== undefined ? String(data.err) : '0';
  return { err, msg: err === '0' ? data.msg || '' : '' };
}

function shipsSelectParams(shipIds) {
  const ids = Array.isArray(shipIds) ? shipIds.filter(Boolean) : [];
  const parts = [`cnt=${ids.length}`];
  ids.forEach((id, i) => parts.push(`sh${i}=${encodeURIComponent(id)}`));
  return parts.join('&');
}

export async function shipsMakeOrder({ shid, orid, nname, gname, msg }) {
  const parts = [`shid=${encodeURIComponent(shid)}`, `orid=${encodeURIComponent(orid)}`];
  if (nname !== undefined) parts.push(`nname=${encodeURIComponent(nname)}`);
  if (gname !== undefined) parts.push(`gname=${encodeURIComponent(gname)}`);
  if (msg !== undefined) parts.push(`msg=${encodeURIComponent(msg)}`);
  return fetchPage(33, parts.join('&'));
}

export async function shipsMakeAttack({ shid, orid }) {
  return fetchPage(
    331,
    `shid=${encodeURIComponent(shid)}&orid=${encodeURIComponent(orid)}`,
  );
}

export async function shipsMakeFleet(shipIds) {
  return fetchPage(35, shipsSelectParams(shipIds));
}

export async function shipsFleetAttack(shipIds) {
  return fetchPage(351, shipsSelectParams(shipIds));
}

export async function shipsFleetOff({ fid, shipIds }) {
  const ids = Array.isArray(shipIds) ? shipIds.filter(Boolean) : [];
  const parts = [`cnt=${ids.length}`, `fid=${encodeURIComponent(fid)}`];
  ids.forEach((id, i) => parts.push(`sh${i}=${encodeURIComponent(id)}`));
  return fetchPage(353, parts.join('&'));
}

export async function shipsFleetSet({ set, shipIds }) {
  const ids = Array.isArray(shipIds) ? shipIds.filter(Boolean) : [];
  const parts = [`cnt=${ids.length}`, `set=${encodeURIComponent(set)}`];
  ids.forEach((id, i) => parts.push(`sh${i}=${encodeURIComponent(id)}`));
  return fetchPage(355, parts.join('&'));
}

export async function shipsDeconserv({ shid, cnt, gname }) {
  return fetchPage(
    391,
    [
      `shid=${encodeURIComponent(shid)}`,
      `cnt=${encodeURIComponent(cnt)}`,
      `gname=${encodeURIComponent(gname || '')}`,
    ].join('&'),
  );
}

async function fetchWo(id, params = '') {
  const qs = params ? (params.startsWith('&') ? params : `&${params}`) : '';
  const res = await fetch(`/wo.php?id=${id}${qs}`, { credentials: 'same-origin' });
  return parseVars(await res.text());
}

function parseWarSide(data, prefix, cntKey) {
  const cnt = parseInt(data[cntKey] || '0', 10);
  const items = [];
  for (let i = 0; i < cnt; i++) {
    items.push({
      id: data[`${prefix}id${i}`] || '',
      name: data[`${prefix}name${i}`] || '',
      count: data[`${prefix}c${i}`] || '',
      shield: data[`${prefix}sh${i}`] || '',
      shieldTot: data[`${prefix}st${i}`] || '',
      pic: data[`${prefix}pc${i}`] || '',
    });
  }
  return items;
}

export async function loadWarStart(wid) {
  const data = await fetchWo(361, `wid=${encodeURIComponent(wid)}`);
  const err = data.err !== undefined ? String(data.err) : '0';
  if (err !== '0') {
    return { err, side: '0', lastMove: '0', placeHash: '', near: [], far: [] };
  }
  return {
    err: '0',
    side: data.side !== undefined ? String(data.side) : '0',
    lastMove: data.lm !== undefined ? String(data.lm) : '0',
    placeHash: data.ph || '',
    near: parseWarSide(data, 'n', 'ncnt'),
    far: parseWarSide(data, 'f', 'fcnt'),
  };
}

export async function loadWarRead({ wi, lm, sd }) {
  const data = await fetchWo(
    362,
    [
      `wi=${encodeURIComponent(wi)}`,
      `lm=${encodeURIComponent(lm)}`,
      `sd=${encodeURIComponent(sd)}`,
    ].join('&'),
  );
  const err = data.err !== undefined ? String(data.err) : '0';
  const cnt = parseInt(data.cnt || '0', 10);
  const shots = [];
  for (let i = 0; i < cnt; i++) {
    if (data[`l${i}`] !== undefined) shots.push(data[`l${i}`]);
  }
  return {
    err,
    reload: String(data.reload || '') === 'true',
    lastMove: data.lm !== undefined ? String(data.lm) : String(lm),
    shots,
  };
}

function parseStationLots(data) {
  const rows = parseInt(data.rows || '0', 10);
  const lots = [];
  for (let i = 0; i < rows; i++) {
    lots.push({
      id: data[`l${i}c0`] || '',
      name: data[`l${i}c1`] || '',
      buyCnt: data[`l${i}c2`] || '',
      buyPrice: data[`l${i}c3`] || '',
      sellCnt: data[`l${i}c4`] || '',
      sellPrice: data[`l${i}c5`] || '',
      min: data[`l${i}c6`] || '',
      avg: data[`l${i}c7`] || '',
      max: data[`l${i}c8`] || '',
      bgColor: data[`l${i}c9`] || '',
    });
  }
  return { lots, rows };
}

export async function loadStationLots(rf = '') {
  const params = rf !== '' && rf !== undefined ? `rf=${encodeURIComponent(rf)}` : '';
  const data = await fetchPage(23, params);
  return { ...data, ...parseStationLots(data), ok: data.rows !== undefined };
}

export async function loadStationGoods(rf = '') {
  const params = rf !== '' && rf !== undefined ? `rf=${encodeURIComponent(rf)}` : '';
  const data = await fetchPage(233, params);
  const err = data.err !== undefined ? String(data.err) : '';
  if (err !== '0') {
    return { err: err || '1', items: [], ok: false };
  }
  const items = parseIndexedList(data, 'cnt', {
    id: 'id',
    name: 'name',
    bgColor: 'c',
  });
  return { ...data, err: '0', items, ok: true };
}

export async function loadStationTradeInfo(oid) {
  const data = await fetchPage(231, `oid=${encodeURIComponent(oid)}`);
  const err = data.err !== undefined ? String(data.err) : '1';
  if (err !== '0') {
    return {
      err,
      money: '',
      maxcnt: '0',
      canbay: false,
      cansell: false,
    };
  }
  return {
    err: '0',
    money: data.money || '',
    maxcnt: data.maxcnt !== undefined ? String(data.maxcnt) : '0',
    canbay: String(data.canbay || '') === '1',
    cansell: String(data.cansell || '') === '1',
    i_min: data.i_min || '',
    i_avg: data.i_avg || '',
    i_max: data.i_max || '',
    i_cnt: data.i_cnt || '0',
    i_price: data.i_price || '0',
    o_min: data.o_min || '',
    o_avg: data.o_avg || '',
    o_max: data.o_max || '',
    o_cnt: data.o_cnt || '0',
    o_price: data.o_price || '0',
  };
}

export async function saveStationTrade({ oid, iprice, icnt, oprice, ocnt }) {
  const data = await fetchPage(
    232,
    [
      `oid=${encodeURIComponent(oid)}`,
      `iprice=${encodeURIComponent(iprice ?? '0')}`,
      `icnt=${encodeURIComponent(icnt ?? '0')}`,
      `oprice=${encodeURIComponent(oprice ?? '0')}`,
      `ocnt=${encodeURIComponent(ocnt ?? '0')}`,
    ].join('&'),
  );
  return { err: data.err !== undefined ? String(data.err) : '1' };
}
