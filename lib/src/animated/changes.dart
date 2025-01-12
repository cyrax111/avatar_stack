import 'key_widget_list.dart';

/// Defines differences between two [KeyWidgetList] lists.
class Changes {
  /// Added items. Items that are not into [oldStackedWidgets] but in [newStackedWidgets].
  final KeyWidgetList added;

  /// Removed items. Items that are not into [newStackedWidgets] but in [oldStackedWidgets].
  final KeyWidgetList removed;

  /// Moved items. Items that are into [newStackedWidgets] and in [oldStackedWidgets] but are
  /// changed their positions.
  final KeyWidgetList moved;

  /// Not changed items. Items that are into [newStackedWidgets] and in [oldStackedWidgets] and
  /// have the same positions.
  final KeyWidgetList didntChange;

  const Changes({
    this.added = const KeyWidgetList.empty(),
    this.removed = const KeyWidgetList.empty(),
    this.moved = const KeyWidgetList.empty(),
    this.didntChange = const KeyWidgetList.empty(),
  });

  const Changes.init({
    required KeyWidgetList widgets,
  })  : added = const KeyWidgetList.empty(),
        removed = const KeyWidgetList.empty(),
        moved = const KeyWidgetList.empty(),
        didntChange = widgets;

  /// Compares to [KeyWidgetList] and defines [added], [removed], [moved] and [didntChange] lists.
  factory Changes.compareWidgetLists(
      {required KeyWidgetList oldStackedWidgets, required KeyWidgetList newStackedWidgets}) {
    // 1. Widgets that didn't change their positions
    final didntChangePositions = oldStackedWidgets.positionIntersection(newStackedWidgets);

    // 2. Removed. Widgets are in stackedWidgets1 but not in stackedWidgets2
    final inOldNotInNew = oldStackedWidgets - newStackedWidgets;

    // 3. Added. Widgets in stackedWidgets2 but not in stackedWidgets1
    final inNewNotInOld = newStackedWidgets - oldStackedWidgets;

    // 4. Widgets that changed their positions
    final changedPositions =
        newStackedWidgets - inOldNotInNew - inNewNotInOld - didntChangePositions;

    return Changes(
      added: inNewNotInOld,
      removed: inOldNotInNew,
      moved: changedPositions,
      didntChange: didntChangePositions,
    );
  }

  @override
  String toString() => '''
  Changes(
    added: $added,
    removed: $removed,
    moved: $moved,
    didntChange: $didntChange,
  )
  ''';
}
