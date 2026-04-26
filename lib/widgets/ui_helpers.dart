import 'package:flutter/material.dart';
import '../data/dummy_data.dart';

// ─── Card shell ─────────────────────────────────────────────────────────────

Widget cardWrapper({required Widget child}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: kNavy.withValues(alpha: 0.06),
          blurRadius: 12,
          offset: const Offset(0, 2),
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
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Color(0xFF111827),
          letterSpacing: -0.2,
        ),
      ),
      const SizedBox(height: 3),
      Text(
        subtitle,
        style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
      ),
    ],
  );
}

Widget cardHint(String text) {
  return Row(
    children: [
      const Icon(Icons.touch_app_rounded, size: 12, color: Color(0xFFD1D5DB)),
      const SizedBox(width: 4),
      Text(
        text,
        style: const TextStyle(fontSize: 11, color: Color(0xFFD1D5DB)),
      ),
    ],
  );
}

// ─── Sheet helpers ───────────────────────────────────────────────────────────

Widget sheetHandle() {
  return Center(
    child: Container(
      margin: const EdgeInsets.only(top: 12, bottom: 20),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(2),
      ),
    ),
  );
}

Widget sheetChip(String label, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.10),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      label,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: color,
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
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
        ),
      ],
    ),
  );
}

Widget sheetDivider() {
  return const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6));
}

Widget sheetSectionLabel(String text) {
  return Text(
    text,
    style: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: Color(0xFF374151),
    ),
  );
}

Widget sheetProgressBar(double value, Color color) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(4),
    child: LinearProgressIndicator(
      value: value,
      backgroundColor: const Color(0xFFF3F4F6),
      color: color,
      minHeight: 7,
    ),
  );
}

Widget sheetCta(BuildContext context, String label) {
  return SizedBox(
    width: double.infinity,
    child: FilledButton(
      onPressed: () => Navigator.pop(context),
      style: FilledButton.styleFrom(
        backgroundColor: kNavy,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
      ),
    ),
  );
}
