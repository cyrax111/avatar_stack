import 'package:avatar_stack/positions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'animated_avatar_stack_example.dart';
import 'animated_widget_stack_example.dart';
import 'get_avatar.dart';

class AvatarStackExample extends StatefulWidget {
  const AvatarStackExample({Key? key}) : super(key: key);

  @override
  State<AvatarStackExample> createState() => _AvatarStackExampleState();
}

class _AvatarStackExampleState extends State<AvatarStackExample> {
  @override
  Widget build(BuildContext context) {
    final horizontal = <Widget>[
      const Indent(),
      AnimatedAvatarStackExample(stackedWidgets: _stackedImages, positions: _positions),
      const Indent(),
      AnimatedAvatarStackExample(
          name: 'Wide info item',
          stackedWidgets: _stackedImages,
          positions: _positions,
          infoItem: const InfoItem(indent: 50, size: 100)),
      const Indent(),
      AnimatedAvatarStackExample(
        name: 'Max item amount is restricted with 5',
        stackedWidgets: _stackedImages,
        positions: _positions,
        maxAmountItems: 5,
      ),
      const Indent(),
      AnimatedAvatarStackExample(
        name: 'The first item is at the top',
        stackedWidgets: _stackedImages,
        positions: _positions,
        laying: StackLaying.first,
      ),
      const Indent(),
      AnimatedWidgetStackExample(
        name: 'Any widget stack',
        stackedWidgets: _stackedWidgets,
        positions: _positions,
        // laying: StackLaying.first,
      ),
      const SizedBox(height: 1000),
    ];

    final vertical = <Widget>[
      AnimatedAvatarStackExample(
        name: 'Vertical layout',
        stackedWidgets: _stackedImages,
        layoutDirection: LayoutDirection.vertical,
        positions: _positions,
      ),
      RotatedBox(
        quarterTurns: 3,
        child: AnimatedAvatarStackExample(
          name: 'RotatedBox',
          stackedWidgets: _stackedImages,
          positions: _positions,
        ),
      ),
    ];

    return Scaffold(
      appBar: _AppBar(),
      bottomSheet: _bottomSheet(),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 8.8, right: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 32, right: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: horizontal,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Row(children: vertical),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomSheet() {
    const space = 16.0;
    return BottomSheet(
      onClosing: () {},
      elevation: 8.0,
      enableDrag: false,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: space, vertical: space),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: space,
            runSpacing: space,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _index++;
                    _stackedImages = _stackedImages.toList() //
                      ..insert(0, _generateImage(_index));
                    _stackedWidgets = _stackedWidgets.toList() //
                      ..insert(0, _generateWidget(_index));
                  });
                },
                child: const Text('Add'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (_stackedImages.isNotEmpty) {
                      _stackedImages = _stackedImages.toList() //
                        ..removeAt(0);
                      _stackedWidgets = _stackedWidgets.toList() //
                        ..removeAt(0);
                    }
                  });
                },
                child: const Text('Remove'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _stackedImages = _stackedImages.toList()..shuffle();
                    _stackedWidgets = _stackedWidgets.toList()..shuffle();
                  });
                  setState(() {});
                },
                child: const Text('Shuffle'),
              ),
              SegmentedButton<StackAlign>(
                direction: Axis.horizontal,
                segments: const [
                  ButtonSegment(
                    value: StackAlign.left,
                    icon: Icon(Icons.align_horizontal_left),
                  ),
                  ButtonSegment(
                    value: StackAlign.center,
                    icon: Icon(Icons.align_horizontal_center),
                  ),
                  ButtonSegment(
                    value: StackAlign.right,
                    icon: Icon(Icons.align_horizontal_right),
                  ),
                ],
                selected: {_positions.align},
                emptySelectionAllowed: false,
                onSelectionChanged: (selected) =>
                    setState(() => _positions = _positions.copyWith(align: selected.first)),
              ),
              Column(
                children: [
                  Text('Min coverage: ${(_positions.minCoverage * 100).toInt()}%'),
                  Slider(
                    label: '${(_positions.minCoverage * 100).toInt()}',
                    min: -1.0,
                    max: 0.8,
                    value: _positions.minCoverage,
                    divisions: 20,
                    onChanged: (minCoverage) {
                      if (minCoverage > _positions.maxCoverage) {
                        return;
                      }
                      setState(() {
                        _positions = _positions.copyWith(minCoverage: minCoverage);
                      });
                    },
                  ),
                ],
              ),
              Column(
                children: [
                  Text('Max coverage: ${(_positions.maxCoverage * 100).toInt()}%'),
                  Slider(
                    label: '${(_positions.maxCoverage * 100).toInt()}',
                    min: -1.0,
                    max: 0.8,
                    value: _positions.maxCoverage,
                    divisions: 20,
                    onChanged: (maxCoverage) {
                      if (_positions.minCoverage > maxCoverage) {
                        return;
                      }
                      setState(() {
                        _positions = _positions.copyWith(maxCoverage: maxCoverage);
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  late List<ImageProvider> _stackedImages;
  late List<Widget> _stackedWidgets;
  late RestrictedPositions _positions = RestrictedPositions(minCoverage: -0.18, maxCoverage: 0.26);
  late int _index;

  @override
  void initState() {
    super.initState();

    _index = 5;
    _stackedImages =
        List.generate(_index, (index) => index).map((index) => _generateImage(index)).toList();

    _stackedWidgets =
        List.generate(_index, (index) => index).map((index) => _generateWidget(index)).toList();
  }

  ImageProvider _generateImage(int index) => getAvatar(index);
  Widget _generateWidget(int index) => FlutterLogo(
        key: ValueKey(index),
        size: double.infinity,
        style: FlutterLogoStyle.stacked,
        textColor: Color(0xFF * 0x1000000 + index * 0x10000 + (0xFF - index * 10) * 0x100),
      );
}

class _AppBar extends AppBar {
  _AppBar()
      : super(
            title: SelectableText.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Avatar Stack',
                style: const TextStyle(color: Colors.blue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launchUrl(Uri.parse('https://pub.dev/packages/avatar_stack'));
                  },
              ),
              const TextSpan(
                text: ' Example',
              ),
            ],
          ),
        ));
}

class Indent extends StatelessWidget {
  const Indent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const SizedBox(height: 30);
}

void main() {
  runApp(MaterialApp(
    title: 'Avatar Stack Example',
    themeMode: ThemeMode.light,
    theme: ThemeData(
      colorSchemeSeed: const Color(0xff6750a4),
      useMaterial3: true,
      brightness: Brightness.light,
    ),
    darkTheme: ThemeData(
      colorSchemeSeed: const Color(0xff6750a4),
      useMaterial3: true,
      brightness: Brightness.dark,
    ),
    home: const AvatarStackExample(),
  ));
}
