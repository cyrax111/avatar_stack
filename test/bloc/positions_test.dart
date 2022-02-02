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
    final item = ItemPosition(number: 2, position: 10.0);
    test('toString', () {
      expect(
          item.toString(), equals('ItemPosition(number: 2, position: 10.0)'));
    });

    test('hashCode', () {
      expect(item.hashCode, equals(8));
    });
  });

  group('InfoItemPosition -', () {
    final item =
        InfoItemPosition(number: 2, position: 10.0, amountAdditionalItems: 4);

    test('toString', () {
      expect(
          item.toString(),
          equals(
              'InfoItemPosition(number: 2, position: 10.0, additionalItems: 4)'));
    });

    test('hashCode', () {
      expect(item.hashCode, equals(12));
    });
  });
}
