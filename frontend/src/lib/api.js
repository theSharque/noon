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
    out[pair.slice(0, i)] = pair.slice(i + 1);
  });
  return out;
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
  const res = await fetch(`reader.php?id=93&cid=${cid}&uh=${encodeURIComponent(uh)}&rnd=${rnd}`, {
    credentials: 'same-origin',
  });
  const text = await res.text();
  return parseChatPoll(text);
}

export async function sendChat(text) {
  const res = await fetch(`page.php?id=94&text=${encodeChatText(text)}`, {
    credentials: 'same-origin',
  });
  const body = await res.text();
  return parseVars(body);
}

export async function deleteChatMessage(id) {
  const res = await fetch(`page.php?id=91&del=${encodeURIComponent(id)}`, {
    credentials: 'same-origin',
  });
  await res.text();
}

export async function blockChatUser(id) {
  const res = await fetch(`page.php?id=91&blk=${encodeURIComponent(id)}`, {
    credentials: 'same-origin',
  });
  await res.text();
}

export async function pollMail(mailId) {
  const ts = Date.now();
  const res = await fetch(`page.php?id=15&li=${mailId}&p=${ts}`, {
    credentials: 'same-origin',
  });
  const text = await res.text();
  return { data: parseVars(text), ts };
}

export async function listMail() {
  const res = await fetch('page.php?id=125', { credentials: 'same-origin' });
  return parseMailList(await res.text());
}

export async function readMail(msgid) {
  const res = await fetch(`page.php?id=126&msgid=${encodeURIComponent(msgid)}`, {
    credentials: 'same-origin',
  });
  return parseMailRead(await res.text());
}

export async function deleteMail(ids) {
  const list = Array.isArray(ids) ? ids : [ids];
  const params = new URLSearchParams();
  params.set('cnt', String(list.length));
  list.forEach((id, i) => params.set(`mid${i}`, String(id)));
  const res = await fetch(`page.php?id=127&${params}`, { credentials: 'same-origin' });
  return parseVars(await res.text());
}

export async function deleteMailAll() {
  const res = await fetch('page.php?id=127&all=true', { credentials: 'same-origin' });
  return parseVars(await res.text());
}

export async function checkMailTo(login) {
  const res = await fetch(`page.php?id=128&user=${encodeURIComponent(login)}`, {
    credentials: 'same-origin',
  });
  return parseVars(await res.text());
}

export async function sendMail(to, text) {
  const params = new URLSearchParams();
  params.set('to', to);
  params.set('text', encodeChatText(text));
  const res = await fetch(`page.php?id=129&${params}`, { credentials: 'same-origin' });
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
  const res = await fetch(`page.php?id=19&login=${encodeLogin(login)}`, {
    credentials: 'same-origin',
  });
  return parseAboutInfo(await res.text());
}

export async function setRelation(login, rel) {
  const res = await fetch(
    `page.php?id=191&rel=${encodeURIComponent(rel)}&login=${encodeLogin(login)}`,
    { credentials: 'same-origin' },
  );
  return parseVars(await res.text());
}

export async function setIgnore(login, ign) {
  const res = await fetch(
    `page.php?id=193&ign=${encodeURIComponent(ign)}&login=${encodeLogin(login)}`,
    { credentials: 'same-origin' },
  );
  return parseVars(await res.text());
}

export async function setPremium(login, premium) {
  const res = await fetch(
    `page.php?id=192&premium=${encodeURIComponent(premium)}&login=${encodeLogin(login)}`,
    { credentials: 'same-origin' },
  );
  return parseVars(await res.text());
}

export async function getMedalInfo(mid) {
  const res = await fetch(`page.php?id=181&mid=${encodeURIComponent(mid)}`, {
    credentials: 'same-origin',
  });
  return parseVars(await res.text());
}

export async function getMedalParam(mid) {
  const res = await fetch(`page.php?id=182&mid=${encodeURIComponent(mid)}`, {
    credentials: 'same-origin',
  });
  return parseVars(await res.text());
}

export async function medalOrder(ord, mid, login = '', txt = '') {
  let url = `page.php?id=183&ord=${encodeURIComponent(ord)}&mid=${encodeURIComponent(mid)}`;
  if (ord === '2' || ord === 2) {
    url += `&login=${encodeLogin(login)}&txt=${encodeURIComponent(txt)}`;
  }
  const res = await fetch(url, { credentials: 'same-origin' });
  return parseVars(await res.text());
}
