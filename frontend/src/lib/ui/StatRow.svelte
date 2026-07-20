<script>
  export let label = '';
  export let value = '';
  export let icon = 'dot';
  export let warn = false;
</script>

<div class="stat-row" class:warn>
  <span class="icon" aria-hidden="true">
    {#if icon === 'star'}
      <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="1.8">
        <path d="M12 2l2.4 7.2H22l-6 4.4 2.3 7L12 16.8 5.7 20.6 8 13.6 2 9.2h7.6L12 2z" />
      </svg>
    {:else if icon === 'planet'}
      <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="1.8">
        <circle cx="12" cy="12" r="7" />
        <path d="M3 12c2-3 5-4.5 9-4.5S19 9 21 12c-2 3-5 4.5-9 4.5S5 15 3 12z" />
      </svg>
    {:else if icon === 'credits'}
      <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="1.8">
        <circle cx="12" cy="12" r="9" />
        <path d="M12 7v10M9 9.5c.8-1 2-1.5 3-1.5s2.2.5 3 1.5M9 14.5c.8 1 2 1.5 3 1.5s2.2-.5 3-1.5" />
      </svg>
    {:else if icon === 'people'}
      <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="1.8">
        <circle cx="9" cy="8" r="3" />
        <circle cx="17" cy="9" r="2.5" />
        <path d="M3 19c1.5-3 4-4.5 6-4.5s4.5 1.5 6 4.5M14 14.5c1.5-.3 3-.1 4.5 1.5" />
      </svg>
    {:else if icon === 'robot'}
      <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="1.8">
        <rect x="5" y="8" width="14" height="11" rx="2" />
        <path d="M12 3v5M9 13h.01M15 13h.01M9 17h6" />
      </svg>
    {:else if icon === 'shield'}
      <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="1.8">
        <path d="M12 3l8 3v6c0 5-3.5 8.5-8 10-4.5-1.5-8-5-8-10V6l8-3z" />
      </svg>
    {:else}
      <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor">
        <circle cx="12" cy="12" r="4" />
      </svg>
    {/if}
  </span>
  <div class="body">
    <span class="label">{label}</span>
    <span class="value">
      {#if $$slots.default}
        <slot />
      {:else}
        {value}
      {/if}
    </span>
  </div>
</div>

<style>
  .stat-row {
    display: flex;
    align-items: flex-start;
    gap: 10px;
    padding: 6px 0;
    border-bottom: 1px solid rgba(255, 255, 255, 0.04);
  }

  .stat-row:last-child {
    border-bottom: 0;
  }

  .icon {
    flex: 0 0 auto;
    color: var(--neon-cyan);
    margin-top: 2px;
    opacity: 0.9;
  }

  .body {
    flex: 1 1 auto;
    min-width: 0;
    display: flex;
    flex-direction: column;
    gap: 2px;
  }

  .label {
    font-size: 0.68rem;
    letter-spacing: 0.6px;
    text-transform: uppercase;
    color: var(--text-muted);
  }

  .value {
    font-size: 0.9rem;
    color: var(--text-main);
    font-family: var(--font-mono);
    word-break: break-word;
  }

  .warn .value {
    color: var(--accent-warn);
  }
</style>
