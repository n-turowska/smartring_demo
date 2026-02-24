class Event {
  final String title;
  final int? id;
  final DateTime date;
  Event(this.title, this.date, {this.id});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String().split('T').first,
      'event_type': 'user_event',
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(map['title'], DateTime.parse(map['date']), id: map['id']);
  }
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
