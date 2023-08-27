
function zixuan() {
  return (localStorage['zixuan'] || "").split(',')
}

function zixuanIndex() {
    zixuan().forEach((s) => {
    const a = document.createElement("a")
    a.classList.add("link-underline-light")
    a.setAttribute('href', s.split(/（|）/)[1] + ".html")
    a.textContent = s.split(/（|）/)[0]
    const div = document.createElement("div")
    div.classList.add("col-2", "my-2")
    div.appendChild(a)
    document.getElementById("zixuan").appendChild(div)
    });
  document.getElementById("zixuan").firstChild.remove();
}


function getStockNC() {
  return document.getElementById('stock-name-code')
}
function getStockNCText() {
  return getStockNC().textContent.replace("加自选", "").replace("已添加", "")
}
function zixuanAddItem() {
  localStorage['zixuan'] = zixuan().concat(getStockNCText());
  zixuanShow();
}
function zixuanShow() {
  if (zixuan().includes(getStockNCText())) {
    document.getElementById("zixuan-add-item-button").setAttribute("disabled", "true")
    document.getElementById("zixuan-add-item-button").textContent = "已添加"
  }
}



// document.addEventListener("DOMContentLoaded", (event) => {
//   popDataToZixuan();
// });
