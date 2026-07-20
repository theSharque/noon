<script>
  import { location } from 'svelte-spa-router';
  import { routeMeta } from '../lib/router.js';

  $: meta = routeMeta[$location] || {
    title: 'Полдень 21 века',
    gallery: '/images/char.jpg',
    hint: 'Экран в разработке',
  };
</script>

<div class="stub scifi-panel">
  <div class="panel-header">{meta.title}</div>
  <div class="panel-content">
    {#if meta.pageId}
      <p class="page-id">page {meta.pageId}</p>
    {/if}
    <p class="hint">{meta.hint}</p>
    <p class="route">{$location}</p>
    <img src={meta.gallery} alt={meta.title} />
    <p class="note">Экран будет портирован в cosmic UI.</p>
  </div>
</div>

<style>
  .stub {
    max-width: 900px;
    margin: 0 auto;
  }

  .page-id {
    margin: 0 0 6px;
    font-size: 0.75rem;
    color: var(--text-muted);
    text-transform: lowercase;
  }

  .hint {
    margin: 0 0 8px;
    color: var(--text-main);
  }

  .route {
    margin: 0 0 12px;
    color: var(--text-muted);
    font-family: var(--font-mono);
    font-size: 0.75rem;
  }

  img {
    display: block;
    max-width: 100%;
    height: auto;
    border: 1px solid var(--border-light);
    box-shadow: var(--glow-soft);
  }

  .note {
    margin-top: 12px;
    color: var(--text-muted);
    font-style: italic;
    font-size: 0.85rem;
  }
</style>
