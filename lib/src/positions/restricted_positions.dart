import 'positions.dart';

class RestrictedPositions implements Positions {
  RestrictedPositions({
    this.maxCoverage = 0.8,
    this.minCoverage,
  });

  late double _width;
  late double _height;
  final double? minCoverage;
  final double? maxCoverage;
  late final int amountElements;

  @override
  List<ItemPosition> calculate() {
    final spaceBetweenItems = _calculateSpaceBetweenItems();
    final offsetStep = _calculateOffsetStep(spaceBetweenItems);
    return _generatePositions(offsetStep);
  }

  double _calculateSpaceBetweenItems() {
    if (amountElements < 2) {
      return 0;
    }
    return (_width - _itemSize * amountElements) / (amountElements - 1);
  }

  double _calculateOffsetStep(double spaceBetweenItems) {
    final calculatedCoveragePercent = -spaceBetweenItems / _itemSize;

    final isMaxCoverageSet = maxCoverage != null;
    if (isMaxCoverageSet && calculatedCoveragePercent > maxCoverage!) {
      return _itemSize * (1 - maxCoverage!);
    }

    final isMinCoverageSet = minCoverage != null;
    if (isMinCoverageSet && calculatedCoveragePercent < minCoverage!) {
      return _itemSize * (1 - minCoverage!);
    }
    return _itemSize + spaceBetweenItems;
  }

  List<ItemPosition> _generatePositions(double offsetStep) {
    final positions = <ItemPosition>[];
    for (var n = 0; n < amountElements; n++) {
      positions.add(ItemPosition(number: n, position: n * offsetStep));
    }
    return positions;
  }

  double get _itemSize => _height;

  @override
  void setSize({required double width, required double height}) {
    _width = width;
    _height = height;
  }

  @override
  void setAmountItems(int amountItems) {
    amountElements = amountItems;
  }
}
