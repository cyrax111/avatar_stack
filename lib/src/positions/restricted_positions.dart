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
    this.laying = StackLaying.last,
    this.layoutDirection = LayoutDirection.horizontal,
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

  /// The way to tile items.
  late StackLaying laying;

  final LayoutDirection layoutDirection;

  late double _width;
  late double _height;
  @override
  void setSize({required double width, required double height}) {
    assert(width > 0, 'width has to be more then zero');
    assert(height > 0, 'height has to be more then zero');

    switch (layoutDirection) {
      case LayoutDirection.horizontal:
        _width = width;
        _height = height;
        break;
      case LayoutDirection.vertical:
        _width = height;
        _height = width;
        break;
    }
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
    switch (align) {
      case StackAlign.left:
        return 0;
      case StackAlign.right:
        return freeSpace;
      case StackAlign.center:
        return freeSpace / 2;
      default:
        return 0;
    }
  }

  List<ItemPosition> _generatePositions() {
    final positions = <ItemPosition>[];

    _fillPositionsBackward(positions);
    _fillPositionsForward(positions);
    _addInfoItemPosition(positions);

    return positions;
  }

  void _fillPositionsBackward(List<ItemPosition> positions) {
    final normalizedTopPosition =
        min(_itemToFill, laying.itemPositionNumberAtTop);
    for (var n = _itemToFill - 1; n >= normalizedTopPosition; n--) {
      positions.add(_generateItemPosition(n));
    }
  }

  void _fillPositionsForward(List<ItemPosition> positions) {
    final normalizedTopPosition =
        min(_itemToFill, laying.itemPositionNumberAtTop);
    for (var n = 0; n < normalizedTopPosition; n++) {
      positions.add(_generateItemPosition(n));
    }
  }

  void _addInfoItemPosition(List<ItemPosition> positions) {
    if (_isInfoItem) {
      if (laying.infoItemAtTop) {
        positions.add(_generateInfoItemPosition());
      } else {
        positions.insert(0, _generateInfoItemPosition());
      }
    }
  }

  ItemPosition _generateItemPosition(int number) =>
      _getItemPositionByLayoutDirection(
        number: number,
        position: number * _offsetStep + _alignmentOffset,
      );

  ItemPosition _generateInfoItemPosition() => InfoItemPosition.fromItemPosition(
        amountAdditionalItems:
            _amountHiddenItems + 1, // we also replace one item with infoItem
        itemPosition: _getItemPositionByLayoutDirection(
          number: _allowedAmountItems - 1,
          position: (_allowedAmountItems - 1) * _offsetStep +
              _alignmentOffset +
              _infoIndent,
        ),
      );

  ItemPosition _getItemPositionByLayoutDirection({
    required int number,
    required double position,
  }) {
    switch (layoutDirection) {
      case LayoutDirection.horizontal:
        return ItemPosition(
          number: number,
          x: position,
          y: 0,
          size: _itemSize,
        );
      case LayoutDirection.vertical:
        return ItemPosition(
          number: number,
          x: 0,
          y: position,
          size: _itemSize,
        );
    }
  }

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
    StackLaying laying = StackLaying.last,
    super.layoutDirection = LayoutDirection.horizontal,
  }) : super(
          maxCoverage: maxCoverage,
          minCoverage: minCoverage,
          align: align,
          infoIndent: infoIndent,
          laying: laying,
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
