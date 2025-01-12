import 'dart:collection';

import 'package:flutter/material.dart';

import 'animated_widget_stack.dart';
import 'changes.dart';
import 'key_widget_list.dart';

/// Constantly keeps values all time. If the value was added, removed or moved it will be here
/// all the time.
class Conveyor {
  factory Conveyor.init({required Changes changes}) {
    return Conveyor._(boxes: Map.fromEntries(
      changes.didntChange.keyWidgets.keys.map((key) {
        final indexWidget = changes.didntChange[key]!;
        return MapEntry(
            key,
            ConveyorBox(
              actionType: ActionType.none,
              number: indexWidget.index,
              oldNumber: indexWidget.index,
              widget: indexWidget.widget,
            ));
      }),
    ));
  }

  /// Updates position and actionType according new [changes].
  Conveyor copyWith({required Changes changes}) {
    final newBoxes = Map.of(boxes);
    final existedBeforeButAddedAgain = <Key, IndexWidget>{};
    for (final key in newBoxes.keys) {
      final isNotChanged = changes.didntChange[key] != null;
      if (isNotChanged) {
        continue;
      }

      final box = newBoxes[key]!;

      final removed = changes.removed[key];
      if (removed != null) {
        newBoxes[key] = box.copyWith(
          actionType: ActionType.removed,
          oldNumber: () => box.number,
          number: () => null,
        );
        continue;
      }

      final moved = changes.moved[key];
      if (moved != null) {
        newBoxes[key] = box.copyWith(
          actionType: ActionType.changedPosition,
          oldNumber: () => box.number,
          number: () => moved.index,
        );
        continue;
      }

      // Existed before but added again
      final added = changes.added[key];
      if (added != null) {
        newBoxes[key] = box.copyWith(
          actionType: ActionType.added,
          oldNumber: () => null,
          number: () => changes.added[key]?.index,
        );
        existedBeforeButAddedAgain[key] = added;
        continue;
      }
    }

    final neverExistedBeforeButAddedAgain =
        changes.added - KeyWidgetList(keyWidgets: existedBeforeButAddedAgain);
    newBoxes.addEntries(
      neverExistedBeforeButAddedAgain.keyWidgets.keys.map((key) {
        final indexWidget = neverExistedBeforeButAddedAgain[key]!;
        return MapEntry(
            key,
            ConveyorBox(
              actionType: ActionType.added,
              number: indexWidget.index,
              oldNumber: null,
              widget: indexWidget.widget,
            ));
      }),
    );

    return Conveyor._(boxes: newBoxes);
  }

  final Map<Key, ConveyorBox> boxes;

  Conveyor._({required Map<Key, ConveyorBox> boxes}) : boxes = UnmodifiableMapView(boxes);
}

/// Keeps current [actionType], new position [number], old position [oldNumber] and [widget].
class ConveyorBox {
  ConveyorBox({
    required this.oldNumber,
    required this.number,
    required this.widget,
    required this.actionType,
  })  : assert(oldNumber != null || number != null),
        assert(actionType == ActionType.none && number != null ||
            actionType == ActionType.added && number != null ||
            actionType == ActionType.removed && oldNumber != null ||
            actionType == ActionType.changedPosition && number != null && oldNumber != null);

  final Widget widget;
  final int? oldNumber;
  final int? number;
  final ActionType actionType;

  ConveyorBox copyWith({
    int? Function()? number,
    int? Function()? oldNumber,
    ActionType? actionType,
  }) {
    return ConveyorBox(
      number: number == null ? this.number : number(),
      oldNumber: oldNumber == null ? this.oldNumber : oldNumber(),
      actionType: actionType ?? this.actionType,
      widget: widget,
    );
  }
}
