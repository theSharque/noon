<script>
  import { onMount, onDestroy, tick } from 'svelte';
  import {
    blockChatUser,
    deleteChatMessage,
    mergeChatHtml,
    pollChat,
    sendChat,
  } from './api.js';
  import { openPlayerAbout } from './chatActions.js';

  const tabs = [
    { id: 'main', label: 'Основной' },
    { id: 'sys', label: 'Системный' },
    { id: 'priv', label: 'Приват' },
  ];

  let cid = 0;
  let uh = 'first';
  let activeTab = 'main';
  let draft = '';
  let sending = false;
  let pollTimer;
  let msgsEl;
  let onlineEl;
  let inputEl;

  let mainHtml = '';
  let sysHtml = '';
  let privHtml = '';
  let usersHtml = '';
  let unread = { sys: false, priv: false };

  $: activeHtml = activeTab === 'main' ? mainHtml : activeTab === 'sys' ? sysHtml : privHtml;

  function mergeChannel(key, chunk) {
    if (!chunk) return false;
    if (key === 'main') mainHtml = mergeChatHtml(mainHtml, chunk);
    if (key === 'sys') sysHtml = mergeChatHtml(sysHtml, chunk);
    if (key === 'priv') privHtml = mergeChatHtml(privHtml, chunk);
    return true;
  }

  async function doPoll() {
    try {
      const data = await pollChat(cid, uh);
      if (data.err !== '0') return;

      if (data.id) cid = parseInt(data.id, 10) || cid;

      const gotMain = mergeChannel('main', data.msgm);
      const gotSys = mergeChannel('sys', data.msgs);
      const gotPriv = mergeChannel('priv', data.msgp);

      if (gotSys && activeTab !== 'sys') unread.sys = true;
      if (gotPriv && activeTab !== 'priv') unread.priv = true;

      if (data.users) {
        usersHtml = data.users;
        if (data.uh) uh = data.uh;
      }
    } catch (e) {}
  }

  function selectTab(id) {
    activeTab = id;
    if (id === 'sys') unread.sys = false;
    if (id === 'priv') unread.priv = false;
  }

  function prefillNick(nick) {
    if (!nick) return;
    draft = nick.endsWith(':') ? `${nick} ` : `${nick}: `;
    inputEl?.focus();
  }

  async function refreshChat() {
    cid = 0;
    uh = 'first';
    mainHtml = '';
    sysHtml = '';
    privHtml = '';
    usersHtml = '';
    await doPoll();
    await tick();
    if (msgsEl) msgsEl.scrollTop = 0;
  }

  async function adminDelete(id) {
    if (!id) return;
    await deleteChatMessage(id);
    await refreshChat();
  }

  async function adminBlock(id) {
    if (!id) return;
    if (!confirm('Заблокировать игрока на 7 дней и удалить его сообщения?')) return;
    await blockChatUser(id);
    await refreshChat();
  }

  function onChatClick(e) {
    const el = e.target.closest('[data-chat-action]');
    if (!el) return;
    e.preventDefault();
    const action = el.dataset.chatAction;
    if (action === 'nick') {
      prefillNick(el.dataset.nick);
      return;
    }
    if (action === 'del') {
      adminDelete(el.dataset.id);
      return;
    }
    if (action === 'blk') {
      adminBlock(el.dataset.id);
      return;
    }
    if (action === 'about') {
      openPlayerAbout(el.dataset.login);
    }
  }

  async function submitMessage() {
    const text = draft.trim();
    if (!text || sending) return;
    sending = true;
    try {
      const res = await sendChat(text);
      if (res.err === '0') {
        draft = '';
        await doPoll();
        await tick();
        if (msgsEl) msgsEl.scrollTop = 0;
      }
    } finally {
      sending = false;
    }
  }

  function onKeydown(e) {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      submitMessage();
    }
  }

  onMount(() => {
    doPoll();
    pollTimer = setInterval(doPoll, 5000);
  });

  onDestroy(() => {
    clearInterval(pollTimer);
  });
</script>

