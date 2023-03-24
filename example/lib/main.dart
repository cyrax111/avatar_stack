import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Example1Default(),
                      Indent(),
                      Example9StackLayingFirst(),
                      Indent(),
                      Example10StackLayingFive(),
                      Indent(),
                      Example8InfoIndent(),
                      Indent(),
                      Example2MaxAmount(),
                      Indent(),
                      Example3MaxAmountCenterAlign(),
                      Indent(),
                      Example4RightAlign(),
                      Indent(),
                      Example5MaxCoverage(),
                      Indent(),
                      Example6MinCoverage(),
                      Indent(),
                      Example7WidgetStack(),
                    ],
                  ),
                ),
              ),
            ),
            const Example11Vertical(),
            const RotatedBox(
              quarterTurns: 3,
              child: Example1Default(name: 'RotatedBox'),
            ),
          ],
        ),
      ),
    );
  }
}

class Indent extends StatelessWidget {
  const Indent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const SizedBox(height: 30);
}

class Example1Default extends StatelessWidget {
  const Example1Default({this.name = 'Default:', Key? key}) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(name),
        const SizedBox(height: 10),
        AvatarStack(
          height: 50,
          avatars: [for (var n = 0; n < 15; n++) NetworkImage(getAvatarUrl(n))],
        ),
      ],
    );
  }
}

class Example2MaxAmount extends StatelessWidget {
  const Example2MaxAmount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settings = RestrictedAmountPositions(
      maxAmountItems: 5,
      maxCoverage: 0.3,
      minCoverage: 0.1,
    );
    return Column(
      children: [
        const Text(
          'Restricted amount:',
        ),
        const SizedBox(height: 10),
        AvatarStack(
          settings: settings,
          height: 50,
          avatars: [for (var n = 0; n < 15; n++) NetworkImage(getAvatarUrl(n))],
        ),
      ],
    );
  }
}

class Example3MaxAmountCenterAlign extends StatelessWidget {
  const Example3MaxAmountCenterAlign({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settings = RestrictedAmountPositions(
      maxAmountItems: 4,
      maxCoverage: 0.3,
      minCoverage: 0.1,
      align: StackAlign.center,
    );
    return Column(
      children: [
        const Text(
          'Restricted amount with center alignment:',
        ),
        const SizedBox(height: 10),
        AvatarStack(
          settings: settings,
          height: 50,
          avatars: [for (var n = 0; n < 15; n++) NetworkImage(getAvatarUrl(n))],
        ),
      ],
    );
  }
}

class Example4RightAlign extends StatelessWidget {
  const Example4RightAlign({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settings = RestrictedPositions(
      maxCoverage: 0.3,
      minCoverage: 0.1,
      align: StackAlign.right,
    );
    return Column(
      children: [
        const Text(
          'Right alignment:',
        ),
        const SizedBox(height: 10),
        AvatarStack(
          height: 50,
          settings: settings,
          avatars: [for (var n = 0; n < 15; n++) NetworkImage(getAvatarUrl(n))],
        ),
      ],
    );
  }
}

class Example5MaxCoverage extends StatelessWidget {
  const Example5MaxCoverage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settings = RestrictedPositions(
      maxCoverage: 0.7,
      minCoverage: 0.1,
      align: StackAlign.right,
    );
    return Column(
      children: [
        const Text(
          'Max coverage is set to 70%:',
        ),
        const SizedBox(height: 10),
        AvatarStack(
          height: 50,
          settings: settings,
          avatars: [for (var n = 0; n < 40; n++) NetworkImage(getAvatarUrl(n))],
        ),
      ],
    );
  }
}

class Example6MinCoverage extends StatelessWidget {
  const Example6MinCoverage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settings = RestrictedPositions(
      maxCoverage: 0.3,
      minCoverage: -0.5,
    );
    return Column(
      children: [
        const Text(
          'Min coverage is set to minus 50%:',
        ),
        const SizedBox(height: 10),
        AvatarStack(
          height: 50,
          settings: settings,
          avatars: [for (var n = 0; n < 5; n++) NetworkImage(getAvatarUrl(n))],
        ),
      ],
    );
  }
}

