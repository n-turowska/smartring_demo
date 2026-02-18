import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/database_service.dart';
//import '../models/temp_entry.dart';

class TempChart extends StatefulWidget {
  const TempChart({super.key});

  @override
  State<TempChart> createState() => _TempChartState();
}

class _TempChartState extends State<TempChart> {
  late final DatabaseService db;
  //late final List<TemperatureEntry> days;

  @override
  void initState() {
    super.initState();
    db = DatabaseService();
    db.generateSyntheticTempData();
  }

  @override
  Widget build(BuildContext context) {
    final data = db.getLast7Days();
    return SizedBox(
      height: 400,
      width: double.infinity,
      child: LineChart(
        LineChartData(
          minY: 36.0,
          maxY: 37.5,
          gridData:FlGridData(show:true,
          horizontalInterval: 0.5,
          drawVerticalLine: false,),
          titlesData: FlTitlesData(
             rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 &&
                      value.toInt() < data.length) {
                      final dayName = data[value.toInt()].dayName;
                    return Text(dayName,style: TextStyle(fontSize: 12, color: Colors.black),);
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              axisNameWidget: const Text('Temp [°C]'),
              axisNameSize: 30,
              sideTitles:SideTitles(
                showTitles:true,
                interval:0.5,
                reservedSize: 40,
                getTitlesWidget: (value,meta) {
                  return Text(value.toStringAsFixed(1),style: TextStyle(fontSize: 12,color: Colors.black));
                },
              )
            )
            
          ),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                data.length,
                (index) =>
                    FlSpot(index.toDouble(), data[index].value),
              ),
              isCurved: true,
              barWidth: 3,
              dotData: FlDotData(show: true),
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
