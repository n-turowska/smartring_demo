// services/database_service.dart

import 'package:path/path.dart';

import '../models/health_metrics.dart';
import '../ekrany/kalendarz/event.dart';
import '../models/temp_entry.dart';
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
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();
  final String _cycleTableName = 'cycle_events';

  DatabaseService._constructor();

  void addCycleEvent(Event event) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert(_cycleTableName, event.toMap());
  }

  // ============ FUTURE DATABASE METHODS ============
  // These will be implemented when we add actual SQLite database

  /// Initialize database
  ///
  /// TODO: Implement SQLite database initialization
  Future<void> initialize() async {
    // For now, do nothing
    // Later: Create database, run migrations, etc.
  }

  /// Insert health metrics for a date
  ///
  /// TODO: Implement database insert
  Future<int> insertHealthMetrics(HealthMetrics metrics) async {
    throw UnimplementedError('Database insert not yet implemented');
  }

  /// Update health metrics
  ///
  /// TODO: Implement database update
  Future<int> updateHealthMetrics(HealthMetrics metrics) async {
    throw UnimplementedError('Database update not yet implemented');
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
    return _mockOvulationDay;
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
    return _mockMenstruationDay;
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

  /// added by user events-for example period days
  final List<Event> _userEvents = [];
  Future<List<Event>> getUserEvents() async {
    return _userEvents;
  }

  void addUserEvent(Event event) {
    _userEvents.add(event);
  }

  Future<void> deleteEvent(Event event) async {
    _userEvents.remove(event);
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
    // Simulate async database query with small delay
    await Future.delayed(const Duration(milliseconds: 100));

    return List.from(_mockWeeklySteps);
  }

  /// Get today's step count
  ///
  /// Returns: Integer step count for today
  Future<int> getTodaySteps() async {
    await Future.delayed(const Duration(milliseconds: 50));

    // Today is last day of the week (Sunday)
    return _mockWeeklySteps.last;
  }

  /// Get HRV values for the last 7 days
  ///
  /// Returns: List of 7 doubles (Monday to Sunday)
  Future<List<double>> getWeeklyHRV() async {
    await Future.delayed(const Duration(milliseconds: 100));

    return List.from(_mockWeeklyHRV);
  }

  /// Get today's HRV value
  ///
  /// Returns: Double HRV value for today in milliseconds
  Future<double> getTodayHRV() async {
    await Future.delayed(const Duration(milliseconds: 50));

    return _mockWeeklyHRV.last;
  }

  /// Get health metrics for a specific date
  ///
  /// Parameters:
  ///   - date: The date to get metrics for
  ///
  /// Returns: HealthMetrics object or null if no data
  Future<HealthMetrics?> getHealthMetricsForDate(DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 100));

    // For now, return mock data for today
    final today = DateTime.now();
    if (date.day == today.day &&
        date.month == today.month &&
        date.year == today.year) {
      return HealthMetrics(
        id: 1,
        date: date,
        stepCount: _mockWeeklySteps.last,
        basalTemperature: 36.6,
        hrv: _mockWeeklyHRV.last,
        restingHeartRate: 65,
        sleepHours: 8.0,
        readinessScore: 75,
      );
    }

    return null;
  }

  /// Get calories burned today (calculated from steps)
  ///
  /// Returns: Integer calories burned
  Future<int> getTodayCalories() async {
    await Future.delayed(const Duration(milliseconds: 50));

    // Simple calculation: ~0.04 calories per step for average person
    final steps = _mockWeeklySteps.last;
    return (steps * 0.105).round(); // ~590 calories for 5607 steps
  }

  /// Get distance traveled today in kilometers (calculated from steps)
  ///
  /// Returns: Integer distance in km
  Future<int> getTodayDistanceKm() async {
    await Future.delayed(const Duration(milliseconds: 50));

    // Simple calculation: ~0.75m per step for average person
    final steps = _mockWeeklySteps.last;
    final meters = steps * 0.75;
    return (meters / 1000).round(); // ~4-5 km for 5607 steps
  }
}
