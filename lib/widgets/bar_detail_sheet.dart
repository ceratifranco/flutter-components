import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import 'ui_helpers.dart';

class BarDetailSheet extends StatelessWidget {
  final MonthlyRevenue revenue;

  const BarDetailSheet({super.key, required this.revenue});

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.paddingOf(context).bottom;
    final isPositive = revenue.vsLastMonth >= 0;
    final sign = isPositive ? '↑' : '↓';
    final pctStr = '${revenue.vsLastMonth.abs().toStringAsFixed(1)}%';
    final growthColor = isPositive ? kGreen : kRed;
    final growthBg =
        isPositive ? const Color(0xFFD1FAE5) : const Color(0xFFFEE2E2);

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
                sheetChip('${revenue.month} 2025', kBlue),
                const SizedBox(height: 14),
                Text(
                  '\$${revenue.value.toInt()}K',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: kNavy,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: growthBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$sign $pctStr vs previous month',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: growthColor,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                sheetDivider(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    sheetStat(
                      revenue.newClients.toString(),
                      'New Clients',
                      const Color(0xFF111827),
                    ),
                    sheetStat(
                      revenue.avgDeal,
                      'Avg. Deal',
                      const Color(0xFF111827),
                    ),
                    sheetStat(revenue.churnRate, 'Churn Rate', kAmber),
                  ],
                ),
                const SizedBox(height: 16),
                sheetDivider(),
                const SizedBox(height: 16),
                sheetSectionLabel('Revenue Sources'),
                const SizedBox(height: 14),
                ...revenue.sources.map(_sourceRow),
                const SizedBox(height: 4),
                sheetCta(context, 'View Full ${revenue.month} Report'),
                SizedBox(height: bottomPad + 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sourceRow(RevenueSource src) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: src.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    src.name,
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF374151)),
                  ),
                ],
              ),
              Text(
                '${(src.fraction * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: src.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          sheetProgressBar(src.fraction, src.color),
        ],
      ),
    );
  }
}
