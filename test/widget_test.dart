// Widget tests for the Analytics Dashboard.
//
// Strategy:
//   - Loading state tests: use _PendingService — a Completer-based service
//     whose future intentionally never resolves. No FakeAsync timer is created,
//     so the test harness doesn't error about "pending timers" at teardown.
//   - Loaded state tests: use MockAnalyticsService(delay: Duration.zero).
//     After pumpPastLoad(), the zero-delay timer has fired and data is shown.
//     No infinite animation exists in the loaded state.
//   - Error state tests: same zero-delay approach with shouldFail: true.

import 'dart:async';

import 'package:analytics_dashboard/models/dashboard_data.dart';
import 'package:analytics_dashboard/services/analytics_service.dart';
import 'package:analytics_dashboard/widgets/card_skeleton.dart';
import 'package:analytics_dashboard/widgets/error_card.dart';
import 'package:flutter_test/flutter_test.dart';
import 'helpers/test_app.dart';

// ─── Test-only service stubs ──────────────────────────────────────────────────

/// A service whose [fetchDashboard] future never resolves.
///
/// Because no [Future.delayed] timer is involved, Flutter's FakeAsync
/// teardown won't flag "pending timers", so loading-state widget tests
/// can end with data still in flight.
class _PendingService implements AnalyticsService {
  @override
  Future<DashboardData> fetchDashboard() => Completer<DashboardData>().future;
}

// ─── Pump helpers ─────────────────────────────────────────────────────────────

/// Advances time past a zero-delay [MockAnalyticsService] fetch.
///
/// Two-phase pump:
///   1. One micro-task tick so the first [notifyListeners] fires.
///   2. 50 ms so [Future.delayed(Duration.zero)] resolves and the second
///      [notifyListeners] (data loaded / error captured) fires.
Future<void> pumpPastLoad(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
}

