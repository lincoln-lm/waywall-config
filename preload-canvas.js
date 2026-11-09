window.addEventListener("DOMContentLoaded", () => {
  const style = document.createElement("style");
  style.innerText = `
    body {
      background-color: rgba(0, 0, 0, 0);
      color: white;
      margin: 0px auto;
      overflow: hidden;
      position: absolute;
      top: 0px;
      left: 0px;
      text-shadow:
        -1px -1px 0 #000,
        1px -1px 0 #000,
        -1px 1px 0 #000,
        1px 1px 0 #000; 
    }
    `;
  document.head.appendChild(style);
});
