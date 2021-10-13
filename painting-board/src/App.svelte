<script>
  import Canvas from "./Canvas.svelte";
  //   export let name;
</script>

<main>
  <h1 class="rainbow_font">Data Generator</h1>
  <Canvas />
</main>

<style>
  main {
    text-align: center;
    padding: 1em;
    max-width: 240px;
    margin: 0 auto;
  }

  h1 {
    /* color: #ff3e00; */
    color: #999333;
    /* text-transform: uppercase; */
    font-size: 4em;
    font-weight: 100;
  }
  @media (min-width: 640px) {
    main {
      max-width: none;
    }
  }
</style>
