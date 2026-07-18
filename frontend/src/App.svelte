<script>
  import Router, { push, location } from 'svelte-spa-router';
  import { onMount } from 'svelte';
  import TopMenu from './lib/TopMenu.svelte';
  import Chat from './lib/Chat.svelte';
  import { routes } from './lib/router.js';
  import { getNoonConfig } from './lib/api.js';
  import { playerAbout } from './lib/chatActions.js';

  const config = getNoonConfig();

  onMount(() => {
    if (!$location || $location === '/') {
      push('/character');
    }
  });
</script>

<div class="shell">
  <header class="shell-top">
    <TopMenu mv={config.mv} sv={config.sv} />
  </header>
  <main class="shell-main">
    {#if $playerAbout}
      <div class="player-about-stub">
        <h1>Профиль: {$playerAbout}</h1>
        <p>Экран «О персонаже» будет портирован позже.</p>
      </div>
    {:else}
      <Router {routes} />
    {/if}
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

  .player-about-stub {
    padding: 24px 32px;
    color: #7fd4ff;
    font-family: Verdana, Arial, sans-serif;
  }

  .player-about-stub h1 {
    margin: 0 0 12px;
    font-size: 22px;
    color: #00d8f0;
    text-transform: uppercase;
    letter-spacing: 1px;
  }

  .player-about-stub p {
    margin: 0;
    color: #888;
    font-size: 13px;
  }

  .shell-chat {
    flex: 0 0 160px;
    height: 160px;
    overflow: hidden;
    border-top: 1px solid #1a3a4a;
    background: #050508;
  }
</style>
