import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:smartring_demo/models/cycle_records.dart';
import 'package:smartring_demo/services/database_service.dart';
import 'package:intl/intl.dart';

class CycleAnalysisScreen extends StatefulWidget {
  final DatabaseService databaseService;
  const CycleAnalysisScreen({super.key, required this.databaseService});

  @override
  State<CycleAnalysisScreen> createState() => _CycleAnalysisScreenState();
}

class _CycleAnalysisScreenState extends State<CycleAnalysisScreen> {
  CycleAnalysis? _analysis;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAnalysis();
  }

  Future<void> _loadAnalysis() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final analysis = await widget.databaseService.getCycleAnalysis();
      _analysis = analysis;
      _isLoading = false;
    } catch (e) {
      setState(() {
        _error = "Błąd ładowania analizy cyklu: {$e}";
        _isLoading = false;
      });
    }
  }

  int myIndex = 1;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Analiza cyklu',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            myIndex = index;
          });
          if (index == 0) {
            Navigator.pushNamed(context, '/parowanie');
          }
          if (index == 1) {
            Navigator.pushNamed(context, '/startowy');
          }
          if (index == 2) {
            Navigator.pushNamed(context, '/glowny');
          }
        },
        backgroundColor: Colors.white,
        selectedItemColor: Color.fromARGB(255, 217, 127, 201),
        unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
        currentIndex: myIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.bluetooth),
            label: 'Mój Ring',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Podsumowanie",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: "Więcej",
          ),
        ],
      ),
      body: /*_isLoading
          ? const Center(child: CircularProgressIndicator())
          :*/ _error != null
          ? Center(child: Text(_error!))
          : _analysis == null
          ? const Center(child: Text("Brak danych o cyklach"))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          const Text(
                            "Moje podsumowanie:",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text(" "),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _buildCard(
                                        "Średnia długość cyklu",
                                        "${_analysis!.averageCycleLength} dni",
                                        const Color.fromARGB(255, 7, 7, 7),
                                      ),
                                      const SizedBox(width: 16),
                                      _buildCard(
                                        "Regularność ",
                                        "${_analysis!.isRegular ? "TAK" : "NIE"} ",
                                        _analysis!.isRegular
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(10),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  _buildCard(
                                    "Najkrótszy cykl",
                                    "${_analysis!.shortestCycle} dni",
                                    const Color.fromARGB(255, 3, 3, 3),
                                  ),
                                  const SizedBox(width: 16),
                                  _buildCard(
                                    "Najdłuższy cykl",
                                    "${_analysis!.longestCycle} dni",
                                    const Color.fromARGB(255, 9, 9, 9),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  _buildCard(
                                    "Średnia długość miesiączki ",
                                    "${_analysis!.averagePeriodLength} dni",
                                    Colors.red,
                                  ),

                                  _buildCard(
                                    "Odchylenie standardowe ",
                                    "${_analysis!.standardDeviation.toStringAsFixed(1)} dni",
                                    const Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          const Text(
                            "Wykres długości cykli w roku:",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          _buildChart(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                "Regularny",
                                style: TextStyle(fontSize: 12),
                              ),
                              const SizedBox(width: 16),
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                "Nieregularny",
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildCard(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildChart() {
    if (_analysis == null || _analysis!.recentCycles.isEmpty) {
      return Text("Brak danych o nieregularnych cyklach do wyświetlenia");
    }
    final sortedCycles = List<CycleRecord>.from(_analysis!.recentCycles);
    sortedCycles.sort(
      (a, b) => a.startDate.compareTo(b.startDate),
    ); //od najstarszego do najnowszego

    return SizedBox(
      height: 250,
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 50,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()} dni',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight(300),
                      color: const Color.fromARGB(255, 7, 1, 8),
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: 1,
                getTitlesWidget: (index, meta) {
                  if (index >= sortedCycles.length) return const Text('');
                  final date = sortedCycles[index.toInt()].startDate;
                  return Transform.rotate(
                    angle: -0.5,
                    child: Text(
                      '${date.month}/${date.year}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight(500),
                        color: Color.fromARGB(255, 45, 6, 52),
                      ),
                    ),
                  );
                },
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: sortedCycles.asMap().entries.map((entry) {
                final index = entry.key;
                final cycle = entry.value;
                return FlSpot(index.toDouble(), cycle.cycleLength.toDouble());
              }).toList(),
              isCurved: false,
              color: const Color.fromARGB(255, 64, 56, 68),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  final cycle = sortedCycles[index];
                  return FlDotCirclePainter(
                    radius: 4,
                    color: cycle.isIrregular ? Colors.red : Colors.green,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  );
                },
              ),
            ),
          ],
          minX: 0,
          maxX: (sortedCycles.length - 1).toDouble(),
          minY: 0,
          maxY: sortedCycles
              .map((c) => c.cycleLength)
              .reduce((a, b) => a > b ? a : b)
              .toDouble(),
        ),
      ),
    );
  }
}
