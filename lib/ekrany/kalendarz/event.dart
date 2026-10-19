import 'package:intl/intl.dart';

class Event {
  final String? title;
  final int? id;
  final DateTime date;
  final String eventType;

  Event(this.title, this.date, {this.id, this.eventType = 'user_event'});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String().split('T').first,
      'event_type': eventType,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      map['title'],
      DateFormat('yyyy-MM-dd').parse(map['date'] as String),
      id: map['id'],
      eventType: map['event_type'] ?? 'user_event',
    );
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
