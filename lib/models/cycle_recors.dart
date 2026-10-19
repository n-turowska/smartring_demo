class CycleAnalysis {
  final int averageCycleLength;
  final int shortestCycle;
  final int longestCycle;
  final double standardDeviation;
  final int averagePeriodLength;
  final List<CycleRecord> recentCycles;
  final bool isRegular;
  CycleAnalysis({
    required this.averageCycleLength,
    required this.shortestCycle,
    required this.longestCycle,
    required this.standardDeviation,
    required this.averagePeriodLength,
    required this.recentCycles,
    required this.isRegular,
  });
}

class CycleRecord {
  final DateTime startDate;
  final DateTime? endDate;
  final int cycleLength;
  final int periodLength;
  final bool isIrregular;

  CycleRecord({
    required this.startDate,
    this.endDate,
    required this.cycleLength,
    required this.periodLength,
    required this.isIrregular,
  });
}
