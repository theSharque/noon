<script>
  import { createEventDispatcher } from 'svelte';

  export let tabs = [];
  export let active = '';

  const dispatch = createEventDispatcher();

  function select(id) {
    if (id === active) return;
    dispatch('change', id);
  }
</script>

<div class="scifi-tabs" role="tablist">
  {#each tabs as tab}
    <button
      type="button"
      class="tab"
      class:active={active === tab.id}
      role="tab"
      aria-selected={active === tab.id}
      on:click={() => select(tab.id)}
    >
      {tab.label}
    </button>
  {/each}
</div>
