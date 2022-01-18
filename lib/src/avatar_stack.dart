import 'package:flutter/material.dart';

import 'widget_stack.dart';

import 'positions/positions.dart';
import 'positions/restricted_positions.dart';

class AvatarStack extends StatelessWidget {
  const AvatarStack({
    Key? key,
    required this.avatars,
    this.settings,
    this.infoWidgetBuilder,
    this.width,
    this.height,
    this.borderWidth,
    this.borderColor,
  }) : super(key: key);

  final List<ImageProvider<Object>> avatars;
  final Positions? settings;
  final InfoWidgetBuilder? infoWidgetBuilder;
  final double? width;
  final double? height;
  final double? borderWidth;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final _settings =
        settings ?? RestrictedPositions(maxCoverage: 0.3, minCoverage: 0.1);

    final border = BorderSide(
        color: borderColor ?? Theme.of(context).colorScheme.onPrimary,
        width: borderWidth ?? 2.0);

    Widget _textInfoWidgetBuilder(surplus) => BorderedCircleAvatar(
        border: border,
        child: FittedBox(
            fit: BoxFit.contain,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '+$surplus',
                style: Theme.of(context).textTheme.headline6,
              ),
            )));
    final _infoWidgetBuilder = infoWidgetBuilder ?? _textInfoWidgetBuilder;

    return SizedBox(
      height: height,
      width: width,
      child: WidgetStack(
        positions: _settings,
        buildInfoWidget: _infoWidgetBuilder,
        stackedWidgets: avatars
            .map((avatar) => BorderedCircleAvatar(
                  border: border,
                  backgroundImage: avatar,
                ))
            .toList(),
      ),
    );
  }
}

class BorderedCircleAvatar extends StatelessWidget {
  const BorderedCircleAvatar({
    Key? key,
    this.border = const BorderSide(),
    this.backgroundImage,
    this.child,
  }) : super(key: key);

  final BorderSide border;
  final ImageProvider<Object>? backgroundImage;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: border.color,
      child: ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: Padding(
          padding: EdgeInsets.all(border.width),
          child: CircleAvatar(
            backgroundImage: backgroundImage,
            child: child,
          ),
        ),
      ),
    );
  }
}
