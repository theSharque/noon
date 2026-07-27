<script>
  import { onMount } from 'svelte';
  import { push } from 'svelte-spa-router';
  import TermConfirm from '../ui/TermConfirm.svelte';
  import { adminStats, adminRecalcPrice } from '../api.js';

  let stats = null;
  let err = '';
  let confirmOpen = false;

  onMount(load);

  async function load() {
    try {
      stats = await adminStats('all');
    } catch {
      err = 'load failed';
    }
  }

  async function recalc() {
    confirmOpen = false;
    try {
      await adminRecalcPrice();
      await load();
    } catch {
      err = 'recalc failed';
    }
  }

  function userLink(login) {
    push(`/users/${encodeURIComponent(login)}`);
  }

  function fmt(n) {
    if (n === null || n === undefined || n === '') return '—';
    const num = Number(n);
    return Number.isFinite(num) ? num.toLocaleString('ru-RU') : n;
  }
</script>

<section class="term-panel">
  <h2 class="term-panel-title">Recalc prices</h2>
  <button type="button" class="danger" on:click={() => (confirmOpen = true)}>[ RECALC ALL PRICES ]</button>
</section>

{#if err}
  <p class="term-error">{err}</p>
{:else if stats}
  {#each [
    ['total', 'Total statistic', stats.total],
    ['ingame', 'In game statistic', stats.ingame],
    ['bay_log', 'Bay_log statistic', stats.bay_log],
    ['last_conf_trade', 'Last confederate trade', stats.last_conf_trade],
    ['history', 'History statistic', stats.history],
    ['by_credits', 'By credits', stats.by_credits],
    ['by_conf', 'By confederate', stats.by_conf],
    ['registrant', 'Registrant', stats.registrant],
    ['last_fin', 'Last fin level', stats.last_fin],
    ['last_high', 'Last high level', stats.last_high],
    ['last_low', 'Last low level', stats.last_low],
    ['donators', 'Donators', stats.donators],
  ] as [id, title, rows]}
    {#if rows?.length}
      <section class="term-panel" id={id}>
        <h2 class="term-panel-title">{title}</h2>
        <table class="term-table">
          <thead>
            <tr>
              {#each Object.keys(rows[0]) as col}
                <th>{col}</th>
              {/each}
            </tr>
          </thead>
          <tbody>
            {#each rows as row}
              <tr>
                {#each Object.entries(row) as [col, val]}
                  <td>
                    {#if col === 'login' || col === 'user'}
                      <button type="button" class="linkish" on:click={() => userLink(val)}>{val}</button>
                    {:else if typeof val === 'number' || (typeof val === 'string' && /^-?\d+(\.\d+)?$/.test(val))}
                      {fmt(val)}
                    {:else}
                      {val}
                    {/if}
                  </td>
                {/each}
              </tr>
            {/each}
          </tbody>
        </table>
      </section>
    {/if}
  {/each}
{:else}
  <div class="term-empty">загрузка...</div>
{/if}

<TermConfirm
  bind:open={confirmOpen}
  title="Recalc prices"
  message="Пересчитать цены всех объектов?"
  confirmLabel="[ RECALC ]"
  danger={true}
  on:confirm={recalc}
  on:cancel={() => (confirmOpen = false)}
/>

<style>
  button.linkish {
    background: transparent;
    border: none;
    padding: 0;
    color: var(--term-fg-bright);
    text-decoration: underline;
  }
</style>
