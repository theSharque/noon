<script>
  import { onMount } from 'svelte';
  import { adminTutorials, adminTutorialSave } from '../api.js';

  let tutorials = [];
  let level = '';
  let pageId = '';
  let premium = '';
  let text = '';
  let err = '';

  onMount(load);

  async function load() {
    try {
      const data = await adminTutorials();
      tutorials = data.tutorials || [];
    } catch {
      err = 'load failed';
    }
  }

  async function pick(lvl) {
    level = String(lvl);
    try {
      const data = await adminTutorials({ level: lvl });
      const cur = data.current;
      if (cur) {
        pageId = String(cur.page_id);
        premium = String(cur.premium);
        text = cur.tutorial || '';
      }
    } catch {
      err = 'load tutorial failed';
    }
  }

  async function save() {
    try {
      await adminTutorialSave({ level, page_id: pageId, premium, tutorial: text });
    } catch {
      err = 'save failed';
    }
  }
</script>

<div class="term-master-detail">
  <div class="term-list">
    {#each tutorials as t}
      <button type="button" class:active={level === String(t.level)} on:click={() => pick(t.level)}>
        lvl {t.level} · page {t.page_id} · prem {t.premium}
      </button>
    {/each}
  </div>

  <section class="term-panel">
    <h2 class="term-panel-title">Tutorial editor</h2>
    {#if level}
      <div class="term-row"><span>level</span><input bind:value={level} /></div>
      <div class="term-row"><span>page_id</span><input bind:value={pageId} /></div>
      <div class="term-row"><span>premium</span><input bind:value={premium} /></div>
      <textarea bind:value={text} rows="22" style="width:100%"></textarea>
      <div class="term-row"><button type="button" on:click={save}>[ SAVE ]</button></div>
    {:else}
      <div class="term-empty">выберите уровень</div>
    {/if}
    {#if err}<p class="term-error">{err}</p>{/if}
  </section>
</div>
