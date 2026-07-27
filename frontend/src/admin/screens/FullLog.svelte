<script>
  import { push } from 'svelte-spa-router';
  import { adminLog } from '../api.js';

  let login = '';
  let time = '0000-00-00 00:00:00';
  let filterId = '';
  let entries = [];
  let err = '';
  let loading = false;

  async function load() {
    if (!login.trim()) return;
    loading = true;
    err = '';
    try {
      const data = await adminLog(login.trim(), {
        time,
        filter_id: filterId === '' ? -1 : filterId,
      });
      if (!data?.ok) {
        err = data?.err || 'error';
        entries = [];
      } else {
        entries = data.entries || [];
      }
    } catch {
      err = 'load failed';
      entries = [];
    }
    loading = false;
  }

  function openUser(name) {
    push(`/users/${encodeURIComponent(name)}`);
  }
</script>

<section class="term-panel">
  <h2 class="term-panel-title">Full log</h2>
  <div class="term-row">
    <span>login</span><input bind:value={login} />
    <span>after</span><input bind:value={time} />
    <span>page id</span><input bind:value={filterId} placeholder="all" style="width:80px" />
    <button type="button" on:click={load}>[ LOAD ]</button>
  </div>
</section>

{#if loading}
  <div class="term-empty">загрузка...</div>
{:else if err}
  <p class="term-error">{err}</p>
{:else if entries.length}
  <section class="term-panel">
    <table class="term-table">
      <thead>
        <tr><th>time</th><th>id</th><th>action</th><th>params</th></tr>
      </thead>
      <tbody>
        {#each entries as e}
          <tr>
            <td>{e.log_time}</td>
            <td>{e.page_id}</td>
            <td>{e.label}</td>
            <td><code>{JSON.stringify(e.params)}</code></td>
          </tr>
        {/each}
      </tbody>
    </table>
  </section>
{:else}
  <div class="term-empty">нет записей</div>
{/if}

<p><button type="button" class="linkish" on:click={() => login && openUser(login)}>open user</button></p>

<style>
  button.linkish {
    background: transparent;
    border: none;
    padding: 0;
    color: var(--term-fg-bright);
    text-decoration: underline;
  }
  code {
    font-size: 11px;
    word-break: break-all;
  }
</style>
