import 'dart:math';

import 'positions.dart';

/// Defines coordinates of common items and an information item.
/// The height of elements is defined by _height of the area.
/// Has coverage and align settings.
class RestrictedPositions implements Positions {
  RestrictedPositions({
    this.maxCoverage = 0.8,
    this.minCoverage = double.negativeInfinity,
    this.align = StackAlign.left,
    this.infoIndent = 0.0,
    this.laying = const StackLaying.last(),
  });

  /// Define minimum items coverage.
  /// If [minCoverage] is negative the gape between item exists.
  /// It is measured as a percentage, for example:
  /// minCoverage = 0.5 means 50% of coverage
  /// minCoverage = 0.81 means 81% of coverage
  final double minCoverage;

  /// Define maximum items coverage.
  /// If [maxCoverage] is negative the gape between item exists.
  /// It is measured as a percentage, for example:
  /// minCoverage = 0.5 means 50% of coverage
  /// minCoverage = 0.81 means 81% of coverage
  final double maxCoverage;

  /// Alignment
  final StackAlign align;

  /// The additional space between an info item (if exists) and other items.
  /// Info item usually has information about hidden items. Something like: (+5)
  final double infoIndent;
  double get _infoIndent => _isInfoItem ? infoIndent : 0;

  late StackLaying laying;

  late double _width;
  late double _height;
  @override
  void setSize({required double width, required double height}) {
    _width = width;
    _height = height;
  }

  late int _fullAmountItems;
  @override
  void setAmountItems(int fullAmountItems) {
    _fullAmountItems = fullAmountItems;
  }

  late int _allowedAmountItems;
  late int _allowedBySpaceAndMaxCoverageAmountItems;
  late double _spaceBetweenItems;
  late double _offsetStep;
  late double _alignmentOffset;

  @override
  List<ItemPosition> calculate() {
    _allowedBySpaceAndMaxCoverageAmountItems = _calculateMaxCapacityItems();
    _allowedAmountItems = _getAmountItems();
    _spaceBetweenItems = _calculateSpaceBetweenItems();
    _offsetStep = _calculateOffsetStep();
    _alignmentOffset = _getAlignmentOffset();
    return _generatePositions();
  }

  int _calculateMaxCapacityItems() {
    final capacity =
        _width / (_itemSize + _getSpaceBetweenItemsBy(coverage: maxCoverage));
    return capacity.toInt();
  }

  int _getAmountItems() {
    return min(_fullAmountItems, _allowedBySpaceAndMaxCoverageAmountItems);
  }

  double _calculateSpaceBetweenItems() {
    if (_allowedAmountItems <= 1) {
      return 0;
    }

    final spaceBetweenItemsForFullWidth =
        (_width - _infoIndent - _itemSize * _allowedAmountItems) /
            (_allowedAmountItems - 1);
    final spaceBetweenItemsWithMinCoverageRestriction =
        _getSpaceBetweenItemsBy(coverage: minCoverage);
    return min(spaceBetweenItemsForFullWidth,
        spaceBetweenItemsWithMinCoverageRestriction);
  }

  double _calculateOffsetStep() {
    return _itemSize + _spaceBetweenItems;
  }

  double _getAlignmentOffset() {
    final freeSpace = _width -
        _allowedAmountItems * _offsetStep +
        _spaceBetweenItems -
        _infoIndent;
    late double alignmentOffset;
    switch (align) {
      case StackAlign.left:
        alignmentOffset = 0;
        break;
      case StackAlign.right:
        alignmentOffset = freeSpace;
        break;
      case StackAlign.center:
        alignmentOffset = freeSpace / 2;
        break;
      default:
        alignmentOffset = 0;
    }
    return alignmentOffset;
  }

  List<ItemPosition> _generatePositions() {
    final positions = <ItemPosition>[];

    _fillPositionsBackward(positions);
    _fillPositionsForward(positions);
    _addInfoItemPosition(positions);

    return positions;
  }

  void _fillPositionsBackward(List<ItemPosition> positions) {
    final normalizedTopPosition = min(_itemToFill, laying.topPosition);
    for (var n = _itemToFill - 1; n >= normalizedTopPosition; n--) {
      positions.add(_generateItemPosition(n));
    }
  }

  void _fillPositionsForward(List<ItemPosition> positions) {
    final normalizedTopPosition = min(_itemToFill, laying.topPosition);
    for (var n = 0; n < normalizedTopPosition; n++) {
      positions.add(_generateItemPosition(n));
    }
  }

  void _addInfoItemPosition(List<ItemPosition> positions) {
    if (_isInfoItem) {
      positions.add(_generateInfoItemPosition());
    }
  }

  ItemPosition _generateItemPosition(int number) => ItemPosition(
        number: number,
        position: number * _offsetStep + _alignmentOffset,
      );

  ItemPosition _generateInfoItemPosition() => ItemPosition(
        number: _allowedAmountItems - 1,
        position: (_allowedAmountItems - 1) * _offsetStep +
            _alignmentOffset +
            _infoIndent,
        isInformationalItem: true,
        amountAdditionalItems:
            _amountHiddenItems + 1, // we also replace one item with infoItem
      );

  bool get _isInfoItem => _amountHiddenItems > 0;

  int get _amountHiddenItems => _fullAmountItems - _allowedAmountItems;

  int get _itemToFill {
    int itemToFill;
    if (_isInfoItem) {
      itemToFill = _allowedAmountItems - 1;
    } else {
      itemToFill = _allowedAmountItems;
    }
    return itemToFill;
  }

  double _getSpaceBetweenItemsBy({required double coverage}) {
    return _itemSize * (-1 * coverage);
  }

  double get _itemSize => _height;
}

/// Defines coordinates of common items and an information item
/// as [RestrictedAmountPositions] and has [maxAmountItems] which
/// means only maxAmountItems items will be shown maximum.
class RestrictedAmountPositions extends RestrictedPositions {
  RestrictedAmountPositions({
    double maxCoverage = 0.8,
    double minCoverage = double.negativeInfinity,
    this.maxAmountItems = 5,
    StackAlign align = StackAlign.left,
    double infoIndent = 0.0,
  }) : super(
          maxCoverage: maxCoverage,
          minCoverage: minCoverage,
          align: align,
          infoIndent: infoIndent,
        );

  /// The maximum amount of items to show
  final int maxAmountItems;

  @override
  int _getAmountItems() {
    final minBetweenFullAndCalculatedAmount =
        min(_fullAmountItems, _allowedBySpaceAndMaxCoverageAmountItems);
    return min(maxAmountItems, minBetweenFullAndCalculatedAmount);
  }
}
