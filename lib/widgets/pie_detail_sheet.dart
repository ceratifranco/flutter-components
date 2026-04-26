import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import 'ui_helpers.dart';

class PieDetailSheet extends StatelessWidget {
  final BudgetSegment segment;

  const PieDetailSheet({super.key, required this.segment});

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.paddingOf(context).bottom;
    final isPositive = segment.vsLastYear.startsWith('+');

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sheetHandle(),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sheetChip(segment.label, segment.color),
                const SizedBox(height: 16),
                Semantics(
                  header: true,
                  label:
                      '${segment.label} budget, ${segment.value}, ${segment.percentage.toInt()} percent of total',
                  child: ExcludeSemantics(
                    child: Text(
                      segment.value,
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        color: kNavy,
                        height: 1,
                        letterSpacing: -1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Allocated — FY 2025  ·  ${segment.percentage.toInt()}% of total budget',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFFADB5BD),
                    letterSpacing: 0.1,
                  ),
                ),
                const SizedBox(height: 22),
                sheetDivider(),
                const SizedBox(height: 20),
                Row(
                  children: [
                    sheetStat(
                      segment.vsLastYear,
                      'vs Last Year',
                      isPositive ? kGreen : kRed,
                    ),
                    sheetStat(
                      segment.ytdSpent,
                      'YTD Spent',
                      const Color(0xFF1E293B),
                    ),
                    sheetStat(segment.remaining, 'Remaining', kAmber),
                  ],
                ),
                const SizedBox(height: 20),
                sheetDivider(),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    sheetSectionLabel('Budget Utilization'),
                    Text(
                      '${(segment.utilization * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: segment.color,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                sheetProgressBar(segment.utilization, segment.color),
                const SizedBox(height: 24),
                sheetSectionLabel('Monthly Breakdown'),
                const SizedBox(height: 14),
                _miniChart(),
                const SizedBox(height: 24),
                sheetCta(context, 'View Full ${segment.label} Report'),
                SizedBox(height: bottomPad + 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniChart() {
    const chartH = 60.0;
    const months = ['J', 'F', 'M', 'A', 'M', 'J'];
    final maxVal = segment.monthlyBreakdown.reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: chartH + 24,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(segment.monthlyBreakdown.length, (i) {
          final barH = (segment.monthlyBreakdown[i] / maxVal) * chartH;
          final isHighest = segment.monthlyBreakdown[i] == maxVal;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: barH,
                    decoration: BoxDecoration(
                      color: isHighest
                          ? segment.color
                          : segment.color.withValues(alpha: 0.15),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    months[i],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: isHighest
                          ? FontWeight.w700
                          : FontWeight.w400,
                      color: isHighest
                          ? segment.color
                          : const Color(0xFFCBD5E1),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
