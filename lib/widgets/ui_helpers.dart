import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/dummy_data.dart';

// ─── Card shell ─────────────────────────────────────────────────────────────

Widget cardWrapper({required Widget child}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF1B2B4B).withValues(alpha: 0.05),
          blurRadius: 20,
          spreadRadius: 0,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: const Color(0xFF1B2B4B).withValues(alpha: 0.03),
          blurRadius: 6,
          spreadRadius: 0,
          offset: const Offset(0, 1),
        ),
      ],
    ),
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
    child: child,
  );
}

Widget cardHeader({required String title, required String subtitle}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Color(0xFF111827),
          letterSpacing: -0.3,
          height: 1.1,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFFADB5BD),
          letterSpacing: 0.1,
        ),
      ),
    ],
  );
}

Widget cardHint(String text) {
  return Row(
    children: [
      const Icon(
        Icons.touch_app_rounded,
        size: 11,
        color: Color(0xFFCBD5E1),
      ),
      const SizedBox(width: 5),
      Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xFFCBD5E1),
          letterSpacing: 0.1,
        ),
      ),
    ],
  );
}

// ─── Sheet helpers ───────────────────────────────────────────────────────────

Widget sheetHandle() {
  return Center(
    child: Container(
      margin: const EdgeInsets.only(top: 14, bottom: 22),
      width: 36,
      height: 4,
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(2),
      ),
    ),
  );
}

Widget sheetChip(String label, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.10),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      label,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: color,
        letterSpacing: 0.2,
      ),
    ),
  );
}

Widget sheetStat(String value, String label, Color color) {
  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: color,
            letterSpacing: -0.3,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFFADB5BD),
            letterSpacing: 0.1,
          ),
        ),
      ],
    ),
  );
}

Widget sheetDivider() {
  return const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9));
}

Widget sheetSectionLabel(String text) {
  return Text(
    text,
    style: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: Color(0xFF1E293B),
      letterSpacing: -0.2,
    ),
  );
}

Widget sheetProgressBar(double value, Color fillColor) {
  return LayoutBuilder(builder: (context, constraints) {
    final trackWidth = constraints.maxWidth;
    final clampedValue = value.clamp(0.0, 1.0);
    final fillWidth = trackWidth * clampedValue;
    const trackHeight = 7.0;
    const thumbDiameter = 18.0;
    const totalHeight = 24.0;
    const verticalOffset = (totalHeight - trackHeight) / 2;
    const thumbOffset = (totalHeight - thumbDiameter) / 2;

    return SizedBox(
      height: totalHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Track background
          Positioned(
            top: verticalOffset,
            left: 0,
            right: 0,
            child: Container(
              height: trackHeight,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(trackHeight / 2),
              ),
            ),
          ),
          // Fill
          Positioned(
            top: verticalOffset,
            left: 0,
            child: Container(
              height: trackHeight,
              width: fillWidth,
              decoration: BoxDecoration(
                color: fillColor,
                borderRadius: BorderRadius.circular(trackHeight / 2),
              ),
            ),
          ),
          // Thumb
          Positioned(
            top: thumbOffset,
            left: (fillWidth - thumbDiameter / 2).clamp(0, trackWidth - thumbDiameter),
            child: Container(
              width: thumbDiameter,
              height: thumbDiameter,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: fillColor, width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: fillColor.withValues(alpha: 0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  });
}

Widget sheetCta(BuildContext context, String label) {
  return SizedBox(
    width: double.infinity,
    child: FilledButton(
      onPressed: () {
        HapticFeedback.lightImpact();
        Navigator.pop(context);
      },
      style: FilledButton.styleFrom(
        backgroundColor: kNavy,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 17),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.arrow_forward_rounded, size: 18),
        ],
      ),
    ),
  );
}
