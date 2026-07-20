<script>
  import { link, push } from 'svelte-spa-router';
  import { onMount, onDestroy } from 'svelte';
  import { get } from 'svelte/store';
  import { pollMail } from './api.js';
  import { mailHasUnread, mailLastId } from './mailStore.js';

  export let mv = 0;
  export let sv = 50;

  const ASSET = '/app/img/topmenu';
  const VER = '7';

  const navItems = [
    { cls: 'btn-char', href: '/character', title: 'Персонаж', label: 'персонаж' },
    { cls: 'btn-place', href: '/place', title: 'Местность', label: 'МЕСТНОСТЬ' },
    { cls: 'btn-ship', href: '/ships', title: 'Корабли', label: 'корабли' },
    { cls: 'btn-ware', href: '/ware', title: 'Склад', label: 'склад' },
    { cls: 'btn-trade', href: '/trade', title: 'Торговля', label: 'торговля' },
    { cls: 'btn-misc', href: '/misc', title: 'Прочее', label: 'прочее' },
  ];

  const playlist = Array.from({ length: 9 }, (_, i) => `/music/${i + 1}.mp3`);

  let trackIndex = Math.floor(Math.random() * 9);
  let playing = false;
  let pingMs = null;
  let pingClass = '';

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

  async function doPoll() {
    try {
      const { data, ts } = await pollMail(get(mailLastId));
      const sent = parseInt(data.png, 10);
      if (!isNaN(sent)) setPing(ts - sent);
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

  function onMailClick(e) {
    playClick();
    mailHasUnread.set(false);
    push('/mail');
  }

  function onExitClick() {
    playClick();
    window.location.href = 'page.php?id=7';
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

<div id="bar">
  <nav id="nav">
    {#each navItems as item}
      <a
        class="nav-btn {item.cls}"
        href={item.href}
        use:link
        title={item.title}
        on:mouseenter={playHover}
        on:mousedown={onNavClick}
      >
        <span>{item.label}</span>
      </a>
    {/each}
    <a
      class="nav-btn btn-exit exit"
      href="page.php?id=7"
      title="Выход"
      on:mouseenter={playHover}
      on:mousedown={onExitClick}
      on:click|preventDefault={onExitClick}
    >
      <span>выход</span>
    </a>
  </nav>

  <div id="tools">
    <span id="ping" class={pingClass}>{pingMs ?? ''}</span>
    {#if !playing}
      <button type="button" title="Музыка" on:click={toggleMusic} on:mouseenter={playHover} on:mousedown={playClick}>
        <img src="{ASSET}/btn_player_off.png?v={VER}" width="27" height="21" alt="play" />
      </button>
    {:else}
      <button type="button" title="Пауза" on:click={toggleMusic} on:mouseenter={playHover} on:mousedown={playClick}>
        <img src="{ASSET}/btn_player_on.png?v={VER}" width="27" height="21" alt="pause" />
      </button>
    {/if}
    <button type="button" title="Следующий" on:click={nextTrack} on:mouseenter={playHover} on:mousedown={playClick}>
      <img src="{ASSET}/btn_player_next.png?v={VER}" width="27" height="21" alt="next" />
    </button>
    <a
      id="btn-mail"
      class:has-mail={$mailHasUnread}
      href="/mail"
      use:link
      title="Почта"
      aria-label="Почта"
      on:mouseenter={playHover}
      on:mousedown={onMailClick}
      on:click|preventDefault={onMailClick}
    ></a>
  </div>
</div>

<audio bind:this={player} preload="none"></audio>
<audio bind:this={sndHover} preload="auto" src="{ASSET}/sound7.wav"></audio>
<audio bind:this={sndClick} preload="auto" src="{ASSET}/bleep.wav"></audio>

<style>
  #bar {
    position: relative;
    display: flex;
    align-items: flex-end;
    justify-content: center;
    box-sizing: border-box;
    height: 27px;
    padding-bottom: 1px;
    width: 100%;
    overflow: visible;
    background: #000;
  }

  #nav {
    display: flex;
    align-items: flex-end;
    height: 25px;
    flex: 0 0 auto;
  }

  #nav a.nav-btn {
    --plate: url('/app/img/topmenu/plate.svg');
    display: flex;
    align-items: flex-end;
    justify-content: center;
    flex: 0 0 auto;
    height: 25px;
    overflow: visible;
    text-decoration: none;
    box-sizing: border-box;
    padding: 0 10px 3px;
    border: 0;
    border-style: solid;
    border-width: 3px 8px;
    border-image-source: var(--plate);
    border-image-slice: 3 8 3 8 fill;
    border-image-width: 3px 8px;
    border-image-repeat: stretch;
    background: transparent;
  }

  #nav a.nav-btn:hover {
    filter: brightness(1.2) drop-shadow(0 0 3px rgba(0, 240, 255, 0.65));
  }

  #nav a.btn-char  { width: 124px; }
  #nav a.btn-place { width: 136px; }
  #nav a.btn-ship  { width: 108px; }
  #nav a.btn-ware  { width: 82px; }
  #nav a.btn-trade { width: 122px; }
  #nav a.btn-misc  { width: 96px; }
  #nav a.btn-exit  { width: 83px; }

  #nav a span {
    display: block;
    font: 12px/12px 'TerminatorCyr', sans-serif;
    color: #fff;
    pointer-events: none;
  }

  #nav a:hover span {
    text-shadow: 0 0 5px #00ffff, 0 0 2px #00ffff;
  }

  #nav a.exit span {
    color: #ff0000;
  }

  #nav a.exit:hover {
    filter: brightness(1.25) drop-shadow(0 0 2px #ff6666);
  }

  #nav a.exit:hover span {
    text-shadow: 0 0 5px #ff0000, 0 0 2px #ff6666;
  }

  #tools {
    position: absolute;
    right: 8px;
    top: 1px;
    height: 25px;
    display: flex;
    align-items: center;
    gap: 2px;
  }

  #tools a,
  #tools button {
    display: block;
    padding: 0;
    margin: 0;
    border: 0;
    background: transparent;
    cursor: pointer;
    line-height: 0;
  }

  #tools img {
    display: block;
  }

  #ping {
    min-width: 28px;
    font: 9px/25px Verdana, Arial, sans-serif;
    color: #00ff00;
    text-align: right;
    padding-right: 4px;
    pointer-events: none;
  }

  #ping.warn {
    color: #ffff00;
  }

  #ping.bad {
    color: #ff0000;
  }

  #btn-mail {
    width: 44px;
    height: 21px;
    background: url('/app/img/topmenu/mail_strip.png') 0 0 no-repeat;
    background-size: 3080px 21px;
  }

  #btn-mail.has-mail {
    animation: mailBlink 2s steps(70) infinite;
  }

  @keyframes mailBlink {
    from { background-position: 0 0; }
    to   { background-position: -3080px 0; }
  }

  #btn-mail:hover {
    filter: brightness(1.25);
  }

  #tools button:hover img {
    filter: brightness(1.25) drop-shadow(0 0 2px #00ffff);
  }
</style>
