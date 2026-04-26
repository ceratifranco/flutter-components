import 'package:flutter/material.dart';
import 'ui_helpers.dart';

/// Animated shimmer block — base unit for placeholder skeletons.
///
/// A single [AnimationController] (1500 ms loop) drives a translating
/// gradient. Callers compose multiple `_Shimmer`s inside a [cardWrapper]
/// to mirror the layout of the loaded state, eliminating layout shift.
class _Shimmer extends StatefulWidget {
  final double width;
  final double height;

  const _Shimmer({
    required this.width,
    required this.height,
  });

  @override
  State<_Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<_Shimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, _) {
        // Slide gradient from -1.5 → +1.5 in alignment space.
        final dx = -1.5 + _ctrl.value * 3.0;
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              begin: Alignment(dx - 0.3, 0),
              end: Alignment(dx + 0.3, 0),
              colors: const [
                Color(0xFFEFF2F7),
                Color(0xFFF8FAFC),
                Color(0xFFEFF2F7),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}

// ─── Donut card skeleton ─────────────────────────────────────────────────────

class DonutCardSkeleton extends StatelessWidget {
  const DonutCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return cardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Shimmer(width: 160, height: 16),
          const SizedBox(height: 8),
          const _Shimmer(width: 120, height: 12),
          const SizedBox(height: 22),
          Row(
            children: [
              SizedBox(
                width: 160,
                height: 160,
                child: Center(
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEFF2F7),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        width: 92,
                        height: 92,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    4,
                    (_) => const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: _Shimmer(width: 110, height: 22),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const _Shimmer(width: 180, height: 11),
        ],
      ),
    );
  }
}

// ─── Bar card skeleton ───────────────────────────────────────────────────────

class BarCardSkeleton extends StatelessWidget {
  const BarCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return cardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Shimmer(width: 160, height: 16),
          const SizedBox(height: 8),
          const _Shimmer(width: 160, height: 12),
          const SizedBox(height: 22),
          SizedBox(
            height: 176,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                _Shimmer(width: 22, height: 90),
                _Shimmer(width: 22, height: 130),
                _Shimmer(width: 22, height: 70),
                _Shimmer(width: 22, height: 150),
                _Shimmer(width: 22, height: 120),
                _Shimmer(width: 22, height: 105),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const _Shimmer(width: 160, height: 11),
        ],
      ),
    );
  }
}
