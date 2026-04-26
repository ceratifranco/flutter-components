import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../data/dummy_data.dart';
import '../providers/analytics_provider.dart';
import '../utils/breakpoints.dart';
import '../widgets/bar_chart_card.dart';
import '../widgets/bar_detail_sheet.dart';
import '../widgets/card_skeleton.dart';
import '../widgets/donut_chart_card.dart';
import '../widgets/error_card.dart';
import '../widgets/pie_detail_sheet.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const _navItems = ['Analytics', 'Reports', 'Settings'];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F3F9),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const _DashboardHeader(),
              const Expanded(child: _DashboardBody()),
            ],
          ),
        ),
        bottomNavigationBar: const _BottomNav(),
      ),
    );
  }
}

// ─── Body (responsive + loading/error/data switch) ───────────────────────────

class _DashboardBody extends StatelessWidget {
  const _DashboardBody();

  @override
  Widget build(BuildContext context) {
    final hPad = scaledHorizontalPadding(context);
    final bottomInset = MediaQuery.paddingOf(context).bottom + 88;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(hPad, 20, hPad, bottomInset),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: Breakpoints.desktopMaxContentWidth,
          ),
          child: Consumer<AnalyticsProvider>(
            builder: (context, provider, _) {
              // Initial load → skeletons
              if (provider.isLoading && provider.data == null) {
                return _buildLayout(
                  context,
                  donut: const DonutCardSkeleton(),
                  bar: const BarCardSkeleton(),
                );
              }

              // Failure with no cached data → error card
              if (provider.error != null && provider.data == null) {
                return ErrorCard(
                  message: 'We couldn\'t load the dashboard data. '
                      'Please check your connection and try again.',
                  onRetry: provider.refresh,
                );
              }

              // Data available — render real cards
              return _buildLayout(
                context,
                donut: DonutChartCard(
                  data: provider.budgetData,
                  onSegmentTapped: (segment) {
                    provider.selectSegment(segment);
                    _showPieDetail(context, segment);
                  },
                ),
                bar: BarChartCard(
                  data: provider.revenueData,
                  onBarTapped: (revenue) {
                    provider.selectRevenue(revenue);
                    _showBarDetail(context, revenue);
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /// Mobile → Column. Tablet/Desktop → Row with two equal columns.
  Widget _buildLayout(
    BuildContext context, {
    required Widget donut,
    required Widget bar,
  }) {
    if (isMobile(context)) {
      return Column(
        children: [
          donut,
          const SizedBox(height: 16),
          bar,
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: donut),
        const SizedBox(width: 16),
        Expanded(child: bar),
      ],
    );
  }

  void _showPieDetail(BuildContext context, BudgetSegment segment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: false,
      backgroundColor: Colors.transparent,
      builder: (_) => PieDetailSheet(segment: segment),
    );
  }

  void _showBarDetail(BuildContext context, MonthlyRevenue revenue) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: false,
      backgroundColor: Colors.transparent,
      builder: (_) => BarDetailSheet(revenue: revenue),
    );
  }
}

// ─── Header ──────────────────────────────────────────────────────────────────

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader();

  @override
  Widget build(BuildContext context) {
    final hPad = scaledHeaderPadding(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B2B4B).withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(hPad, 14, hPad, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Expanded(child: _HeaderText()),
          SizedBox(width: 12),
          _Avatar(),
        ],
      ),
    );
  }
}

class _HeaderText extends StatelessWidget {
  const _HeaderText();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analytics',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: kNavy,
              letterSpacing: -0.8,
              height: 1.1,
            ),
          ),
          SizedBox(height: 3),
          Text(
            'Q2 2025  —  Financial Overview',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFFADB5BD),
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'User avatar, FC',
      button: true,
      child: Container(
        width: 38,
        height: 38,
        decoration: const BoxDecoration(
          color: kNavy,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: const Text(
          'FC',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

// ─── Bottom navigation ───────────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  const _BottomNav();

  static const _items = DashboardScreen._navItems;

  @override
  Widget build(BuildContext context) {
    final navIndex = context.watch<AnalyticsProvider>().navIndex;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 58,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (i) {
              final isActive = i == navIndex;
              return _NavItem(
                label: _items[i],
                isActive: isActive,
                onTap: () {
                  HapticFeedback.selectionClick();
                  context.read<AnalyticsProvider>().setNavIndex(i);
                },
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isActive,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ExcludeSemantics(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                    color: isActive ? kBlue : const Color(0xFFADB5BD),
                    letterSpacing: isActive ? -0.1 : 0,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                width: isActive ? 20 : 0,
                height: 2.5,
                decoration: BoxDecoration(
                  color: kBlue,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
