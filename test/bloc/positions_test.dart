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
    final item = ItemPosition(number: 2, x: 10.0, y: 0, size: 10.0);

    test('toString', () {
      expect(item.toString, returnsNormally);
    });

    test('hashCode', () {
      expect(() => item.hashCode, returnsNormally);
    });
  });

  group('InfoItemPosition -', () {
    final item = InfoItemPosition(
        number: 2, x: 10.0, y: 0, size: 10.0, amountAdditionalItems: 4);

    test('toString', () {
      expect(item.toString, returnsNormally);
    });

    test('hashCode', () {
      expect(() => item.hashCode, returnsNormally);
    });
  });
}
