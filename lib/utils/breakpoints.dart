import 'package:flutter/widgets.dart';

/// Material-style breakpoints used by the dashboard layout.
///
/// - **Mobile**: < 600pt — single column, full-width cards
/// - **Tablet**: 600pt – 1024pt — two-column row (donut + bar side by side)
/// - **Desktop**: ≥ 1024pt — same two-column row, capped at 1200pt and centered
class Breakpoints {
  Breakpoints._();

  /// Below this width the layout collapses to a single column. Bumped from
  /// 600 → 720 because the donut card needs ≥ 720pt total to fit the donut +
  /// legend side by side without truncating segment names.
  static const double mobileMax = 720;
  static const double tabletMax = 1024;
  static const double desktopMaxContentWidth = 1200;
}

bool isMobile(BuildContext context) =>
    MediaQuery.sizeOf(context).width < Breakpoints.mobileMax;

bool isTablet(BuildContext context) {
  final w = MediaQuery.sizeOf(context).width;
  return w >= Breakpoints.mobileMax && w < Breakpoints.tabletMax;
}

bool isDesktop(BuildContext context) =>
    MediaQuery.sizeOf(context).width >= Breakpoints.tabletMax;

/// Padding horizontal escalado por breakpoint (16 / 24 / 32).
double scaledHorizontalPadding(BuildContext context) {
  if (isDesktop(context)) return 32;
  if (isTablet(context)) return 24;
  return 16;
}

/// Padding del header escalado por breakpoint (20 / 32 / 48).
double scaledHeaderPadding(BuildContext context) {
  if (isDesktop(context)) return 48;
  if (isTablet(context)) return 32;
  return 20;
}