void main() {
  // ─── Loading state ──────────────────────────────────────────────────────────

  group('DashboardScreen — loading state', () {
    testWidgets('shows DonutCardSkeleton while data is pending', (tester) async {
      await tester.pumpWidget(
        buildTestApp(_PendingService()),
      );
      await tester.pump(); // one frame: notifyListeners(isLoading=true) fires
      expect(find.byType(DonutCardSkeleton), findsOneWidget);
    });

    testWidgets('shows BarCardSkeleton while data is pending', (tester) async {
      await tester.pumpWidget(
        buildTestApp(_PendingService()),
      );
      await tester.pump();
      expect(find.byType(BarCardSkeleton), findsOneWidget);
    });

    testWidgets('does NOT show chart card titles while loading', (tester) async {
      await tester.pumpWidget(
        buildTestApp(_PendingService()),
      );
      await tester.pump();
      expect(find.text('Budget Allocation'), findsNothing);
      expect(find.text('Monthly Revenue'), findsNothing);
    });
  });

  // ─── Header (always visible) ─────────────────────────────────────────────

  group('DashboardScreen — header', () {
    testWidgets('shows Analytics page title', (tester) async {
      await tester.pumpWidget(
        buildTestApp(_PendingService()),
      );
      // 'Analytics' appears in both header and nav, so check for ≥ 1
      expect(find.text('Analytics'), findsAtLeastNWidgets(1));
    });

    testWidgets('shows quarter subtitle', (tester) async {
      await tester.pumpWidget(
        buildTestApp(_PendingService()),
      );
      expect(
        find.text('Q2 2025  —  Financial Overview'),
        findsOneWidget,
      );
    });

    testWidgets('shows user avatar with FC initials', (tester) async {
      await tester.pumpWidget(
        buildTestApp(_PendingService()),
      );
      expect(find.text('FC'), findsOneWidget);
    });
  });

  // ─── Bottom navigation ───────────────────────────────────────────────────

  group('DashboardScreen — bottom navigation', () {
    testWidgets('renders Reports nav item', (tester) async {
      await tester.pumpWidget(
        buildTestApp(_PendingService()),
      );
      expect(find.text('Reports'), findsOneWidget);
    });

    testWidgets('renders Settings nav item', (tester) async {
      await tester.pumpWidget(
        buildTestApp(_PendingService()),
      );
      expect(find.text('Settings'), findsOneWidget);
    });
  });

  // ─── Loaded state ────────────────────────────────────────────────────────

  group('DashboardScreen — loaded state', () {
    testWidgets('shows Budget Allocation card title', (tester) async {
      await tester.pumpWidget(
        buildTestApp(const MockAnalyticsService(delay: Duration.zero)),
      );
      await pumpPastLoad(tester);
      expect(find.text('Budget Allocation'), findsOneWidget);
    });

    testWidgets('shows Monthly Revenue card title', (tester) async {
      await tester.pumpWidget(
        buildTestApp(const MockAnalyticsService(delay: Duration.zero)),
      );
      await pumpPastLoad(tester);
      expect(find.text('Monthly Revenue'), findsOneWidget);
    });

    testWidgets('shows all 5 budget segment labels in the legend',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(const MockAnalyticsService(delay: Duration.zero)),
      );
      await pumpPastLoad(tester);
      for (final label in ['Revenue', 'Operations', 'Marketing', 'R&D', 'Other']) {
        expect(
          find.text(label),
          findsAtLeastNWidgets(1),
          reason: '"$label" should appear in the donut legend',
        );
      }
    });

    testWidgets('shows donut chart hint text', (tester) async {
      await tester.pumpWidget(
        buildTestApp(const MockAnalyticsService(delay: Duration.zero)),
      );
      await pumpPastLoad(tester);
      expect(find.text('Tap a segment to explore details'), findsOneWidget);
    });

    testWidgets('shows bar chart hint text', (tester) async {
      await tester.pumpWidget(
        buildTestApp(const MockAnalyticsService(delay: Duration.zero)),
      );
      await pumpPastLoad(tester);
      expect(find.text('Tap a bar to explore details'), findsOneWidget);
    });

    testWidgets('skeleton is gone after data loads', (tester) async {
      await tester.pumpWidget(
        buildTestApp(const MockAnalyticsService(delay: Duration.zero)),
      );
      await pumpPastLoad(tester);
      expect(find.byType(DonutCardSkeleton), findsNothing);
      expect(find.byType(BarCardSkeleton), findsNothing);
    });
  });

  // ─── Error state ──────────────────────────────────────────────────────────

  group('DashboardScreen — error state', () {
    testWidgets('shows ErrorCard when the service fails', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          const MockAnalyticsService(delay: Duration.zero, shouldFail: true),
        ),
      );
      await pumpPastLoad(tester);
      expect(find.byType(ErrorCard), findsOneWidget);
    });

    testWidgets('error card shows "Something went wrong" heading',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          const MockAnalyticsService(delay: Duration.zero, shouldFail: true),
        ),
      );
      await pumpPastLoad(tester);
      expect(find.text('Something went wrong'), findsOneWidget);
    });

    testWidgets('error card shows Retry button', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          const MockAnalyticsService(delay: Duration.zero, shouldFail: true),
        ),
      );
      await pumpPastLoad(tester);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('tapping Retry does not crash the app', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          const MockAnalyticsService(delay: Duration.zero, shouldFail: true),
        ),
      );
      await pumpPastLoad(tester);
      await tester.tap(find.text('Retry'));
      await pumpPastLoad(tester);
      // Error persists (same service still fails), but no exception thrown
      expect(find.byType(ErrorCard), findsOneWidget);
    });
  });

  // ─── PieDetailSheet ───────────────────────────────────────────────────────

  group('PieDetailSheet', () {
    // Helper: load the dashboard and tap a legend item by label.
    Future<void> tapLegendItem(
      WidgetTester tester,
      String label,
    ) async {
      await tester.pumpWidget(
        buildTestApp(const MockAnalyticsService(delay: Duration.zero)),
      );
      await pumpPastLoad(tester);
      await tester.tap(find.text(label).first);
      await tester.pump(); // trigger tap callback
      await tester.pump(const Duration(milliseconds: 350)); // sheet slide-in
    }

    testWidgets('Revenue sheet shows 30% allocation subtitle', (tester) async {
      // Sheet-only text — unique to this segment (30% is only Revenue).
      await tapLegendItem(tester, 'Revenue');
      expect(
        find.text('Allocated — FY 2025  ·  30% of total budget'),
        findsOneWidget,
      );
    });

    testWidgets('sheet shows segment-specific CTA for Revenue', (tester) async {
      await tapLegendItem(tester, 'Revenue');
      expect(find.text('View Full Revenue Report'), findsOneWidget);
    });

    testWidgets('Operations sheet shows 25% allocation subtitle',
        (tester) async {
      // Sheet-only text — unique to this segment (25% is only Operations).
      await tapLegendItem(tester, 'Operations');
      expect(
        find.text('Allocated — FY 2025  ·  25% of total budget'),
        findsOneWidget,
      );
    });

    testWidgets('sheet shows correct CTA for Operations', (tester) async {
      await tapLegendItem(tester, 'Operations');
      expect(find.text('View Full Operations Report'), findsOneWidget);
    });

    testWidgets('tapping Marketing opens sheet with correct CTA',
        (tester) async {
      await tapLegendItem(tester, 'Marketing');
      // Marketing and R&D share the same '\$1.6M' value so the text appears
      // in both legend items. Check the unique CTA instead.
      expect(find.text('View Full Marketing Report'), findsOneWidget);
    });

    testWidgets('Marketing sheet shows allocation subtitle', (tester) async {
      await tapLegendItem(tester, 'Marketing');
      // Subtitle is sheet-only and contains the exact percentage (20%).
      expect(
        find.text('Allocated — FY 2025  ·  20% of total budget'),
        findsOneWidget,
      );
    });

    testWidgets('tapping Other opens sheet with \$0.4M amount',
        (tester) async {
      await tapLegendItem(tester, 'Other');
      // '\$0.4M' appears in both the legend and the sheet header (×2 total).
      expect(find.text('\$0.4M'), findsAtLeastNWidgets(1));
      // Unique sheet-only check:
      expect(find.text('View Full Other Report'), findsOneWidget);
    });

    testWidgets('Revenue sheet shows 75% utilization', (tester) async {
      await tapLegendItem(tester, 'Revenue');
      // Revenue utilization = 0.75 → displayed as '75%'
      expect(find.text('75%'), findsOneWidget);
    });

    testWidgets('Operations sheet shows 69% utilization', (tester) async {
      await tapLegendItem(tester, 'Operations');
      // Operations utilization = 0.69 → displayed as '69%'
      expect(find.text('69%'), findsOneWidget);
    });

    testWidgets('sheet shows YTD Spent label', (tester) async {
      await tapLegendItem(tester, 'Revenue');
      expect(find.text('YTD Spent'), findsOneWidget);
    });

    testWidgets('sheet shows Remaining label', (tester) async {
      await tapLegendItem(tester, 'Revenue');
      expect(find.text('Remaining'), findsOneWidget);
    });
  });
}
