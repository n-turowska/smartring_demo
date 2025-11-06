// models/ring_data.dart

/// Represents raw sensor data from the Mira smart ring
///
/// This model contains the raw measurements collected by the ring's sensors
/// at a specific point in time. This data is later processed and aggregated
/// into [HealthMetrics] for storage and analysis.
class RingData {
  /// Timestamp when this data was collected
  final DateTime timestamp;

  /// Step count since last reading
  final int stepCount;

  /// Skin temperature in Celsius
  final double temperature;

  /// Battery level (0-100%)
  final int batteryLevel;

  /// Heart Rate Variability in milliseconds (calculated from PPG)
  final double? hrv;

  /// Resting heart rate in BPM (calculated from PPG)
  final int? heartRate;

  /// Raw PPG (photoplethysmography) samples for heart rate analysis
  /// In a real implementation, this would be a large array of sensor values
  final List<int>? ppgSamples;

  /// Raw accelerometer data for activity detection
  /// In a real implementation, this would be 3-axis accelerometer readings
  final List<double>? accelerometerData;

  const RingData({
    required this.timestamp,
    required this.stepCount,
    required this.temperature,
    required this.batteryLevel,
    this.hrv,
    this.heartRate,
    this.ppgSamples,
    this.accelerometerData,
  });

  /// Create RingData from database map
  factory RingData.fromMap(Map<String, dynamic> map) {
    return RingData(
      timestamp: DateTime.parse(map['timestamp'] as String),
      stepCount: map['step_count'] as int,
      temperature: map['temperature'] as double,
      batteryLevel: map['battery_level'] as int,
      hrv: map['hrv'] as double?,
      heartRate: map['heart_rate'] as int?,
      // Note: In real implementation, would deserialize BLOB data
      ppgSamples: null,
      accelerometerData: null,
    );
  }

  /// Convert RingData to database map
  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'step_count': stepCount,
      'temperature': temperature,
      'battery_level': batteryLevel,
      if (hrv != null) 'hrv': hrv,
      if (heartRate != null) 'heart_rate': heartRate,
      // Note: In real implementation, would serialize BLOB data
      'created_at': DateTime.now().toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'RingData(timestamp: $timestamp, steps: $stepCount, temp: ${temperature.toStringAsFixed(1)}°C, battery: $batteryLevel%)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RingData &&
        other.timestamp == timestamp &&
        other.stepCount == stepCount &&
        other.temperature == temperature &&
        other.batteryLevel == batteryLevel;
  }

  @override
  int get hashCode {
    return Object.hash(timestamp, stepCount, temperature, batteryLevel);
  }
}
