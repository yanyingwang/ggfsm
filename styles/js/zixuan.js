
function zixuan() {
  return (localStorage['zixuan'] || "").split(',').filter((s) =>  s.length > 0 )
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
  return getStockNC().textContent.replace("add to WL", "").replace("delete from WL", "")
}
function zixuanAddItem() {
  localStorage['zixuan'] = zixuan().concat(getStockNCText());
  zixuanShow();
}
function zixuanDelItem() {
  localStorage['zixuan'] = zixuan().filter((s) => s !== getStockNCText());
  zixuanShow();
}
function zixuanShow() {
  if (zixuan().includes(getStockNCText())) {
    // document.getElementById("zixuan-add-item-button").setAttribute("disabled", "true")
    document.getElementById("zixuan-add-item-button").textContent = "delete from WL"
    document.getElementById("zixuan-add-item-button").classList = "btn btn-danger"
    document.getElementById("zixuan-add-item-button").setAttribute('onclick', 'zixuanDelItem()')
  } else {
    document.getElementById("zixuan-add-item-button").textContent = "add to WL"
    document.getElementById("zixuan-add-item-button").classList = "btn btn-success"
    document.getElementById("zixuan-add-item-button").setAttribute('onclick', 'zixuanAddItem()')
  }
}



// document.addEventListener("DOMContentLoaded", (event) => {
//   popDataToZixuan();
// });
