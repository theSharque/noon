<script>
  import { push, params as routeParams } from 'svelte-spa-router';
  import TermConfirm from '../ui/TermConfirm.svelte';
  import { adminUser, adminUserAction, adminUsersRecent } from '../api.js';

  const tabs = ['overview', 'skills', 'money', 'trade', 'planets', 'ships', 'fleets'];
  const tabLabels = {
    overview: 'Обзор',
    skills: 'Навыки',
    money: 'Платежи',
    trade: 'Торговля',
    planets: 'Планеты',
    ships: 'Корабли',
    fleets: 'Флоты',
  };

  let loginInput = '';
  let data = null;
  let recent = [];
  let tab = 'overview';
  let err = '';
  let loading = false;
  let recentLoading = false;
  let paySum = '';
  let addObject = '';
  let addCnt = '1';
  let skillBook = '';
  let skillLevel = '0';
  let confirm = { open: false, title: '', message: '', act: null, danger: false };

  let lastRouteLogin = null;

  $: routeLogin = $routeParams?.login ? decodeURIComponent($routeParams.login) : '';
  $: if (routeLogin !== lastRouteLogin) {
    lastRouteLogin = routeLogin;
    if (routeLogin) {
      loginInput = routeLogin;
      loadUser(routeLogin);
    } else {
      data = null;
      loadRecent();
    }
  }
  $: showRecent = !routeLogin;

  async function loadRecent() {
    recentLoading = true;
    err = '';
    try {
      const res = await adminUsersRecent();
      recent = res?.ok ? res.recent || [] : [];
      if (!res?.ok) err = res?.err || 'load failed';
    } catch {
      err = 'load failed';
      recent = [];
    }
    recentLoading = false;
  }

  async function loadUser(login) {
    if (!login) return;
    loading = true;
    err = '';
    try {
      data = await adminUser(login);
      if (!data?.ok) err = data?.err || 'not found';
    } catch {
      err = 'load failed';
      data = null;
    }
    loading = false;
  }

  function search() {
    const login = loginInput.trim();
    if (!login) return;
    push(`/users/${encodeURIComponent(login)}`);
  }

  function askConfirm(title, message, act, danger = true) {
    confirm = { open: true, title, message, act, danger };
  }

  async function onConfirm() {
    const { act } = confirm;
    confirm = { ...confirm, open: false };
    if (!act || !data?.profile?.login) return;
    try {
      await adminUserAction(
        data.profile.login,
        act,
        act === 'pay' ? { summ: paySum } : act === 'add' ? { object: addObject, cnt: addCnt } : {}
      );
      await loadUser(data.profile.login);
    } catch {
      err = 'action failed';
    }
  }

  function userLink(name) {
    if (!name) return;
    push(`/users/${encodeURIComponent(name)}`);
  }

  function formatAgo(ago) {
    const s = Math.max(0, parseInt(ago, 10) || 0);
    if (s <= 60) return 'online';
    if (s < 3600) return `${Math.floor(s / 60)}м назад`;
    if (s < 86400) return `${Math.floor(s / 3600)}ч назад`;
    return `${Math.floor(s / 86400)}д назад`;
  }

  async function saveSkill() {
    if (!data?.profile?.login || !skillBook) return;
    err = '';
    try {
      const res = await adminUserAction(data.profile.login, 'set_skill', {
        book: skillBook,
        level: skillLevel,
      });
      if (!res?.ok) {
        err = res?.err || 'save failed';
        return;
      }
      await loadUser(data.profile.login);
    } catch {
      err = 'save failed';
    }
  }

  function pickSkill(row) {
    skillBook = String(row.book_id);
    skillLevel = String(row.level);
  }
</script>

<section class="term-panel">
  <h2 class="term-panel-title">Пользователь</h2>
  <div class="term-row">
    <span>&gt;</span>
    <input bind:value={loginInput} placeholder="login" on:keydown={(e) => e.key === 'Enter' && search()} />
    <button type="button" on:click={search}>[ FIND ]</button>
  </div>
</section>

