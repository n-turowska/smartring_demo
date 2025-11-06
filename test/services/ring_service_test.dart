// test/services/ring_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:smartring_demo/services/ring_service.dart';
import 'package:smartring_demo/models/ring_data.dart';

/// Tests for RingService mock implementation
///
/// These tests demonstrate how the service works and can be used
/// as examples for students.
void main() {
  group('RingService', () {
    late RingService ringService;

    setUp(() async {
      ringService = RingService.instance;
      // Ensure service starts disconnected
      await ringService.disconnect();
      // Disable failures for predictable tests
      ringService.connectionFailureRate = 0.0;
      ringService.syncFailureRate = 0.0;
    });

    test('starts in disconnected state', () {
      expect(ringService.currentState, RingConnectionState.disconnected);
      expect(ringService.isConnected, false);
    });

    test('connection success updates state', () async {
      ringService.connectionFailureRate = 0.0; // No failures

      await ringService.connect();

      expect(ringService.currentState, RingConnectionState.connected);
      expect(ringService.isConnected, true);
    });

    test('connection failure throws exception', () async {
      ringService.connectionFailureRate = 1.0; // Always fail

      expect(
        () => ringService.connect(),
        throwsA(isA<RingConnectionException>()),
      );
    });

    test('disconnect changes state to disconnected', () async {
      ringService.connectionFailureRate = 0.0;

      await ringService.connect();
      expect(ringService.isConnected, true);

      await ringService.disconnect();
      expect(ringService.currentState, RingConnectionState.disconnected);
      expect(ringService.isConnected, false);
    });

    test('sync requires connection', () async {
      expect(ringService.isConnected, false);

      expect(
        () => ringService.syncData(),
        throwsA(isA<RingNotConnectedException>()),
      );
    });

    test('sync returns data when connected', () async {
      ringService.connectionFailureRate = 0.0;
      ringService.syncFailureRate = 0.0;

      await ringService.connect();

      // Ring has 3 days of data by default
      final data = await ringService.syncData();

      expect(data, isNotEmpty);
      expect(data.first, isA<RingData>());
      expect(ringService.lastSyncTime, isNotNull);
    });

    test('sync calls progress callback', () async {
      ringService.connectionFailureRate = 0.0;
      ringService.syncFailureRate = 0.0;

      await ringService.connect();

      // Simulate some days of data to sync
      ringService.simulateTimePassing(days: 2);

      final progressUpdates = <int>[];

      await ringService.syncData(
        onProgress: (progress) {
          progressUpdates.add(progress);
        },
      );

      expect(progressUpdates, isNotEmpty);
      expect(progressUpdates.last, 100); // Should reach 100%
    });

    test('getCurrentReading returns current data', () async {
      ringService.connectionFailureRate = 0.0;

      await ringService.connect();

      final reading = await ringService.getCurrentReading();

      expect(reading, isA<RingData>());
      expect(reading.stepCount, greaterThanOrEqualTo(0));
      expect(reading.temperature, greaterThan(35.0));
      expect(reading.temperature, lessThan(38.0));
    });

    test('battery level is accessible', () {
      expect(ringService.batteryLevel, greaterThan(0));
      expect(ringService.batteryLevel, lessThanOrEqualTo(100));
    });

    test('simulateTimePassing reduces battery', () {
      final initialBattery = ringService.batteryLevel;

      ringService.simulateTimePassing(days: 5);

      expect(ringService.batteryLevel, lessThan(initialBattery));
    });

    test('chargeBattery updates level', () {
      ringService.chargeBattery(50);
      expect(ringService.batteryLevel, 50);

      ringService.chargeBattery(100);
      expect(ringService.batteryLevel, 100);

      ringService.chargeBattery(150); // Over limit
      expect(ringService.batteryLevel, 100); // Capped at 100
    });

    test('connection state stream emits updates', () async {
      ringService.connectionFailureRate = 0.0;

      final states = <RingConnectionState>[];
      final subscription = ringService.connectionState.listen((state) {
        states.add(state);
      });

      await ringService.connect();
      await Future.delayed(Duration(milliseconds: 100)); // Let stream emit

      await subscription.cancel();

      // Should have seen: scanning → connecting → connected
      expect(states, contains(RingConnectionState.scanning));
      expect(states, contains(RingConnectionState.connecting));
      expect(states, contains(RingConnectionState.connected));
    });

    test('battery stream emits updates', () async {
      final batteryLevels = <int>[];
      final subscription = ringService.batteryLevelStream.listen((level) {
        batteryLevels.add(level);
      });

      ringService.chargeBattery(80);
      ringService.chargeBattery(60);
      await Future.delayed(Duration(milliseconds: 100)); // Let stream emit

      await subscription.cancel();

      expect(batteryLevels, contains(80));
      expect(batteryLevels, contains(60));
    });

    test('generated data has realistic values', () async {
      ringService.connectionFailureRate = 0.0;

      await ringService.connect();

      final reading = await ringService.getCurrentReading();

      // Check realistic ranges
      expect(reading.temperature, greaterThanOrEqualTo(36.0));
      expect(reading.temperature, lessThanOrEqualTo(37.5));

      if (reading.hrv != null) {
        expect(reading.hrv, greaterThanOrEqualTo(20.0));
        expect(reading.hrv, lessThanOrEqualTo(200.0));
      }

      if (reading.heartRate != null) {
        expect(reading.heartRate, greaterThanOrEqualTo(50));
        expect(reading.heartRate, lessThanOrEqualTo(100));
      }
    });
  });
}
