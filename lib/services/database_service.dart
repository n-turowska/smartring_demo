// services/database_service.dart

import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../models/health_metrics.dart';
import '../ekrany/kalendarz/event.dart';
import '../models/temp_entry.dart';
import '../models/symptom.dart';
import 'package:sqflite/sqflite.dart';
import 'package:smartring_demo/services/database_helper.dart';

/// Database service for managing health data persistence
///
/// Currently returns mock (hardcoded) data for development.
/// Later, this will be replaced with actual SQLite database operations.
///
/// Using a service allows us to:
/// - Separate data logic from UI
/// - Easily swap mock data for real database
/// - Test business logic without database
/// - Reuse data access across multiple screens
class DatabaseService {
  // Singleton pattern - only one instance of DatabaseService exists
  DatabaseService();
  static final DatabaseService instance = DatabaseService._constructor();
  final String _cycleTableName = 'cycle_events';
  final String _cycleIdColumnName = 'id';
  final String _cycleDateColumnName = 'date';
  final String _cycleEventTypeColumnName = 'event_type';

  DatabaseService._constructor();

  Future<void> addUserEvent(Event event) async {
    try {
      final db = await DatabaseHelper.instance.database;
      await db.insert(_cycleTableName, event.toMap());
    } catch (e) {
      throw Exception("add user event error: $e");
    }
  }

  // ============ DATABASE METHODS ============

  /// Initialize database
  ///

  Future<void> initialize() async {
    try {
      await DatabaseHelper.instance.database;
    } catch (e) {
      print("Database initialization error: $e");
    }
  }

