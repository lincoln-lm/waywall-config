window.addEventListener("DOMContentLoaded", () => {
  const style = document.createElement("style");
  style.innerText = `
    body {
        background-color: rgba(0, 0, 0, 0);
        margin: 0px auto;
        overflow: hidden;
        font-family: 'Maple Mono';
        --player-background-color: transparent;
        --song-text-color: #e0def4;
        --artist-text-color: #eb6f92;
    }
    `;
  document.head.appendChild(style);
});
