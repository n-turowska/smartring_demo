class TemperatureEntry {
  final DateTime date;
  final double value;
  late final String dayName;

  TemperatureEntry({required this.date, required this.value}){
    const weekdays = [
      'Pn',
      'Wt',
      'Śr',
      'Cz',
      'Pt',
      'Sb',
      'Nd'
    ];
    dayName = weekdays[date.weekday -1];
  }
}
