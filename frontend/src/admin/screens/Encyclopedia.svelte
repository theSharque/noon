<script>
  import { onMount } from 'svelte';
  import TermConfirm from '../ui/TermConfirm.svelte';
  import { adminEncyclopedia, adminEncyclopediaSave, adminEncyclopediaRebuild } from '../api.js';

  let objects = [];
  let selected = 0;
  let desc = '';
  let filter = '';
  let err = '';
  let rebuildOpen = false;

  onMount(load);

  async function load() {
    try {
      const data = await adminEncyclopedia({ object: selected || undefined });
      objects = data.objects || [];
      if (selected) desc = data.desc || '';
    } catch {
      err = 'load failed';
    }
  }

  async function pick(id) {
    selected = id;
    try {
      const data = await adminEncyclopedia({ object: id });
      desc = data.desc || '';
    } catch {
      err = 'load desc failed';
    }
  }

  async function save() {
    try {
      await adminEncyclopediaSave(selected, desc);
    } catch {
      err = 'save failed';
    }
  }

  async function rebuild() {
    rebuildOpen = false;
    try {
      await adminEncyclopediaRebuild();
      await load();
    } catch {
      err = 'rebuild failed';
    }
  }

  $: filtered = objects.filter((o) => {
    if (!filter) return true;
    const q = filter.toLowerCase();
    return String(o.name).toLowerCase().includes(q);
  });
</script>

<section class="term-panel">
  <button type="button" on:click={() => (rebuildOpen = true)}>[ REBUILD MINERAL ENC ]</button>
</section>

<div class="term-master-detail">
  <div>
    <input bind:value={filter} placeholder="поиск" />
    <div class="term-list">
      {#each filtered as o}
        <button type="button" class:active={selected === o.id} on:click={() => pick(o.id)}>
          {o.class}:{o.name}
        </button>
      {/each}
    </div>
  </div>

  <section class="term-panel">
    <h2 class="term-panel-title">Encyclopedia</h2>
    {#if selected}
      <textarea bind:value={desc} rows="24" style="width:100%"></textarea>
      <div class="term-row"><button type="button" on:click={save}>[ SAVE ]</button></div>
    {:else}
      <div class="term-empty">выберите объект</div>
    {/if}
    {#if err}<p class="term-error">{err}</p>{/if}
  </section>
</div>

<TermConfirm bind:open={rebuildOpen} title="Rebuild minerals" message="Пересобрать описания минералов?" on:confirm={rebuild} on:cancel={() => (rebuildOpen = false)} />
