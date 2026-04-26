import 'package:analytics_dashboard/providers/analytics_provider.dart';
import 'package:analytics_dashboard/services/analytics_service.dart';
import 'package:flutter_test/flutter_test.dart';

// ─── Helpers ──────────────────────────────────────────────────────────────────

/// Creates a provider backed by a [MockAnalyticsService] with the given params
/// and waits long enough for any zero-delay future to resolve.
Future<AnalyticsProvider> _makeProvider({
  Duration delay = Duration.zero,
  bool shouldFail = false,
}) async {
  final provider = AnalyticsProvider(
    MockAnalyticsService(delay: delay, shouldFail: shouldFail),
  );
  // Give the event loop one cycle so zero-delay futures complete.
  await Future<void>.delayed(const Duration(milliseconds: 10));
  return provider;
}

void main() {
  // ─── Initial state ─────────────────────────────────────────────────────────

  group('AnalyticsProvider — initial state', () {
    late AnalyticsProvider provider;

    setUp(() {
      // Long delay: data will NOT arrive during these tests.
      provider = AnalyticsProvider(
        const MockAnalyticsService(delay: Duration(seconds: 30)),
      );
    });

    tearDown(() => provider.dispose());

    test('isLoading is true immediately after construction', () {
      expect(provider.isLoading, isTrue);
    });

    test('data is null before fetch completes', () {
      expect(provider.data, isNull);
    });

    test('error is null before fetch completes', () {
      expect(provider.error, isNull);
    });

    test('budgetData is empty while data is null', () {
      expect(provider.budgetData, isEmpty);
    });

    test('revenueData is empty while data is null', () {
      expect(provider.revenueData, isEmpty);
    });

    test('navIndex starts at 0', () {
      expect(provider.navIndex, 0);
    });

    test('selectedSegment starts null', () {
      expect(provider.selectedSegment, isNull);
    });

    test('selectedRevenue starts null', () {
      expect(provider.selectedRevenue, isNull);
    });
  });

  // ─── Successful load ────────────────────────────────────────────────────────

  group('AnalyticsProvider — successful load', () {
    late AnalyticsProvider provider;

    setUp(() async {
      provider = await _makeProvider();
    });

    tearDown(() => provider.dispose());

    test('isLoading is false after fetch completes', () {
      expect(provider.isLoading, isFalse);
    });

    test('data is non-null after fetch', () {
      expect(provider.data, isNotNull);
    });

    test('error is null after successful fetch', () {
      expect(provider.error, isNull);
    });

    test('budgetData contains 5 segments', () {
      expect(provider.budgetData, hasLength(5));
    });

    test('revenueData contains 6 months', () {
      expect(provider.revenueData, hasLength(6));
    });

    test('budget segment labels are non-empty', () {
      for (final seg in provider.budgetData) {
        expect(seg.label, isNotEmpty);
      }
    });

    test('revenue month strings are non-empty', () {
      for (final r in provider.revenueData) {
        expect(r.month, isNotEmpty);
      }
    });
  });

  // ─── Failed load ────────────────────────────────────────────────────────────

  group('AnalyticsProvider — error state', () {
    late AnalyticsProvider provider;

    setUp(() async {
      provider = await _makeProvider(shouldFail: true);
    });

    tearDown(() => provider.dispose());

    test('isLoading is false after failed fetch', () {
      expect(provider.isLoading, isFalse);
    });

    test('error is non-null after failed fetch', () {
      expect(provider.error, isNotNull);
    });

    test('data is null after failed fetch', () {
      expect(provider.data, isNull);
    });

    test('budgetData is empty when data is null', () {
      expect(provider.budgetData, isEmpty);
    });

    test('revenueData is empty when data is null', () {
      expect(provider.revenueData, isEmpty);
    });
  });

  // ─── refresh() ─────────────────────────────────────────────────────────────

  group('AnalyticsProvider — refresh', () {
    test('refresh reloads data successfully', () async {
      final provider = await _makeProvider();
      expect(provider.data, isNotNull);

      // Trigger a refresh; with zero-delay it resolves immediately
      await provider.refresh();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(provider.isLoading, isFalse);
      expect(provider.data, isNotNull);
      expect(provider.error, isNull);
      provider.dispose();
    });

    test('refresh notifies listeners at least twice (loading + done)', () async {
      int notifyCount = 0;
      final provider = AnalyticsProvider(
        const MockAnalyticsService(delay: Duration.zero),
      );
      provider.addListener(() => notifyCount++);
      await provider.refresh();
      await Future<void>.delayed(const Duration(milliseconds: 10));
      // Expects at least: isLoading=true + isLoading=false (2 calls)
      expect(notifyCount, greaterThanOrEqualTo(2));
      provider.dispose();
    });
  });

  // ─── Navigation ─────────────────────────────────────────────────────────────

  group('AnalyticsProvider — navigation', () {
    late AnalyticsProvider provider;

    setUp(() {
      provider = AnalyticsProvider(
        const MockAnalyticsService(delay: Duration(seconds: 30)),
      );
    });

    tearDown(() => provider.dispose());

    test('setNavIndex changes the active index', () {
      provider.setNavIndex(1);
      expect(provider.navIndex, 1);
    });

    test('setNavIndex to the current index does NOT notify', () {
      int notifyCount = 0;
      provider.addListener(() => notifyCount++);
      provider.setNavIndex(0); // already at 0
      expect(notifyCount, 0);
    });

    test('setNavIndex to different index DOES notify', () {
      int notifyCount = 0;
      provider.addListener(() => notifyCount++);
      provider.setNavIndex(2);
      expect(notifyCount, 1);
    });
  });

  // ─── Segment selection ─────────────────────────────────────────────────────

  group('AnalyticsProvider — budget segment selection', () {
    late AnalyticsProvider provider;

    setUp(() async {
      provider = await _makeProvider();
    });

    tearDown(() => provider.dispose());

    test('selectSegment stores the chosen segment', () {
      final target = provider.budgetData.first;
      provider.selectSegment(target);
      expect(provider.selectedSegment, same(target));
    });

    test('clearSegment resets selectedSegment to null', () {
      provider.selectSegment(provider.budgetData.first);
      provider.clearSegment();
      expect(provider.selectedSegment, isNull);
    });

    test('selectSegment notifies listeners', () {
      int count = 0;
      provider.addListener(() => count++);
      provider.selectSegment(provider.budgetData.first);
      expect(count, 1);
    });

    test('clearSegment notifies listeners', () {
      provider.selectSegment(provider.budgetData.first);
      int count = 0;
      provider.addListener(() => count++);
      provider.clearSegment();
      expect(count, 1);
    });
  });

  // ─── Revenue selection ──────────────────────────────────────────────────────

  group('AnalyticsProvider — revenue selection', () {
    late AnalyticsProvider provider;

    setUp(() async {
      provider = await _makeProvider();
    });

    tearDown(() => provider.dispose());

    test('selectRevenue stores the chosen revenue', () {
      final target = provider.revenueData.first;
      provider.selectRevenue(target);
      expect(provider.selectedRevenue, same(target));
    });

    test('clearRevenue resets selectedRevenue to null', () {
      provider.selectRevenue(provider.revenueData.first);
      provider.clearRevenue();
      expect(provider.selectedRevenue, isNull);
    });

    test('selectRevenue notifies listeners', () {
      int count = 0;
      provider.addListener(() => count++);
      provider.selectRevenue(provider.revenueData.first);
      expect(count, 1);
    });

    test('clearRevenue notifies listeners', () {
      provider.selectRevenue(provider.revenueData.first);
      int count = 0;
      provider.addListener(() => count++);
      provider.clearRevenue();
      expect(count, 1);
    });
  });
}
