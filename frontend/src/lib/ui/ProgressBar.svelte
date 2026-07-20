<script>
  export let label = '';
  export let value = '';
  export let percent = 0;

  $: width = Math.max(0, Math.min(100, Number(percent) || 0));
</script>

<div class="progress-container">
  <div class="progress-label">
    <span>{label}</span>
    <span class="num">{value}</span>
  </div>
  <div class="progress-track">
    <div class="progress-fill" style="width:{width}%"></div>
  </div>
</div>
