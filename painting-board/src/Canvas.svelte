<script>
  import { onMount } from "svelte";

  onMount(async () => {
    const canvas = document.querySelector("#draw-area");
    const context = canvas.getContext("2d");
    canvas.addEventListener("mousedown", (event) => dragStart(event, context));
    canvas.addEventListener("mouseup", (event) => dragEnd(event, context));
    canvas.addEventListener("mouseout", (event) => dragEnd(event, context));
    canvas.addEventListener("mousemove", (event) => {
      draw(event.layerX, event.layerY, context);
    });
  });
  let isDrag = false;
  const lastPosition = { x: null, y: null };
  const dragStart = (event, context) => {
    console.debug("drag start");
    context.beginPath();
    isDrag = true;
  };

  const dragEnd = (event, context) => {
    console.debug("drag end");
    context.closePath();
    isDrag = false;
    lastPosition.x = null;
    lastPosition.y = null;
  };
  const draw = (x, y, context) => {
    if (!isDrag) return;
    context.lineCap = "round";
    context.lineJoin = "round";
    context.lineWidth = 5;
    context.strokeStyle = "#000000";
    if (lastPosition.x === null || lastPosition.y === null) {
      context.moveTo(x, y);
    } else {
      context.moveTo(lastPosition.x, lastPosition.y);
    }
    context.lineTo(x, y);
    context.stroke();
    lastPosition.x = x;
    lastPosition.y = y;
  };
</script>

<main>
  <canvas
    id="draw-area"
    width="600px"
    height="400px"
    style="border: 1px solid #000000;"
  />
</main>

<style></style>
