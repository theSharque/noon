<script>
  import { onMount } from 'svelte';
  import { querystring } from 'svelte-spa-router';
  import {
    checkMailTo,
    deleteMail,
    deleteMailAll,
    listMail,
    readMail,
    sendMail,
  } from '../lib/api.js';
  import { markMailSeen } from '../lib/mailStore.js';

  let mode = 'list';
  let loading = false;
  let error = '';
  let messages = [];
  let selected = new Set();
  let current = null;
  let bodyHtml = '';
  let canReply = false;
  let composeTo = '';
  let composeText = '';
  let composeError = '';

  $: toPrefill = (new URLSearchParams($querystring || '').get('to') || '').trim();

  function syncSeen() {
    const maxId = messages.reduce((max, m) => Math.max(max, m.id), 0);
    markMailSeen(maxId);
  }

  async function loadList() {
    loading = true;
    error = '';
    try {
      const data = await listMail();
      if (data.err !== '0') {
        error = 'Не удалось загрузить почту';
        return;
      }
      messages = data.messages;
      selected = new Set();
      syncSeen();
    } catch (e) {
      error = 'Ошибка сети';
    } finally {
      loading = false;
    }
  }

  async function openMessage(msg) {
    loading = true;
    error = '';
    try {
      const data = await readMail(msg.id);
      if (data.err !== '0') {
        error = 'Не удалось открыть сообщение';
        return;
      }
      current = { ...msg, read: 1 };
      bodyHtml = data.text || '';
      canReply = data.reply === '1';
      messages = messages.map((m) => (m.id === msg.id ? { ...m, read: 1 } : m));
      mode = 'read';
      syncSeen();
    } catch (e) {
      error = 'Ошибка сети';
    } finally {
      loading = false;
    }
  }

  function openCompose(to = '') {
    composeTo = to;
    composeText = '';
    composeError = '';
    mode = 'compose';
  }

  function backToList() {
    mode = 'list';
    current = null;
    bodyHtml = '';
    composeError = '';
  }

  function toggleSelect(id, checked) {
    const next = new Set(selected);
    if (checked) next.add(id);
    else next.delete(id);
    selected = next;
  }

  async function removeSelected() {
    if (!selected.size) return;
    if (!confirm(`Удалить ${selected.size} сообщений?`)) return;
    loading = true;
    error = '';
    try {
      const data = await deleteMail([...selected]);
      if (data.err !== '0') {
        error = 'Не удалось удалить';
        return;
      }
      await loadList();
      mode = 'list';
    } catch (e) {
      error = 'Ошибка сети';
    } finally {
      loading = false;
    }
  }

  async function clearSystem() {
    if (!confirm('Удалить все системные сообщения? Личная переписка останется.')) return;
    loading = true;
    error = '';
    try {
      const data = await deleteMailAll();
      if (data.err !== '0') {
        error = 'Не удалось очистить';
        return;
      }
      await loadList();
    } catch (e) {
      error = 'Ошибка сети';
    } finally {
      loading = false;
    }
  }

  async function submitCompose() {
    const to = composeTo.trim();
    const text = composeText.trim();
    if (!to || !text) {
      composeError = 'Укажите получателя и текст';
      return;
    }
    loading = true;
    composeError = '';
    try {
      const check = await checkMailTo(to);
      if (check.err !== '0') {
        composeError = 'Получатель не найден';
        return;
      }
      const sent = await sendMail(to, text);
      if (sent.err !== '0') {
        composeError = 'Не удалось отправить';
        return;
      }
      await loadList();
      mode = 'list';
    } catch (e) {
      composeError = 'Ошибка сети';
    } finally {
      loading = false;
    }
  }

  function replyToSender() {
    if (!current) return;
    openCompose(current.from);
  }

  onMount(async () => {
    await loadList();
    if (toPrefill) openCompose(toPrefill);
  });
</script>

