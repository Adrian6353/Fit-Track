import 'package:flutter/material.dart';
import '../theme/app_breakpoints.dart';

enum DeviceType { compact, medium, expanded }

class ResponsiveInfo {
  final BuildContext context;

  const ResponsiveInfo(this.context);

  double get width => MediaQuery.sizeOf(context).width;

  DeviceType get deviceType {
    if (width < AppBreakpoints.compact) return DeviceType.compact;
    if (width < AppBreakpoints.medium) return DeviceType.medium;
    return DeviceType.expanded;
  }

  bool get isCompact => deviceType == DeviceType.compact;
  bool get isTablet => deviceType == DeviceType.medium;
  bool get isDesktop => deviceType == DeviceType.expanded;
}

class AdaptiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const AdaptiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= AppBreakpoints.expanded && desktop != null) {
      return desktop!;
    }
    if (width >= AppBreakpoints.compact && tablet != null) {
      return tablet!;
    }
    return mobile;
  }
}

int getResponsiveColumns(double width) {
  if (width >= AppBreakpoints.expanded) return 4;
  if (width >= AppBreakpoints.medium) return 3;
  if (width >= AppBreakpoints.compact) return 2;
  return 1;
}
