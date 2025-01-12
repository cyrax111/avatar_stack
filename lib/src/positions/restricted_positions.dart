import 'dart:math';
import 'dart:ui';

import 'positions.dart';

/// Defines coordinates of common items and an information item.
/// The height of elements is defined by _height of the area.
/// Has coverage and align settings.
class RestrictedPositions implements Positions {
  RestrictedPositions({
    this.maxCoverage = 0.8,
    this.minCoverage = double.negativeInfinity,
    this.align = StackAlign.left,
    this.infoItem = const InfoItem.absent(),
    this.laying = StackLaying.last,
    this.layoutDirection = LayoutDirection.horizontal,
  }) : assert(maxCoverage >= minCoverage,
            'minCoverage ($minCoverage) should not be more then maxCoverage ($maxCoverage)');

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

  /// Info item usually has information about hidden items. Something like: (+5)
  /// Contains the additional space between an info item (if exists) and other items
  /// and size of the info item.
  final InfoItem infoItem;

  InfoItem get _infoItem => infoItem;

  /// The way to tile items.
  late StackLaying laying;

  final LayoutDirection layoutDirection;

  late double _length;
  late double _tallness;

  @override
  void setSize({required double width, required double height}) {
    assert(width > 0, 'width has to be more then zero');
    assert(height > 0, 'height has to be more then zero');

    switch (layoutDirection) {
      case LayoutDirection.horizontal:
        _length = width;
        _tallness = height;
        break;
      case LayoutDirection.vertical:
        _length = height;
        _tallness = width;
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
  late int _amountHiddenItems;
  late bool _isInfoItem;
  late double _spaceBetweenItems;
  late double _offsetStep;
  late double _alignmentOffset;

  @override
  List<ItemPosition> calculate() {
    _allowedBySpaceAndMaxCoverageAmountItems = _calculateMaxCapacityItems(_length);
    _allowedAmountItems = _getAmountItems();
    _amountHiddenItems = _fullAmountItems - _allowedAmountItems;
    _isInfoItem = _amountHiddenItems > 0;
    if (_isInfoItem) {
      _allowedBySpaceAndMaxCoverageAmountItems = _calculateMaxCapacityItemsWithInfoItem();
      _allowedAmountItems = _getAmountItems();
      _amountHiddenItems = _fullAmountItems - _allowedAmountItems + 1;
      _spaceBetweenItems = _calculateSpaceBetweenItemsWithInfoItem();
    } else {
      _spaceBetweenItems = _calculateSpaceBetweenItems();
    }
    _offsetStep = _calculateOffsetStep();
    _alignmentOffset = _getAlignmentOffset();
    return _generatePositions();
  }

  int _calculateMaxCapacityItems(double length) {
    const lastItem = 1;
    final lastItemSize = _itemSize;
    final capacity =
        (length - lastItemSize) / (_itemSize + _getSpaceBetweenItemsBy(coverage: maxCoverage));
    return capacity.toInt() + lastItem;
  }

  int _getAmountItems() {
    return min(_fullAmountItems, _allowedBySpaceAndMaxCoverageAmountItems);
  }

  int _calculateMaxCapacityItemsWithInfoItem() {
    final infoItemItself = 1;
    final infoItemLength = infoItem.indent +
        (infoItem.size ?? _itemSize) +
        _getSpaceBetweenItemsBy(coverage: maxCoverage);
    return _calculateMaxCapacityItems(_length - infoItemLength) + infoItemItself;
  }

  double _calculateSpaceBetweenItems() {
    if (_allowedAmountItems <= 1) {
      return 0;
    }

    final spaceBetweenItemsForFullWidth =
        (_length - _itemSize * _allowedAmountItems) / (_allowedAmountItems - 1);
    final spaceBetweenItemsWithMinCoverageRestriction =
        _getSpaceBetweenItemsBy(coverage: minCoverage);
    return min(spaceBetweenItemsForFullWidth, spaceBetweenItemsWithMinCoverageRestriction);
  }

  double _calculateSpaceBetweenItemsWithInfoItem() {
    assert(_isInfoItem);

    if (_allowedAmountItems <= 1) {
      return 0;
    }

    final itemsSizesSum =
        _itemSize * (_allowedAmountItems - 1) + (_infoItem.size ?? _itemSize) + _infoItem.indent;
    final spaceBetweenItemsForFullWidth = (_length - itemsSizesSum) / (_allowedAmountItems - 1);
    final spaceBetweenItemsWithMinCoverageRestriction =
        _getSpaceBetweenItemsBy(coverage: minCoverage);
    return min(spaceBetweenItemsForFullWidth, spaceBetweenItemsWithMinCoverageRestriction);
  }

  double _calculateOffsetStep() {
    return _itemSize + _spaceBetweenItems;
  }

  double _getAlignmentOffset() {
    final infoItemSpace = _isInfoItem //
        ? _infoItem.indent + (_infoItem.size ?? _itemSize) - _itemSize
        : 0;
    final occupiedSpace = _allowedAmountItems * _offsetStep - _spaceBetweenItems + infoItemSpace;
    final freeSpace = _length - occupiedSpace;
    switch (align) {
      case StackAlign.left:
        return 0;
      case StackAlign.right:
        return freeSpace;
      case StackAlign.center:
        return freeSpace / 2;
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
    final normalizedTopPosition = min(_itemToFill, laying.itemPositionNumberAtTop);
    for (var n = _itemToFill - 1; n >= normalizedTopPosition; n--) {
      positions.add(_generateItemPosition(n));
    }
  }

  void _fillPositionsForward(List<ItemPosition> positions) {
    final normalizedTopPosition = min(_itemToFill, laying.itemPositionNumberAtTop);
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

  ItemPosition _generateItemPosition(int number) => _getItemPositionByLayoutDirection(
        number: number,
        position: number * _offsetStep + _alignmentOffset,
      );

  ItemPosition _generateInfoItemPosition() {
    Size getSize() {
      if (layoutDirection == LayoutDirection.horizontal) {
        return Size(_infoItem.size ?? _itemSize, _itemSize);
      } else {
        return Size(_itemSize, _infoItem.size ?? _itemSize);
      }
    }

    final number = _allowedAmountItems - 1;
    return InfoItemPosition.fromItemPosition(
      amountAdditionalItems: _amountHiddenItems,
      size: getSize(),
      itemPosition: _getItemPositionByLayoutDirection(
        number: number,
        position: number * _offsetStep + _alignmentOffset + _infoItem.indent,
      ),
    );
  }

  ItemPosition _getItemPositionByLayoutDirection({
    required int number,
    required double position,
  }) {
    switch (layoutDirection) {
      case LayoutDirection.horizontal:
        return ItemPosition(
          number: number,
          offset: Offset(position, 0),
          size: Size.square(_itemSize),
        );
      case LayoutDirection.vertical:
        return ItemPosition(
          number: number,
          offset: Offset(0, position),
          size: Size.square(_itemSize),
        );
    }
  }

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

  double get _itemSize => _tallness;
}

/// Defines coordinates of common items and an information item
/// as [RestrictedAmountPositions] and has [maxAmountItems] which
/// means only maxAmountItems items will be shown maximum.
class RestrictedAmountPositions extends RestrictedPositions {
  RestrictedAmountPositions({
    super.maxCoverage,
    super.minCoverage,
    this.maxAmountItems = 5,
    super.align,
    super.infoItem,
    super.laying,
    super.layoutDirection = LayoutDirection.horizontal,
  });

  /// The maximum amount of items to show
  final int maxAmountItems;

  @override
  int _getAmountItems() {
    final minBetweenFullAndCalculatedAmount =
        min(_fullAmountItems, _allowedBySpaceAndMaxCoverageAmountItems);
    return min(maxAmountItems, minBetweenFullAndCalculatedAmount);
  }
}
