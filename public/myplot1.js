const xArray = [50,60,70,80,90,100,110,120,130,140,150];
const yArray = [7,8,8,9,9,9,10,11,14,14,15];

// Define Data
const data = [{
  x: xArray,
  y: yArray,
  mode:"markers",
  type:"scatter"
}];

// Define Layout
const layout = {
  xaxis: {range: [40, 160], title: "Square Meters"},
  yaxis: {range: [5, 16], title: "Price in Millions"},
  title: "House Prices vs. Size"
};

Plotly.newPlot("myPlot", data, layout);




// const xArray = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130];
// const yArray = [57,58,57,50,49,49,49,49,49,49,50,41,41,41,41,41,41,41,41,41,42,41,42,42,41,33,33,33,34,33,33,34,27,27,38,36,35,34,35,33,33,34,35,35,35,34,37,43,42,41,44,44,42,37,35,34,34,26,23,20,19,18,18,17,18,17,9,19,17,18,17,17,17,17,18,18,17,17,18,9,10,11,11,18,18,9,10,10,12,18,18,17,19,27,18,18,15,10,9,9,9,9,9,10,9,9,9,9,9,9,12,18,9,18,17,17,17,18,18,18,17,18,28,29,26,28,27,27,25,28];

// // Define Data
// const data = [{
//   x: xArray,
//   y: yArray,
//   mode:"markers",
//   type:"scatter"
// }];

// // Define Layout
// const layout = {
//   xaxis: {range: [0, 130], title: "时间"},
//   yaxis: {range: [0, 64], title: "卦象"},
//   title: "卦象走势图"
// };

// Plotly.newPlot("myPlot", data, layout;)




// const xArray = [50,60,70,80,90,100,110,120,130,140,150];
// const yArray = [7,8,8,9,9,9,10,11,14,14,15];

// // Define Data
// const data = [{
//   x:xArray,
//   y:yArray,
//   mode:"markers"
// }];
// // Define Layout
// const layout = {
//   xaxis: {range: [40, 160], title: "Square Meters"},
//   yaxis: {range: [5, 16], title: "Price in Millions"},
//   title: "House Prices vs. Size"
// };
// // Display using Plotly
// Plotly.newPlot("myPlot", data, layout, {responsive: true});






// const xArray1 = ["Italy", "France", "Spain", "USA", "Argentina"];
// const yArray1 = [55, 49, 44, 24, 15];
// const layout1 = {title:"World Wide Wine Production"};
// const data1 = [{labels: xArray1, values: yArray1, type: "pie"}];
// Plotly.newPlot("myPlot1", data1, layout1);


// var trace21 = {
//   x: [0, 1, 2, 3, 4],
//   y: [1, 5, 3, 7, 5],
//   mode: 'lines+markers',
//   type: 'scatter'
// };
// var trace22 = {
//   x: [1, 2, 3, 4, 5],
//   y: [4, 0, 4, 6, 8],
//   mode: 'lines+markers',
//   type: 'scatter'
// };
// var data2 = [trace21, trace22];
// var layout2 = {title: 'Click Here<br>to Edit Chart Title'};
// Plotly.newPlot('myPlot2', data2, layout2, {editable: true});
