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
  late int _fullAmountItems;
  late int _allowedAmountItems;

  @override
  void setSize({required double width, required double height}) {
    _width = width;
    _height = height;
  }

  @override
  void setAmountItems(int fullAmountItems) {
    _fullAmountItems = fullAmountItems;
  }

  @override
  List<ItemPosition> calculate() {
    final allowedBySpaceAndMaxCoverageAmountItems =
        _calculateMaxCapacityItems();
    _allowedAmountItems = _getAmountItems(
        calculatedAmountItems: allowedBySpaceAndMaxCoverageAmountItems);
    final spaceBetweenItems = _calculateSpaceBetweenItems();
    final offsetStep = _calculateOffsetStep(spaceBetweenItems);
    final alignmentOffset = _getAlignmentOffset(
      offsetStep: offsetStep,
      spaceBetweenItems: spaceBetweenItems,
    );
    return _generatePositions(
      offsetStep: offsetStep,
      alignmentOffset: alignmentOffset,
    );
  }

  int _calculateMaxCapacityItems() {
    final capacity =
        _width / (_itemSize + _getSpaceBetweenItemsBy(coverage: maxCoverage));
    return capacity.toInt();
  }

  int _getAmountItems({required int calculatedAmountItems}) {
    return min(_fullAmountItems, calculatedAmountItems);
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

  double _getSpaceBetweenItemsBy({required double coverage}) {
    return _itemSize * (-1 * coverage);
  }

  double _calculateOffsetStep(double spaceBetweenItems) {
    return _itemSize + spaceBetweenItems;
  }

  double _getAlignmentOffset({
    required double offsetStep,
    required double spaceBetweenItems,
  }) {
    final freeSpace = _width -
        _allowedAmountItems * offsetStep +
        spaceBetweenItems -
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

  int get _amountHiddenItems => _fullAmountItems - _allowedAmountItems;

  bool get _isInfoItem => _amountHiddenItems > 0;

  List<ItemPosition> _generatePositions({
    required double offsetStep,
    required double alignmentOffset,
  }) {
    final positions = <ItemPosition>[];

    if (_isInfoItem) {
      final topPosition = min(_allowedAmountItems - 1, laying.topPosition);
      for (var n = _allowedAmountItems - 1 - 1; n >= topPosition; n--) {
        positions.add(ItemPosition(
            number: n, position: n * offsetStep + alignmentOffset));
      }
      for (var n = 0; n < topPosition; n++) {
        positions.add(ItemPosition(
            number: n, position: n * offsetStep + alignmentOffset));
      }
      positions.add(ItemPosition(
        number: _allowedAmountItems - 1,
        position: (_allowedAmountItems - 1) * offsetStep +
            alignmentOffset +
            infoIndent,
        isInformationalItem: true,
        amountAdditionalItems: _amountHiddenItems + 1,
      ));
    } else {
      final topPosition = min(_allowedAmountItems, laying.topPosition);
      for (var n = _allowedAmountItems - 1; n >= topPosition; n--) {
        positions.add(ItemPosition(
            number: n, position: n * offsetStep + alignmentOffset));
      }
      for (var n = 0; n < topPosition; n++) {
        positions.add(ItemPosition(
            number: n, position: n * offsetStep + alignmentOffset));
      }
    }
    return positions;
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
  int _getAmountItems({required int calculatedAmountItems}) {
    final minBetweenFullAndCalculatedAmount =
        min(_fullAmountItems, calculatedAmountItems);
    return min(maxAmountItems, minBetweenFullAndCalculatedAmount);
  }
}
