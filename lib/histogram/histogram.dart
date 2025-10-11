import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:smartring_demo/histogram/histogram_dane.dart';

class MyHistogram extends StatelessWidget {
  final List tygodniowePodsumowanie;
  const MyHistogram({
    super.key, 
    required this.tygodniowePodsumowanie,
  });

  @override
  Widget build(BuildContext context) {
    HistogramDane mojeDane = HistogramDane(
      ponLiczba: tygodniowePodsumowanie[0], 
      wtLiczba: tygodniowePodsumowanie[1], 
      srLiczba: tygodniowePodsumowanie[2], 
      czwLiczba: tygodniowePodsumowanie[3], 
      ptLiczba: tygodniowePodsumowanie[4], 
      sobLiczba: tygodniowePodsumowanie[5], 
      niedzLiczba: tygodniowePodsumowanie[6],
    );

    mojeDane.initializeHistogramDane();

    return BarChart(
      BarChartData(
        maxY: 15000,
        minY: 0,
        gridData: FlGridData(show: false),
        barGroups: mojeDane.histogramDane
            .map(
              (data) => BarChartGroupData(
                x: data.x,
                barRods: [
                  BarChartRodData(
                    toY: data.y,
                    width: 20,
                    color: Colors.blueGrey[400],
                    borderRadius: BorderRadius.circular(3),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: 15000,
                      color: Colors.grey[300],
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}