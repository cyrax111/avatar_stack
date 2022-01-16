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