<div class="chat">
  <div class="chat-read">
    <div class="chat-tabs">
      {#each tabs as tab}
        <button
          type="button"
          class:active={activeTab === tab.id}
          class:blink={tab.id === 'sys' && unread.sys && activeTab !== 'sys'}
          class:blink-priv={tab.id === 'priv' && unread.priv && activeTab !== 'priv'}
          on:click={() => selectTab(tab.id)}
        >
          {tab.label}
        </button>
      {/each}
    </div>
    <div class="chat-panes">
      <!-- svelte-ignore a11y-click-events-have-key-events -->
      <!-- svelte-ignore a11y-no-static-element-interactions -->
      <div class="chat-msgs" bind:this={msgsEl} on:click={onChatClick}>
        {#if activeHtml}
          {@html activeHtml}
        {:else}
          <span class="empty">…</span>
        {/if}
      </div>
      <!-- svelte-ignore a11y-click-events-have-key-events -->
      <!-- svelte-ignore a11y-no-static-element-interactions -->
      <div class="chat-online" bind:this={onlineEl} on:click={onChatClick}>
        {#if usersHtml}
          {@html usersHtml}
        {/if}
      </div>
    </div>
  </div>
  <form class="chat-write" on:submit|preventDefault={submitMessage}>
    <input
      type="text"
      bind:this={inputEl}
      bind:value={draft}
      maxlength="1400"
      autocomplete="off"
      spellcheck="false"
      placeholder="Сообщение"
      on:keydown={onKeydown}
    />
    <button type="submit" disabled={sending}>Отправить</button>
  </form>
</div>

<style>
  .chat {
    display: flex;
    flex-direction: column;
    height: 100%;
    background: #000;
    color: #ccc;
    font: 11px/1.25 Verdana, Arial, sans-serif;
  }

  .chat-read {
    flex: 1 1 auto;
    min-height: 0;
    display: flex;
    flex-direction: column;
  }

  .chat-tabs {
    display: flex;
    flex: 0 0 auto;
    gap: 2px;
    padding: 2px 4px 0;
    background: #0a0a0a;
    border-bottom: 1px solid #1a3a4a;
  }

  .chat-tabs button {
    margin: 0;
    padding: 1px 8px 2px;
    border: 1px solid #2a4a5a;
    border-bottom: 0;
    background: #111820;
    color: #7fd4ff;
    font: 10px/14px Verdana, Arial, sans-serif;
    cursor: pointer;
    text-transform: uppercase;
    letter-spacing: 0.5px;
  }

  .chat-tabs button.active {
    background: #000;
    color: #fff;
    border-color: #3a8aaa;
    box-shadow: inset 0 1px 0 #00d8f0;
  }

  .chat-tabs button.blink,
  .chat-tabs button.blink-priv {
    animation: tabBlink 1s steps(2) infinite;
  }

  @keyframes tabBlink {
    50% { color: #00ffff; border-color: #00ffff; }
  }

  .chat-panes {
    flex: 1 1 auto;
    min-height: 0;
    display: flex;
    overflow: hidden;
  }

  .chat-msgs {
    flex: 1 1 auto;
    min-width: 0;
    overflow: auto;
    padding: 2px 6px;
    background: #000;
  }

  .chat-online {
    flex: 0 0 140px;
    width: 140px;
    overflow: auto;
    padding: 2px 4px;
    border-left: 1px solid #1a3a4a;
    background: #050508;
    font-size: 10px;
    line-height: 1.3;
  }

  .chat-msgs :global(a),
  .chat-online :global(a) {
    color: inherit;
    text-decoration: underline;
    cursor: pointer;
  }

  .chat-msgs :global(font),
  .chat-online :global(font) {
    font-size: inherit;
  }

  .empty {
    color: #444;
  }

  .chat-write {
    flex: 0 0 25px;
    height: 25px;
    display: flex;
    align-items: stretch;
    gap: 4px;
    padding: 0 4px 1px;
    box-sizing: border-box;
    border-top: 1px solid #1a3a4a;
    background: #0a0a0a;
  }

  .chat-write input {
    flex: 1 1 auto;
    min-width: 0;
    margin: 0;
    padding: 2px 6px;
    border: 1px solid #2a5a6a;
    background: #000;
    color: #fff;
    font: 11px/18px Verdana, Arial, sans-serif;
    outline: none;
  }

  .chat-write input:focus {
    border-color: #00d8f0;
    box-shadow: 0 0 4px rgba(0, 216, 240, 0.35);
  }

  .chat-write button {
    flex: 0 0 auto;
    margin: 0;
    padding: 0 10px;
    border: 1px solid #2a6a8a;
    background: linear-gradient(180deg, #1a3a4a 0%, #0a1a22 100%);
    color: #7fd4ff;
    font: 10px/18px Verdana, Arial, sans-serif;
    text-transform: uppercase;
    cursor: pointer;
  }

  .chat-write button:disabled {
    opacity: 0.5;
    cursor: default;
  }

  .chat-write button:hover:not(:disabled) {
    filter: brightness(1.15);
  }
</style>
