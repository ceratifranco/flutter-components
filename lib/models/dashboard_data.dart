import '../data/dummy_data.dart';

/// Aggregate payload returned by [AnalyticsService.fetchDashboard].
///
/// Wraps the two collections that drive the dashboard so the data layer
/// can return a single object instead of multiple endpoints.
class DashboardData {
  final List<BudgetSegment> budget;
  final List<MonthlyRevenue> revenue;

  const DashboardData({
    required this.budget,
    required this.revenue,
  });
}
