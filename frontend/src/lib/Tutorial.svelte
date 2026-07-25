<script>
  import { location } from 'svelte-spa-router';
  import ScifiButton from './ui/ScifiButton.svelte';
  import { fetchTutor, getNoonConfig } from './api.js';
  import { tutorialNavTick } from './tutorialStore.js';

  const PAGE_ID = {
    '/character': 1,
    '/mail': 1,
    '/place': 2,
    '/ships': 3,
    '/ware': 4,
    '/trade': 5,
    '/misc': 6,
  };

  let visible = false;
  let html = '';
  let lastPageId = -1;
  let lastTick = 0;
  let reqSeq = 0;
  let debounceTimer = null;

  $: pageId = PAGE_ID[$location];
  $: enabled = (parseInt(getNoonConfig().level, 10) || 99) <= 42;
  $: if (enabled) {
    const tick = $tutorialNavTick;
    if (pageId == null) {
      lastPageId = -1;
    } else if (pageId !== lastPageId) {
      lastPageId = pageId;
      lastTick = tick;
      scheduleLoad(pageId);
    } else if (tick !== lastTick) {
      lastTick = tick;
      if (!visible) {
        scheduleLoad(pageId);
      }
    }
  }

  function scheduleLoad(pg) {
    clearTimeout(debounceTimer);
    debounceTimer = setTimeout(() => {
      loadTutor(pg);
    }, 200);
  }

  async function loadTutor(pg) {
    const seq = ++reqSeq;
    try {
      const data = await fetchTutor(pg);
      if (seq !== reqSeq) return;
      if (String(data.err) === '0' && data.tx) {
        html = String(data.tx).replace(/\n/g, '<br>');
        visible = true;
      } else if (!visible) {
        html = '';
      }
    } catch (e) {
      if (seq !== reqSeq) return;
      if (!visible) {
        html = '';
      }
    }
  }

  function dismiss() {
    visible = false;
    clearTimeout(debounceTimer);
    if (pageId != null) {
      loadTutor(pageId);
    }
  }

  function onKey(e) {
    if (!visible) return;
    if (e.key === 'Escape') {
      e.preventDefault();
      dismiss();
    }
  }
</script>

<svelte:window on:keydown={onKey} />

{#if visible}
  <div class="tutorial-backdrop" role="presentation">
    <div
      class="scifi-panel scifi-modal tutorial-modal"
      role="dialog"
      aria-modal="true"
      aria-labelledby="tutorial-title"
    >
      <div class="panel-header" id="tutorial-title">Обучение</div>
      <div class="panel-content tutorial-body">
        <div class="tutorial-text">{@html html}</div>
        <div class="tutorial-actions">
          <ScifiButton variant="primary" on:click={dismiss}>Понятно</ScifiButton>
        </div>
      </div>
    </div>
  </div>
{/if}

<style>
  .tutorial-backdrop {
    position: fixed;
    inset: 0;
    z-index: 85;
    display: flex;
    align-items: center;
    justify-content: center;
    background: rgba(0, 4, 12, 0.72);
    backdrop-filter: blur(4px);
    padding: 16px;
  }

  .tutorial-modal {
    width: min(560px, 100%);
    max-height: min(80vh, 640px);
    display: flex;
    flex-direction: column;
  }

  .tutorial-body {
    display: flex;
    flex-direction: column;
    gap: 16px;
    min-height: 0;
    overflow: hidden;
  }

  .tutorial-text {
    margin: 0;
    color: var(--text-main);
    font-size: var(--font-size);
    line-height: 1.45;
    overflow: auto;
    max-height: min(55vh, 480px);
    padding-right: 4px;
  }

  .tutorial-text :global(b),
  .tutorial-text :global(strong) {
    color: var(--neon-cyan);
    font-weight: 600;
  }

  .tutorial-text :global(a) {
    color: inherit;
  }

  .tutorial-actions {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
    justify-content: flex-end;
    flex-shrink: 0;
  }
</style>
