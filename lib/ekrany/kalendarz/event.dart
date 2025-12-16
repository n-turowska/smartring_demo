class Event {
  final String title;
  final DateTime date;
  Event(this.title, this.date);
}

class PredictedOvulation {
  final String title;
  final DateTime date;

  PredictedOvulation({required this.title, required this.date});
}

class PredictedMenstruation {
  final String title;
  final DateTime date;
  PredictedMenstruation({required this.title, required this.date});
}
