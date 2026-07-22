<script>
  export let variant = 'ghost';
  export let type = 'button';
  export let disabled = false;
  export let className = '';
</script>

<button class="scifi-btn {variant} {className}" {type} {disabled} on:click>
  <slot />
</button>
