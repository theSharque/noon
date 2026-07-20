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
  <div class="shell-bg" aria-hidden="true"></div>
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
    position: relative;
    display: flex;
    flex-direction: column;
    height: 100vh;
    width: 100%;
    overflow: hidden;
    background: var(--bg-deep);
  }

  .shell-bg {
    position: absolute;
    inset: 0;
    z-index: 0;
    pointer-events: none;
    background:
      radial-gradient(ellipse 80% 50% at 20% 10%, rgba(80, 40, 120, 0.35), transparent 55%),
      radial-gradient(ellipse 70% 60% at 85% 30%, rgba(0, 100, 160, 0.28), transparent 50%),
      radial-gradient(ellipse 50% 40% at 50% 90%, rgba(20, 60, 140, 0.25), transparent 60%),
      linear-gradient(180deg, #040814 0%, #071018 50%, #050a12 100%);
  }

  .shell-bg::after {
    content: '';
    position: absolute;
    inset: 0;
    background-image:
      radial-gradient(1px 1px at 10% 20%, rgba(255, 255, 255, 0.55), transparent),
      radial-gradient(1px 1px at 30% 70%, rgba(255, 255, 255, 0.35), transparent),
      radial-gradient(1px 1px at 55% 35%, rgba(255, 255, 255, 0.45), transparent),
      radial-gradient(1px 1px at 75% 15%, rgba(255, 255, 255, 0.3), transparent),
      radial-gradient(1px 1px at 90% 60%, rgba(255, 255, 255, 0.4), transparent),
      radial-gradient(1.5px 1.5px at 42% 48%, rgba(180, 230, 255, 0.5), transparent);
    opacity: 0.7;
  }

  .shell-top,
  .shell-main,
  .shell-chat {
    position: relative;
    z-index: 1;
  }

  .shell-top {
    flex: 0 0 var(--shell-top);
    height: var(--shell-top);
    margin: 0;
    padding: 0;
    border: 0;
    overflow: visible;
  }

  .shell-main {
    flex: 1 1 auto;
    min-height: 0;
    overflow: auto;
    padding: 10px 12px;
  }

  .shell-chat {
    flex: 0 0 var(--shell-chat);
    height: var(--shell-chat);
    overflow: hidden;
    border-top: 1px solid var(--border-light);
    background: rgba(4, 8, 16, 0.55);
    backdrop-filter: blur(8px);
    margin: 0 8px 8px;
    border-radius: var(--radius-panel);
    border: 1px solid var(--border-light);
    box-shadow: var(--glow-soft);
  }
</style>