{#if showRecent}
  <section class="term-panel">
    <h2 class="term-panel-title">Последние в сети (25)</h2>
    {#if recentLoading}
      <div class="term-empty">загрузка...</div>
    {:else if recent.length === 0}
      <div class="term-empty">нет данных</div>
    {:else}
      <table class="term-table">
        <thead>
          <tr><th>login</th><th>level</th><th>lastlogin</th><th>ago</th></tr>
        </thead>
        <tbody>
          {#each recent as row}
            <tr
              class:online={Number(row.ago) <= 60}
              class="clickable"
              on:click={() => userLink(row.login)}
              on:keydown={(e) => (e.key === 'Enter' || e.key === ' ') && userLink(row.login)}
              role="link"
              tabindex="0"
            >
              <td>
                <a href="#/users/{encodeURIComponent(row.login)}" on:click|preventDefault={() => userLink(row.login)}
                  >{row.login}</a
                >
              </td>
              <td>{row.level}</td>
              <td>{row.lastlogin}</td>
              <td>{formatAgo(row.ago)}</td>
            </tr>
          {/each}
        </tbody>
      </table>
    {/if}
  </section>
{/if}

{#if loading}
  <div class="term-empty">загрузка...</div>
{:else if err && !showRecent}
  <p class="term-error">{err}</p>
{:else if data?.profile}
  <div class="term-tabs">
    {#each tabs as t}
      <button type="button" class:active={tab === t} on:click={() => (tab = t)}>{tabLabels[t]}</button>
    {/each}
  </div>

  {#if tab === 'overview'}
    <section class="term-panel">
      <table class="term-table">
        <tbody>
          {#each Object.entries(data.profile) as [k, v]}
            <tr>
              <th>{k}</th>
              <td>
                {#if k === 'parent' && v}
                  <a href="#/users/{v}" on:click|preventDefault={() => userLink(v)}>{v}</a>
                {:else if k === 'child' && data.children?.length}
                  {#each data.children as ch}
                    <a href="#/users/{ch}" on:click|preventDefault={() => userLink(ch)}>{ch}</a>{' '}
                  {/each}
                {:else}
                  {v}
                {/if}
              </td>
            </tr>
          {/each}
        </tbody>
      </table>
    </section>

    <section class="term-panel danger-zone">
      <h2 class="term-panel-title">Danger zone</h2>
      <div class="term-row">
        <button type="button" class="danger" on:click={() => askConfirm('Kill', `Убить ${data.profile.login}?`, 'kill')}>kill</button>
        <button type="button" on:click={() => askConfirm('Go home', `Отправить ${data.profile.login} домой?`, 'go_home', false)}>go home</button>
        <button type="button" on:click={() => askConfirm('Mute week', `Мут на неделю: ${data.profile.login}?`, 'mute_w')}>mute week</button>
        <button type="button" on:click={() => askConfirm('Mute month', `Мут на месяц: ${data.profile.login}?`, 'mute_m')}>mute month</button>
        <button type="button" class="danger" on:click={() => askConfirm('Enter as user', `Войти как ${data.profile.login}?`, 'enter')}>enter as user</button>
      </div>
      <div class="term-row">
        <input bind:value={paySum} placeholder="сумма конфедератов" />
        <button type="button" on:click={() => askConfirm('Pay', `Зачислить ${paySum} конфедератов?`, 'pay', false)}>[ PAY ]</button>
      </div>
      <div class="term-row">
        <select bind:value={addObject}>
          <option value="">объект</option>
          {#each data.objects || [] as o}
            <option value={o.id}>{o.class} {o.name}</option>
          {/each}
        </select>
        <input bind:value={addCnt} style="width:80px" />
        <button type="button" on:click={() => askConfirm('Add item', 'Добавить предмет на склад?', 'add', false)}>[ ADD ]</button>
      </div>
    </section>
  {:else if tab === 'skills'}
    <section class="term-panel">
      <h2 class="term-panel-title">Изученные навыки (users_books)</h2>
      <table class="term-table">
        <thead><tr><th>id</th><th>навык</th><th>уровень</th></tr></thead>
        <tbody>
          {#each data.skills || [] as row}
            <tr
              class="clickable"
              on:click={() => pickSkill(row)}
              on:keydown={(e) => (e.key === 'Enter' || e.key === ' ') && pickSkill(row)}
              role="button"
              tabindex="0"
            >
              <td>{row.book_id}</td>
              <td>{row.name}</td>
              <td>{row.level}</td>
            </tr>
          {:else}
            <tr><td colspan="3" class="term-empty">нет изученных навыков</td></tr>
          {/each}
        </tbody>
      </table>
    </section>
    <section class="term-panel">
      <h2 class="term-panel-title">Редактор</h2>
      <div class="term-row">
        <select bind:value={skillBook}>
          <option value="">навык</option>
          {#each data.books || [] as b}
            <option value={b.id}>{b.id} {b.name}</option>
          {/each}
        </select>
        <input bind:value={skillLevel} type="number" min="0" max="10" style="width:80px" />
        <button type="button" disabled={!skillBook} on:click={saveSkill}>[ SET ]</button>
      </div>
      <p class="term-hint">Уровень 0 — удалить запись. Импланты и медали здесь не редактируются.</p>
    </section>
  {:else if tab === 'money'}
    <section class="term-panel">
      <table class="term-table">
        <thead><tr><th>time</th><th>message</th></tr></thead>
        <tbody>
          {#each data.pay || [] as row}
            <tr><td>{row.log_time}</td><td>{row.mess}</td></tr>
          {/each}
        </tbody>
      </table>
    </section>
  {:else if tab === 'trade'}
    <section class="term-panel">
      <table class="term-table">
        <thead><tr><th>time</th><th>buyer</th><th>seller</th><th>object</th><th>cnt</th><th>sum</th></tr></thead>
        <tbody>
          {#each data.trade || [] as row}
            <tr>
              <td>{row.trade_time}</td>
              <td><button type="button" class="linkish" on:click={() => userLink(row.bay_login)}>{row.bay_login}</button></td>
              <td><button type="button" class="linkish" on:click={() => userLink(row.sell_login)}>{row.sell_login}</button></td>
              <td>{row.oname}</td><td>{row.object_cnt}</td><td>{row.log_sum}</td>
            </tr>
          {/each}
        </tbody>
      </table>
    </section>
    <section class="term-panel">
      <h2 class="term-panel-title">Bay log</h2>
      <table class="term-table">
        <tbody>
          {#each data.bay || [] as row}
            <tr><td>{row.log_time}</td><td>{row.log_text}</td></tr>
          {/each}
        </tbody>
      </table>
    </section>
  {:else if tab === 'planets'}
    <section class="term-panel">
      <table class="term-table">
        <thead><tr><th>name</th><th>type</th><th>level</th></tr></thead>
        <tbody>
          {#each data.planets || [] as row}
            <tr><td>{row.name}</td><td>{row.type}</td><td>{row.level}</td></tr>
          {/each}
        </tbody>
      </table>
    </section>
  {:else if tab === 'ships'}
    <section class="term-panel">
      <table class="term-table">
        <thead><tr><th>id</th><th>name</th><th>type</th><th>war</th><th>place</th></tr></thead>
        <tbody>
          {#each data.ships || [] as row}
            <tr><td>{row.id}</td><td>{row.name}</td><td>{row.oname}</td><td>{row.inwar}</td><td>{row.place}</td></tr>
          {/each}
        </tbody>
      </table>
    </section>
  {:else if tab === 'fleets'}
    <section class="term-panel">
      <table class="term-table">
        <thead><tr><th>id</th><th>name</th><th>war</th><th>count</th><th>power</th><th>place</th></tr></thead>
        <tbody>
          {#each data.fleets || [] as row}
            <tr><td>{row.id}</td><td>{row.name}</td><td>{row.inwar}</td><td>{row.w_count}</td><td>{row.w_power}</td><td>{row.place}</td></tr>
          {/each}
        </tbody>
      </table>
    </section>
  {/if}
{/if}

<TermConfirm
  bind:open={confirm.open}
  title={confirm.title}
  message={confirm.message}
  danger={confirm.danger}
  on:confirm={onConfirm}
  on:cancel={() => (confirm = { ...confirm, open: false })}
/>

<style>
  button.linkish {
    background: transparent;
    border: none;
    padding: 0;
    color: var(--term-fg-bright);
    text-decoration: underline;
    cursor: pointer;
  }

  tr.clickable {
    cursor: pointer;
  }

  tr.clickable:hover td {
    background: color-mix(in srgb, var(--term-fg, #ccc) 8%, transparent);
  }

  tr.online td {
    color: var(--term-ok, #6f6);
  }

  .term-hint {
    margin: 0.5rem 0 0;
    font-size: 0.85rem;
    color: var(--term-fg-dim, #888);
  }
</style>
