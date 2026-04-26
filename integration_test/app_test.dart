// E2E integration tests for the Analytics Dashboard.
//
// These tests drive the full compiled app from a user's perspective —
// full widget tree, real navigation, real modal sheets.
//
// Run on the web target:
//   flutter test integration_test/app_test.dart -d chrome
// Run on the Flutter test driver (headless):
//   flutter test integration_test/app_test.dart
//
// Design notes:
//   • Uses an instant MockAnalyticsService (delay: Duration.zero) so tests
//     run in under a second each.
//   • Avoids pumpAndSettle() during loading because the shimmer
//     AnimationController repeats indefinitely. Uses pump(Duration) instead.
//   • Sheet animations (300 ms slide-in) are cleared with a 350 ms pump.

import 'package:analytics_dashboard/providers/analytics_provider.dart';
import 'package:analytics_dashboard/screens/dashboard_screen.dart';
import 'package:analytics_dashboard/services/analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';

// ─── Test app factory ─────────────────────────────────────────────────────────

Widget _buildApp({bool shouldFail = false}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => AnalyticsProvider(
          MockAnalyticsService(
            delay: Duration.zero,
            shouldFail: shouldFail,
          ),
        ),
      ),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF0F3F9),
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    ),
  );
}

/// Advances the fake timer past a zero-delay service fetch.
Future<void> _pumpLoad(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
}

/// Advances enough frames to complete a 300 ms modal bottom-sheet slide-in.
Future<void> _pumpSheet(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 350));
}

