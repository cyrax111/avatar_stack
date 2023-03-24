import 'package:avatar_stack/positions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('StackLaying', () {
    expect(
      () => StackLaying(itemPositionNumberAtTop: -1, infoItemAtTop: false),
      throwsAssertionError,
    );
  });
}
