import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

class HealthService {
  static final HealthService _instance = HealthService._internal();
  factory HealthService() => _instance;
  HealthService._internal();

  final Health _health = Health();

  static const List<HealthDataType> _types = [
    HealthDataType.HEART_RATE,
    HealthDataType.STEPS,
    HealthDataType.BLOOD_OXYGEN,
  ];

  static const List<HealthDataAccess> _permissions = [
    HealthDataAccess.READ,
    HealthDataAccess.READ,
    HealthDataAccess.READ,
  ];

  /// Request Health Connect permissions and return whether granted
  Future<bool> requestPermissions() async {
    try {
      // Request activity recognition permission first (required on Android)
      await Permission.activityRecognition.request();

      // Configure health
      await _health.configure();

      // Request health data permissions
      final granted = await _health.requestAuthorization(
        _types,
        permissions: _permissions,
      );
      return granted;
    } catch (e) {
      return false;
    }
  }

  /// Check if permissions are already granted
  Future<bool> hasPermissions() async {
    try {
      final result = await _health.hasPermissions(_types, permissions: _permissions);
      return result ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Get latest resting heart rate (past 24 hours)
  Future<HeartRateResult> getRestingHeartRate() async {
    try {
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(hours: 24));

      final data = await _health.getHealthDataFromTypes(
        startTime: yesterday,
        endTime: now,
        types: [HealthDataType.HEART_RATE],
      );

      if (data.isEmpty) {
        return HeartRateResult(
          success: false,
          errorMessage: 'No heart rate data found in the last 24 hours. '
              'Make sure your smartwatch is synced.',
        );
      }

      // Remove duplicates
      final unique = Health().removeDuplicates(data);
      // Calculate average (resting = minimum of the batch is more accurate,
      // but we use average of the lowest 25% for resting estimate)
      final values = unique
          .map((d) => (d.value as NumericHealthValue).numericValue.toDouble())
          .toList()
        ..sort();

      final restingCount = (values.length * 0.25).ceil().clamp(1, values.length);
      final restingValues = values.take(restingCount).toList();
      final restingHR = restingValues.reduce((a, b) => a + b) / restingValues.length;
      final latestValue = values.isNotEmpty ? values.last : 0.0;
      final minValue = values.first;
      final maxValue = values.last;

      return HeartRateResult(
        success: true,
        restingHeartRate: restingHR.round(),
        currentHeartRate: latestValue.round(),
        minHeartRate: minValue.round(),
        maxHeartRate: maxValue.round(),
        dataPointCount: unique.length,
        lastUpdated: unique.last.dateTo,
      );
    } catch (e) {
      return HeartRateResult(
        success: false,
        errorMessage: 'Error reading heart rate: ${e.toString()}',
      );
    }
  }

  /// Get step count for today
  Future<int> getTodaySteps() async {
    try {
      final now = DateTime.now();
      final midnight = DateTime(now.year, now.month, now.day);
      final data = await _health.getHealthDataFromTypes(
        startTime: midnight,
        endTime: now,
        types: [HealthDataType.STEPS],
      );
      if (data.isEmpty) return 0;
      final unique = Health().removeDuplicates(data);
      final total = unique.fold<double>(
        0,
        (sum, d) => sum + (d.value as NumericHealthValue).numericValue.toDouble(),
      );
      return total.round();
    } catch (e) {
      return 0;
    }
  }

  /// Get SpO2 (blood oxygen) — latest reading
  Future<int?> getBloodOxygen() async {
    try {
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(hours: 24));
      final data = await _health.getHealthDataFromTypes(
        startTime: yesterday,
        endTime: now,
        types: [HealthDataType.BLOOD_OXYGEN],
      );
      if (data.isEmpty) return null;
      final unique = Health().removeDuplicates(data);
      final latest = unique.last;
      return (latest.value as NumericHealthValue).numericValue.round();
    } catch (e) {
      return null;
    }
  }
}

class HeartRateResult {
  final bool success;
  final int? restingHeartRate;
  final int? currentHeartRate;
  final int? minHeartRate;
  final int? maxHeartRate;
  final int? dataPointCount;
  final DateTime? lastUpdated;
  final String? errorMessage;

  HeartRateResult({
    required this.success,
    this.restingHeartRate,
    this.currentHeartRate,
    this.minHeartRate,
    this.maxHeartRate,
    this.dataPointCount,
    this.lastUpdated,
    this.errorMessage,
  });
}
