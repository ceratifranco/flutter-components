import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          const SizedBox(height: 22),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Semantics(
                label: 'Budget allocation donut chart, total \$8.0M',
                container: true,
                child: SizedBox(
                  width: 160,
                  height: 160,
                  child: _donutChart(),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(child: _legend()),
            ],
          ),
          const SizedBox(height: 18),
          cardHint('Tap a segment to explore details'),
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
                  if (_touchedIndex != -1) {
                    setState(() => _touchedIndex = -1);
                  }
                  return;
                }
                final idx = response.touchedSection!.touchedSectionIndex;
                if (idx != _touchedIndex) {
                  HapticFeedback.selectionClick();
                  setState(() => _touchedIndex = idx);
                }
                if (event is FlTapUpEvent) {
                  HapticFeedback.lightImpact();
                  widget.onSegmentTapped(widget.data[idx]);
                }
              },
            ),
            centerSpaceRadius: 46,
            sectionsSpace: 2.5,
            sections: widget.data.asMap().entries.map((e) {
              final active = e.key == _touchedIndex;
              return PieChartSectionData(
                color: e.value.color,
                value: e.value.percentage,
                radius: active ? 62 : 54,
                showTitle: false,
              );
            }).toList(),
          ),
        ),
        // Direct conditional build (no AnimatedSwitcher) to avoid the
        // duplicate-key crash that fires during rapid hover events when an
        // outgoing child still animates while an incoming child reuses the
        // same ValueKey. The donut's own segment radius animation already
        // provides enough feedback.
        sel == null
            ? _centerLabel(
                top: '\$8.0M',
                bottom: 'Total',
                topColor: const Color(0xFF111827),
              )
            : _centerLabel(
                top: '${sel.percentage.toInt()}%',
                bottom: sel.label,
                topColor: sel.color,
              ),
      ],
    );
  }

  Widget _centerLabel({
    required String top,
    required String bottom,
    required Color topColor,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          top,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: topColor,
            letterSpacing: -0.5,
            height: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          bottom,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFFADB5BD),
            letterSpacing: 0.1,
          ),
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
        return Semantics(
          button: true,
          label:
              '${e.value.label}, ${e.value.percentage.toInt()}% of budget, ${e.value.value}',
          hint: 'Double tap to view details',
          child: GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              setState(() => _touchedIndex = isActive ? -1 : e.key);
              if (!isActive) widget.onSegmentTapped(e.value);
            },
            child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            margin: const EdgeInsets.only(bottom: 9),
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
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        e.value.label,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isActive
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: const Color(0xFF1E293B),
                          height: 1.2,
                        ),
                      ),
                      Text(
                        e.value.value,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFFADB5BD),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ),
        );
      }).toList(),
    );
  }
}
