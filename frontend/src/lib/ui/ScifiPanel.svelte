<script>
  export let title = '';
  export let className = '';
</script>

<div class="scifi-panel {className}">
  {#if title || $$slots.header}
    <div class="panel-header">
      {#if $$slots.header}
        <slot name="header" />
      {:else}
        {title}
      {/if}
    </div>
  {/if}
  <div class="panel-content">
    <slot />
  </div>
</div>
