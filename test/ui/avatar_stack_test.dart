import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'image.dart';

void main() {
  testWidgets('WidgetStack', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: SizedBox(
            height: 50,
            width: 200,
            child: AvatarStack(
                avatars: List.generate(
                    30, (index) => MemoryImage(kTransparentImage))),
          ),
        ),
      ),
    );

    final widgetStack = find.byType(WidgetStack);
    expect(widgetStack, findsOneWidget);

    await expectLater(widgetStack, matchesGoldenFile('avatar_stack.png'));
  });
}
