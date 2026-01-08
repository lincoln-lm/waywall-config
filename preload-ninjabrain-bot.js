window.addEventListener("DOMContentLoaded", () => {
  const style = document.createElement("style");
  style.innerText = `
    body {
      background-color: rgba(0, 0, 0, 0);
      color: white;
      margin: 0px auto;
      overflow: hidden;
      width: 1000px;
      height: 1000px;
      position: absolute;
      top: 1117px;
      left: 896px;
      text-shadow:
        -1px -1px 0 #000,
        1px -1px 0 #000,
        -1px 1px 0 #000,
        1px 1px 0 #000; 
    }
    `;
  document.head.appendChild(style);
});
