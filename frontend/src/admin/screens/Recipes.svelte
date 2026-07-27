<script>
  import { onMount } from 'svelte';
  import { adminRecipes, adminRecipeAdd, adminRecipeDelete } from '../api.js';

  let objects = [];
  let selected = 0;
  let subs = [];
  let addObj = '';
  let count = '1';
  let err = '';
  let filter = '';

  onMount(load);

  async function load() {
    try {
      const data = await adminRecipes({ object: selected || undefined });
      objects = data.objects || [];
      if (selected) subs = data.subs || [];
    } catch {
      err = 'load failed';
    }
  }

  async function pick(id) {
    selected = id;
    try {
      const data = await adminRecipes({ object: id });
      subs = data.subs || [];
    } catch {
      err = 'load subs failed';
    }
  }

  async function add() {
    try {
      await adminRecipeAdd(selected, addObj, count);
      await pick(selected);
    } catch {
      err = 'add failed';
    }
  }

  async function delSub(resId) {
    try {
      await adminRecipeDelete(selected, resId);
      await pick(selected);
    } catch {
      err = 'delete failed';
    }
  }

  $: filtered = objects.filter((o) => {
    if (!filter) return true;
    const q = filter.toLowerCase();
    return String(o.name).toLowerCase().includes(q);
  });
</script>

<div class="term-master-detail">
  <div>
    <input bind:value={filter} placeholder="поиск объекта" />
    <div class="term-list">
      {#each filtered as o}
        <button type="button" class:active={selected === o.id} on:click={() => pick(o.id)}>
          {o.class} {o.name}
        </button>
      {/each}
    </div>
  </div>

  <section class="term-panel">
    <h2 class="term-panel-title">Recipes (objects_sub)</h2>
    {#if selected}
      <table class="term-table">
        <thead><tr><th>resource</th><th>cnt</th><th>mass</th><th>price</th><th></th></tr></thead>
        <tbody>
          {#each subs as s}
            <tr>
              <td>{s.name}</td><td>{s.res_cnt}</td><td>{s.mass}</td><td>{s.myprice}</td>
              <td><button type="button" class="danger" on:click={() => delSub(s.res_id)}>x</button></td>
            </tr>
          {/each}
        </tbody>
      </table>
      <div class="term-row">
        <select bind:value={addObj}>
          <option value="">добавить ресурс</option>
          {#each objects as o}
            <option value={o.id}>{o.class} {o.name}</option>
          {/each}
        </select>
        <input bind:value={count} style="width:80px" />
        <button type="button" on:click={add}>[ ADD ]</button>
      </div>
    {:else}
      <div class="term-empty">выберите объект</div>
    {/if}
    {#if err}<p class="term-error">{err}</p>{/if}
  </section>
</div>
