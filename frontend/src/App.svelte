<script>
  import Router, { push, location } from 'svelte-spa-router';
  import { onMount } from 'svelte';
  import TopMenu from './lib/TopMenu.svelte';
  import Chat from './lib/Chat.svelte';
  import { routes } from './lib/router.js';
  import { getNoonConfig } from './lib/api.js';

  const config = getNoonConfig();

  onMount(() => {
    if (config.boot) {
      push(config.boot);
      return;
    }
    const hashPath = (window.location.hash.replace(/^#\/?/, '').split('?')[0] || '').trim();
    if ((!$location || $location === '/') && !hashPath) {
      push('/character');
    }
  });
</script>

<div class="shell">
  <header class="shell-top">
    <TopMenu mv={config.mv} sv={config.sv} />
  </header>
  <main class="shell-main">
    <Router {routes} />
  </main>
  <footer class="shell-chat">
    <Chat />
  </footer>
</div>

<style>
  .shell {
    display: flex;
    flex-direction: column;
    height: 100vh;
    width: 100%;
    overflow: hidden;
    background: #000;
  }

  .shell-top {
    flex: 0 0 27px;
    height: 27px;
    margin: 0;
    padding: 0;
    border: 0;
    line-height: 0;
    overflow: visible;
    position: relative;
    z-index: 2;
  }

  .shell-main {
    flex: 1 1 auto;
    min-height: 0;
    overflow: auto;
    background: #0a0a12;
  }

  .shell-chat {
    flex: 0 0 160px;
    height: 160px;
    overflow: hidden;
    border-top: 1px solid #1a3a4a;
    background: #050508;
  }
</style>
