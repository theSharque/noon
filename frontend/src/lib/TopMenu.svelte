<script>
  import { link, push } from 'svelte-spa-router';
  import active from 'svelte-spa-router/active';
  import { onMount, onDestroy } from 'svelte';
  import { get } from 'svelte/store';
  import { pollMail } from './api.js';
  import { mailHasUnread, mailLastId } from './mailStore.js';

  export let mv = 0;
  export let sv = 50;

  const ASSET = '/app/img/topmenu';

  const navItems = [
    { href: '/character', title: 'Персонаж', label: 'Персонаж' },
    { href: '/place', title: 'Местность', label: 'Местность' },
    { href: '/ships', title: 'Корабли', label: 'Корабли' },
    { href: '/ware', title: 'Склад', label: 'Склад' },
    { href: '/trade', title: 'Торговля', label: 'Торговля' },
    { href: '/misc', title: 'Прочее', label: 'Прочее' },
  ];

  const playlist = Array.from({ length: 9 }, (_, i) => `/music/${i + 1}.mp3`);

  let trackIndex = Math.floor(Math.random() * 9);
  let playing = false;
  let pingMs = null;
  let pingClass = '';
  let creditsText = '—';
  let confText = '—';

  let player;
  let sndHover;
  let sndClick;
  let pollTimer;

  function sfxVolume() {
    const v = Math.max(0, Math.min(1, sv / 100));
    if (sndHover) sndHover.volume = v;
    if (sndClick) sndClick.volume = v;
  }

  function playHover() {
    try {
      sndHover.pause();
      sndHover.currentTime = 0;
      sndHover.play();
    } catch (e) {}
  }

  function playClick() {
    try {
      sndClick.pause();
      sndClick.currentTime = 0;
      sndClick.play();
    } catch (e) {}
  }

  function loadTrack(idx) {
    trackIndex = ((idx % playlist.length) + playlist.length) % playlist.length;
    if (player) {
      player.src = playlist[trackIndex];
      player.load();
    }
  }

  function setMusicVolume(vol) {
    if (player) player.volume = Math.max(0, Math.min(1, vol / 100));
  }

  function playMusic() {
    setMusicVolume(mv);
    player?.play().catch(() => {});
    playing = true;
  }

  function pauseMusic() {
    player?.pause();
    playing = false;
  }

  function toggleMusic() {
    if (playing) pauseMusic();
    else {
      if (mv <= 0) mv = 50;
      if (!player?.src) loadTrack(trackIndex);
      playMusic();
    }
  }

  function nextTrack() {
    loadTrack(trackIndex + 1);
    if (playing) playMusic();
  }

  function setPing(ms) {
    if (ms === null || isNaN(ms)) {
      pingMs = '';
      pingClass = '';
      return;
    }
    pingMs = String(ms);
    if (ms <= 1000) pingClass = '';
    else if (ms <= 3000) pingClass = 'warn';
    else pingClass = 'bad';
  }

  function applyBalances(data) {
    if (data.summ !== undefined) creditsText = data.summ;
    if (data.conf !== undefined) confText = data.conf;
  }

  async function doPoll() {
    try {
      const { data, ts } = await pollMail(get(mailLastId));
      const sent = parseInt(data.png, 10);
      if (!isNaN(sent)) setPing(ts - sent);
      applyBalances(data);
      if (parseInt(data.err, 10) === 0) {
        const nextId = parseInt(data.id, 10) || get(mailLastId);
        mailLastId.set(nextId);
        mailHasUnread.set(true);
      } else {
        mailHasUnread.set(false);
      }
      if (data.mv !== undefined) {
        mv = parseInt(data.mv, 10);
        if (playing) setMusicVolume(mv);
      }
      if (data.sv !== undefined) {
        sv = parseInt(data.sv, 10);
        sfxVolume();
      }
    } catch (e) {
      pingMs = '!';
      pingClass = 'bad';
    }
  }

  function onNavClick() {
    playClick();
  }

  function onMailClick() {
    playClick();
    mailHasUnread.set(false);
    push('/mail');
  }

  function onExitClick() {
    playClick();
    window.location.href = '/page.php?id=7';
  }

  onMount(() => {
    sfxVolume();
    loadTrack(trackIndex);
    if (mv > 0) playMusic();
    else pauseMusic();

    player?.addEventListener('ended', nextTrack);
    doPoll();
    pollTimer = setInterval(doPoll, 15000);
  });

  onDestroy(() => {
    clearInterval(pollTimer);
    player?.removeEventListener('ended', nextTrack);
  });
</script>

