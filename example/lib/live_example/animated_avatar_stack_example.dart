import 'package:avatar_stack/animated_avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
import 'package:flutter/material.dart';

import 'animated_stack_base.dart';

class AnimatedAvatarStackExample extends AnimatedStackBase {
  const AnimatedAvatarStackExample({
    super.name = 'Default:',
    super.key,
    required this.stackedWidgets,
    required super.positions,
    super.infoItem,
    super.laying,
    super.layoutDirection,
    super.maxAmountItems,
  });

  final List<ImageProvider> stackedWidgets;

  @override
  Widget buildAnimatedStack({
    required double? height,
    required double? width,
    required Positions positions,
  }) {
    return AnimatedAvatarStack(
      height: height,
      width: width,
      settings: positions,
      avatars: stackedWidgets,
    );
  }
}