  /// Insert health metrics for a date
  Future<int> insertHealthMetrics(HealthMetrics metrics) async {
    try {
      final db = await DatabaseHelper.instance.database;
      return await db.insert('health_metrics', {
        'date': metrics.date.toIso8601String(),
        'step_count': metrics.stepCount,
        'basal_temperature': metrics.basalTemperature,
        'hrv': metrics.hrv,
        "resting_heart_rate": metrics.restingHeartRate,
        "sleep_hours": metrics.sleepHours,
        'readiness_score': metrics.readinessScore,
        'created_at': DateTime.now().toIso8601String(),
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      throw Exception("DATABASE INSERT FAILED, ERROR: $e");
    }
  }

  /// Update health metrics
  Future<int> updateHealthMetrics(HealthMetrics metrics) async {
    try {
      final db = await DatabaseHelper.instance.database;
      return await db.update(
        'health_metrics',
        {
          'step_count': metrics.stepCount,
          'basal_temperature': metrics.basalTemperature,
          'hrv': metrics.hrv,
          "resting_heart_rate": metrics.restingHeartRate,
          "sleep_hours": metrics.sleepHours,
          'readiness_score': metrics.readinessScore,
        },
        where: 'date = ?',
        whereArgs: [metrics.date.toIso8601String()],
      );
    } catch (e) {
      throw Exception("DATABASE UPDATE FAILED, ERROR: $e");
    }
  }

  /// Delete all data
  ///
  /// TODO: Implement database deletion
  Future<void> deleteAllData() async {
    throw UnimplementedError('Database deletion not yet implemented');
  }

  /// Close database connection
  ///
  /// TODO: Implement when database is added
  Future<void> close() async {
    // For now, do nothing
  }
  // ============ MOCK DATA ============
  // TODO: Replace with actual database queries when ready

  /// Get health metrics for a specific date
  ///
  /// Parameters:
  ///   - date: The date to get metrics for
  ///
  /// Returns: HealthMetrics object or null if no data
  Future<HealthMetrics?> getHealthMetricsForDate(DateTime date) async {
    try {
      final db = await DatabaseHelper.instance.database;
      final result = await db.query(
        'health_metrics',
        where: 'date=?',
        whereArgs: [date.toIso8601String()],
      );
      if (result.isEmpty) {
        return null;
      }
      final data = result.first;
      return HealthMetrics(
        id: data['id'] as int,
        date: DateTime.parse(data['date'] as String),
        stepCount: data['step_count'] as int? ?? 0,
        basalTemperature: data['basal_temperature'] as double? ?? 0,
        hrv: data['hrv'] as double? ?? 0,
        restingHeartRate: data['resting_heart_rate'] as int? ?? 0,
        sleepHours: data['sleep_hours'] as double? ?? 0,
        readinessScore: data['readiness_score'] as int? ?? 0,
      );
    } catch (e) {
      throw Exception("DATABASE ERROR: $e");
    }
  }

  /// Mock weekly step counts (Monday to Sunday)
  ///
  /// This data matches what's currently hardcoded in aktywnosc.dart
  final List<int> _mockWeeklySteps = [
    5040, // Monday
    6490, // Tuesday
    2904, // Wednesday
    10075, // Thursday
    7099, // Friday
    12349, // Saturday
    5607, // Sunday (today)
  ];

  /// Mock weekly HRV values (Monday to Sunday)
  ///
  /// This data matches what's currently hardcoded in wykres1.dart
  final List<double> _mockWeeklyHRV = [
    75.0, // Monday
    30.0, // Tuesday
    120.0, // Wednesday
    130.0, // Thursday
    20.0, // Friday
    100.0, // Saturday
    80.0, // Sunday
  ];

  //Mock symptoms
  final List<SymptomType> physicalSymptoms = [
    SymptomType(
      id: 'cramps',
      name: 'Cramps',
      namePolish: "Skurcze",
      category: SymptomCategory.physical,
      icon: "🩸",
    ),
    SymptomType(
      id: 'headache',
      name: "Headache",
      namePolish: "Ból głowy",
      category: SymptomCategory.physical,
      icon: "🤕",
    ),
    SymptomType(
      id: "bloating",
      name: "Bloating",
      namePolish: "Wzdęcia",
      category: SymptomCategory.physical,
      icon: "🎈",
    ),
    SymptomType(
      id: "breast_tenderness",
      name: "Breast tenderness",
      namePolish: "Tkliwość piersi",
      category: SymptomCategory.physical,
      icon: "💗",
    ),
    SymptomType(
      id: "fatigue",
      name: "Fatigue",
      namePolish: "Zmęczenie",
      category: SymptomCategory.physical,
      icon: "😴",
    ),
    SymptomType(
      id: "backache",
      name: "Backache",
      namePolish: "Ból pleców",
      category: SymptomCategory.physical,
      icon: "🦴",
    ),
    SymptomType(
      id: "nausea",
      name: "Nausea",
      namePolish: "Nudności",
      category: SymptomCategory.physical,
      icon: "🤢",
    ),
    SymptomType(
      id: "acne",
      name: "Acne",
      namePolish: "Trądzik",
      category: SymptomCategory.physical,
      icon: "🧴",
    ),
  ];
  final List<SymptomType> moodSymptoms = [
    SymptomType(
      id: "happy",
      name: "Happy",
      namePolish: "Szczęśliwa",
      category: SymptomCategory.mood,
      icon: "😊",
    ),
    SymptomType(
      id: "anxious",
      name: "Anxious",
      namePolish: "Niespokojna",
      category: SymptomCategory.mood,
      icon: "😰",
    ),
    SymptomType(
      id: "irritable",
      name: "Irritable",
      namePolish: "Rozdrażniona",
      category: SymptomCategory.mood,
      icon: "😠",
    ),
    SymptomType(
      id: "sad",
      name: "Sad",
      namePolish: "Smutna",
      category: SymptomCategory.mood,
      icon: "😢",
    ),
    SymptomType(
      id: "calm",
      name: "Calm",
      namePolish: "Spokojna",
      category: SymptomCategory.mood,
      icon: "😌",
    ),
    SymptomType(
      id: "energetic",
      name: "Energetic",
      namePolish: "Energiczna",
      category: SymptomCategory.mood,
      icon: "⚡",
    ),
    SymptomType(
      id: "sensitive",
      name: "Sensitive",
      namePolish: "Wrażliwa",
      category: SymptomCategory.mood,
      icon: "💔",
    ),
  ];

  /// Mock annually ovulation day
  final List<PredictedOvulation> _mockOvulationDay = [
    PredictedOvulation(title: 'owulacja', date: DateTime(2025, 11, 15)),
    PredictedOvulation(title: 'owulacja', date: DateTime(2025, 12, 13)),
    PredictedOvulation(title: 'owulacja', date: DateTime(2026, 1, 10)),
    PredictedOvulation(title: 'owulacja', date: DateTime(2026, 2, 7)),
    PredictedOvulation(title: 'owulacja', date: DateTime(2026, 3, 7)),
    PredictedOvulation(title: 'owulacja', date: DateTime(2026, 4, 4)),
    PredictedOvulation(title: 'owulacja', date: DateTime(2026, 5, 2)),
    PredictedOvulation(title: 'owulacja', date: DateTime(2026, 5, 30)),
    PredictedOvulation(title: 'owulacja', date: DateTime(2026, 6, 27)),
    PredictedOvulation(title: 'owulacja', date: DateTime(2026, 7, 25)),
    PredictedOvulation(title: 'owulacja', date: DateTime(2026, 8, 22)),
    PredictedOvulation(title: 'owulacja', date: DateTime(2026, 9, 19)),
  ];
  List<PredictedOvulation> get ovulationDays =>
      _mockOvulationDay; //zeby mozna bylo sie odwolac do danego dnia na zewnatrz pliku
  Future<List<PredictedOvulation>> getAllOvulationDays() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query('ovulation_days');

    return result
        .map(
          (e) => PredictedOvulation(
            title: e['title'] as String,
            date: DateTime.parse(e['date'] as String),
          ),
        )
        .toList();
  }

  final List<PredictedMenstruation> _mockMenstruationDay = [
    PredictedMenstruation(
      title: 'miesiączka: 1 dzień',
      date: DateTime(2025, 12, 27),
    ),
    PredictedMenstruation(
      title: 'miesiączka: 2 dzień',
      date: DateTime(2025, 12, 28),
    ),
    PredictedMenstruation(
      title: 'miesiączka: 3 dzień',
      date: DateTime(2025, 12, 29),
    ),
    PredictedMenstruation(
      title: 'miesiączka: 1 dzień',
      date: DateTime(2026, 1, 24),
    ),
    PredictedMenstruation(
      title: 'miesiączka: 2 dzień',
      date: DateTime(2026, 1, 25),
    ),
    PredictedMenstruation(
      title: 'miesiączka: 3 dzień',
      date: DateTime(2026, 1, 26),
    ),
    PredictedMenstruation(
      title: 'miesiączka: 1 dzień',
      date: DateTime(2026, 2, 21),
    ),
    PredictedMenstruation(
      title: 'miesiączka: 2 dzień',
      date: DateTime(2026, 2, 22),
    ),
    PredictedMenstruation(
      title: 'miesiączka: 3 dzień',
      date: DateTime(2026, 2, 23),
    ),
    PredictedMenstruation(
      title: 'miesiączka: 1 dzień',
      date: DateTime(2026, 3, 21),
    ),
    PredictedMenstruation(
      title: 'miesiączka: 2 dzień',
      date: DateTime(2026, 3, 22),
    ),
    PredictedMenstruation(
      title: 'miesiączka: 3 dzień',
      date: DateTime(2026, 3, 23),
    ),
  ];
  List<PredictedMenstruation> get menstruationDays => _mockMenstruationDay;
  Future<List<PredictedMenstruation>> getAllMenstruationDays() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query('menstruation_days');
    return result
        .map(
          (e) => PredictedMenstruation(
            title: e['title'] as String,
            date: DateTime.parse(e['date'] as String),
          ),
        )
        .toList();
  }

