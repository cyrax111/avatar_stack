import 'dart:ui';

import 'package:avatar_stack/positions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RestrictedPositions -', () {
    test('all items are fit', () {
      final defaultPositions = RestrictedPositions(
        align: StackAlign.left,
        infoItem: const InfoItem.absent(),
        laying: StackLaying.last,
        maxCoverage: 0.8,
        minCoverage: double.negativeInfinity,
      );
      defaultPositions.setAmountItems(5);
      defaultPositions.setSize(width: 100, height: 20);

      final calculatedPositions = defaultPositions.calculate();
      final expectedPositions = [
        ItemPosition(number: 0, size: Size.square(20.0), offset: Offset(0.0, 0)),
        ItemPosition(number: 1, size: Size.square(20.0), offset: Offset(20.0, 0)),
        ItemPosition(number: 2, size: Size.square(20.0), offset: Offset(40.0, 0)),
        ItemPosition(number: 3, size: Size.square(20.0), offset: Offset(60.0, 0)),
        ItemPosition(number: 4, size: Size.square(20.0), offset: Offset(80.0, 0)),
      ];

      expect(calculatedPositions, equals(expectedPositions));
    });

    group('hidden items exist, infoinfo item', () {
      test('info item is larger then other items', () {
        final defaultPositions = RestrictedPositions(
          align: StackAlign.left,
          infoItem: const InfoItem(indent: 0, size: 15),
          laying: StackLaying.last,
          maxCoverage: 0.5,
        );
        defaultPositions.setAmountItems(6);
        defaultPositions.setSize(width: 30, height: 10);

        final calculatedPositions = defaultPositions.calculate();
        final expectedPositions = [
          ItemPosition(number: 0, size: Size.square(10), offset: Offset(0.0, 0)),
          ItemPosition(number: 1, size: Size.square(10), offset: Offset(5.0, 0)),
          ItemPosition(number: 2, size: Size.square(10), offset: Offset(10.0, 0)),
          InfoItemPosition(
              number: 3, size: Size(15, 10), offset: Offset(15.0, 0), amountAdditionalItems: 3),
        ];

        expect(calculatedPositions, equals(expectedPositions));
      });

      test('info item is larger then other items and has intent', () {
        final defaultPositions = RestrictedPositions(
          align: StackAlign.left,
          infoItem: const InfoItem(indent: 5, size: 15),
          laying: StackLaying.last,
          maxCoverage: 0.5,
        );
        defaultPositions.setAmountItems(6);
        defaultPositions.setSize(width: 30, height: 10);

        final calculatedPositions = defaultPositions.calculate();
        final expectedPositions = [
          ItemPosition(number: 0, size: Size.square(10), offset: Offset(0.0, 0)),
          ItemPosition(number: 1, size: Size.square(10), offset: Offset(5.0, 0)),
          InfoItemPosition(
              number: 2, size: Size(15, 10), offset: Offset(15.0, 0), amountAdditionalItems: 4),
        ];

        expect(calculatedPositions, equals(expectedPositions));
      });

      test('info item is smaller then other items', () {
        final defaultPositions = RestrictedPositions(
          align: StackAlign.left,
          infoItem: const InfoItem(indent: 0, size: 5),
          laying: StackLaying.last,
          maxCoverage: 0.5,
        );
        defaultPositions.setAmountItems(6);
        defaultPositions.setSize(width: 30, height: 10);

        final calculatedPositions = defaultPositions.calculate();
        final expectedPositions = [
          ItemPosition(number: 0, size: Size.square(10), offset: Offset(0.0, 0)),
          ItemPosition(number: 1, size: Size.square(10), offset: Offset(5.0, 0)),
          ItemPosition(number: 2, size: Size.square(10), offset: Offset(10.0, 0)),
          ItemPosition(number: 3, size: Size.square(10), offset: Offset(15.0, 0)),
          ItemPosition(number: 4, size: Size.square(10), offset: Offset(20.0, 0)),
          InfoItemPosition(
              number: 5, size: Size(5, 10), offset: Offset(25.0, 0), amountAdditionalItems: 1),
        ];

        expect(calculatedPositions, equals(expectedPositions));
      });

      test('LayoutDirection is vertical, info item is larger then other items', () {
        final defaultPositions = RestrictedPositions(
          align: StackAlign.left,
          infoItem: const InfoItem(indent: 0, size: 15),
          laying: StackLaying.last,
          maxCoverage: 0.5,
          layoutDirection: LayoutDirection.vertical,
        );
        defaultPositions.setAmountItems(6);
        defaultPositions.setSize(width: 10, height: 30);

        final calculatedPositions = defaultPositions.calculate();
        final expectedPositions = [
          ItemPosition(number: 0, size: Size.square(10), offset: Offset(0, 0.0)),
          ItemPosition(number: 1, size: Size.square(10), offset: Offset(0, 5.0)),
          ItemPosition(number: 2, size: Size.square(10), offset: Offset(0, 10.0)),
          InfoItemPosition(
              number: 3, size: Size(10, 15), offset: Offset(0, 15.0), amountAdditionalItems: 3),
        ];

        expect(calculatedPositions, equals(expectedPositions));
      });

      test('align is right, info item has intent', () {
        final defaultPositions = RestrictedPositions(
          maxCoverage: 0.5,
          minCoverage: 0.5,
          align: StackAlign.right,
          infoItem: const InfoItem(indent: 50.0, size: 50),
        );
        defaultPositions.setAmountItems(35);
        defaultPositions.setSize(width: 200, height: 50);

        final calculatedPositions = defaultPositions.calculate();
        final expectedPositions = [
          ItemPosition(number: 0, size: Size.square(50), offset: Offset(0.0, 0)),
          ItemPosition(number: 1, size: Size.square(50), offset: Offset(25.0, 0)),
          ItemPosition(number: 2, size: Size.square(50), offset: Offset(50.0, 0)),
          ItemPosition(number: 3, size: Size.square(50), offset: Offset(75.0, 0)),
          InfoItemPosition(
              number: 4, size: Size(50, 50), offset: Offset(150.0, 0), amountAdditionalItems: 31),
        ];

        expect(calculatedPositions, equals(expectedPositions));
      });
    });

    test('hidden items exist - StackLaying first', () {
      final defaultPositions = RestrictedPositions(
        align: StackAlign.left,
        infoItem: const InfoItem(indent: 0, size: 15),
        laying: StackLaying.first,
        maxCoverage: 0.5,
        minCoverage: double.negativeInfinity,
      );
      defaultPositions.setAmountItems(6);
      defaultPositions.setSize(width: 30, height: 10);

      final calculatedPositions = defaultPositions.calculate();
      final expectedPositions = [
        InfoItemPosition(
          number: 3,
          size: Size(15, 10),
          offset: Offset(15.0, 0),
          amountAdditionalItems: 3,
        ),
        ItemPosition(number: 2, size: Size.square(10), offset: Offset(10.0, 0)),
        ItemPosition(number: 1, size: Size.square(10), offset: Offset(5.0, 0)),
        ItemPosition(number: 0, size: Size.square(10), offset: Offset(0.0, 0)),
      ];

      expect(calculatedPositions, equals(expectedPositions));
    });

    test('min coverage', () {
      final defaultPositions = RestrictedPositions(
        align: StackAlign.left,
        infoItem: const InfoItem(indent: 0, size: 15),
        laying: StackLaying.last,
        maxCoverage: 0.5,
        minCoverage: 0.5,
      );
      defaultPositions.setAmountItems(4);
      defaultPositions.setSize(width: 100, height: 10);

      final calculatedPositions = defaultPositions.calculate();
      final expectedPositions = [
        ItemPosition(number: 0, size: Size.square(10), offset: Offset(0.0, 0)),
        ItemPosition(number: 1, size: Size.square(10), offset: Offset(5.0, 0)),
        ItemPosition(number: 2, size: Size.square(10), offset: Offset(10.0, 0)),
        ItemPosition(number: 3, size: Size.square(10), offset: Offset(15.0, 0)),
      ];

      expect(calculatedPositions, equals(expectedPositions));
    });

    test('StackLaying first', () {
      final defaultPositions = RestrictedPositions(
        align: StackAlign.left,
        infoItem: const InfoItem.absent(),
        laying: StackLaying.first,
        maxCoverage: 0.8,
        minCoverage: double.negativeInfinity,
      );
      defaultPositions.setAmountItems(5);
      defaultPositions.setSize(width: 100, height: 20);

      final calculatedPositions = defaultPositions.calculate();
      final expectedPositions = [
        ItemPosition(number: 4, size: Size.square(20), offset: Offset(80.0, 0)),
        ItemPosition(number: 3, size: Size.square(20), offset: Offset(60.0, 0)),
        ItemPosition(number: 2, size: Size.square(20), offset: Offset(40.0, 0)),
        ItemPosition(number: 1, size: Size.square(20), offset: Offset(20.0, 0)),
        ItemPosition(number: 0, size: Size.square(20), offset: Offset(0.0, 0)),
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
        infoItem: const InfoItem.absent(),
        laying: StackLaying.last,
        maxCoverage: 0.8,
        minCoverage: double.negativeInfinity,
        layoutDirection: LayoutDirection.vertical,
      );
      defaultPositions.setAmountItems(5);
      defaultPositions.setSize(width: 20, height: 100);

      final calculatedPositions = defaultPositions.calculate();
      final expectedPositions = [
        ItemPosition(number: 0, size: Size.square(20), offset: Offset(0.0, 0)),
        ItemPosition(number: 1, size: Size.square(20), offset: Offset(0, 20.0)),
        ItemPosition(number: 2, size: Size.square(20), offset: Offset(0, 40.0)),
        ItemPosition(number: 3, size: Size.square(20), offset: Offset(0, 60.0)),
        ItemPosition(number: 4, size: Size.square(20), offset: Offset(0, 80.0)),
      ];

      expect(calculatedPositions, equals(expectedPositions));
    });
  });

  group('RestrictedAmountPositions -', () {
    test('hidden items are', () {
      final defaultPositions = RestrictedAmountPositions(
        align: StackAlign.left,
        infoItem: const InfoItem.absent(),
        laying: StackLaying.last,
        maxCoverage: 0.8,
        minCoverage: double.negativeInfinity,
        maxAmountItems: 3,
      );
      defaultPositions.setAmountItems(5);
      defaultPositions.setSize(width: 100, height: 20);

      final calculatedPositions = defaultPositions.calculate();
      final expectedPositions = [
        ItemPosition(number: 0, size: Size.square(20), offset: Offset(0.0, 0)),
        ItemPosition(number: 1, size: Size.square(20), offset: Offset(40.0, 0)),
        InfoItemPosition(
          number: 2,
          size: Size.square(20),
          offset: Offset(80.0, 0),
          amountAdditionalItems: 3,
        ),
      ];

      expect(calculatedPositions, equals(expectedPositions));
    });

    test('minCoverage is the same maxCoverage', () {
      final defaultPositions = RestrictedAmountPositions(
        align: StackAlign.left,
        infoItem: const InfoItem.absent(),
        laying: StackLaying.last,
        maxCoverage: 0.8,
        minCoverage: 0.8,
        maxAmountItems: 3,
      );
      defaultPositions.setAmountItems(5);
      defaultPositions.setSize(width: 100, height: 20);

      final calculatedPositions = defaultPositions.calculate();
      final expectedPositions = [
        ItemPosition(number: 0, size: Size.square(20), offset: Offset(0.0, 0)),
        ItemPosition(number: 1, size: Size.square(20), offset: Offset(4.0, 0)),
        InfoItemPosition(
          number: 2,
          size: Size.square(20),
          offset: Offset(8.0, 0),
          amountAdditionalItems: 3,
        ),
      ];

      expect(calculatedPositions, equals(expectedPositions));
    });

    test('align is centre', () {
      final defaultPositions = RestrictedAmountPositions(
        align: StackAlign.center,
        infoItem: const InfoItem.absent(),
        laying: StackLaying.last,
        maxCoverage: 0.8,
        minCoverage: 0.8,
        maxAmountItems: 3,
      );
      defaultPositions.setAmountItems(5);
      defaultPositions.setSize(width: 100, height: 20);

      final calculatedPositions = defaultPositions.calculate();
      final expectedPositions = [
        ItemPosition(number: 0, size: Size.square(20), offset: Offset(36.0, 0)),
        ItemPosition(number: 1, size: Size.square(20), offset: Offset(40.0, 0)),
        InfoItemPosition(
          number: 2,
          size: Size.square(20),
          offset: Offset(44.0, 0),
          amountAdditionalItems: 3,
        ),
      ];

      expect(calculatedPositions, equals(expectedPositions));
    });

    test('align is right', () {
      final defaultPositions = RestrictedAmountPositions(
        align: StackAlign.right,
        infoItem: const InfoItem.absent(),
        laying: StackLaying.last,
        maxCoverage: 0.8,
        minCoverage: 0.8,
        maxAmountItems: 3,
      );
      defaultPositions.setAmountItems(5);
      defaultPositions.setSize(width: 100, height: 20);

      final calculatedPositions = defaultPositions.calculate();
      final expectedPositions = [
        ItemPosition(number: 0, size: Size.square(20), offset: Offset(72.0, 0)),
        ItemPosition(number: 1, size: Size.square(20), offset: Offset(76.0, 0)),
        InfoItemPosition(
          number: 2,
          size: Size.square(20),
          offset: Offset(80.0, 0),
          amountAdditionalItems: 3,
        ),
      ];

      expect(calculatedPositions, equals(expectedPositions));
    });
  });
}
