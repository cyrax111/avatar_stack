import 'dart:collection';
import 'dart:math';

import 'package:flutter/widgets.dart';

/// Represents Map(Key, IndexWidget) keyWidget with extra functionality
class KeyWidgetList {
  /// Transfers List [widgets] into the map
  factory KeyWidgetList.fromList({required List<Widget> widgets}) {
    final keyWidgets = <Key, IndexWidget>{};
    for (var i = 0; i < widgets.length; i++) {
      final widget = widgets[i];
      final key = widget.key;
      assert(key != null, '''The key should be set for a widget.
      
Every widget of stackedWidgets of AnimatedWidgetStack should have an unique key.
      ''');
      assert(!keyWidgets.keys.contains(key), '''The key($key) already exists.
      
Every widget of stackedWidgets of AnimatedWidgetStack should have an unique key.     
      ''');
      final positiveKey = key ?? UniqueKey();
      keyWidgets[positiveKey] = IndexWidget(i, widget);
    }
    return KeyWidgetList(keyWidgets: keyWidgets);
  }
  const KeyWidgetList.empty()
      : keyWidgets = const {},
        _keys = const {};

  /// Creates a new [KeyWidgetList] with the elements of this that are not in [other].
  KeyWidgetList operator -(KeyWidgetList other) {
    final difference = _keys.difference(other._keys);
    return KeyWidgetList(
      keyWidgets: Map.fromEntries(difference.map(
        (key) => MapEntry(key, keyWidgets[key]!),
      )),
    );
  }

  /// Creates a new [KeyWidgetList] with the elements of this that has the same [IndexWidget]
  /// in the same  [other].
  KeyWidgetList positionIntersection(KeyWidgetList other) {
    final intersection = <Key, IndexWidget>{};
    final keys = keyWidgets.keys.toList();
    final otherKeys = other.keyWidgets.keys.toList();
    int minLength = min(keys.length, otherKeys.length);
    for (int i = 0; i < minLength; i++) {
      final currentKey = keys[i];
      if (currentKey == otherKeys[i]) {
        intersection[currentKey] = keyWidgets[currentKey]!;
      }
    }
    return KeyWidgetList(keyWidgets: intersection);
  }

  /// Returns [IndexWidget] value by key
  IndexWidget? operator [](Key key) => keyWidgets[key];

  @override
  String toString() => keyWidgets.toString();

  KeyWidgetList({
    required Map<Key, IndexWidget> keyWidgets,
  })  : keyWidgets = UnmodifiableMapView(keyWidgets),
        _keys = keyWidgets.keys.toSet();
  final Map<Key, IndexWidget> keyWidgets;
  final Set<Key> _keys;
}

/// Keeps [index] and [widget] together
class IndexWidget {
  const IndexWidget(this.index, this.widget);
  final Index index;
  final Widget widget;
}

typedef Index = int;
