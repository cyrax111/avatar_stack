import 'dart:ui';

import '../constants/max_int.dart'
    if (dart.library.io) '../constants/max_int_64.dart'
    if (dart.library.html) '../constants/max_int_32.dart';

/// Base interface for positions.
abstract class Positions {
  /// Set size of area items are needed to place in
  void setSize({required double width, required double height});

  /// Set full amount of items
  void setAmountItems(int amountItems);

  /// Calculate item positions
  List<ItemPosition> calculate();
}

/// ItemPosition consists coordinates, order
class ItemPosition {
  ItemPosition({
    required this.number,
    required this.offset,
    required this.size,
  });

  /// Ordinal number
  final int number;

  final Offset offset;
  final Size size;

  @override
  String toString() {
    return 'ItemPosition(number: $number, offset: $offset, size: $size)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ItemPosition &&
        other.number == number &&
        other.offset == offset &&
        other.size == size;
  }

  @override
  int get hashCode => number.hashCode ^ offset.hashCode ^ size.hashCode;
}

/// InfoItemPosition consists coordinates, order and information about
/// last (information) item
class InfoItemPosition extends ItemPosition {
  InfoItemPosition({
    required super.number,
    required this.amountAdditionalItems,
    required super.offset,
    required super.size,
  }) : assert(amountAdditionalItems != 0);

  InfoItemPosition.fromItemPosition({
    required this.amountAdditionalItems,
    required ItemPosition itemPosition,
    required super.size,
  }) : super(
          number: itemPosition.number,
          offset: itemPosition.offset,
        );

  /// Shows amount of additional (hidden) items.
  final int amountAdditionalItems;

  @override
  String toString() {
    return 'InfoItemPosition(number: $number, additionalItems: $amountAdditionalItems, offset: $offset, size: $size)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is InfoItemPosition &&
        other.amountAdditionalItems == amountAdditionalItems &&
        other.number == number &&
        other.offset == offset &&
        other.size == size;
  }

  @override
  int get hashCode =>
      number.hashCode ^ amountAdditionalItems.hashCode ^ offset.hashCode ^ size.hashCode;
}

/// Whether and how to align avatars horizontally.
enum StackAlign {
  /// Align the avatar stack on the left edge of the container.
  left,

  /// Align the avatar stack on the right edge of the container.
  right,

  /// Align the avatar stack in the center of the container.
  center,
}

/// The way to tile items.
class StackLaying {
  const StackLaying({
    required this.itemPositionNumberAtTop,
    this.infoItemAtTop = false,
  }) : assert(itemPositionNumberAtTop >= 0, 'itemPositionNumberAtTop must be positive');
  static const StackLaying first = StackLaying(
    itemPositionNumberAtTop: 0,
    infoItemAtTop: false,
  );
  static const StackLaying last = StackLaying(
    itemPositionNumberAtTop: maxInt,
    infoItemAtTop: true,
  );

  /// Which item position is at the top. Other items are at the bottom.
  final int itemPositionNumberAtTop;

  /// Defines wether an info item is at the top or at the bottom.
  final bool infoItemAtTop;
}

/// A direction of laying the items
enum LayoutDirection {
  /// Items laying in horizontal way
  horizontal,

  /// Items laying in vertical way
  vertical,
}

/// Info item
/// Usually has information about hidden items. Something like: (+5)
class InfoItem {
  const InfoItem({required this.indent, this.size});
  const InfoItem.absent()
      : indent = 0.0,
        size = null;

  /// The additional space between an info item (if exists) and other items.
  final double indent;

  /// Size of the info item
  /// If [size] is null the size match the regular item
  final double? size;
}
