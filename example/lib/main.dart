import 'package:avatar_stack/avatar_stack.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: AvatarStackExample()));
}

class AvatarStackExample extends StatelessWidget {
  const AvatarStackExample({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Example')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Example1(),
              SizedBox(height: 50),
              Example2MaxAmount(),
            ],
          ),
        ),
      ),
    );
  }
}

class Example1 extends StatelessWidget {
  const Example1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Default:',
        ),
        const SizedBox(height: 10),
        AvatarStack(
          height: 50,
          avatars: [
            for (var n = 0; n < 15; n++)
              NetworkImage('https://i.pravatar.cc/150?img=$n')
          ],
        ),
      ],
    );
  }
}

class Example2MaxAmount extends StatelessWidget {
  const Example2MaxAmount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settings = RestrictedAmountPositionsWithInfoItem(
      maxAmountItems: 5,
      maxCoverage: 0.3,
      minCoverage: 0.1,
    );
    return Column(
      children: [
        const Text(
          'RestrictedAmountPositionsWithInfoItem:',
        ),
        const SizedBox(height: 10),
        AvatarStack(
          settings: settings,
          height: 50,
          avatars: [
            for (var n = 0; n < 15; n++)
              NetworkImage('https://i.pravatar.cc/150?img=$n')
          ],
        ),
      ],
    );
  }
}
