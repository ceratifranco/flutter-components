import 'package:flutter/material.dart';

class BudgetSegment {
  final String label;
  final double percentage;
  final String value;
  final Color color;
  final String ytdSpent;
  final String remaining;
  final String vsLastYear;
  final double utilization;
  final List<double> monthlyBreakdown;

  const BudgetSegment({
    required this.label,
    required this.percentage,
    required this.value,
    required this.color,
    required this.ytdSpent,
    required this.remaining,
    required this.vsLastYear,
    required this.utilization,
    required this.monthlyBreakdown,
  });
}

class RevenueSource {
  final String name;
  final double fraction;
  final Color color;
  const RevenueSource(this.name, this.fraction, this.color);
}

class MonthlyRevenue {
  final String month;
  final double value;
  final int newClients;
  final String avgDeal;
  final String churnRate;
  final double vsLastMonth;
  final List<RevenueSource> sources;

  const MonthlyRevenue({
    required this.month,
    required this.value,
    required this.newClients,
    required this.avgDeal,
    required this.churnRate,
    required this.vsLastMonth,
    required this.sources,
  });
}

const kNavy = Color(0xFF1B2B4B);
const kBlue = Color(0xFF2563EB);
const kPurple = Color(0xFF7C3AED);
const kGreen = Color(0xFF059669);
const kAmber = Color(0xFFF59E0B);
const kRed = Color(0xFFEF4444);

const List<BudgetSegment> budgetData = [
  BudgetSegment(
    label: 'Revenue',
    percentage: 30,
    value: '\$2.4M',
    color: kBlue,
    ytdSpent: '\$1.8M',
    remaining: '\$0.6M',
    vsLastYear: '+12.4%',
    utilization: 0.75,
    monthlyBreakdown: [58, 72, 65, 80, 75, 68],
  ),
  BudgetSegment(
    label: 'Operations',
    percentage: 25,
    value: '\$2.0M',
    color: kPurple,
    ytdSpent: '\$1.5M',
    remaining: '\$0.5M',
    vsLastYear: '+8.2%',
    utilization: 0.69,
    monthlyBreakdown: [48, 52, 55, 60, 58, 62],
  ),
  BudgetSegment(
    label: 'Marketing',
    percentage: 20,
    value: '\$1.6M',
    color: kGreen,
    ytdSpent: '\$1.1M',
    remaining: '\$0.5M',
    vsLastYear: '+15.3%',
    utilization: 0.58,
    monthlyBreakdown: [38, 42, 40, 48, 45, 44],
  ),
  BudgetSegment(
    label: 'R&D',
    percentage: 20,
    value: '\$1.6M',
    color: kAmber,
    ytdSpent: '\$0.9M',
    remaining: '\$0.7M',
    vsLastYear: '+20.1%',
    utilization: 0.44,
    monthlyBreakdown: [30, 35, 38, 42, 40, 38],
  ),
  BudgetSegment(
    label: 'Other',
    percentage: 5,
    value: '\$0.4M',
    color: kRed,
    ytdSpent: '\$0.3M',
    remaining: '\$0.1M',
    vsLastYear: '-2.5%',
    utilization: 0.62,
    monthlyBreakdown: [8, 10, 9, 11, 10, 9],
  ),
];

const List<MonthlyRevenue> revenueData = [
  MonthlyRevenue(
    month: 'Jan',
    value: 65,
    newClients: 18,
    avgDeal: '\$3.61K',
    churnRate: '2.8%',
    vsLastMonth: 5.2,
    sources: [
      RevenueSource('Enterprise', 0.50, kBlue),
      RevenueSource('SMB', 0.35, kPurple),
      RevenueSource('Self-serve', 0.15, kGreen),
    ],
  ),
  MonthlyRevenue(
    month: 'Feb',
    value: 78,
    newClients: 22,
    avgDeal: '\$3.55K',
    churnRate: '2.5%',
    vsLastMonth: 20.0,
    sources: [
      RevenueSource('Enterprise', 0.52, kBlue),
      RevenueSource('SMB', 0.33, kPurple),
      RevenueSource('Self-serve', 0.15, kGreen),
    ],
  ),
  MonthlyRevenue(
    month: 'Mar',
    value: 55,
    newClients: 14,
    avgDeal: '\$3.93K',
    churnRate: '3.1%',
    vsLastMonth: -29.5,
    sources: [
      RevenueSource('Enterprise', 0.48, kBlue),
      RevenueSource('SMB', 0.36, kPurple),
      RevenueSource('Self-serve', 0.16, kGreen),
    ],
  ),
  MonthlyRevenue(
    month: 'Apr',
    value: 90,
    newClients: 24,
    avgDeal: '\$3.75K',
    churnRate: '2.1%',
    vsLastMonth: 9.8,
    sources: [
      RevenueSource('Enterprise', 0.55, kBlue),
      RevenueSource('SMB', 0.30, kPurple),
      RevenueSource('Self-serve', 0.15, kGreen),
    ],
  ),
  MonthlyRevenue(
    month: 'May',
    value: 82,
    newClients: 20,
    avgDeal: '\$4.10K',
    churnRate: '2.3%',
    vsLastMonth: -8.9,
    sources: [
      RevenueSource('Enterprise', 0.54, kBlue),
      RevenueSource('SMB', 0.30, kPurple),
      RevenueSource('Self-serve', 0.16, kGreen),
    ],
  ),
  MonthlyRevenue(
    month: 'Jun',
    value: 72,
    newClients: 19,
    avgDeal: '\$3.79K',
    churnRate: '2.6%',
    vsLastMonth: -12.2,
    sources: [
      RevenueSource('Enterprise', 0.51, kBlue),
      RevenueSource('SMB', 0.33, kPurple),
      RevenueSource('Self-serve', 0.16, kGreen),
    ],
  ),
];
