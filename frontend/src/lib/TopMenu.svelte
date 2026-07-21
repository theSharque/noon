<script>
  import { link, push } from 'svelte-spa-router';
  import active from 'svelte-spa-router/active';
  import { onMount, onDestroy } from 'svelte';
  import { get } from 'svelte/store';
  import { pollMail } from './api.js';
  import { mailHasUnread, mailLastId } from './mailStore.js';
  import { musicVolume, soundVolume, setMusicVolumeLocal, setSoundVolumeLocal } from './audioStore.js';

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
  let unsubMusic;
  let unsubSound;

  $: mv = $musicVolume;
  $: sv = $soundVolume;

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

  function applyPlayerVolume(vol) {
    if (player) player.volume = Math.max(0, Math.min(1, vol / 100));
  }

  function playMusic() {
    applyPlayerVolume(mv);
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
      if (mv <= 0) setMusicVolumeLocal(50);
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
        setMusicVolumeLocal(parseInt(data.mv, 10));
      }
      if (data.sv !== undefined) {
        setSoundVolumeLocal(parseInt(data.sv, 10));
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
    setMusicVolumeLocal(mv);
    setSoundVolumeLocal(sv);
    sfxVolume();
    unsubMusic = musicVolume.subscribe((vol) => {
      applyPlayerVolume(vol);
    });
    unsubSound = soundVolume.subscribe(() => sfxVolume());
    loadTrack(trackIndex);
    if (get(musicVolume) > 0) playMusic();
    else pauseMusic();

    player?.addEventListener('ended', nextTrack);
    doPoll();
    pollTimer = setInterval(doPoll, 15000);
  });

  onDestroy(() => {
    clearInterval(pollTimer);
    unsubMusic?.();
    unsubSound?.();
    player?.removeEventListener('ended', nextTrack);
  });
</script>

<div class="bar">
  <nav class="nav">
    {#each navItems as item}
      <a
        class="scifi-nav-link"
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
      class="scifi-nav-link exit"
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

  .scifi-nav-link.exit {
    color: var(--accent-danger);
    border-color: rgba(255, 59, 92, 0.4);
  }

  .scifi-nav-link.exit:hover {
    color: #ff7a90;
    border-color: var(--accent-danger);
    background: rgba(255, 59, 92, 0.1);
    box-shadow: inset 0 0 12px rgba(255, 59, 92, 0.2), 0 0 12px rgba(255, 59, 92, 0.25);
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
    border: 1px solid var(--ctrl-border-color);
    background: var(--ctrl-bg);
    color: var(--ctrl-color);
    cursor: pointer;
    text-decoration: none;
    clip-path: var(--ctrl-clip);
    transform: translateY(0) scale(1);
    transition:
      border-color 0.2s ease,
      color 0.2s ease,
      background 0.2s ease,
      box-shadow 0.2s ease,
      transform 0.12s ease;
  }

  .tool-btn:hover {
    color: var(--ctrl-active-color);
    border-color: var(--ctrl-active-border);
    box-shadow: var(--ctrl-active-shadow);
    background: var(--ctrl-hover-bg);
  }

  .tool-btn:active {
    transform: translateY(1px) scale(0.94);
    background: rgba(0, 229, 255, 0.22);
    box-shadow: inset 0 0 12px rgba(0, 229, 255, 0.35);
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
