import 'package:flutter/material.dart';

import 'positions/positions.dart';

typedef InfoWidgetBuilder = Widget Function(int surplus);

/// Draws widgets stack. Can use any widgets.
class WidgetStack extends StatelessWidget {
  const WidgetStack({
    required this.positions,
    required this.stackedWidgets,
    required this.buildInfoWidget,
    Key? key,
  }) : super(key: key);

  /// List of any widgets to draw
  final List<Widget> stackedWidgets;

  /// Algorithm of calculating positions
  final Positions positions;

  /// Callback for drawing information of hidden widgets. Something like: (+5)
  final InfoWidgetBuilder buildInfoWidget;

  @override
  Widget build(BuildContext context) {
    positions.setAmountItems(stackedWidgets.length);
    return LayoutBuilder(builder: (context, BoxConstraints constraints) {
      positions.setSize(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
      );

      return Stack(
        children: positions.calculate().map((position) {
          return Positioned(
            left: position.position,
            child: SizedBox(
              height: constraints.maxHeight,
              width: constraints.maxHeight,
              child: _buildStackedWidgetOrInfoWidget(position: position),
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _buildStackedWidgetOrInfoWidget({
    required ItemPosition position,
  }) {
    if (position.isInformationalItem) {
      return buildInfoWidget(position.amountAdditionalItems);
    } else {
      return stackedWidgets[position.number];
    }
  }
}
