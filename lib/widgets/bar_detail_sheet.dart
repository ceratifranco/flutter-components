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
    final sign = isPositive ? '+' : '';
    final pctStr = '$sign${revenue.vsLastMonth.toStringAsFixed(1)}%';
    final growthColor = isPositive ? kGreen : kRed;
    final growthBg = isPositive
        ? const Color(0xFFECFDF5)
        : const Color(0xFFFEF2F2);
    final growthIcon = isPositive
        ? Icons.trending_up_rounded
        : Icons.trending_down_rounded;

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
                sheetChip('${revenue.month} 2025', kBlue),
                const SizedBox(height: 16),
                Text(
                  '\$${revenue.value.toInt()}K',
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                    color: kNavy,
                    height: 1,
                    letterSpacing: -1.5,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: growthBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(growthIcon, size: 14, color: growthColor),
                      const SizedBox(width: 5),
                      Text(
                        '$pctStr vs previous month',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: growthColor,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                sheetDivider(),
                const SizedBox(height: 20),
                Row(
                  children: [
                    sheetStat(
                      revenue.newClients.toString(),
                      'New Clients',
                      const Color(0xFF1E293B),
                    ),
                    sheetStat(
                      revenue.avgDeal,
                      'Avg. Deal',
                      const Color(0xFF1E293B),
                    ),
                    sheetStat(revenue.churnRate, 'Churn Rate', kAmber),
                  ],
                ),
                const SizedBox(height: 20),
                sheetDivider(),
                const SizedBox(height: 20),
                sheetSectionLabel('Revenue Sources'),
                const SizedBox(height: 16),
                ...revenue.sources.map(_sourceRow),
                const SizedBox(height: 8),
                sheetCta(context, 'View Full ${revenue.month} Report'),
                SizedBox(height: bottomPad + 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sourceRow(RevenueSource src) {
    final pct = (src.fraction * 100).toInt();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
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
                  const SizedBox(width: 9),
                  Text(
                    src.name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF374151),
                    ),
                  ),
                ],
              ),
              Text(
                '$pct%',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: src.color,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          sheetProgressBar(src.fraction, src.color),
        ],
      ),
    );
  }
}
