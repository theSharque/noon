<script>
  import { createEventDispatcher, onDestroy, onMount } from 'svelte';

  export let value = '';
  export let options = [];
  export let className = '';
  export let disabled = false;

  const dispatch = createEventDispatcher();
  let open = false;
  let root;

  $: selected = options.find((o) => String(o.value) === String(value));
  $: label = selected ? selected.label : '—';

  function toggle() {
    if (disabled || !options.length) return;
    open = !open;
  }

  function pick(next) {
    value = next;
    open = false;
    dispatch('change', { value: next });
  }

  function onDocPointer(e) {
    if (!open || !root) return;
    if (!root.contains(e.target)) open = false;
  }

  onMount(() => {
    document.addEventListener('pointerdown', onDocPointer, true);
  });

  onDestroy(() => {
    document.removeEventListener('pointerdown', onDocPointer, true);
  });
</script>

<div class="scifi-combo {className}" class:open class:disabled bind:this={root}>
  <button type="button" class="scifi-combo-trigger" {disabled} on:click={toggle}>
    <span class="scifi-combo-label">{label}</span>
    <span class="scifi-combo-caret" aria-hidden="true"></span>
  </button>
  {#if open && options.length}
    <div class="scifi-combo-menu" role="listbox">
      {#each options as opt}
        <button
          type="button"
          class="scifi-combo-option"
          class:active={String(opt.value) === String(value)}
          role="option"
          aria-selected={String(opt.value) === String(value)}
          on:click={() => pick(opt.value)}
        >
          {opt.label}
        </button>
      {/each}
    </div>
  {/if}
</div>
