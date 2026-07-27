<script>
  import { onMount } from 'svelte';
  import TermConfirm from '../ui/TermConfirm.svelte';
  import { adminObjects, adminObjectSave, adminObjectDelete } from '../api.js';

  let objects = [];
  let classes = {};
  let selected = null;
  let calcMass = null;
  let filter = '';
  let classFilter = '';
  let form = blankForm();
  let confirmOpen = false;
  let err = '';

  function blankForm() {
    return {
      object: '',
      obj_name: '',
      min_cnt: '1',
      mass: '1',
      class: '0',
      price: '0',
      cprice: '0',
      weight: '0',
      make_time: '0',
    };
  }

  onMount(loadList);

  async function loadList() {
    try {
      const data = await adminObjects();
      objects = data.objects || [];
      classes = data.classes || {};
    } catch {
      err = 'load failed';
    }
  }

  async function select(id) {
    try {
      const data = await adminObjects({ object: id });
      selected = id;
      const o = data.object || {};
      form = {
        object: String(id),
        obj_name: o.name || '',
        min_cnt: String(o.min_cnt ?? '1'),
        mass: String(o.mass ?? '1'),
        class: String(o.class ?? '0'),
        price: String(o.price ?? '0'),
        cprice: String(o.cprice ?? '0'),
        weight: String(o.weight ?? '0'),
        make_time: String(o.make_time ?? '0'),
      };
      calcMass = data.calc_mass;
    } catch {
      err = 'load object failed';
    }
  }

  function newObject() {
    selected = 'new';
    form = blankForm();
    calcMass = null;
  }

  async function save() {
    try {
      const data = await adminObjectSave(form);
      await loadList();
      if (data.object_id) await select(data.object_id);
    } catch {
      err = 'save failed';
    }
  }

  async function remove() {
    confirmOpen = false;
    if (!form.object) return;
    try {
      await adminObjectDelete(form.object);
      selected = null;
      form = blankForm();
      await loadList();
    } catch {
      err = 'delete failed';
    }
  }

  $: filtered = objects.filter((o) => {
    if (classFilter !== '' && String(o.class) !== classFilter) return false;
    if (!filter) return true;
    const q = filter.toLowerCase();
    return String(o.name).toLowerCase().includes(q) || String(o.id).includes(q);
  });
</script>

<div class="term-master-detail">
  <div>
    <div class="term-row">
      <input bind:value={filter} placeholder="поиск" />
      <select bind:value={classFilter}>
        <option value="">class</option>
        {#each Object.entries(classes) as [id, name]}
          <option value={id}>{name}</option>
        {/each}
      </select>
      <button type="button" on:click={newObject}>[ NEW ]</button>
    </div>
    <div class="term-list">
      {#each filtered as o}
        <button type="button" class:active={selected === o.id} on:click={() => select(o.id)}>
          {o.class} · {o.name} (#{o.id})
        </button>
      {/each}
    </div>
  </div>

  <section class="term-panel">
    <h2 class="term-panel-title">Object editor</h2>
    {#if selected}
      <div class="term-row"><span>name</span><input bind:value={form.obj_name} /></div>
      <div class="term-row"><span>min_cnt</span><input bind:value={form.min_cnt} /></div>
      <div class="term-row"><span>mass</span><input bind:value={form.mass} /> {#if calcMass !== null}<span>calc: {calcMass}</span>{/if}</div>
      <div class="term-row"><span>price</span><input bind:value={form.price} /></div>
      <div class="term-row"><span>cprice</span><input bind:value={form.cprice} /></div>
      <div class="term-row"><span>weight</span><input bind:value={form.weight} /></div>
      <div class="term-row"><span>make_time</span><input bind:value={form.make_time} /></div>
      <div class="term-row">
        <span>class</span>
        <select bind:value={form.class}>
          {#each Object.entries(classes) as [id, name]}
            <option value={id}>{name}</option>
          {/each}
        </select>
      </div>
      <div class="term-row">
        <button type="button" on:click={save}>[ SAVE ]</button>
        {#if form.object}
          <button type="button" class="danger" on:click={() => (confirmOpen = true)}>[ DELETE ]</button>
        {/if}
      </div>
    {:else}
      <div class="term-empty">выберите объект</div>
    {/if}
    {#if err}<p class="term-error">{err}</p>{/if}
  </section>
</div>

<TermConfirm bind:open={confirmOpen} title="Delete object" message="Удалить объект?" on:confirm={remove} on:cancel={() => (confirmOpen = false)} />