class Example7WidgetStack extends StatelessWidget {
  const Example7WidgetStack({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settings = RestrictedPositions(
      maxCoverage: -0.1,
      minCoverage: -0.5,
      align: StackAlign.right,
    );
    return Column(
      children: [
        const Text(
          'Any widgets for stack:',
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 50,
          child: WidgetStack(
            positions: settings,
            stackedWidgets: [
              for (var n = 0; n < 12; n++)
                FlutterLogo(
                  style: FlutterLogoStyle.stacked,
                  textColor: Color(0xFF * 0x1000000 +
                      n * 10 * 0x10000 +
                      (0xFF - n * 10) * 0x100),
                ),
              const FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Text('A',
                      style: TextStyle(height: 0.9, color: Colors.orange))),
              const FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Text('B', style: TextStyle(height: 0.9))),
              const FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Text('C',
                      style: TextStyle(height: 0.9, color: Colors.green))),
            ],
            buildInfoWidget: (surplus) {
              return Center(
                  child: Text(
                '+$surplus',
                style: Theme.of(context).textTheme.headlineSmall,
              ));
            },
          ),
        ),
      ],
    );
  }
}

class Example8InfoIndent extends StatelessWidget {
  const Example8InfoIndent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settings = RestrictedPositions(
      maxCoverage: 0.3,
      minCoverage: 0.1,
      align: StackAlign.right,
      infoIndent: 15,
    );
    return Column(
      children: [
        const Text(
          'Indent of the info widget:',
        ),
        const SizedBox(height: 10),
        AvatarStack(
          height: 50,
          settings: settings,
          avatars: [for (var n = 0; n < 35; n++) NetworkImage(getAvatarUrl(n))],
          infoWidgetBuilder: (surplus) => _infoWidget(surplus, context),
        ),
      ],
    );
  }

  Widget _infoWidget(int surplus, BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          '+$surplus',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}

class Example9StackLayingFirst extends StatelessWidget {
  const Example9StackLayingFirst({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settings = RestrictedPositions(
      maxCoverage: 0.3,
      minCoverage: 0.1,
      laying: StackLaying.first,
    );
    return Column(
      children: [
        const Text(
          'The first item is at the top:',
        ),
        const SizedBox(height: 10),
        AvatarStack(
          height: 50,
          settings: settings,
          avatars: [for (var n = 0; n < 17; n++) NetworkImage(getAvatarUrl(n))],
        ),
      ],
    );
  }
}

class Example10StackLayingFive extends StatelessWidget {
  const Example10StackLayingFive({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settings = RestrictedPositions(
      maxCoverage: 0.3,
      minCoverage: 0.1,
      laying: const StackLaying(itemPositionNumberAtTop: 5),
    );
    return Column(
      children: [
        const Text('The fifth item is at the top:'),
        const SizedBox(height: 10),
        AvatarStack(
          height: 50,
          settings: settings,
          avatars: [for (var n = 0; n < 20; n++) NetworkImage(getAvatarUrl(n))],
        ),
      ],
    );
  }
}

class Example11Vertical extends StatelessWidget {
  const Example11Vertical({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settings = RestrictedPositions(
      maxCoverage: 0.3,
      minCoverage: 0.1,
      laying: const StackLaying(itemPositionNumberAtTop: 5),
      layoutDirection: LayoutDirection.vertical,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          const RotatedBox(quarterTurns: 3, child: Text('Vertical')),
          const SizedBox(width: 10),
          AvatarStack(
            width: 50,
            settings: settings,
            avatars: [
              for (var n = 0; n < 20; n++) NetworkImage(getAvatarUrl(n))
            ],
          ),
        ],
      ),
    );
  }
}

String getAvatarUrl(int n) {
  final url = 'https://i.pravatar.cc/150?img=$n';
  // final url = 'https://robohash.org/$n?bgset=bg1';
  return url;
}