<div class="bar">
  <nav class="nav">
    {#each navItems as item}
      <a
        class="nav-link"
        href={item.href}
        use:link
        use:active
        title={item.title}
        on:mouseenter={playHover}
        on:mousedown={onNavClick}
      >
        {item.label}
      </a>
    {/each}
    <a
      class="nav-link exit"
      href="/page.php?id=7"
      title="Выход"
      on:mouseenter={playHover}
      on:mousedown={onExitClick}
      on:click|preventDefault={onExitClick}
    >
      Выход
    </a>
  </nav>

  <div class="balances">
    <span class="balance">Кредиты: {creditsText}</span>
    <span class="balance">Конфедераты: {confText}</span>
  </div>

  <div class="tools">
    <span class="ping {pingClass}">{pingMs ?? ''}</span>
    <button type="button" class="tool-btn" title={playing ? 'Пауза' : 'Музыка'} on:click={toggleMusic} on:mouseenter={playHover} on:mousedown={playClick}>
      {#if playing}
        <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor"><rect x="6" y="5" width="4" height="14" /><rect x="14" y="5" width="4" height="14" /></svg>
      {:else}
        <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor"><path d="M8 5v14l11-7z" /></svg>
      {/if}
    </button>
    <button type="button" class="tool-btn" title="Следующий" on:click={nextTrack} on:mouseenter={playHover} on:mousedown={playClick}>
      <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor"><path d="M6 5v14l8.5-7L6 5zm9 0h3v14h-3z" /></svg>
    </button>
    <a
      class="tool-btn mail"
      class:has-mail={$mailHasUnread}
      href="/mail"
      use:link
      title="Почта"
      aria-label="Почта"
      on:mouseenter={playHover}
      on:mousedown={onMailClick}
      on:click|preventDefault={onMailClick}
    >
      <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="1.8">
        <rect x="3" y="5" width="18" height="14" rx="2" />
        <path d="M3 7l9 7 9-7" />
      </svg>
    </a>
  </div>
</div>

<audio bind:this={player} preload="none"></audio>
<audio bind:this={sndHover} preload="auto" src="{ASSET}/sound7.wav"></audio>
<audio bind:this={sndClick} preload="auto" src="{ASSET}/bleep.wav"></audio>

<style>
  .bar {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 12px;
    height: 100%;
    padding: 0 12px;
    background: rgba(6, 12, 24, 0.75);
    border-bottom: 1px solid var(--border-light);
    backdrop-filter: blur(8px);
  }

  .nav {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 6px;
    min-width: 0;
  }

  .nav-link {
    display: inline-flex;
    align-items: center;
    padding: 5px 12px;
    color: var(--text-muted);
    text-decoration: none;
    font-size: 0.72rem;
    font-weight: 600;
    letter-spacing: 1px;
    text-transform: uppercase;
    border: 1px solid var(--border-light);
    clip-path: polygon(6px 0, 100% 0, 100% calc(100% - 6px), calc(100% - 6px) 100%, 0 100%, 0 6px);
    transition: color 0.2s, border-color 0.2s, background 0.2s, box-shadow 0.2s;
  }

  .nav-link:hover,
  .nav-link:global(.active) {
    color: var(--neon-cyan);
    border-color: var(--neon-cyan);
    background: rgba(0, 229, 255, 0.08);
    box-shadow: var(--glow-soft);
  }

  .nav-link:global(.active) {
    background: rgba(0, 229, 255, 0.16);
    box-shadow: var(--glow-strong);
  }

  .nav-link.exit {
    color: var(--accent-danger);
    border-color: rgba(255, 59, 92, 0.4);
  }

  .nav-link.exit:hover {
    color: #ff7a90;
    border-color: var(--accent-danger);
    background: rgba(255, 59, 92, 0.1);
  }

  .balances {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 8px;
    margin-left: auto;
    min-width: 0;
  }

  .balance {
    display: inline-flex;
    align-items: center;
    padding: 4px 10px;
    font-family: var(--font-mono);
    font-size: 0.72rem;
    color: var(--neon-cyan);
    border: 1px solid var(--border-light);
    background: rgba(0, 229, 255, 0.06);
    white-space: nowrap;
  }

  .tools {
    display: flex;
    align-items: center;
    gap: 6px;
    flex: 0 0 auto;
  }

  .ping {
    min-width: 32px;
    font-family: var(--font-mono);
    font-size: 0.7rem;
    color: var(--accent-buy);
    text-align: right;
  }

  .ping.warn {
    color: var(--accent-warn);
  }

  .ping.bad {
    color: var(--accent-sell);
  }

  .tool-btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 28px;
    height: 28px;
    padding: 0;
    border: 1px solid var(--border-light);
    background: rgba(0, 229, 255, 0.05);
    color: var(--neon-cyan-dim);
    cursor: pointer;
    text-decoration: none;
    transition: background 0.2s, box-shadow 0.2s, color 0.2s;
  }

  .tool-btn:hover {
    color: var(--neon-cyan);
    box-shadow: var(--glow-soft);
    background: rgba(0, 229, 255, 0.12);
  }

  .tool-btn.mail.has-mail {
    animation: mailPulse 1.2s ease-in-out infinite;
    color: var(--accent-warn);
    border-color: var(--accent-warn);
  }

  @keyframes mailPulse {
    50% {
      box-shadow: 0 0 12px rgba(255, 154, 60, 0.55);
    }
  }

  @media (max-width: 900px) {
    .balances {
      order: 3;
      width: 100%;
      margin-left: 0;
    }
  }
</style>
