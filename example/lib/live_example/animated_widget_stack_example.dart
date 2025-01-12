import 'package:avatar_stack/animated_avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
import 'package:flutter/material.dart';

import 'animated_stack_base.dart';

class AnimatedWidgetStackExample extends AnimatedStackBase {
  const AnimatedWidgetStackExample({
    super.name = 'Default:',
    super.key,
    required this.stackedWidgets,
    required super.positions,
    super.infoItem,
    super.laying,
    super.layoutDirection,
    super.maxAmountItems,
  });

  final List<Widget> stackedWidgets;

  @override
  Widget buildAnimatedStack({
    required double? height,
    required double? width,
    required Positions positions,
  }) {
    return SizedBox(
      height: height,
      width: width,
      child: AnimatedWidgetStack(
        positions: positions,
        widgetChangeBuilder: (context, action, constraints) {
          return WidgetWithParameters(
            widget: DefaultAnimatedAction(
              key: action.key,
              action: action,
              size: constraints.biggest,
              infoWidgetBuilder: (surplus, context) {
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.lightBlueAccent,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      '+$surplus',
                      style: const TextStyle(height: 0.9, color: Colors.black),
                    ),
                  ),
                );
              },
            ),
          );
        },
        stackedWidgets: stackedWidgets,
      ),
    );
  }
}
