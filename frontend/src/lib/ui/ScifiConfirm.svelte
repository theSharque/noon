<script>
  import { onDestroy } from 'svelte';
  import ScifiButton from './ScifiButton.svelte';
  import { confirmDialog, closeConfirm } from '../confirmStore.js';

  let state = null;
  const unsub = confirmDialog.subscribe((value) => {
    state = value;
  });

  function onKey(e) {
    if (!state) return;
    switch (e.key) {
      case 'Escape':
        e.preventDefault();
        closeConfirm(false);
        break;
      case 'Enter':
        e.preventDefault();
        closeConfirm(true);
        break;
    }
  }

  function onBackdrop(e) {
    if (e.target === e.currentTarget) closeConfirm(false);
  }

  if (typeof window !== 'undefined') {
    window.addEventListener('keydown', onKey);
  }

  onDestroy(() => {
    unsub();
    if (typeof window !== 'undefined') {
      window.removeEventListener('keydown', onKey);
    }
  });
</script>

{#if state}
  <!-- svelte-ignore a11y-click-events-have-key-events a11y-no-static-element-interactions -->
  <div class="scifi-confirm-backdrop" on:click={onBackdrop} role="presentation">
    <div class="scifi-panel scifi-modal scifi-confirm" role="dialog" aria-modal="true" aria-labelledby="scifi-confirm-title">
      <div class="panel-header" id="scifi-confirm-title">{state.title}</div>
      <div class="panel-content scifi-confirm-body">
        <p class="scifi-confirm-message">{state.message}</p>
        <div class="scifi-confirm-actions">
          <ScifiButton
            variant={state.danger ? 'danger' : 'primary'}
            on:click={() => closeConfirm(true)}
          >
            {state.confirmLabel}
          </ScifiButton>
          <ScifiButton variant="ghost" on:click={() => closeConfirm(false)}>
            {state.cancelLabel}
          </ScifiButton>
        </div>
      </div>
    </div>
  </div>
{/if}

<style>
  .scifi-confirm-backdrop {
    position: fixed;
    inset: 0;
    z-index: 80;
    display: flex;
    align-items: center;
    justify-content: center;
    background: rgba(0, 4, 12, 0.72);
    backdrop-filter: blur(4px);
    padding: 16px;
  }

  .scifi-confirm {
    width: min(440px, 100%);
  }

  .scifi-confirm-body {
    display: flex;
    flex-direction: column;
    gap: 16px;
  }

  .scifi-confirm-message {
    margin: 0;
    white-space: pre-wrap;
    color: var(--text-main);
    font-size: var(--font-size);
    line-height: 1.45;
  }

  .scifi-confirm-actions {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
    justify-content: flex-end;
  }
</style>
