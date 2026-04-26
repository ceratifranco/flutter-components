import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/dashboard_data.dart';
import '../services/analytics_service.dart';

/// Central state manager for the Analytics Dashboard.
///
/// Owns:
/// - The remote [DashboardData] (with `isLoading` / `error` flags)
/// - Active bottom navigation index
/// - Currently selected budget segment (donut chart)
/// - Currently selected monthly revenue (bar chart)
///
/// Constructor injection of [AnalyticsService] lets us swap a mock for
/// production without touching the UI.
class AnalyticsProvider extends ChangeNotifier {
  final AnalyticsService _service;

  AnalyticsProvider(this._service) {
    load();
  }

  // ─── Data fetch ─────────────────────────────────────────────────────────

  bool _isLoading = false;
  String? _error;
  DashboardData? _data;

  bool get isLoading => _isLoading;
  String? get error => _error;
  DashboardData? get data => _data;

  /// Convenience accessors. Return empty lists while loading so widgets
  /// that opt into "render anyway" gracefully degrade instead of crashing.
  List<BudgetSegment> get budgetData => _data?.budget ?? const [];
  List<MonthlyRevenue> get revenueData => _data?.revenue ?? const [];

  /// First-time load. Sets `isLoading` so the UI can render skeletons.
  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _data = await _service.fetchDashboard();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Subsequent reload — typically triggered by a Retry button or
  /// pull-to-refresh. Same flow as [load].
  Future<void> refresh() => load();

  // ─── Navigation ─────────────────────────────────────────────────────────

  int _navIndex = 0;

  int get navIndex => _navIndex;

  void setNavIndex(int index) {
    if (_navIndex == index) return;
    _navIndex = index;
    notifyListeners();
  }

  // ─── Budget / Donut ─────────────────────────────────────────────────────

  BudgetSegment? _selectedSegment;

  BudgetSegment? get selectedSegment => _selectedSegment;

  void selectSegment(BudgetSegment segment) {
    _selectedSegment = segment;
    notifyListeners();
  }

  void clearSegment() {
    _selectedSegment = null;
    notifyListeners();
  }

  // ─── Revenue / Bar ──────────────────────────────────────────────────────

  MonthlyRevenue? _selectedRevenue;

  MonthlyRevenue? get selectedRevenue => _selectedRevenue;

  void selectRevenue(MonthlyRevenue revenue) {
    _selectedRevenue = revenue;
    notifyListeners();
  }

  void clearRevenue() {
    _selectedRevenue = null;
    notifyListeners();
  }
}
