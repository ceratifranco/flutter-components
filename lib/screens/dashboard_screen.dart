import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/dummy_data.dart';
import '../widgets/donut_chart_card.dart';
import '../widgets/bar_chart_card.dart';
import '../widgets/pie_detail_sheet.dart';
import '../widgets/bar_detail_sheet.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _navIndex = 0;

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
              _header(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    16,
                    20,
                    16,
                    MediaQuery.paddingOf(context).bottom + 88,
                  ),
                  child: Column(
                    children: [
                      DonutChartCard(
                        data: budgetData,
                        onSegmentTapped: _showPieDetail,
                      ),
                      const SizedBox(height: 16),
                      BarChartCard(
                        data: revenueData,
                        onBarTapped: _showBarDetail,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _bottomNav(),
      ),
    );
  }

  Widget _header() {
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
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Analytics',
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
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFFADB5BD),
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
          _avatar(),
        ],
      ),
    );
  }

  Widget _avatar() {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: kNavy,
        borderRadius: BorderRadius.circular(19),
      ),
      child: const Center(
        child: Text(
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

  Widget _bottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF1F5F9), width: 1)),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 58,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _navItems.asMap().entries.map((e) {
              final isActive = e.key == _navIndex;
              return GestureDetector(
                onTap: () => setState(() => _navIndex = e.key),
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  width: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        e.value,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isActive
                              ? FontWeight.w700
                              : FontWeight.w400,
                          color: isActive
                              ? kBlue
                              : const Color(0xFFADB5BD),
                          letterSpacing: isActive ? -0.1 : 0,
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
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _showPieDetail(BudgetSegment segment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: false,
      backgroundColor: Colors.transparent,
      builder: (_) => PieDetailSheet(segment: segment),
    );
  }

  void _showBarDetail(MonthlyRevenue revenue) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: false,
      backgroundColor: Colors.transparent,
      builder: (_) => BarDetailSheet(revenue: revenue),
    );
  }
}
