import '../data/dummy_data.dart';
import '../models/dashboard_data.dart';

/// Contract for the data source that powers the dashboard.
///
/// Two implementations are provided:
/// - [MockAnalyticsService] — returns the hard-coded sample data after a
///   simulated network delay. Used for development and tests.
/// - [HttpAnalyticsService] — production implementation backed by HTTP
///   (stubbed below; plug a real endpoint when the backend is ready).
abstract class AnalyticsService {
  Future<DashboardData> fetchDashboard();
}

/// Mock implementation that returns the dummy dataset after [delay].
///
/// The 800 ms default exercises the loading state in the UI. Set [shouldFail]
/// to `true` to simulate a network error and validate the error UI.
class MockAnalyticsService implements AnalyticsService {
  final Duration delay;
  final bool shouldFail;

  const MockAnalyticsService({
    this.delay = const Duration(milliseconds: 800),
    this.shouldFail = false,
  });

  @override
  Future<DashboardData> fetchDashboard() async {
    await Future.delayed(delay);
    if (shouldFail) {
      throw const _MockNetworkException('Mock service failure');
    }
    return const DashboardData(
      budget: budgetData,
      revenue: revenueData,
    );
  }
}

/// HTTP implementation stub. When the real backend is available:
///   1. Add the endpoint URL.
///   2. Replace this stub with `package:http` calls.
///   3. Parse the JSON response into [DashboardData].
class HttpAnalyticsService implements AnalyticsService {
  final String baseUrl;

  const HttpAnalyticsService({required this.baseUrl});

  @override
  Future<DashboardData> fetchDashboard() async {
    throw UnimplementedError(
      'HttpAnalyticsService not implemented yet. '
      'Connect to $baseUrl when the backend is ready.',
    );
  }
}

class _MockNetworkException implements Exception {
  final String message;
  const _MockNetworkException(this.message);

  @override
  String toString() => 'NetworkException: $message';
}
