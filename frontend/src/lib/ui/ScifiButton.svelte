<script>
  export let variant = 'ghost';
  export let type = 'button';
  export let disabled = false;
</script>

<button class="scifi-btn {variant}" {type} {disabled} on:click>
  <slot />
</button>
