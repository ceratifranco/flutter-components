import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import '../data/dummy_data.dart';
import 'ui_helpers.dart';

class BarChartCard extends StatefulWidget {
  final List<MonthlyRevenue> data;
  final void Function(MonthlyRevenue) onBarTapped;

  const BarChartCard({
    super.key,
    required this.data,
    required this.onBarTapped,
  });

  @override
  State<BarChartCard> createState() => _BarChartCardState();
}

class _BarChartCardState extends State<BarChartCard> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return cardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          cardHeader(
            title: 'Monthly Revenue',
            subtitle: 'Jan – Jun 2025  ·  values in \$K',
          ),
          const SizedBox(height: 22),
          Semantics(
            label: 'Monthly revenue bar chart, January to June 2025. '
                'Tap a bar to see details for that month.',
            container: true,
            child: SizedBox(
              height: 176,
              child: _barChart(),
            ),
          ),
          const SizedBox(height: 12),
          cardHint('Tap a bar to explore details'),
        ],
      ),
    );
  }

  Widget _barChart() {
    return BarChart(
      BarChartData(
        maxY: 115,
        minY: 0,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => kNavy,
            tooltipRoundedRadius: 10,
            tooltipPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                BarTooltipItem(
              '\$${widget.data[group.x].value.toInt()}K',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 12,
                letterSpacing: -0.2,
              ),
            ),
          ),
          touchCallback: (event, response) {
            if (!event.isInterestedForInteractions ||
                response == null ||
                response.spot == null) {
              if (_touchedIndex != -1) {
                setState(() => _touchedIndex = -1);
              }
              return;
            }
            final idx = response.spot!.touchedBarGroupIndex;
            if (idx != _touchedIndex) {
              HapticFeedback.selectionClick();
              setState(() => _touchedIndex = idx);
            }
            if (event is FlTapUpEvent) {
              HapticFeedback.lightImpact();
              widget.onBarTapped(widget.data[idx]);
            }
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: 50,
              getTitlesWidget: (value, meta) {
                if (value != 0 && value != 50 && value != 100) {
                  return const SizedBox.shrink();
                }
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    value.toInt().toString(),
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFFCBD5E1),
                    ),
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (value, meta) {
                final i = value.toInt();
                if (i < 0 || i >= widget.data.length) {
                  return const SizedBox.shrink();
                }
                final isActive = i == _touchedIndex;
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    widget.data[i].month,
                    style: TextStyle(
                      fontSize: 11,
                      color: isActive ? kBlue : const Color(0xFFADB5BD),
                      fontWeight:
                          isActive ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
                );
              },
            ),
          ),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 50,
          getDrawingHorizontalLine: (_) => const FlLine(
            color: Color(0xFFF1F5F9),
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
        groupsSpace: 6,
        barGroups: widget.data.asMap().entries.map((e) {
          final isActive = e.key == _touchedIndex;
          return BarChartGroupData(
            x: e.key,
            barRods: [
              BarChartRodData(
                toY: e.value.value,
                color: isActive ? kBlue : const Color(0xFFDDE6FB),
                width: 22,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(6)),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
