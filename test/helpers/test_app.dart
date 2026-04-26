import 'package:analytics_dashboard/providers/analytics_provider.dart';
import 'package:analytics_dashboard/screens/dashboard_screen.dart';
import 'package:analytics_dashboard/services/analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Builds a minimal, testable version of the Analytics Dashboard app.
///
/// Accepts a custom [AnalyticsService] so tests can inject:
/// - `MockAnalyticsService(delay: Duration.zero)` — instant data, loaded state
/// - `MockAnalyticsService(delay: Duration(seconds: 10))` — catch loading state
/// - `MockAnalyticsService(shouldFail: true)` — trigger error state
///
/// Uses the same [DashboardScreen] and theme as the real app so widget tests
/// exercise the actual rendering pipeline.
Widget buildTestApp(AnalyticsService service) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => AnalyticsProvider(service),
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
