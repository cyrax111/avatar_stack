import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WidgetStack -', () {
    testWidgets('golden - usual behavior', (WidgetTester tester) async {
      final settings = RestrictedPositions(maxCoverage: 0.6, minCoverage: 0.6);
      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: Container(
              key: const Key('WidgetStack'),
              height: 50,
              width: 200,
              color: Colors.blueGrey,
              child: WidgetStack(
                positions: settings,
                stackedWidgets: List.generate(30, (index) => const Item()),
                buildInfoWidget: (surplus, context) => const InfoItem(),
              ),
            ),
          ),
        ),
      );

      final widgetStack = find.byKey(const Key('WidgetStack'));
      expect(widgetStack, findsOneWidget);

      expect(find.byType(Item), findsNWidgets(7));
      expect(find.byType(InfoItem), findsOneWidget);

      await expectLater(widgetStack, matchesGoldenFile('widget_stack.png'));
    });

    testWidgets('not enough space', (WidgetTester tester) async {
      final widgetStack = MaterialApp(
        home: Center(
          child: SizedBox(
            height: 0,
            width: 200,
            child: WidgetStack(
              positions: RestrictedPositions(),
              stackedWidgets: List.generate(30, (index) => const Item()),
              buildInfoWidget: (surplus, context) => const InfoItem(),
            ),
          ),
        ),
      );
      await tester.pumpWidget(widgetStack);

      expect(find.byType(WidgetStack), findsOneWidget);

      expect(find.byType(Item), findsNothing);
      expect(find.byType(InfoItem), findsNothing);
    });
  });
}

class Item extends StatelessWidget {
  const Item({super.key});

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

class InfoItem extends StatelessWidget {
  const InfoItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.green);
  }
}
