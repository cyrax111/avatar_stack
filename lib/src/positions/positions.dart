abstract class Positions {
  /// Set size of area items are need to place in
  void setSize({required double width, required double height});

  /// Set full amount of items
  void setAmountItems(int amountItems);

  /// Calculate item positions
  List<ItemPosition> calculate();
}

/// ItemPosition consists coordinates, order and information about
/// last (information) item
class ItemPosition {
  ItemPosition({
    required this.number,
    required this.position,
    this.isInformationalItem = false,
    this.amountAdditionalItems = 0,
  }) : assert(isInformationalItem && amountAdditionalItems != 0 ||
            !isInformationalItem && amountAdditionalItems == 0);

  /// Ordinal number
  final int number;

  /// Coordinate
  final double position;

  /// Is the item last (information) which shows amount of additional (hidden)
  /// items
  final bool isInformationalItem;
  final int amountAdditionalItems;
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
