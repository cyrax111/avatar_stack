import '../constants/max_int.dart'
    if (dart.library.io) '../constants/max_int_64.dart'
    if (dart.library.html) '../constants/max_int_32.dart';

/// Base interface for positions.
abstract class Positions {
  /// Set size of area items are need to place in
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
    required this.position,
  });

  /// Ordinal number
  final int number;

  /// Coordinate
  final double position;

  @override
  String toString() {
    return 'ItemPosition(number: $number, position: $position)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ItemPosition &&
        other.number == number &&
        other.position == position;
  }

  @override
  int get hashCode => number.hashCode ^ position.hashCode;
}

/// InfoItemPosition consists coordinates, order and information about
/// last (information) item
class InfoItemPosition extends ItemPosition {
  InfoItemPosition({
    required int number,
    required double position,
    required this.amountAdditionalItems,
  })  : assert(amountAdditionalItems != 0),
        super(number: number, position: position);

  /// Shows amount of additional (hidden) items.
  final int amountAdditionalItems;

  @override
  String toString() {
    return 'InfoItemPosition(number: $number, position: $position, additionalItems: $amountAdditionalItems)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is InfoItemPosition &&
        other.amountAdditionalItems == amountAdditionalItems &&
        other.number == number &&
        other.position == position;
  }

  @override
  int get hashCode =>
      number.hashCode ^ position.hashCode ^ amountAdditionalItems.hashCode;
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
  }) : assert(itemPositionNumberAtTop >= 0,
            'itemPositionNumberAtTop must be positive');
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
