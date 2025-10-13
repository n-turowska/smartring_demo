import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StressChart extends StatelessWidget {
  const StressChart ({super.key});

  @override
  Widget build(BuildContext context){
    final hrvValues = [75,30,120,130,20,100,80];
    //final stressValues = [3,4,1,1,5,3,3];
    final days = ['Pn','Wt','Śr','Cz','Pt','So','Nd'];

    return BarChart(
      BarChartData(
        maxY: 130,
        minY: 0,
        barGroups: List.generate(hrvValues.length, (i)=>BarChartGroupData(
          x:i,
          barRods:[
            BarChartRodData(
              toY: hrvValues[i].toDouble(),
              width:16,
              color: const Color.fromARGB(255, 15, 214, 197),
              borderRadius: BorderRadius.circular(3),
              
            )
          ]
        )),
        gridData: const FlGridData(show:true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(axisNameWidget: const Padding(padding:EdgeInsets.only(top:0),child: Text('HRV (ms)',style: TextStyle(fontWeight:FontWeight.bold),))),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            axisNameWidget:const Padding(padding:EdgeInsets.only(top:0),
            child: Text('Dni tygodnia',style:TextStyle(fontWeight:FontWeight.bold)),
            ),
            sideTitles:SideTitles( showTitles:true,
            getTitlesWidget:(value,meta) {
              int index = value.toInt();
              if(index>=0 && index < days.length){
                return Text(days[index], style: const TextStyle(fontSize:12));}
              
              return const Text('');},
            ),)
            
            ))
      );
     

  }
}