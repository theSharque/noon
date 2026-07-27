<script>
  import { onMount } from 'svelte';
  import { adminShipTypes, adminShipTypeSave } from '../api.js';

  let ships = [];
  let shipObjs = [];
  let conservObjs = [];
  let form = blank();
  let err = '';

  function blank() {
    return {
      ship_id: '',
      conserv_id: '',
      planet: '0',
      hyper: '0',
      shield: '0',
      cargo: '0',
      w_power: '0',
      w_count: '0',
      code: '',
      planet_cnt: '0',
      hyper_cnt: '0',
      agrav: false,
      radar: false,
      cloak: false,
      remote: false,
    };
  }

  onMount(load);

  async function load() {
    try {
      const data = await adminShipTypes();
      ships = data.ships || [];
      shipObjs = data.ship_objects || [];
      conservObjs = data.conserv_objects || [];
    } catch {
      err = 'load failed';
    }
  }

  function edit(row) {
    form = {
      ship_id: String(row.ship_id),
      conserv_id: String(row.conserv_id),
      planet: String(row.planet),
      hyper: String(row.hyper),
      shield: String(row.shield),
      cargo: String(row.cargo),
      w_power: String(row.w_power),
      w_count: String(row.w_count),
      code: row.code || '',
      planet_cnt: String(row.planet_cnt),
      hyper_cnt: String(row.hyper_cnt),
      agrav: !!Number(row.agrav),
      radar: !!Number(row.radar),
      cloak: !!Number(row.cloak),
      remote: !!Number(row.remote),
    };
  }

  async function save() {
    try {
      await adminShipTypeSave({
        ...form,
        agrav: form.agrav ? '1' : '',
        radar: form.radar ? '1' : '',
        cloak: form.cloak ? '1' : '',
        remote: form.remote ? '1' : '',
      });
      form = blank();
      await load();
    } catch {
      err = 'save failed';
    }
  }
</script>

<section class="term-panel">
  <h2 class="term-panel-title">Ship types</h2>
  <div style="overflow:auto">
    <table class="term-table">
      <thead>
        <tr>
          <th>ship</th><th>conserv</th><th>planet</th><th>hyper</th><th>shield</th><th>cargo</th>
          <th>w_power</th><th>w_count</th><th>code</th><th></th>
        </tr>
      </thead>
      <tbody>
        {#each ships as s}
          <tr>
            <td>{s.ship_name}</td><td>{s.conserv_name}</td><td>{s.planet}</td><td>{s.hyper}</td>
            <td>{s.shield}</td><td>{s.cargo}</td><td>{s.w_power}</td><td>{s.w_count}</td><td>{s.code}</td>
            <td><button type="button" on:click={() => edit(s)}>edit</button></td>
          </tr>
        {/each}
      </tbody>
    </table>
  </div>
</section>

<section class="term-panel">
  <h2 class="term-panel-title">Upsert</h2>
  <div class="term-row">
    <select bind:value={form.ship_id}><option value="">ship</option>{#each shipObjs as o}<option value={o.id}>{o.name}</option>{/each}</select>
    <select bind:value={form.conserv_id}><option value="">conserv</option>{#each conservObjs as o}<option value={o.id}>{o.name}</option>{/each}</select>
  </div>
  <div class="term-row">
    <input bind:value={form.planet} placeholder="planet speed" />
    <input bind:value={form.hyper} placeholder="hyper speed" />
    <input bind:value={form.shield} placeholder="shield" />
    <input bind:value={form.cargo} placeholder="cargo" />
  </div>
  <div class="term-row">
    <input bind:value={form.w_power} placeholder="w_power" />
    <input bind:value={form.w_count} placeholder="w_count" />
    <input bind:value={form.code} placeholder="code" />
    <input bind:value={form.planet_cnt} placeholder="planet fuel" />
    <input bind:value={form.hyper_cnt} placeholder="hyper fuel" />
  </div>
  <div class="term-row">
    <label><input type="checkbox" bind:checked={form.agrav} /> agrav</label>
    <label><input type="checkbox" bind:checked={form.radar} /> radar</label>
    <label><input type="checkbox" bind:checked={form.cloak} /> cloak</label>
    <label><input type="checkbox" bind:checked={form.remote} /> remote</label>
    <button type="button" on:click={save}>[ SAVE ]</button>
  </div>
  {#if err}<p class="term-error">{err}</p>{/if}
</section>