<div class="mail">
  <header class="mail-head">
    <h1>Почта</h1>
    {#if mode === 'list'}
      <div class="actions">
        <button type="button" on:click={() => openCompose()}>Написать</button>
        <button type="button" disabled={!selected.size || loading} on:click={removeSelected}>
          Удалить выбранные
        </button>
        <button type="button" disabled={loading} on:click={clearSystem}>Очистить системные</button>
      </div>
    {:else}
      <button type="button" class="back" on:click={backToList}>← К списку</button>
    {/if}
  </header>

  {#if error}
    <p class="error">{error}</p>
  {/if}

  {#if loading && mode === 'list' && !messages.length}
    <p class="status">Загрузка…</p>
  {:else if mode === 'list'}
    {#if !messages.length}
      <p class="status">Почтовый ящик пуст</p>
    {:else}
      <table class="inbox">
        <thead>
          <tr>
            <th class="col-check"></th>
            <th class="col-from">От</th>
            <th class="col-time">Дата</th>
            <th class="col-text">Сообщение</th>
          </tr>
        </thead>
        <tbody>
          {#each messages as msg (msg.id)}
            <tr class:unread={msg.read === 0}>
              <td class="col-check">
                <input
                  type="checkbox"
                  checked={selected.has(msg.id)}
                  on:change={(e) => toggleSelect(msg.id, e.currentTarget.checked)}
                />
              </td>
              <td class="col-from">
                <button type="button" class="link" on:click={() => openMessage(msg)}>{msg.from}</button>
              </td>
              <td class="col-time">{msg.time}</td>
              <td class="col-text">
                <button type="button" class="link preview" on:click={() => openMessage(msg)}>
                  {msg.preview}
                </button>
              </td>
            </tr>
          {/each}
        </tbody>
      </table>
    {/if}
  {:else if mode === 'read' && current}
    <article class="read">
      <div class="read-meta">
        <span class="from">{current.from}</span>
        <span class="time">{current.time}</span>
      </div>
      <div class="read-body">{@html bodyHtml}</div>
      {#if canReply}
        <button type="button" class="reply" on:click={replyToSender}>Ответить</button>
      {/if}
    </article>
  {:else if mode === 'compose'}
    <form class="compose" on:submit|preventDefault={submitCompose}>
      <label>
        Кому
        <input type="text" bind:value={composeTo} disabled={loading} />
      </label>
      <label>
        Текст
        <textarea rows="10" bind:value={composeText} disabled={loading}></textarea>
      </label>
      {#if composeError}
        <p class="error">{composeError}</p>
      {/if}
      <div class="actions">
        <button type="submit" disabled={loading}>Отправить</button>
        <button type="button" disabled={loading} on:click={backToList}>Отмена</button>
      </div>
    </form>
  {/if}
</div>

<style>
  .mail {
    padding: 16px 20px 24px;
    color: #ccc;
    font: 12px/1.4 Verdana, Arial, sans-serif;
    min-height: 100%;
    box-sizing: border-box;
  }

  .mail-head {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 12px;
    margin-bottom: 16px;
    flex-wrap: wrap;
  }

  h1 {
    margin: 0;
    font: bold 18px/1.2 Verdana, Arial, sans-serif;
    color: #7fd4ff;
    text-transform: uppercase;
    letter-spacing: 1px;
  }

  .actions {
    display: flex;
    gap: 8px;
    flex-wrap: wrap;
  }

  button {
    font: 11px Verdana, Arial, sans-serif;
    color: #dff6ff;
    background: #123a52;
    border: 1px solid #2a6a8a;
    padding: 4px 10px;
    cursor: pointer;
  }

  button:hover:not(:disabled) {
    background: #1a4d6a;
    border-color: #3d8ab0;
  }

  button:disabled {
    opacity: 0.5;
    cursor: default;
  }

  .back {
    margin-left: auto;
  }

  .status {
    color: #888;
    font-style: italic;
  }

  .error {
    color: #ff8888;
    margin: 0 0 12px;
  }

  .inbox {
    width: 100%;
    border-collapse: collapse;
  }

  .inbox th,
  .inbox td {
    border-bottom: 1px solid #1e3a4a;
    padding: 6px 8px;
    text-align: left;
    vertical-align: top;
  }

  .inbox th {
    color: #7fd4ff;
    font-weight: bold;
  }

  tr.unread td {
    color: #fff;
    font-weight: bold;
  }

  .col-check {
    width: 28px;
  }

  .col-from {
    width: 140px;
  }

  .col-time {
    width: 130px;
    white-space: nowrap;
    color: #888;
  }

  .link {
    background: none;
    border: 0;
    padding: 0;
    color: inherit;
    text-align: left;
    cursor: pointer;
  }

  .link:hover {
    color: #7fd4ff;
  }

  .preview {
    width: 100%;
  }

  .read-meta {
    display: flex;
    gap: 16px;
    margin-bottom: 12px;
    color: #7fd4ff;
  }

  .read-body {
    padding: 12px;
    border: 1px solid #2a6a8a;
    background: #0d1520;
    min-height: 120px;
    word-break: break-word;
  }

  .read-body :global(a) {
    color: #7fd4ff;
  }

  .reply {
    margin-top: 12px;
  }

  .compose {
    max-width: 640px;
    display: flex;
    flex-direction: column;
    gap: 10px;
  }

  .compose label {
    display: flex;
    flex-direction: column;
    gap: 4px;
    color: #7fd4ff;
  }

  .compose input,
  .compose textarea {
    font: 12px Verdana, Arial, sans-serif;
    color: #eee;
    background: #0d1520;
    border: 1px solid #2a6a8a;
    padding: 6px 8px;
  }

  .compose textarea {
    resize: vertical;
  }
</style>