  final List<int> _mockPredictedDlugoscCyklu = [
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
  ];
  List<int> get dlCyklu => _mockPredictedDlugoscCyklu;
  Future<int> getCycleLength() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query('user_profile', limit: 1);
    if (result.isEmpty) return 28;
    return result.first['average_cycle_length'] as int;
  }

  /// added by user events-for example period days

  Future<List<Event>> getUserEvents() async {
    try {
      final db = await DatabaseHelper.instance.database;
      final maps = await db.query(
        //czyli wybieramy z cycle_events to co event_type='user_event'
        _cycleTableName,
        where: '$_cycleEventTypeColumnName=?',
        whereArgs: ['user_event'],
      );
      return maps
          .map((e) => Event.fromMap(e))
          .toList(); //dzieki temu lista z mapa zmienia sie na liste z eventami
    } catch (e) {
      throw Exception("Get user events error: $e");
    }
  }

  Future<void> deleteEvent(Event event) async {
    try {
      final db = await DatabaseHelper.instance.database;
      await db.delete('cycle_events', where: 'id=?', whereArgs: [event.id]);
    } catch (e) {
      throw Exception("delete user events error: $e");
    }
  }

  //Mock temperature data for testing//

  final List<TemperatureEntry> _temperatureData = [];

  //Syntetic data generation //
  void generateSyntheticTempData() {
    _temperatureData.clear();

    for (int i = 0; i < 7; i++) {
      final measurements = List<double>.generate(
        3,
        (_) => 36.5 + (0.5 - (0.5 * i) / 6),
      );

      final avg =
          measurements.fold(0.0, (sum, e) => sum + e) / measurements.length;
      final date = DateTime.now().subtract(Duration(days: 6 - i));

      _temperatureData.add(TemperatureEntry(date: date, value: avg));
    }
  }

  // Dodawanie nowego pomiaru
  void addTemperature(double value) {
    final entry = TemperatureEntry(date: DateTime.now(), value: value);
    _temperatureData.add(entry);

    // zachowujemy maksymalnie 7 dni
    if (_temperatureData.length > 7) {
      _temperatureData.sort((a, b) => a.date.compareTo(b.date));
      _temperatureData.removeAt(0); // usuwa najstarszy
    }
  }

  //Pobieranie 7 dni
  List<TemperatureEntry> getLast7Days() {
    _temperatureData.sort((a, b) => a.date.compareTo(b.date));

    if (_temperatureData.length <= 7) {
      return _temperatureData;
    }
    return _temperatureData.sublist(_temperatureData.length - 7);
  }

  //wykre_zdrowie_dane //

  final hrvValues = [75, 30, 120, 130, 20, 100, 80];
  final days = ['Pn', 'Wt', 'Śr', 'Cz', 'Pt', 'So', 'Nd'];

  // ============ PUBLIC API ============

  /// Get step counts for the last 7 days
  ///
  /// Returns: List of 7 integers (Monday to Sunday)
  Future<List<int>> getWeeklySteps() async {
    try {
      final db = await DatabaseHelper.instance.database;
      final result = await db.query(
        'health_metrics',
        columns: ['step_count'],
        orderBy: 'date DESC', //bo chcemy najnowsze dni jako pierwsze
        limit: 7,
      );
      return result
          .map((e) => e['step_count'] as int? ?? 0)
          .toList()
          .reversed
          .toList();
    } catch (e) {
      throw Exception("Weekly steps error: $e");
    }
  }

  /// Get today's step count
  ///
  /// Returns: Integer step count for today
  Future<int> getTodaySteps() async {
    try {
      final db = await DatabaseHelper.instance.database;
      final result = await db.query(
        'health_metrics',
        columns: ['step_count'],
        orderBy: 'date DESC',
        limit: 1,
      );

      return result.first['step_count'] as int? ?? 0;
    } catch (e) {
      throw Exception("Today steps error: $e");
    }
  }

  /// Get HRV values for the last 7 days
  ///
  /// Returns: List of 7 doubles (Monday to Sunday)
  Future<List<double>> getWeeklyHRV() async {
    try {
      final db = await DatabaseHelper.instance.database;
      final result = await db.query(
        'health_metrics',
        columns: ['hrv'],
        orderBy: 'date DESC',
        limit: 7,
      );
      return result
          .map((e) => e['hrv'] as double? ?? 0)
          .toList()
          .reversed
          .toList();
    } catch (e) {
      throw Exception("Weekly hrv error: $e");
    }
  }

  /// Get today's HRV value
  ///
  /// Returns: Double HRV value for today in milliseconds
  Future<double> getTodayHRV() async {
    try {
      final db = await DatabaseHelper.instance.database;
      final result = await db.query(
        'health_metrics',
        columns: ['hrv'],
        orderBy: 'date DESC',
        limit: 1,
      );
      return result.first['hrv'] as double? ?? 0;
    } catch (e) {
      throw Exception("Today HRV error: $e");
    }
  }

  /// Get calories burned today (calculated from steps)
  ///
  /// Returns: Integer calories burned
  Future<int> getTodayCalories() async {
    try {
      final db = await DatabaseHelper.instance.database;
      final result = await db.query(
        'health_metrics',
        columns: ['step_count'],
        orderBy: 'date DESC',
        limit: 1,
      );

      return ((result.first['step_count'] as int? ?? 0) * 0.105)
          .round(); // ~590 calories for 5607 steps
    } catch (e) {
      throw ("Today calories error: $e");
    }
  }

  /// Get distance traveled today in kilometers (calculated from steps)
  ///
  /// Returns: Integer distance in km
  Future<int> getTodayDistanceKm() async {
    try {
      final db = await DatabaseHelper.instance.database;
      final result = await db.query(
        'health_metrics',
        columns: ['step_count'],
        orderBy: 'date DESC',
        limit: 1,
      );
      final steps = result.first['step_count'] as int? ?? 0;
      final meters =
          steps *
          0.75; // Simple calculation: ~0.75m per step for average personreturn (meters / 1000).round();// ~4-5 km for 5607 steps
      return (meters / 1000).round();
    } catch (e) {
      throw ("Today distance error: $e");
    }
  }

  Future addSymptom(Symptom symptom) async {
    try {
      final db = await DatabaseHelper.instance.database;
      if (symptom.intensity < 1 || symptom.intensity > 5) {
        throw Exception("Intensity must be 1-5");
      }
      return await db.insert(
        'symptoms',
        symptom.toMap(),
      ); //zwraca id tego symptomu
    } catch (e) {
      throw Exception("nie udało się dodać symptomu");
    }
  }

  Future getSymptomsForDate(DateTime date) async {
    try {
      final db = await DatabaseHelper.instance.database;
      final result = await db.query(
        "symptoms",
        where: "date=?",
        whereArgs: [date.toIso8601String()],
      );
      return result
          .map((e) => Symptom.fromMap(e))
          .toList(); //kazda mape e z result(lista map) zamien na obiekt Symptom i zmienia na liste List<Symptom>
    } catch (e) {
      throw Exception("nie udało się zwrócić symptomu dla tej daty");
    }
  }

  Future getSymptomsInRange(DateTime start, DateTime end) async {
    try {
      final db = await DatabaseHelper.instance.database;
      final result = await db.query(
        "symptoms",
        where: "date BETWEEN ? AND ?",
        whereArgs: [start.toIso8601String(), end.toIso8601String()],
      );
      return result.map((e) => Symptom.fromMap(e)).toList();
    } catch (e) {
      throw Exception("nie udało się zwrócić zakresu dat dla symptomu");
    }
  }

  Future updateSymptom(Symptom symptom) async {
    try {
      final db = await DatabaseHelper.instance.database;
      return await db.update(
        "symptoms",
        symptom.toMap(),
        where: 'id=?',
        whereArgs: [symptom.id],
      );
    } catch (e) {
      throw Exception("nie udało się zaaktualizować symptomu");
    }
  }

  Future deleteSymptom(int id) async {
    try {
      final db = await DatabaseHelper.instance.database;
      return await db.delete("symptoms", where: 'id=?', whereArgs: [id]);
    } catch (e) {
      throw Exception("nie udało się usunąć symptomu");
    }
  }
}
