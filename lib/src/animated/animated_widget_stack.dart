import 'package:flutter/material.dart' hide Action;

import '../positions/positions.dart';
import 'changes.dart';
import 'conveyor.dart';
import 'key_widget_list.dart';

/// Draws widgets stack. Can use any widgets. Calls [widgetChangeBuilder] builder
/// to create animated widget and show a transition between old and current [stackedWidgets].
/// Each widget of [stackedWidgets] should contain an unique key.
///
///
/// Example:
///
/// ```dart
/// class Example extends StatefulWidget {
///   const Example({super.key});
///
///   @override
///   State<AnimatedExample1Default> createState() => _AnimatedExample1DefaultState();
/// }
///
/// class _AnimatedExample1DefaultState extends State<AnimatedExample1Default> {
///   late List<Widget> _stackedWidgets =
///       List.generate(5, (index) => index).map((index) => _generateAvatar(index)).toList();
///
///   Widget _generateAvatar(int index) => BorderedCircleAvatar(
///         key: _generateKey(index),
///         border: const BorderSide(color: Colors.orange, width: 2.0),
///         backgroundImage: NetworkImage(getAvatarUrl(index)),
///         constraints: const BoxConstraints.expand(),
///       );
///
///   Key _generateKey(int index) => Key('BCA_$index');
///
///   Widget _infoItemBuilder(int surplus, BuildContext context) => BorderedCircleAvatar(
///         constraints: const BoxConstraints.expand(),
///         child: Center(child: Text('+$surplus')),
///       );
///
///   @override
///   Widget build(BuildContext context) {
///     return SizedBox(
///       height: 50,
///       child: AnimatedWidgetStack(
///         positions: RestrictedPositions(maxCoverage: 0.5, minCoverage: 0.3),
///         stackedWidgets: _stackedWidgets,
///         widgetChangeBuilder: (context, action, constraints) {
///           return WidgetWithParameters(
///             widget: DefaultAnimatedAction(
///               key: action.key,
///               action: action,
///               size: constraints.biggest,
///               infoWidgetBuilder: _infoItemBuilder,
///             ),
///           );
///         },
///       ),
///     );
///   }
/// }
/// ```
class AnimatedWidgetStack extends StatefulWidget {
  const AnimatedWidgetStack({
    required this.positions,
    required this.stackedWidgets,
    required this.widgetChangeBuilder,
    super.key,
  });

  /// List of any widgets to draw
  /// Every widget should contain an unique key
  final List<Widget> stackedWidgets;

  /// Algorithm of calculating positions
  final Positions positions;

  /// Animated transition builder
  final WidgetChangeBuilder widgetChangeBuilder;

  @override
  State<AnimatedWidgetStack> createState() => _AnimatedWidgetStackState();
}

class _AnimatedWidgetStackState extends State<AnimatedWidgetStack> {
  late Changes _changes;
  late Conveyor _conveyor;

  @override
  void initState() {
    super.initState();

    _changes = Changes.init(widgets: KeyWidgetList.fromList(widgets: widget.stackedWidgets));
    _conveyor = Conveyor.init(changes: _changes);
  }

  @override
  void didUpdateWidget(covariant AnimatedWidgetStack oldWidget) {
    super.didUpdateWidget(oldWidget);

    _changes = Changes.compareWidgetLists(
      oldStackedWidgets: KeyWidgetList.fromList(widgets: oldWidget.stackedWidgets),
      newStackedWidgets: KeyWidgetList.fromList(widgets: widget.stackedWidgets),
    );

    _conveyor = _conveyor.copyWith(changes: _changes);
  }

  @override
  Widget build(BuildContext context) {
    widget.positions.setAmountItems(widget.stackedWidgets.length);
    return LayoutBuilder(builder: (context, BoxConstraints constraints) {
      final isNotEnoughSpace = constraints.maxWidth <= 0 || constraints.maxHeight <= 0;
      if (isNotEnoughSpace) {
        return const SizedBox.shrink();
      }

      widget.positions.setSize(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
      );

      final calculated = widget.positions.calculate();

      final calculatedMap = _toCalculatedMap(calculated);

      final animatedWidgets = _buildAnimatedWidgets(calculatedMap, context, constraints);

      return Stack(
        clipBehavior: Clip.none,
        children: animatedWidgets.toList(),
      );
    });
  }

