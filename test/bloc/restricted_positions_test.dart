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
        ItemPosition(number: 0, position: 0.0),
        ItemPosition(number: 1, position: 20.0),
        ItemPosition(number: 2, position: 40.0),
        ItemPosition(number: 3, position: 60.0),
        ItemPosition(number: 4, position: 80.0),
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
        ItemPosition(number: 0, position: 0.0),
        ItemPosition(number: 1, position: 1.6666666666666679),
        ItemPosition(number: 2, position: 3.3333333333333357),
        ItemPosition(number: 3, position: 5.0000000000000036),
        ItemPosition(number: 4, position: 6.666666666666671),
        ItemPosition(number: 5, position: 8.33333333333334),
        InfoItemPosition(
            number: 6, position: 10.000000000000007, amountAdditionalItems: 4),
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
        ItemPosition(number: 4, position: 80.0),
        ItemPosition(number: 3, position: 60.0),
        ItemPosition(number: 2, position: 40.0),
        ItemPosition(number: 1, position: 20.0),
        ItemPosition(number: 0, position: 0.0),
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
            number: 6, position: 10.000000000000007, amountAdditionalItems: 4),
        ItemPosition(number: 5, position: 8.33333333333334),
        ItemPosition(number: 4, position: 6.666666666666671),
        ItemPosition(number: 3, position: 5.0000000000000036),
        ItemPosition(number: 2, position: 3.3333333333333357),
        ItemPosition(number: 1, position: 1.6666666666666679),
        ItemPosition(number: 0, position: 0.0),
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
        ItemPosition(number: 0, position: 0.0),
        ItemPosition(number: 1, position: 40.0),
        InfoItemPosition(number: 2, position: 80.0, amountAdditionalItems: 3),
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
        ItemPosition(number: 0, position: 0.0),
        ItemPosition(number: 1, position: 4.0),
        InfoItemPosition(number: 2, position: 8.0, amountAdditionalItems: 3),
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
        ItemPosition(number: 0, position: 36.0),
        ItemPosition(number: 1, position: 40.0),
        InfoItemPosition(number: 2, position: 44.0, amountAdditionalItems: 3),
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
        ItemPosition(number: 0, position: 72.0),
        ItemPosition(number: 1, position: 76.0),
        InfoItemPosition(number: 2, position: 80.0, amountAdditionalItems: 3),
      ];

      expect(calculatedPositions, equals(expectedPositions));
    });
  });
}
