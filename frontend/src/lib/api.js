export function getNoonConfig() {
  if (typeof window !== 'undefined' && window.__NOON__) {
    return window.__NOON__;
  }
  return { mv: 50, sv: 50 };
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
