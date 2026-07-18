<script>
  import { location } from 'svelte-spa-router';
  import { routeMeta } from '../lib/router.js';

  $: meta = routeMeta[$location] || {
    title: 'Полдень 21 века',
    gallery: '/images/char.jpg',
    hint: 'Экран в разработке',
  };
</script>

<div class="stub">
  <div class="stub-head">
    <h1>{meta.title}</h1>
    <p>{meta.hint}</p>
    <p class="route">{$location}</p>
  </div>
  <div class="stub-preview">
    <img src={meta.gallery} alt={meta.title} />
    <p class="note">Экран будет портирован по эталону из галереи.</p>
  </div>
</div>

<style>
  .stub {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 16px;
    min-height: 100%;
  }

  .stub-head {
    text-align: center;
    margin-bottom: 12px;
  }

  h1 {
    margin: 0 0 8px;
    font: bold 18px/1.2 Verdana, Arial, sans-serif;
    color: #7fd4ff;
    text-transform: uppercase;
    letter-spacing: 1px;
  }

  p {
    margin: 4px 0;
    font: 12px/1.4 Verdana, Arial, sans-serif;
    color: #aaa;
  }

  .route {
    color: #555;
    font-size: 10px;
  }

  .stub-preview {
    max-width: 780px;
    text-align: center;
  }

  img {
    display: block;
    max-width: 100%;
    height: auto;
    border: 1px solid #2a6a8a;
    box-shadow: 0 0 12px rgba(0, 180, 255, 0.15);
  }

  .note {
    margin-top: 10px;
    color: #666;
    font-style: italic;
  }
</style>
