<script>
  export let colorPrimary = "oklch(0.558 0.288 302.321)";
  export let colorSecondary = "oklch(0.769 0.188 70.08)";
  export let size = 50;
</script>

<div class="mt-4 -ml-4">
  <svg width={size} height={size} viewBox="0 0 50 50">
    <circle cx="25" cy="25" r="8" fill="none" stroke={colorPrimary} stroke-width="1" opacity="0">
      <animate attributeName="r" from="8" to="20" dur="2s" begin="0s" repeatCount="indefinite"
      ></animate>
      <animate attributeName="opacity" from="1" to="0" dur="2s" begin="0s" repeatCount="indefinite"
      ></animate>
    </circle>
    <circle cx="25" cy="25" r="8" fill="none" stroke={colorSecondary} stroke-width="1" opacity="0">
      <animate attributeName="r" from="8" to="20" dur="2s" begin="0.6s" repeatCount="indefinite"
      ></animate>
      <animate
        attributeName="opacity"
        from="1"
        to="0"
        dur="2s"
        begin="0.6s"
        repeatCount="indefinite"
      ></animate>
    </circle>
    <circle cx="25" cy="25" r="8" fill="none" stroke={colorPrimary} stroke-width="1" opacity="0">
      <animate attributeName="r" from="8" to="20" dur="2s" begin="1.2s" repeatCount="indefinite"
      ></animate>
      <animate
        attributeName="opacity"
        from="1"
        to="0"
        dur="2s"
        begin="1.2s"
        repeatCount="indefinite"
      ></animate>
    </circle>
    <circle cx="25" cy="25" r="8" fill={colorPrimary}
      ><animate attributeName="r" values="6;8;6" dur="1s" repeatCount="indefinite"></animate>
    </circle>
  </svg>
</div>
