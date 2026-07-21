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
  import { askYesNo } from './confirmStore.js';

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
    const ok = await askYesNo({
      title: 'Блокировка',
      message: 'Заблокировать игрока на 7 дней и удалить его сообщения?',
      danger: true,
    });
    if (!ok) return;
    await blockChatUser(id);
    await refreshChat();
  }

  function onChatClick(e) {
    const el = e.target.closest('[data-chat-action]');
    if (!el) return;
    e.preventDefault();
    const action = el.dataset.chatAction;
    switch (action) {
      case 'nick':
        prefillNick(el.dataset.nick);
        break;
      case 'del':
        adminDelete(el.dataset.id);
        break;
      case 'blk':
        adminBlock(el.dataset.id);
        break;
      case 'about':
        openPlayerAbout(el.dataset.login);
        break;
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
    <div class="scifi-tabs chat-tabs">
      {#each tabs as tab}
        <button
          type="button"
          class="tab"
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
      class="scifi-input"
      type="text"
      bind:this={inputEl}
      bind:value={draft}
      maxlength="1400"
      autocomplete="off"
      spellcheck="false"
      placeholder="Сообщение"
      on:keydown={onKeydown}
    />
    <button class="scifi-btn primary" type="submit" disabled={sending}>Отправить</button>
  </form>
</div>

<style>
  .chat {
    display: flex;
    flex-direction: column;
    height: 100%;
    color: var(--text-main);
    font-family: var(--font-ui);
    font-size: var(--font-size);
    line-height: 1.45;
  }

  .chat-read {
    flex: 1 1 auto;
    min-height: 0;
    display: flex;
    flex-direction: column;
  }

  .chat-tabs {
    flex: 0 0 auto;
    padding: 6px 8px 0;
    gap: 6px;
  }

  .chat-tabs .tab.blink,
  .chat-tabs .tab.blink-priv {
    animation: tabBlink 1s steps(2) infinite;
  }

  @keyframes tabBlink {
    50% {
      color: var(--neon-cyan);
      border-color: var(--neon-cyan);
    }
  }

  .chat-panes {
    flex: 1 1 auto;
    min-height: 0;
    display: flex;
    overflow: hidden;
    margin-top: 4px;
  }

  .chat-msgs {
    flex: 1 1 auto;
    min-width: 0;
    overflow: auto;
    padding: 4px 10px;
    font-family: var(--font-ui);
    font-size: var(--font-size);
    line-height: 1.45;
  }

  .chat-online {
    flex: 0 0 225px;
    width: 225px;
    overflow: auto;
    padding: 4px 8px;
    border-left: 1px solid var(--border-light);
    font-family: var(--font-ui);
    font-size: var(--font-size);
    line-height: 1.45;
    background: rgba(0, 0, 0, 0.2);
  }

  .chat-msgs :global(a),
  .chat-online :global(a) {
    color: inherit;
    text-decoration: underline;
    cursor: pointer;
    font-family: inherit;
  }

  .chat-online :global(a),
  .chat-online :global(u) {
    text-decoration: none;
  }

  .chat-msgs :global(font),
  .chat-online :global(font),
  .chat-msgs :global(b),
  .chat-online :global(b),
  .chat-msgs :global(span),
  .chat-online :global(span) {
    font-family: var(--font-ui) !important;
    font-size: inherit !important;
    line-height: inherit;
  }

  .empty {
    color: var(--text-muted);
  }

  .chat-write {
    flex: 0 0 auto;
    display: flex;
    align-items: stretch;
    gap: 8px;
    padding: 6px 8px 8px;
    border-top: 1px solid var(--border-light);
  }

  .chat-write .scifi-input {
    flex: 1 1 auto;
    min-width: 0;
    padding: 6px 10px;
    font-family: var(--font-ui);
    font-size: var(--font-size);
  }

  .chat-write .scifi-btn {
    flex: 0 0 auto;
  }
</style>
