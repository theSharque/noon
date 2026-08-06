async function adminRequest(id, params = {}, method = 'GET') {
  const url = new URL('/page.php', window.location.origin);
  url.searchParams.set('id', String(id));
  const opts = { credentials: 'include', method };

  if (method === 'GET') {
    for (const [key, value] of Object.entries(params)) {
      if (value !== undefined && value !== null && value !== '') {
        url.searchParams.set(key, String(value));
      }
    }
  } else {
    opts.headers = { 'Content-Type': 'application/x-www-form-urlencoded' };
    const body = new URLSearchParams();
    for (const [key, value] of Object.entries(params)) {
      if (value !== undefined && value !== null) {
        body.set(key, String(value));
      }
    }
    opts.body = body.toString();
  }

  const res = await fetch(url, opts);
  if (res.status === 404) {
    const err = new Error('not_found');
    err.status = 404;
    throw err;
  }
  return res.json();
}

export function adminMe() {
  return adminRequest(990);
}

export function adminUser(login, params = {}) {
  return adminRequest(980, { login, ...params });
}

export function adminUsersRecent() {
  return adminRequest(980, { act: 'recent' });
}

export function adminUserAction(login, act, params = {}) {
  return adminRequest(980, { login, act, ...params }, 'POST');
}

export function adminLog(login, params = {}) {
  return adminRequest(999, { login, ...params }, 'POST');
}

export function adminStats(section = 'all') {
  return adminRequest(993, { section });
}

export function adminRecalcPrice() {
  return adminRequest(995, {}, 'POST');
}

export function adminObjects(params = {}) {
  return adminRequest(992, params);
}

export function adminObjectSave(data) {
  return adminRequest(992, data, 'POST');
}

export function adminObjectDelete(objectId) {
  return adminRequest(992, { act: 'delete', object: objectId }, 'POST');
}

export function adminRecipes(params = {}) {
  return adminRequest(991, params);
}

export function adminRecipeAdd(objectId, addObj, count) {
  return adminRequest(991, { act: 'add', object: objectId, add_obj: addObj, count }, 'POST');
}

export function adminRecipeDelete(objectId, resId) {
  return adminRequest(991, { act: 'delete', object: objectId, res_id: resId }, 'POST');
}

export function adminEncyclopedia(params = {}) {
  return adminRequest(994, params);
}

export function adminEncyclopediaSave(objectId, desc) {
  return adminRequest(994, { act: 'save', object: objectId, desc }, 'POST');
}

export function adminEncyclopediaRebuild() {
  return adminRequest(994, { act: 'rebuild_minerals' }, 'POST');
}

export function adminResearch(params = {}) {
  return adminRequest(996, params);
}

export function adminResearchSave(fromObj, toObj) {
  return adminRequest(996, { from_obj: fromObj, to_obj: toObj }, 'POST');
}

export function adminShipTypes(params = {}) {
  return adminRequest(997, params);
}

export function adminShipTypeSave(data) {
  return adminRequest(997, data, 'POST');
}

export function adminTutorials(params = {}) {
  return adminRequest(998, params);
}

export function adminTutorialSave(data) {
  return adminRequest(998, { act: 'save', ...data }, 'POST');
}
