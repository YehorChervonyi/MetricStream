import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
Widget styleTitle(double value, TitleMeta meta){
  var style = TextStyle(
    color: Colors.white
  );
  return Text(value.toString() ,style: style,);
}


Widget Chart(List<FlSpot> data, double min, double max, double interval, String name, String char){
  return Card(
    elevation: 5,
    color: Colors.black.withOpacity(0.4),
    child: Container(
      padding: EdgeInsets.only(top: 5, right: 20, left: 5),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        runSpacing: 5,
        children: [
          Text(
            name,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          AspectRatio(
            // height: 200, // Adjust height based on your layout
            aspectRatio: 2,
            child: LineChart(
              LineChartData(  
                minY: min,
                maxY: max,

                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    // getTooltipColor: (touchedSpot) => Colors.white,
                    getTooltipItems: (List<LineBarSpot> touchedSpots) {
                      return touchedSpots.map((spot) {
                        return LineTooltipItem(
                          ' ${(spot.y*10).toInt().toDouble()/10} ${char}', // Customize text format
                          TextStyle(
                            color: Colors.white, // Change text color here
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        );
                      }).toList();
                    },
                    
                  )
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: data,
                    preventCurveOverShooting: true,
                    isCurved: true,
                    barWidth: 3,
                    // color: Colors.white,
                    gradient: LinearGradient(colors: [Colors.deepPurple.withOpacity(0), Colors.deepPurple], stops: [0.0, 0.1]),
                    // isStrokeCapRound: true,
                    // isStrokeJoinRound: true,
                    // isStepLineChart: false,
                    dotData: FlDotData(show: false, ),
                    belowBarData: BarAreaData(show: true, gradient: LinearGradient(colors: [Colors.deepPurple.withOpacity(0), Colors.deepPurple.withOpacity(0.3)], stops: [0.0, 0.1]))
                    
                  )
                ],
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 25,
                      interval: interval,
                      getTitlesWidget: styleTitle,             
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    )
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false
                    )
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                      getTitlesWidget: styleTitle,
                    )
                  )
                ),
                gridData: FlGridData(show: true,
                verticalInterval: 1,
                horizontalInterval: interval,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.white.withOpacity(0.5),
                    strokeWidth: 1,
                    // dashArray: [6, 6]
                  );                  
                },
                getDrawingVerticalLine: (value) {
                  return FlLine(
                    color: Colors.white.withOpacity(0.5),
                    strokeWidth: 1,
                    dashArray: [6, 6]
                  );
                },
                ),
                
                clipData: FlClipData.all(),
                borderData: FlBorderData(
                  border: Border.all(color: Colors.white))
                // read about it in the LineChartData section
              ),
              
            ),
          ),
        ],
      ),
    ),
  );
}

Widget MyPieChart(double free, double busy, String name){
  free = (free*10).roundToDouble()/10;
  busy = (busy*10).roundToDouble()/10;
  return Card(
    
    // margin: EdgeInsets.symmetric(horizontal: 50),
    elevation: 5,
    color: Colors.black.withOpacity(0.4),
    child: Container(
      padding: EdgeInsets.all( 10),
      child: Column(
        children: [
          Text(
            name,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          AspectRatio(aspectRatio: 2, 
        child: PieChart(
          PieChartData(
            pieTouchData: PieTouchData(
              enabled: false
              ),
              sections: [
                PieChartSectionData(value: free, color: Color(0xFF004D40), titleStyle: TextStyle(color: Colors.white), title: "${free} %", titlePositionPercentageOffset: -0.45), 
                PieChartSectionData(value: busy, color: Color(0xFF800020), titleStyle: TextStyle(color: Colors.white), title: "${busy} %", titlePositionPercentageOffset: -0.45 )]
          )
        ),
        
      ),
      
      ],
      ),
    ),
  );
}