export const CARD_BASE_W = 300;
export const CARD_BASE_H = 200;
export const DESIGN_W = 685;
export const DESIGN_H = 600;

const ORBIT_BUILDING_PIC = {
  3007: 'orbit/bldV.png',
  3008: 'orbit/bldX.png',
  3009: 'orbit/bldY.png',
};

const PLANET_BUILDING_PIC = {
  27: 'planet/bldD.png',
  28: 'planet/bldH.png',
  29: 'planet/bldJ.png',
  30: 'planet/bldN.png',
  31: 'planet/bldU.png',
};

function warUnitKind(id) {
  const kind = String(id || '').charAt(1);
  return kind === 's' || kind === 'o' || kind === 'p' ? kind : '';
}

function warUnitObjectId(id) {
  const kind = warUnitKind(id);
  if (!kind) return null;
  const n = parseInt(String(id).slice(2), 10);
  return Number.isFinite(n) ? n : null;
}

function buildingPicPath(pic) {
  if (!pic) return '';
  if (pic.includes('/')) {
    const path = pic.endsWith('.png') ? pic : `${pic}.png`;
    return `/app/img/${path}`;
  }
  return '';
}

export function warUnitPic(unit, side) {
  const pic = unit?.pic ? String(unit.pic) : '';
  const buildingPath = buildingPicPath(pic);
  if (buildingPath) return buildingPath;

  if (pic.startsWith('n') || pic.startsWith('f')) {
    return `/img/ships/${pic}.png`;
  }

  if (pic) {
    const prefix = side === 'near' ? 'n' : 'f';
    return `/img/ships/${prefix}${pic}.png`;
  }

  const kind = warUnitKind(unit?.id);
  const objectId = warUnitObjectId(unit?.id);
  if (kind === 'o' && objectId && ORBIT_BUILDING_PIC[objectId]) {
    return `/app/img/${ORBIT_BUILDING_PIC[objectId]}`;
  }
  if (kind === 'p' && objectId && PLANET_BUILDING_PIC[objectId]) {
    return `/app/img/${PLANET_BUILDING_PIC[objectId]}`;
  }

  return side === 'near' ? '/img/ships/nFighter.png' : '/img/ships/fFighter.png';
}

function triangleRows(count) {
  const rows = [];
  let left = count;
  let rowSize = 1;
  while (left > 0) {
    rows.push(Math.min(rowSize, left));
    left -= rows[rows.length - 1];
    rowSize += 1;
  }
  return rows;
}

function lineCount(count) {
  if (count <= 0) return 0;
  return triangleRows(count).length;
}

function layoutSide(units, side, fMag, lineCorrection) {
  const count = units.length;
  if (!count) return [];

  const rows = triangleRows(count);
  const cardW = CARD_BASE_W * fMag;
  const cardH = CARD_BASE_H * fMag;
  const cards = [];
  let unitIdx = 0;

  for (let t = 0; t < rows.length; t++) {
    const rowCount = rows[t];
    const yStart = DESIGN_H / 2 - (rowCount * cardH) / 2;

    for (let i = 0; i < rowCount && unitIdx < count; i++) {
      const unit = units[unitIdx];
      let x;
      const y = yStart + i * cardH;
      if (side === 'near') {
        x = 300 - t * cardW - cardW - lineCorrection * cardW;
      } else {
        x = 350 + t * cardW + lineCorrection * cardW;
      }
      cards.push({
        ...unit,
        side,
        x,
        y,
        w: cardW,
        h: cardH,
        key: unit.id,
      });
      unitIdx += 1;
    }
  }
  return cards;
}

function scaleCard(card, scaleX, scaleY) {
  return {
    ...card,
    x: card.x * scaleX,
    y: card.y * scaleY,
    w: card.w * scaleX,
    h: card.h * scaleY,
  };
}

export function layoutWarBattle(nearUnits, farUnits, viewportW, viewportH) {
  const nearN = nearUnits?.length || 0;
  const farN = farUnits?.length || 0;
  const nearLines = lineCount(nearN) || 1;
  const farLines = lineCount(farN) || 1;
  const maxLines = Math.max(nearLines, farLines, 1);

  const fMag = maxLines > 1 ? 1 / maxLines : 1;

  let nearCorrection = 0;
  let farCorrection = 0;
  if (nearLines > farLines) farCorrection = nearLines - farLines;
  else nearCorrection = farLines - nearLines;

  const fieldW = Math.max(1, viewportW);
  const fieldH = Math.max(1, viewportH);
  const scaleX = fieldW / DESIGN_W;
  const scaleY = fieldH / DESIGN_H;

  const near = layoutSide(nearUnits || [], 'near', fMag, nearCorrection).map((c) =>
    scaleCard(c, scaleX, scaleY)
  );
  const far = layoutSide(farUnits || [], 'far', fMag, farCorrection).map((c) =>
    scaleCard(c, scaleX, scaleY)
  );

  return {
    near,
    far,
    cards: [...near, ...far],
    fMag,
    scaleX,
    scaleY,
    fieldW,
    fieldH,
  };
}

export function cardById(cards, id) {
  return cards.find((c) => c.id === id) || null;
}

export function fireOrigin(card) {
  if (!card) return null;
  if (card.side === 'near') {
    return { x: card.x + card.w, y: card.y + card.h / 2 };
  }
  return { x: card.x, y: card.y + card.h / 2 };
}

export function fireTarget(card, fromNear) {
  if (!card) return null;
  let x;
  const y = card.y + card.h / 2;
  if (fromNear) {
    x = card.x + card.w / 3;
  } else {
    x = card.x + (card.w * 2) / 3;
  }
  return { x, y };
}

export function voidTarget(fromNear, fieldW = DESIGN_W, fieldH = DESIGN_H) {
  if (fromNear) return { x: (530 / DESIGN_W) * fieldW, y: fieldH / 2 };
  return { x: (130 / DESIGN_W) * fieldW, y: fieldH / 2 };
}

export function parseWarShot(raw) {
  const parts = String(raw).split(':');
  if (parts.length < 7) return null;
  return {
    attackerId: parts[0],
    defenderId: parts[2],
    wType: parseInt(parts[4], 10) || 0,
    defeat: parseInt(parts[5], 10),
    power: parseInt(parts[6], 10) || 0,
    raw,
  };
}

export function shieldFillPct(shield, shieldTot) {
  const cur = parseInt(shield, 10) || 0;
  const tot = parseInt(shieldTot, 10) || 0;
  if (tot <= 0) return 0;
  return Math.max(0, Math.min(100, (cur / tot) * 100));
}
