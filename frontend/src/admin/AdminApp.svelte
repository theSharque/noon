<script>
  import Router, { location, push } from 'svelte-spa-router';
  import { onMount } from 'svelte';
  import { routes, nav } from './router.js';
  import { adminMe } from './api.js';

  let login = '';
  let ready = false;
  let gone = false;

  onMount(async () => {
    try {
      const data = await adminMe();
      if (!data?.ok) {
        gone = true;
        return;
      }
      login = data.login || '';
      ready = true;
    } catch {
      gone = true;
    }
  });

  function isActive(path) {
    const cur = $location || '/';
    if (path === '/') return cur === '/';
    return cur === path || cur.startsWith(`${path}/`);
  }
</script>

{#if gone}
  <div class="term-empty"></div>
{:else if ready}
  <div class="admin-shell">
    <aside class="admin-sidebar">
      <div class="admin-brand">sys/admin</div>
      {#each nav as group}
        <div class="admin-nav-group">
          <p class="admin-nav-title">{group.title}</p>
          <nav class="admin-nav">
            {#each group.items as item}
              <a href={item.href} class:active={isActive(item.path)}>{item.label}</a>
            {/each}
          </nav>
        </div>
      {/each}
    </aside>
    <main class="admin-main">
      <div class="admin-header">
        <h1>admin terminal</h1>
        <div class="admin-user">{login}</div>
      </div>
      <Router {routes} />
    </main>
  </div>
{:else}
  <div class="term-empty">...</div>
{/if}
