#lang at-exp racket/base

(require ming
         ming/number
         gregor xml json
         racket/format
         )

(provide my-plot.jscode)


(define (to-jscode-array a)
  (􏼪 (佫  ~v a)
      ","
      #:before-first "["
      #:after-last "]")
)

(define (my-plot.jscode x y tt)
  @~a{
    const xArray = @(to-jscode-array x);
    const yArray = @(to-jscode-array y);
    const textArray = @(to-jscode-array tt)
    const data = [{
      name: "卦",
      // mode:"markers+lines+text",
      mode:"markers+lines",
      type:"scatter",
      x: xArray,
      y: yArray,
      // ids: textArray,
      text: textArray,
      hoverinfo: "all",
      // textposition: 'top center',
      // orientation: 'v'
    }];

    const tickText = [
      "^-48坤","-47剥","-46比","-45观","-44豫","-43晋","-42萃","-41否",
      "^-38谦","-37艮","-36蹇","-35渐","-34小过","-33旅","-32咸","-31遁",
      "^-28师","-27蒙","-26坎","-25涣","-24解","-23未济","-22困","-21讼",
      "^-18升","-17蛊","-16井","-15巽","-14恒","-13鼎","-12大过","-11姤",
      "〇",
      "11复","12颐","13屯","14益","15震","16噬嗑","17随","^18无妄",
      "21明夷","22贲","23既济","24家人","25丰","26离","27革","^28同人",
      "31临","32损","33节","34中孚","35归妹","36睽","37兑","^38履",
      "41泰","42大畜","43需","44小畜","45大壮","46大有","47夬","^48乾",
    ]
    const tickVals = [
      -32,-31,-30,-29,-28,-27,-26,-25,
      -24,-23,-22,-21,-20,-19,-18,-17,
      -16,-15,-14,-13,-12,-11,-10,-9,
      -8,-7,-6,-5,-4,-3,-2,-1,
      0,
      1,2,3,4,5,6,7,8,
      9,10,11,12,13,14,15,16,
      17,18,19,20,21,22,23,24,
      25,26,27,28,29,30,31,32]

    var config = {
      // locale: 'zh-CN',
      scrollZoom: true,
      responsive: true,
      editable: true
    };

    const layout = {
      xaxis: {
        title: "时",
        hoverformat: "%Y/%m/%d/%a",
        tickformat: "%Y-%m-%d"
      },
      // yaxis: {range: [-32, 32], title: "卦象", tickmode: "linear", tick0: 0, dtick: 8 }
      yaxis: {
        title: "卦",
        range: [-32, 32],
        tickmode: "array",
        tickvals: tickVals,
        ticktext: tickText,
      },
      title: "量价卦势图（日均半年）",
      font: {size: 12},
      showlegend: true,
      // grid: { columns: 100 }
      // legend: { gbcolor: "red"}
      // showgrid: false,
      height: 1200,
      // width: 600
      // calendar: "chinese"
    }

    Plotly.newPlot("myPlot", data, layout, config);
      }

)
