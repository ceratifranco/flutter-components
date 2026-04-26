import 'package:analytics_dashboard/services/analytics_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // ─── MockAnalyticsService ──────────────────────────────────────────────────

  group('MockAnalyticsService', () {
    test('returns DashboardData with 5 budget segments', () async {
      const service = MockAnalyticsService(delay: Duration.zero);
      final data = await service.fetchDashboard();
      expect(data.budget, hasLength(5));
    });

    test('returns DashboardData with 6 monthly revenue entries', () async {
      const service = MockAnalyticsService(delay: Duration.zero);
      final data = await service.fetchDashboard();
      expect(data.revenue, hasLength(6));
    });

    test('budget percentages sum to 100', () async {
      const service = MockAnalyticsService(delay: Duration.zero);
      final data = await service.fetchDashboard();
      final total =
          data.budget.fold<double>(0, (sum, s) => sum + s.percentage);
      expect(total, 100.0);
    });

    test('all budget segments have positive percentage', () async {
      const service = MockAnalyticsService(delay: Duration.zero);
      final data = await service.fetchDashboard();
      for (final seg in data.budget) {
        expect(seg.percentage, isPositive,
            reason: '${seg.label} percentage must be > 0');
      }
    });

    test('all monthly revenue values are positive', () async {
      const service = MockAnalyticsService(delay: Duration.zero);
      final data = await service.fetchDashboard();
      for (final month in data.revenue) {
        expect(month.value, isPositive,
            reason: '${month.month} value must be > 0');
      }
    });

    test('each revenue month has at least one source', () async {
      const service = MockAnalyticsService(delay: Duration.zero);
      final data = await service.fetchDashboard();
      for (final month in data.revenue) {
        expect(month.sources, isNotEmpty,
            reason: '${month.month} must have revenue sources');
      }
    });

    test('revenue source fractions within each month sum to ≤ 1.0', () async {
      const service = MockAnalyticsService(delay: Duration.zero);
      final data = await service.fetchDashboard();
      for (final month in data.revenue) {
        final total =
            month.sources.fold<double>(0, (sum, s) => sum + s.fraction);
        // Allow a tiny rounding tolerance
        expect(total, lessThanOrEqualTo(1.001),
            reason: '${month.month} source fractions exceed 1.0');
      }
    });

    test('throws an exception when shouldFail is true', () {
      const service =
          MockAnalyticsService(delay: Duration.zero, shouldFail: true);
      expect(service.fetchDashboard(), throwsException);
    });

    test('respects the configured delay', () async {
      const delay = Duration(milliseconds: 50);
      const service = MockAnalyticsService(delay: delay);
      final sw = Stopwatch()..start();
      await service.fetchDashboard();
      sw.stop();
      expect(
        sw.elapsedMilliseconds,
        greaterThanOrEqualTo(delay.inMilliseconds),
        reason: 'Service must wait at least ${delay.inMilliseconds} ms',
      );
    });

    test('returns immediately with Duration.zero', () async {
      const service = MockAnalyticsService(delay: Duration.zero);
      final sw = Stopwatch()..start();
      await service.fetchDashboard();
      sw.stop();
      // Should be well under 100 ms (pure micro-task overhead)
      expect(sw.elapsedMilliseconds, lessThan(100));
    });
  });

  // ─── HttpAnalyticsService ──────────────────────────────────────────────────

  group('HttpAnalyticsService', () {
    test('throws UnimplementedError on fetchDashboard', () {
      final service =
          HttpAnalyticsService(baseUrl: 'https://api.example.com/v1');
      expect(
        service.fetchDashboard(),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });
}
