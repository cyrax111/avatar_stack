import 'package:avatar_stack/positions.dart';
import 'package:flutter/material.dart';

abstract class AnimatedStackBase extends StatelessWidget {
  const AnimatedStackBase({
    this.name = 'Default:',
    super.key,
    required this.positions,
    this.infoItem,
    this.laying,
    this.layoutDirection,
    this.maxAmountItems,
  });

  final String name;
  final RestrictedPositions positions;
  final InfoItem? infoItem;
  final StackLaying? laying;
  final int? maxAmountItems;
  final LayoutDirection? layoutDirection;

  Widget buildAnimatedStack({
    required double? height,
    required double? width,
    required Positions positions,
  });

  @override
  Widget build(BuildContext context) {
    double? height = 50;
    double? width;
    if (layoutDirection == LayoutDirection.vertical) {
      height = null;
      width = 50;
    }
    RestrictedPositions settings = positions;
    if (infoItem != null) {
      settings = settings.copyWith(
        infoItem: infoItem,
      );
    }
    if (laying != null) {
      settings = settings.copyWith(laying: laying);
    }
    if (layoutDirection != null) {
      settings = settings.copyWith(layoutDirection: layoutDirection);
    }
    if (maxAmountItems != null) {
      settings = RestrictedAmountPositions(
        laying: settings.laying,
        minCoverage: settings.minCoverage,
        align: settings.align,
        layoutDirection: settings.layoutDirection,
        infoItem: settings.infoItem,
        maxCoverage: settings.maxCoverage,
        maxAmountItems: maxAmountItems!,
      );
    }

    final children = [
      layoutDirection == LayoutDirection.vertical
          ? RotatedBox(quarterTurns: 3, child: SelectableText(name))
          : SelectableText(name),
      const SizedBox(height: 10),
      SizedBox(
        height: height,
        width: width,
        child: buildAnimatedStack(height: height, width: width, positions: settings),
      ),
    ];

    final Widget widget;
    if (layoutDirection == LayoutDirection.vertical) {
      widget = Row(children: children);
    } else {
      widget = Column(children: children);
    }

    return widget;
  }
}