// ─── Test suites ──────────────────────────────────────────────────────────────

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // ── Journey 1: Dashboard renders ──────────────────────────────────────────

  group('E2E — Dashboard renders', () {
    testWidgets('shows header, both chart cards and bottom nav', (tester) async {
      await tester.pumpWidget(_buildApp());
      await _pumpLoad(tester);

      // Header
      expect(find.text('Analytics'), findsAtLeastNWidgets(1));
      expect(find.text('Q2 2025  —  Financial Overview'), findsOneWidget);
      expect(find.text('FC'), findsOneWidget);

      // Cards
      expect(find.text('Budget Allocation'), findsOneWidget);
      expect(find.text('Monthly Revenue'), findsOneWidget);

      // Navigation bar
      expect(find.text('Reports'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('donut legend lists all 5 budget segments', (tester) async {
      await tester.pumpWidget(_buildApp());
      await _pumpLoad(tester);

      for (final label in [
        'Revenue',
        'Operations',
        'Marketing',
        'R&D',
        'Other',
      ]) {
        expect(
          find.text(label),
          findsAtLeastNWidgets(1),
          reason: '"$label" legend item missing',
        );
      }
    });

    testWidgets('donut chart shows total label', (tester) async {
      await tester.pumpWidget(_buildApp());
      await _pumpLoad(tester);
      expect(find.text('\$8.0M'), findsOneWidget);
    });

    testWidgets('both hint texts are visible', (tester) async {
      await tester.pumpWidget(_buildApp());
      await _pumpLoad(tester);
      expect(find.text('Tap a segment to explore details'), findsOneWidget);
      expect(find.text('Tap a bar to explore details'), findsOneWidget);
    });
  });

  // ── Journey 2: Bottom navigation ──────────────────────────────────────────

  group('E2E — Bottom navigation', () {
    testWidgets('tapping Reports sets navIndex to 1', (tester) async {
      await tester.pumpWidget(_buildApp());
      await _pumpLoad(tester);

      await tester.tap(find.text('Reports'));
      await tester.pump();

      final ctx = tester.element(find.byType(DashboardScreen));
      expect(ctx.read<AnalyticsProvider>().navIndex, 1);
    });

    testWidgets('tapping Settings sets navIndex to 2', (tester) async {
      await tester.pumpWidget(_buildApp());
      await _pumpLoad(tester);

      await tester.tap(find.text('Settings'));
      await tester.pump();

      final ctx = tester.element(find.byType(DashboardScreen));
      expect(ctx.read<AnalyticsProvider>().navIndex, 2);
    });

    testWidgets('tapping Analytics (nav) resets navIndex to 0', (tester) async {
      await tester.pumpWidget(_buildApp());
      await _pumpLoad(tester);

      // Navigate away first
      await tester.tap(find.text('Reports'));
      await tester.pump();

      // Tap the nav Analytics item (second occurrence — first is the header)
      final analyticsNavItem = find.text('Analytics').at(1);
      await tester.tap(analyticsNavItem);
      await tester.pump();

      final ctx = tester.element(find.byType(DashboardScreen));
      expect(ctx.read<AnalyticsProvider>().navIndex, 0);
    });

    testWidgets('tapping same tab twice does not crash', (tester) async {
      await tester.pumpWidget(_buildApp());
      await _pumpLoad(tester);

      await tester.tap(find.text('Reports'));
      await tester.pump();
      await tester.tap(find.text('Reports')); // second tap — idempotent
      await tester.pump();

      final ctx = tester.element(find.byType(DashboardScreen));
      expect(ctx.read<AnalyticsProvider>().navIndex, 1);
    });
  });

  // ── Journey 3: Budget segment detail (PieDetailSheet) ─────────────────────

  group('E2E — Budget segment detail sheet', () {
    Future<void> openSegment(WidgetTester tester, String label) async {
      await tester.pumpWidget(_buildApp());
      await _pumpLoad(tester);
      await tester.tap(find.text(label).first);
      await _pumpSheet(tester);
    }

    testWidgets('Revenue sheet shows 30% allocation and correct CTA',
        (tester) async {
      await openSegment(tester, 'Revenue');
      // Allocation subtitle is sheet-only; 30% uniquely identifies Revenue.
      expect(
        find.text('Allocated — FY 2025  ·  30% of total budget'),
        findsOneWidget,
      );
      expect(find.text('View Full Revenue Report'), findsOneWidget);
    });

    testWidgets('Revenue sheet shows vs-last-year stat', (tester) async {
      await openSegment(tester, 'Revenue');
      expect(find.text('+12.4%'), findsOneWidget);
    });

    testWidgets('Revenue sheet shows YTD Spent stat', (tester) async {
      await openSegment(tester, 'Revenue');
      // '\$1.8M' is the YTD Spent for Revenue — appears only in the sheet.
      expect(find.text('\$1.8M'), findsOneWidget);
    });

    testWidgets('Operations sheet shows 25% allocation and correct CTA',
        (tester) async {
      await openSegment(tester, 'Operations');
      // 25% uniquely identifies Operations.
      expect(
        find.text('Allocated — FY 2025  ·  25% of total budget'),
        findsOneWidget,
      );
      expect(find.text('View Full Operations Report'), findsOneWidget);
    });

    testWidgets('Marketing sheet shows correct CTA', (tester) async {
      await openSegment(tester, 'Marketing');
      // Marketing and R&D share '\$1.6M'; check unique CTA instead.
      expect(find.text('View Full Marketing Report'), findsOneWidget);
    });

    testWidgets('Other sheet shows correct CTA', (tester) async {
      await openSegment(tester, 'Other');
      // '\$0.4M' appears in legend + sheet; check unique CTA and 5% subtitle.
      expect(
        find.text('Allocated — FY 2025  ·  5% of total budget'),
        findsOneWidget,
      );
      expect(find.text('View Full Other Report'), findsOneWidget);
    });

    testWidgets('sheet shows Budget Utilization label', (tester) async {
      await openSegment(tester, 'Revenue');
      expect(find.text('Budget Utilization'), findsOneWidget);
    });

    testWidgets('sheet shows Monthly Breakdown label', (tester) async {
      await openSegment(tester, 'Revenue');
      expect(find.text('Monthly Breakdown'), findsOneWidget);
    });

    testWidgets('tapping Revenue updates selectedSegment on provider',
        (tester) async {
      await tester.pumpWidget(_buildApp());
      await _pumpLoad(tester);
      await tester.tap(find.text('Revenue').first);
      await _pumpSheet(tester);

      final ctx = tester.element(find.byType(DashboardScreen));
      expect(
        ctx.read<AnalyticsProvider>().selectedSegment?.label,
        'Revenue',
      );
    });
  });

  // ── Journey 4: Error state and retry ──────────────────────────────────────

  group('E2E — Error state', () {
    testWidgets('shows error card when service fails', (tester) async {
      await tester.pumpWidget(_buildApp(shouldFail: true));
      await _pumpLoad(tester);

      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('chart cards are hidden in error state', (tester) async {
      await tester.pumpWidget(_buildApp(shouldFail: true));
      await _pumpLoad(tester);

      expect(find.text('Budget Allocation'), findsNothing);
      expect(find.text('Monthly Revenue'), findsNothing);
    });

    testWidgets('tapping Retry keeps the app stable', (tester) async {
      await tester.pumpWidget(_buildApp(shouldFail: true));
      await _pumpLoad(tester);

      // Retry with the same failing service → still shows error, no crash
      await tester.tap(find.text('Retry'));
      await _pumpLoad(tester);

      expect(find.text('Something went wrong'), findsOneWidget);
    });
  });

  // ── Journey 5: Accessibility surface ──────────────────────────────────────

  group('E2E — Accessibility', () {
    testWidgets('donut chart has accessible label via Semantics container',
        (tester) async {
      await tester.pumpWidget(_buildApp());
      await _pumpLoad(tester);

      // The Semantics node wrapping the PieChart has this label
      expect(
        find.bySemanticsLabel(
          'Budget allocation donut chart, total \$8.0M',
        ),
        findsOneWidget,
      );
    });

    testWidgets('bar chart has accessible label via Semantics container',
        (tester) async {
      await tester.pumpWidget(_buildApp());
      await _pumpLoad(tester);

      expect(
        find.bySemanticsLabel(
          RegExp(r'Monthly revenue bar chart'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('each legend item is announced as a button', (tester) async {
      await tester.pumpWidget(_buildApp());
      await _pumpLoad(tester);

      // Check one representative legend item
      final semantics = tester.getSemantics(find.text('Revenue').first);
      expect(semantics.flagsCollection, contains(SemanticsFlag.isButton));
    });
  });
}
