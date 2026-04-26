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
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
                const SizedBox(height: 14),
                Text(
                  segment.value,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: kNavy,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${segment.percentage.toInt()}% of total FY 2025 budget',
                  style: const TextStyle(
                      fontSize: 13, color: Color(0xFF9CA3AF)),
                ),
                const SizedBox(height: 20),
                sheetDivider(),
                const SizedBox(height: 16),
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
                      const Color(0xFF111827),
                    ),
                    sheetStat(segment.remaining, 'Remaining', kAmber),
                  ],
                ),
                const SizedBox(height: 16),
                sheetDivider(),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    sheetSectionLabel('Budget Utilization'),
                    Text(
                      '${(segment.utilization * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: kBlue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                sheetProgressBar(segment.utilization, segment.color),
                const SizedBox(height: 20),
                sheetSectionLabel('Monthly Breakdown'),
                const SizedBox(height: 12),
                _miniChart(),
                const SizedBox(height: 20),
                sheetCta(context, 'View Full Report'),
                SizedBox(height: bottomPad + 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniChart() {
    const chartH = 56.0;
    const months = ['J', 'F', 'M', 'A', 'M', 'J'];
    final maxVal =
        segment.monthlyBreakdown.reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: chartH + 22,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(segment.monthlyBreakdown.length, (i) {
          final barH = (segment.monthlyBreakdown[i] / maxVal) * chartH;
          final isHighest = segment.monthlyBreakdown[i] == maxVal;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: barH,
                    decoration: BoxDecoration(
                      color: isHighest
                          ? segment.color
                          : segment.color.withValues(alpha: 0.18),
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4)),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    months[i],
                    style: const TextStyle(
                        fontSize: 10, color: Color(0xFF9CA3AF)),
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
