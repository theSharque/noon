<script>
  export let open = false;
  export let title = 'Подтвердите';
  export let message = '';
  export let confirmLabel = '[ OK ]';
  export let cancelLabel = '[ CANCEL ]';
  export let danger = false;

  import { createEventDispatcher } from 'svelte';

  const dispatch = createEventDispatcher();
</script>

{#if open}
  <div class="term-overlay" role="presentation" on:click={() => dispatch('cancel')}>
    <div class="term-dialog" role="dialog" on:click|stopPropagation>
      <div class="term-panel-title">{title}</div>
      <p>{message}</p>
      <div class="term-dialog-actions">
        <button type="button" on:click={() => dispatch('cancel')}>{cancelLabel}</button>
        <button type="button" class:danger on:click={() => dispatch('confirm')}>{confirmLabel}</button>
      </div>
    </div>
  </div>
{/if}
