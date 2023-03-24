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
    @Deprecated('"position" is deprecated and will be removed after v2.0.0, use "x" and "y" instead')
        double? position,
    required this.x,
    required this.y,
    required this.size,
  }) : position = position ?? 0;

  /// Ordinal number
  final int number;

  /// Coordinate
  @Deprecated(
      '"position" is deprecated and will be removed after v2.0.0, use "x" and "y" instead')
  final double position;

  final double x;
  final double y;
  final double size;

  @override
  String toString() {
    return 'ItemPosition(number: $number, position: $position, x: $x, y: $y, size: $size)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ItemPosition &&
        other.number == number &&
        other.position == position &&
        other.x == x &&
        other.y == y &&
        other.size == size;
  }

  @override
  int get hashCode =>
      number.hashCode ^
      position.hashCode ^
      x.hashCode ^
      y.hashCode ^
      size.hashCode;
}

/// InfoItemPosition consists coordinates, order and information about
/// last (information) item
class InfoItemPosition extends ItemPosition {
  InfoItemPosition({
    required super.number,
    @Deprecated('"position" is deprecated and will be removed after v2.0.0, use "x" and "y" instead')
        double? position,
    required this.amountAdditionalItems,
    required super.x,
    required super.y,
    required super.size,
  })  : assert(amountAdditionalItems != 0),
        super(position: position);

  InfoItemPosition.fromItemPosition({
    required this.amountAdditionalItems,
    required ItemPosition itemPosition,
  }) : super(
          number: itemPosition.number,
          size: itemPosition.size,
          x: itemPosition.x,
          y: itemPosition.y,
        );

  /// Shows amount of additional (hidden) items.
  final int amountAdditionalItems;

  @override
  String toString() {
    return 'InfoItemPosition(number: $number, position: $position, additionalItems: $amountAdditionalItems, x: $x, y: $y, size: $size)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is InfoItemPosition &&
        other.amountAdditionalItems == amountAdditionalItems &&
        other.number == number &&
        other.position == position &&
        other.x == x &&
        other.y == y &&
        other.size == size;
  }

  @override
  int get hashCode =>
      number.hashCode ^
      position.hashCode ^
      amountAdditionalItems.hashCode ^
      x.hashCode ^
      y.hashCode ^
      size.hashCode;
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

/// A direction of laying the items
enum LayoutDirection {
  /// Items laying in horizontal way
  horizontal,

  /// Items laying in vertical way
  vertical,
}
