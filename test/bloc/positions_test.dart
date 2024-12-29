import 'dart:ui';

import 'package:avatar_stack/positions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('StackLaying', () {
    expect(
      () => StackLaying(itemPositionNumberAtTop: -1, infoItemAtTop: false),
      throwsAssertionError,
    );
  });

  group('ItemPosition -', () {
    final item = ItemPosition(number: 2, offset: Offset(10.0, 0), size: Size.square(10.0));

    test('toString', () {
      expect(item.toString, returnsNormally);
    });

    test('hashCode', () {
      expect(() => item.hashCode, returnsNormally);
    });
  });

  group('InfoItemPosition -', () {
    final item = InfoItemPosition(
        number: 2, offset: Offset(10.0, 0), size: Size.square(10.0), amountAdditionalItems: 4);

    test('toString', () {
      expect(item.toString, returnsNormally);
    });

    test('hashCode', () {
      expect(() => item.hashCode, returnsNormally);
    });
  });
}
