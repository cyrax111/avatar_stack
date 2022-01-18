abstract class Positions {
  void setSize({required double width, required double height});
  void setAmountItems(int amountItems);
  List<ItemPosition> calculate();
}

class ItemPosition {
  ItemPosition({
    required this.number,
    required this.position,
    this.isInformationalItem = false,
    this.amountAdditionalItems = 0,
  }) : assert(isInformationalItem && amountAdditionalItems != 0 ||
            !isInformationalItem && amountAdditionalItems == 0);
  final int number;
  final double position;
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