  Iterable<Widget> _buildAnimatedWidgets(
      Map<int, IndexItemPosition> calculatedMap, BuildContext context, BoxConstraints constraints) {
    final actions = _conveyor.boxes.keys.map(
      (key) {
        final box = _conveyor.boxes[key]!;
        final Action action;
        switch (box.actionType) {
          case ActionType.none:
            final indexItemPosition = _getItemPositionFrom(box.number!, calculatedMap);
            action = Action(
              key: key,
              type: box.actionType,
              stackedWidget: box.widget,
              itemPosition: indexItemPosition.itemPosition,
              order: indexItemPosition.index,
            );
          case ActionType.added:
            final indexItemPosition = _getItemPositionFrom(box.number!, calculatedMap);
            action = Action(
              key: key,
              type: box.actionType,
              stackedWidget: box.widget,
              itemPosition: indexItemPosition.itemPosition,
              order: indexItemPosition.index,
            );
          case ActionType.removed:
            action = Action(
              key: key,
              type: box.actionType,
              stackedWidget: box.widget,
              itemPosition: RemovedPosition(),
              order: -1,
            );
          case ActionType.changedPosition:
            final indexItemPosition = _getItemPositionFrom(box.number!, calculatedMap);
            final indexItemPositionOld = _getItemPositionFrom(box.oldNumber!, calculatedMap);
            action = ChangedPositionAction(
              key: key,
              type: box.actionType,
              stackedWidget: box.widget,
              oldItemPosition: indexItemPositionOld.itemPosition,
              itemPosition: indexItemPosition.itemPosition,
              order: indexItemPosition.index,
            );
        }
        return action;
      },
    );

    final sortedAction = actions.toList()..sort((a, b) => a.order.compareTo(b.order));

    final children = sortedAction
        .map((action) => widget.widgetChangeBuilder(context, action, constraints).widget);
    return children;
  }

  /// Convert list to map
  Map<int, IndexItemPosition> _toCalculatedMap(List<ItemPosition> calculated) {
    final calculatedMap = <int, IndexItemPosition>{};
    for (var i = 0; i < calculated.length; i++) {
      final itemPosition = calculated[i];
      calculatedMap[itemPosition.number] = IndexItemPosition(
        index: i,
        itemPosition: itemPosition,
      );
    }
    return calculatedMap;
  }

  IndexItemPosition _getItemPositionFrom(
      int number, Map<int, IndexItemPosition> calculatedItemPositions) {
    final indexItemPosition = calculatedItemPositions[number];
    final isHiddenItem = indexItemPosition == null;
    if (isHiddenItem) {
      return IndexItemPosition(index: -1, itemPosition: HiddenItemPosition(number: number));
    } else {
      return indexItemPosition;
    }
  }
}

/// Keeps [index] and [itemPosition] together
class IndexItemPosition {
  IndexItemPosition({required this.index, required this.itemPosition});
  final Index index;
  final ItemPosition itemPosition;
}

/// Information for building animated widget
class Action {
  Action({
    required this.key,
    required this.type,
    required this.stackedWidget,
    required this.itemPosition,
    required this.order,
  });

  /// The unique key extracted from [stackedWidget]
  final Key key;

  /// The widget that the animation is applied to
  final Widget stackedWidget;

  /// An [type] that shows has what happened to the [stackedWidget]
  /// since the last [stackedWidgets] change
  final ActionType type;

  /// Dakar coordinates of a new [stackedWidget] position
  final ItemPosition itemPosition;

  /// If [stackedWidgets] are overlapped each other it's important to layout in certain order
  final int order;
}

/// Information for building animated widget with [oldItemPosition]
class ChangedPositionAction extends Action {
  ChangedPositionAction({
    required super.key,
    required super.type,
    required super.stackedWidget,
    required super.itemPosition,
    required this.oldItemPosition,
    required super.order,
  });
  final ItemPosition oldItemPosition;
}

/// Shows what happened to a built widget from last built
enum ActionType {
  none,
  added,
  changedPosition,
  removed;
}

typedef WidgetChangeBuilder = WidgetWithParameters Function(
    BuildContext context, Action action, BoxConstraints constraints);

/// Contains built widget and reserved parameters
class WidgetWithParameters {
  WidgetWithParameters({required this.widget});
  final Widget widget;
}

/// The position of item which is not seen - hidden with info item
class HiddenItemPosition extends ItemPosition {
  HiddenItemPosition({required super.number}) : super(offset: Offset.zero, size: Size.zero);

  @override
  String toString() {
    return 'HiddenItemPosition(number: $number)';
  }
}

/// The position of item which is not exist in the list at all
class RemovedPosition extends ItemPosition {
  RemovedPosition() : super(offset: Offset.zero, size: Size.zero, number: -1);

  @override
  String toString() {
    return 'RemovedPosition()';
  }
}
