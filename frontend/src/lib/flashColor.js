export function parseFlashHex(hex) {
  const raw = String(hex || '')
    .replace(/^0x/i, '')
    .replace(/^#/, '');
  if (!/^[0-9a-fA-F]{6}$/.test(raw)) return null;
  return {
    raw: raw.toUpperCase(),
    r: parseInt(raw.slice(0, 2), 16),
    g: parseInt(raw.slice(2, 4), 16),
    b: parseInt(raw.slice(4, 6), 16),
  };
}

export function flashColor(hex, alpha = 0.5) {
  const c = parseFlashHex(hex);
  if (!c) return null;
  return `rgba(${c.r}, ${c.g}, ${c.b}, ${alpha})`;
}

export function flashBgStyle(hex, alpha = 0.5) {
  const c = parseFlashHex(hex);
  if (!c || c.raw === '000000') return '';
  return `background:rgba(${c.r}, ${c.g}, ${c.b}, ${alpha})`;
}

export function flashTextColor(hex) {
  const c = parseFlashHex(hex);
  if (!c) return null;
  let { r, g, b } = c;
  const max = Math.max(r, g, b);
  if (max > 0 && max < 120) {
    const k = 200 / max;
    r = Math.min(255, Math.round(r * k));
    g = Math.min(255, Math.round(g * k));
    b = Math.min(255, Math.round(b * k));
  }
  if (b > 150 && b > r * 2 && b > g * 2) {
    return 'rgb(0, 229, 255)';
  }
  return `rgb(${r}, ${g}, ${b})`;
}

export function flashTextStyle(hex) {
  const color = flashTextColor(hex);
  return color ? `color:${color}` : '';
}
