import 'dart:math';

import 'positions.dart';

class RestrictedPositionsWithInfoItem implements Positions {
  RestrictedPositionsWithInfoItem({
    this.maxCoverage = 0.8,
    this.minCoverage,
  });

  final double? minCoverage;
  final double? maxCoverage;
  late double _width;
  late double _height;
  late int _amountItems;

  @override
  void setSize({required double width, required double height}) {
    _width = width;
    _height = height;
  }

  @override
  void setAmountItems(int amountItems) {
    _amountItems = amountItems;
  }

  @override
  List<ItemPosition> calculate() {
    final allowedAmountItems = _calculateCapacityItems();
    final minAmountItems = min(_amountItems, allowedAmountItems);
    final spaceBetweenItems = _calculateSpaceBetweenItems(minAmountItems);
    final offsetStep = _calculateOffsetStep(spaceBetweenItems);
    return _generatePositions(offsetStep, allowedAmountItems);
  }

  int _calculateCapacityItems() {
    final capacity = _width / (_itemSize + _minimumSpaceBetweenItems);
    return capacity.toInt();
  }

  double get _minimumSpaceBetweenItems {
    final invertedNormalizedMaxCoverage = -(maxCoverage ?? 0.9);
    return _itemSize * invertedNormalizedMaxCoverage;
  }

  double _calculateSpaceBetweenItems(int _amountItems) {
    if (_amountItems < 2) {
      return 0;
    }
    return (_width - _itemSize * _amountItems) / (_amountItems - 1);
  }

  double _calculateOffsetStep(double spaceBetweenItems) {
    final calculatedCoveragePercent = -spaceBetweenItems / _itemSize;

    final isMinCoverageSet = minCoverage != null;
    if (isMinCoverageSet && calculatedCoveragePercent < minCoverage!) {
      return _itemSize * (1 - minCoverage!);
    }
    return _itemSize + spaceBetweenItems;
  }

  List<ItemPosition> _generatePositions(
      double offsetStep, int allowedAmountItems) {
    final positions = <ItemPosition>[];
    final amount = min(_amountItems, allowedAmountItems);
    int n;
    for (n = 0; n < amount - 1; n++) {
      positions.add(ItemPosition(number: n, position: n * offsetStep));
    }
    final amountAdditionalItems = _amountItems - allowedAmountItems;
    final isAmountAdditionalItems = amountAdditionalItems > 0;
    if (isAmountAdditionalItems) {
      positions.add(ItemPosition(
        number: n,
        position: n * offsetStep,
        isInformationalItem: true,
        amountAdditionalItems: amountAdditionalItems + 1,
      ));
    } else {
      positions.add(ItemPosition(
        number: n,
        position: n * offsetStep,
      ));
    }
    return positions;
  }

  double get _itemSize => _height;
}
