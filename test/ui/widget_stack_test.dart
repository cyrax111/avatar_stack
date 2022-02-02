import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('WidgetStack', (WidgetTester tester) async {
    final settings = RestrictedPositions(maxCoverage: 0.6);
    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: SizedBox(
            height: 50,
            width: 200,
            child: WidgetStack(
              positions: settings,
              stackedWidgets: List.generate(30, (index) => const Wrapper()),
              buildInfoWidget: (surplus) => Container(color: Colors.green),
            ),
          ),
        ),
      ),
    );

    final widgetStack = find.byType(WidgetStack);
    expect(widgetStack, findsOneWidget);

    await expectLater(widgetStack, matchesGoldenFile('widget_stack.png'));
  });
}

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange,
        border: Border.all(),
      ),
    );
  }
}
