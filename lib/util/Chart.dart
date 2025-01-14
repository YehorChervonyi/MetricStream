import 'dart:html';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
Widget styleTitle(double value, TitleMeta meta){
  var style = TextStyle(
    color: Colors.white
  );
  return Text(value.toString() ,style: style,);
}


Widget Chart(List<FlSpot> data, double min, double max, double interval){
  return Container(
    child: SizedBox(
                height: 200, // Adjust height based on your layout
                child: LineChart(
                  
                  LineChartData(
                    
                    minY: min,
                    maxY: max,
                    
                    lineBarsData: [
                      LineChartBarData(
                        spots: data,
                        preventCurveOverShooting: true,
                        isCurved: true,
                        barWidth: 2,
                        // isStrokeCapRound: true,
                        // isStrokeJoinRound: true,
                        isStepLineChart: false,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(show: true)
                      )
                    ],
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 25,
                          interval: interval,
                          getTitlesWidget: styleTitle                    
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
                          showTitles: true,
                          getTitlesWidget: styleTitle
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
  );
}