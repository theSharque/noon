function formatEncLinkTable(html, title, mode) {
  const idx = html.indexOf(title);
  if (idx < 0) return html;
  const afterTitle = idx + title.length;
  let pos = afterTitle;
  while (pos < html.length && (html[pos] === '\n' || html[pos] === '\r')) pos += 1;

  const qtyFirst = /^(\d+)\t+<u><a href='([^']*)'>([^<]*)<\/a><\/u>\n?/;
  const nameFirst = /^<u><a href='([^']*)'>([^<]*)<\/a><\/u>\t*(\d+)\n?/;

  const rows = [];
  let cursor = pos;
  while (cursor < html.length) {
    const rest = html.slice(cursor);
    if (rest.startsWith('\n')) break;
    const m = mode === 'name-first' ? rest.match(nameFirst) : rest.match(qtyFirst);
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

function formatEncNameNumTable(html, title) {
  const idx = html.indexOf(title);
  if (idx < 0) return html;
  let pos = idx + title.length;
  while (pos < html.length && (html[pos] === '\n' || html[pos] === '\r')) pos += 1;

  const rows = [];
  let cursor = pos;
  while (cursor < html.length) {
    const rest = html.slice(cursor);
    if (rest.startsWith('\n')) break;
    const m = rest.match(/^([^\t\n]+)\t+(\d+)\n?/);
    if (!m) break;
    rows.push({ name: m[1].trim(), qty: m[2] });
    cursor += m[0].length;
  }
  if (!rows.length) return html;

  const body = rows
    .map((r) => `<tr><td class="enc-qty">${r.qty}</td><td>${r.name}</td></tr>`)
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

export function formatEncHtml(raw) {
  let html = String(raw || '');
  html = formatEncLinkTable(html, 'Для изготовления необходимо:', 'qty-first');
  html = formatEncLinkTable(html, 'Используется при постройке:', 'qty-first');
  html = formatEncLinkTable(html, 'Содержится в минералах:', 'name-first');
  html = formatEncLinkTable(html, 'Содержит полезные ископаемые:', 'name-first');
  html = formatEncNameNumTable(html, 'Сводная таблица распространенности материалов:');
  html = formatEncKvTable(html, 'ТТХ корабля:');
  return html;
}

export function encHtmlLinkTarget(href) {
  const m = String(href || '').match(/page\.php\?id=6(?:%26|&)itm=([^&'"]+)/i);
  if (!m) return null;
  return decodeURIComponent(m[1].replace(/\+/g, ' '));
}
