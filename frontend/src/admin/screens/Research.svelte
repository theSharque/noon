<script>
  import { onMount } from 'svelte';
  import { adminResearch, adminResearchSave } from '../api.js';

  let links = [];
  let layouts = [];
  let fromObj = '';
  let toObj = '';
  let err = '';

  onMount(load);

  async function load() {
    try {
      const data = await adminResearch();
      links = data.links || [];
      layouts = data.layouts || [];
    } catch {
      err = 'load failed';
    }
  }

  async function save() {
    try {
      await adminResearchSave(fromObj, toObj);
      fromObj = '';
      toObj = '';
      await load();
    } catch {
      err = 'save failed';
    }
  }
</script>

<section class="term-panel">
  <h2 class="term-panel-title">Research links</h2>
  <table class="term-table">
    <thead><tr><th>from</th><th></th><th>to</th></tr></thead>
    <tbody>
      {#each links as l}
        <tr><td>{l.from_name}</td><td>-&gt;</td><td>{l.to_name}</td></tr>
      {/each}
    </tbody>
  </table>
</section>

<section class="term-panel">
  <h2 class="term-panel-title">Add / update</h2>
  <div class="term-row">
    <select bind:value={fromObj}>
      <option value="">from</option>
      {#each layouts as o}<option value={o.id}>{o.name}</option>{/each}
    </select>
    <select bind:value={toObj}>
      <option value="">to</option>
      {#each layouts as o}<option value={o.id}>{o.name}</option>{/each}
    </select>
    <button type="button" on:click={save}>[ SAVE ]</button>
  </div>
  {#if err}<p class="term-error">{err}</p>{/if}
</section>
