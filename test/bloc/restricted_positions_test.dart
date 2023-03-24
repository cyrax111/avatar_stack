import 'package:avatar_stack/positions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RestrictedPositions -', () {
    test('all items are fit', () {
      final defaultPositions = RestrictedPositions(
        align: StackAlign.left,
        infoIndent: 0,
        laying: StackLaying.last,
        maxCoverage: 0.8,
        minCoverage: double.negativeInfinity,
      );
      defaultPositions.setAmountItems(5);
      defaultPositions.setSize(width: 100, height: 20);

      final calculatedPositions = defaultPositions.calculate();
      final expectedPositions = [
        ItemPosition(number: 0, size: 20, y: 0, x: 0.0),
        ItemPosition(number: 1, size: 20, y: 0, x: 20.0),
        ItemPosition(number: 2, size: 20, y: 0, x: 40.0),
        ItemPosition(number: 3, size: 20, y: 0, x: 60.0),
        ItemPosition(number: 4, size: 20, y: 0, x: 80.0),
      ];

      expect(calculatedPositions, equals(expectedPositions));
    });

    test('hidden items are', () {
      final defaultPositions = RestrictedPositions(
        align: StackAlign.left,
        infoIndent: 0,
        laying: StackLaying.last,
        maxCoverage: 0.8,
        minCoverage: double.negativeInfinity,
      );
      defaultPositions.setAmountItems(10);
      defaultPositions.setSize(width: 30, height: 20);

      final calculatedPositions = defaultPositions.calculate();
      final expectedPositions = [
        ItemPosition(number: 0, size: 20, y: 0, x: 0.0),
        ItemPosition(number: 1, size: 20, y: 0, x: 1.6666666666666679),
        ItemPosition(number: 2, size: 20, y: 0, x: 3.3333333333333357),
        ItemPosition(number: 3, size: 20, y: 0, x: 5.0000000000000036),
        ItemPosition(number: 4, size: 20, y: 0, x: 6.666666666666671),
        ItemPosition(number: 5, size: 20, y: 0, x: 8.33333333333334),
        InfoItemPosition(
            number: 6,
            size: 20,
            y: 0,
            x: 10.000000000000007,
            amountAdditionalItems: 4),
      ];

      expect(calculatedPositions, equals(expectedPositions));
    });

    test('StackLaying first', () {
      final defaultPositions = RestrictedPositions(
        align: StackAlign.left,
        infoIndent: 0,
        laying: StackLaying.first,
        maxCoverage: 0.8,
        minCoverage: double.negativeInfinity,
      );
      defaultPositions.setAmountItems(5);
      defaultPositions.setSize(width: 100, height: 20);

      final calculatedPositions = defaultPositions.calculate();
      final expectedPositions = [
        ItemPosition(number: 4, size: 20, y: 0, x: 80.0),
        ItemPosition(number: 3, size: 20, y: 0, x: 60.0),
        ItemPosition(number: 2, size: 20, y: 0, x: 40.0),
        ItemPosition(number: 1, size: 20, y: 0, x: 20.0),
        ItemPosition(number: 0, size: 20, y: 0, x: 0.0),
      ];

      expect(calculatedPositions, equals(expectedPositions));
    });

    test('hidden items are - StackLaying first', () {
      final defaultPositions = RestrictedPositions(
        align: StackAlign.left,
        infoIndent: 0,
        laying: StackLaying.first,
        maxCoverage: 0.8,
        minCoverage: double.negativeInfinity,
      );
      defaultPositions.setAmountItems(10);
      defaultPositions.setSize(width: 30, height: 20);

      final calculatedPositions = defaultPositions.calculate();
      final expectedPositions = [
        InfoItemPosition(
            number: 6,
            size: 20,
            y: 0,
            x: 10.000000000000007,
            amountAdditionalItems: 4),
        ItemPosition(number: 5, size: 20, y: 0, x: 8.33333333333334),
        ItemPosition(number: 4, size: 20, y: 0, x: 6.666666666666671),
        ItemPosition(number: 3, size: 20, y: 0, x: 5.0000000000000036),
        ItemPosition(number: 2, size: 20, y: 0, x: 3.3333333333333357),
        ItemPosition(number: 1, size: 20, y: 0, x: 1.6666666666666679),
        ItemPosition(number: 0, size: 20, y: 0, x: 0.0),
      ];

      expect(calculatedPositions, equals(expectedPositions));
    });

    test('set wrong size', () {
      final defaultPositions = RestrictedPositions();

      expect(
        () => defaultPositions.setSize(width: 30, height: 0),
        throwsAssertionError,
      );

      expect(
        () => defaultPositions.setSize(width: 30, height: -7),
        throwsAssertionError,
      );

      expect(
        () => defaultPositions.setSize(width: 0, height: 20),
        throwsAssertionError,
      );

      expect(
        () => defaultPositions.setSize(width: -80, height: 20),
        throwsAssertionError,
      );

      expect(
        () => defaultPositions.setSize(width: 0, height: 0),
        throwsAssertionError,
      );

      expect(
        () => defaultPositions.setSize(width: 200, height: 10),
        returnsNormally,
      );
    });

    test('vertical layout', () {
      final defaultPositions = RestrictedPositions(
        align: StackAlign.left,
        infoIndent: 0,
        laying: StackLaying.last,
        maxCoverage: 0.8,
        minCoverage: double.negativeInfinity,
        layoutDirection: LayoutDirection.vertical,
      );
      defaultPositions.setAmountItems(5);
      defaultPositions.setSize(width: 20, height: 100);

      final calculatedPositions = defaultPositions.calculate();
      final expectedPositions = [
        ItemPosition(number: 0, size: 20, x: 0, y: 0.0),
        ItemPosition(number: 1, size: 20, x: 0, y: 20.0),
        ItemPosition(number: 2, size: 20, x: 0, y: 40.0),
        ItemPosition(number: 3, size: 20, x: 0, y: 60.0),
        ItemPosition(number: 4, size: 20, x: 0, y: 80.0),
      ];

      expect(calculatedPositions, equals(expectedPositions));
    });
  });

  group('RestrictedAmountPositions -', () {
    test('hidden items are', () {
      final defaultPositions = RestrictedAmountPositions(
        align: StackAlign.left,
        infoIndent: 0,
        laying: StackLaying.last,
        maxCoverage: 0.8,
        minCoverage: double.negativeInfinity,
        maxAmountItems: 3,
      );
      defaultPositions.setAmountItems(5);
      defaultPositions.setSize(width: 100, height: 20);

      final calculatedPositions = defaultPositions.calculate();
      final expectedPositions = [
        ItemPosition(number: 0, size: 20, y: 0, x: 0.0),
        ItemPosition(number: 1, size: 20, y: 0, x: 40.0),
        InfoItemPosition(
            number: 2, size: 20, y: 0, x: 80.0, amountAdditionalItems: 3),
      ];

      expect(calculatedPositions, equals(expectedPositions));
    });

    test('minCoverage is the same maxCoverage', () {
      final defaultPositions = RestrictedAmountPositions(
        align: StackAlign.left,
        infoIndent: 0,
        laying: StackLaying.last,
        maxCoverage: 0.8,
        minCoverage: 0.8,
        maxAmountItems: 3,
      );
      defaultPositions.setAmountItems(5);
      defaultPositions.setSize(width: 100, height: 20);

      final calculatedPositions = defaultPositions.calculate();
      final expectedPositions = [
        ItemPosition(number: 0, size: 20, y: 0, x: 0.0),
        ItemPosition(number: 1, size: 20, y: 0, x: 4.0),
        InfoItemPosition(
            number: 2, size: 20, y: 0, x: 8.0, amountAdditionalItems: 3),
      ];

      expect(calculatedPositions, equals(expectedPositions));
    });

    test('align is centre', () {
      final defaultPositions = RestrictedAmountPositions(
        align: StackAlign.center,
        infoIndent: 0,
        laying: StackLaying.last,
        maxCoverage: 0.8,
        minCoverage: 0.8,
        maxAmountItems: 3,
      );
      defaultPositions.setAmountItems(5);
      defaultPositions.setSize(width: 100, height: 20);

      final calculatedPositions = defaultPositions.calculate();
      final expectedPositions = [
        ItemPosition(number: 0, size: 20, y: 0, x: 36.0),
        ItemPosition(number: 1, size: 20, y: 0, x: 40.0),
        InfoItemPosition(
            number: 2, size: 20, y: 0, x: 44.0, amountAdditionalItems: 3),
      ];

      expect(calculatedPositions, equals(expectedPositions));
    });

    test('align is right', () {
      final defaultPositions = RestrictedAmountPositions(
        align: StackAlign.right,
        infoIndent: 0,
        laying: StackLaying.last,
        maxCoverage: 0.8,
        minCoverage: 0.8,
        maxAmountItems: 3,
      );
      defaultPositions.setAmountItems(5);
      defaultPositions.setSize(width: 100, height: 20);

      final calculatedPositions = defaultPositions.calculate();
      final expectedPositions = [
        ItemPosition(number: 0, size: 20, y: 0, x: 72.0),
        ItemPosition(number: 1, size: 20, y: 0, x: 76.0),
        InfoItemPosition(
            number: 2, size: 20, y: 0, x: 80.0, amountAdditionalItems: 3),
      ];

      expect(calculatedPositions, equals(expectedPositions));
    });
  });
}
