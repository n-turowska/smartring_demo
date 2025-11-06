// models/health_metrics.dart

/// Represents daily health metrics collected from the Mira ring
///
/// This model stores all health-related measurements for a single day,
/// including activity (steps), physiological data (temperature, HRV),
/// and derived metrics (readiness score).
class HealthMetrics {
  final int? id;
  final DateTime date;
  final int? stepCount;
  final double? basalTemperature; // in Celsius
  final double? hrv; // Heart Rate Variability in milliseconds
  final int? restingHeartRate; // in BPM
  final double? sleepHours;
  final int? readinessScore; // 0-100

  const HealthMetrics({
    this.id,
    required this.date,
    this.stepCount,
    this.basalTemperature,
    this.hrv,
    this.restingHeartRate,
    this.sleepHours,
    this.readinessScore,
  });

  /// Create HealthMetrics from database map
  factory HealthMetrics.fromMap(Map<String, dynamic> map) {
    return HealthMetrics(
      id: map['id'] as int?,
      date: DateTime.parse(map['date'] as String),
      stepCount: map['step_count'] as int?,
      basalTemperature: map['basal_temperature'] as double?,
      hrv: map['hrv'] as double?,
      restingHeartRate: map['resting_heart_rate'] as int?,
      sleepHours: map['sleep_hours'] as double?,
      readinessScore: map['readiness_score'] as int?,
    );
  }

  /// Convert HealthMetrics to database map
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'date': date.toIso8601String().split('T')[0], // YYYY-MM-DD
      if (stepCount != null) 'step_count': stepCount,
      if (basalTemperature != null) 'basal_temperature': basalTemperature,
      if (hrv != null) 'hrv': hrv,
      if (restingHeartRate != null) 'resting_heart_rate': restingHeartRate,
      if (sleepHours != null) 'sleep_hours': sleepHours,
      if (readinessScore != null) 'readiness_score': readinessScore,
      'created_at': DateTime.now().toIso8601String(),
    };
  }

  /// Create a copy with modified fields
  HealthMetrics copyWith({
    int? id,
    DateTime? date,
    int? stepCount,
    double? basalTemperature,
    double? hrv,
    int? restingHeartRate,
    double? sleepHours,
    int? readinessScore,
  }) {
    return HealthMetrics(
      id: id ?? this.id,
      date: date ?? this.date,
      stepCount: stepCount ?? this.stepCount,
      basalTemperature: basalTemperature ?? this.basalTemperature,
      hrv: hrv ?? this.hrv,
      restingHeartRate: restingHeartRate ?? this.restingHeartRate,
      sleepHours: sleepHours ?? this.sleepHours,
      readinessScore: readinessScore ?? this.readinessScore,
    );
  }

  @override
  String toString() {
    return 'HealthMetrics(date: $date, steps: $stepCount, hrv: $hrv)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HealthMetrics &&
        other.id == id &&
        other.date == date &&
        other.stepCount == stepCount &&
        other.basalTemperature == basalTemperature &&
        other.hrv == hrv &&
        other.restingHeartRate == restingHeartRate &&
        other.sleepHours == sleepHours &&
        other.readinessScore == readinessScore;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      date,
      stepCount,
      basalTemperature,
      hrv,
      restingHeartRate,
      sleepHours,
      readinessScore,
    );
  }
}
