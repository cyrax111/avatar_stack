import 'package:avatar_stack/avatar_stack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../await_images.dart';
import 'image.dart';

void main() {
  testWidgets('AvatarStack', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: SizedBox(
            height: 50,
            width: 200,
            child: AvatarStack(
              avatars: List.generate(30, (index) => MemoryImage(orangeImage)),
              infoWidgetBuilder: (surplus, context) => BorderedCircleAvatar(
                backgroundImage: MemoryImage(orangeImage),
                border: BorderSide(color: Theme.of(context).colorScheme.onPrimary, width: 2.0),
                child: Text(surplus.toString()),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.awaitImages();

    final widgetStack = find.byType(AvatarStack);
    expect(widgetStack, findsOneWidget);

    await expectLater(widgetStack, matchesGoldenFile('avatar_stack.png'));
  });
}
