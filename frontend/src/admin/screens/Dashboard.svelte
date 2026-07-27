<script>
  import { onMount } from 'svelte';
  import { push } from 'svelte-spa-router';
  import { adminStats } from '../api.js';

  let stats = null;
  let login = '';
  let err = '';

  onMount(async () => {
    try {
      stats = await adminStats('all');
    } catch (e) {
      err = 'load failed';
    }
  });

  function goUser() {
    if (!login.trim()) return;
    push(`/users/${encodeURIComponent(login.trim())}`);
  }

  $: total = stats?.total?.[0] || {};
  $: ingame = stats?.ingame?.[0] || {};
  $: history = stats?.history?.[0] || {};
</script>

<section class="term-panel">
  <h2 class="term-panel-title">Быстрый поиск</h2>
  <div class="term-row">
    <span>&gt;</span>
    <input bind:value={login} placeholder="login" on:keydown={(e) => e.key === 'Enter' && goUser()} />
    <button type="button" on:click={goUser}>[ OPEN ]</button>
  </div>
</section>

{#if err}
  <p class="term-error">{err}</p>
{:else if stats}
  <div class="term-kpi">
    <div class="term-kpi-item">
      <div class="term-kpi-label">Кредиты (всего)</div>
      <div class="term-kpi-value">{Number(total.credit || 0).toLocaleString('ru-RU')}</div>
    </div>
    <div class="term-kpi-item">
      <div class="term-kpi-label">Конфедераты (всего)</div>
      <div class="term-kpi-value">{Number(total.confederate || 0).toLocaleString('ru-RU')}</div>
    </div>
    <div class="term-kpi-item">
      <div class="term-kpi-label">В игре / кредиты</div>
      <div class="term-kpi-value">{Number(ingame.credit || 0).toLocaleString('ru-RU')}</div>
    </div>
    <div class="term-kpi-item">
      <div class="term-kpi-label">Онлайн (history)</div>
      <div class="term-kpi-value">{history.online ?? '—'}</div>
    </div>
  </div>

  <section class="term-panel">
    <h2 class="term-panel-title">Разделы</h2>
    <p>
      <a href="#/users">users</a> ·
      <a href="#/log">log</a> ·
      <a href="#/stats">stats</a> ·
      <a href="#/objects">objects</a> ·
      <a href="#/recipes">recipes</a> ·
      <a href="#/encyclopedia">encyclopedia</a> ·
      <a href="#/research">research</a> ·
      <a href="#/ships">ships</a> ·
      <a href="#/tutorials">tutorials</a>
    </p>
  </section>
{:else}
  <div class="term-empty">загрузка...</div>
{/if}
