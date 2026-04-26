import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../data/dummy_data.dart';
import 'ui_helpers.dart';

class DonutChartCard extends StatefulWidget {
  final List<BudgetSegment> data;
  final void Function(BudgetSegment) onSegmentTapped;

  const DonutChartCard({
    super.key,
    required this.data,
    required this.onSegmentTapped,
  });

  @override
  State<DonutChartCard> createState() => _DonutChartCardState();
}

class _DonutChartCardState extends State<DonutChartCard> {
  int _touchedIndex = -1;

  BudgetSegment? get _selected =>
      _touchedIndex >= 0 ? widget.data[_touchedIndex] : null;

  @override
  Widget build(BuildContext context) {
    return cardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          cardHeader(
            title: 'Budget Allocation',
            subtitle: 'FY 2025  ·  Total \$8.0M',
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 156,
                height: 156,
                child: _donutChart(),
              ),
              const SizedBox(width: 20),
              Expanded(child: _legend()),
            ],
          ),
          const SizedBox(height: 16),
          cardHint('Tap a segment to see details'),
        ],
      ),
    );
  }

  Widget _donutChart() {
    final sel = _selected;
    return Stack(
      alignment: Alignment.center,
      children: [
        PieChart(
          PieChartData(
            pieTouchData: PieTouchData(
              touchCallback: (event, response) {
                if (!event.isInterestedForInteractions ||
                    response == null ||
                    response.touchedSection == null) {
                  setState(() => _touchedIndex = -1);
                  return;
                }
                final idx = response.touchedSection!.touchedSectionIndex;
                setState(() => _touchedIndex = idx);
                if (event is FlTapUpEvent) {
                  widget.onSegmentTapped(widget.data[idx]);
                }
              },
            ),
            centerSpaceRadius: 44,
            sectionsSpace: 2,
            sections: widget.data.asMap().entries.map((e) {
              final active = e.key == _touchedIndex;
              return PieChartSectionData(
                color: e.value.color,
                value: e.value.percentage,
                radius: active ? 60 : 52,
                showTitle: false,
              );
            }).toList(),
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: sel == null
              ? _centerLabel(
                  key: const ValueKey('total'),
                  top: '\$8.0M',
                  bottom: 'Total',
                  topColor: const Color(0xFF111827),
                )
              : _centerLabel(
                  key: ValueKey(sel.label),
                  top: '${sel.percentage.toInt()}%',
                  bottom: sel.label,
                  topColor: sel.color,
                ),
        ),
      ],
    );
  }

  Widget _centerLabel({
    required Key key,
    required String top,
    required String bottom,
    required Color topColor,
  }) {
    return Column(
      key: key,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          top,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: topColor,
            height: 1,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          bottom,
          style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
        ),
      ],
    );
  }

  Widget _legend() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.data.asMap().entries.map((e) {
        final isActive = e.key == _touchedIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            color: isActive
                ? e.value.color.withValues(alpha: 0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: e.value.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      e.value.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isActive
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: const Color(0xFF111827),
                      ),
                    ),
                    Text(
                      '${e.value.percentage.toInt()}%  ·  ${e.value.value}',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
