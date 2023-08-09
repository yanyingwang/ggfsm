var axyValues = [
  {x:50, y:7},
  {x:60, y:8},
  {x:70, y:8},
  {x:80, y:9},
  {x:90, y:9},
  {x:100, y:9},
  {x:110, y:10},
  {x:120, y:11},
  {x:130, y:14},
  {x:140, y:14},
  {x:150, y:15}
];


new Chart("a1234a", {
  type: "scatter",
  data: {
    datasets: [{
      pointRadius: 4,
      pointBackgroundColor: "rgb(0,0,255)",
      data: axyValues
    }]
  },
  options: {
    legend: {display: false},
    scales: {
      xAxes: [{ticks: {min: 40, max:160}}],
      yAxes: [{ticks: {min: 6, max:16}}],
    }
  }
});



const zxValues = [50,60,70,80,90,100,110,120,130,140,150];
const zyValues = [7,8,8,9,9,9,10,11,14,14,15];

new Chart("a1234z", {
  type: "line",
  data: {
    labels: zxValues,
    datasets: [{
      fill: false,
      lineTension: 0,
      backgroundColor: "rgba(0,0,255,1.0)",
      borderColor: "rgba(0,0,255,0.1)",
      data: zyValues
    }]
  },
  options: {
    legend: {display: false},
    scales: {
      yAxes: [{ticks: {min: 6, max:16}}],
    }
  }
});



const bxValues = [100,200,300,400,500,600,700,800,900,1000];

new Chart("a1234b", {
  type: "line",
  data: {
    labels: bxValues,
    datasets: [{
      data: [860,1140,1060,1060,1070,1110,1330,2210,7830,2478],
      borderColor: "red",
      fill: false
    },{
      data: [1600,1700,1700,1900,2000,2700,4000,5000,6000,7000],
      borderColor: "green",
      fill: false
    },{
      data: [300,700,2000,5000,6000,4000,2000,1000,200,100],
      borderColor: "blue",
      fill: false
    }]
  },
  options: {
    legend: {display: false}
  }
});




var cxValues = ["Italy", "France", "Spain", "USA", "Argentina"];
var cyValues = [55, 49, 44, 24, 15];
var cbarColors = ["red", "green","blue","orange","brown"];

new Chart("a1234c", {
  type: "bar",
  data: {
    labels: cxValues,
    datasets: [{
      backgroundColor: cbarColors,
      data: cyValues
    }]
  },
  options: {
    legend: {display: false},
    title: {
      display: true,
      text: "World Wine Production 2018"
    }
  }
});


new Chart("a1234d", {
  type: "pie",
  data: {
    labels: cxValues,
    datasets: [{
      backgroundColor: cbarColors,
      data: cyValues
    }]
  },
  options: {
    title: {
      display: true,
      text: "World Wide Wine Production"
    }
  }
});
