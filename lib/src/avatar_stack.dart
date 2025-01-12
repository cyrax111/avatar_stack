// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';

import 'positions/positions.dart';
import 'positions/restricted_positions.dart';
import 'widget_stack.dart';

/// Draws avatar stack which is presented by [ImageProvider].
///
/// An example of using avatars from Internet:
/// ```dart
/// AvatarStack(
///   height: 50,
///   avatars: [
///       NetworkImage('https://i.pravatar.cc/150?img=1'),
///       NetworkImage('https://i.pravatar.cc/150?img=2'),
///       NetworkImage('https://i.pravatar.cc/150?img=3'),
///   ],
/// ),
/// ```
///
/// If height or width are not set is gets them from parent.
class AvatarStack extends StatelessWidget {
  const AvatarStack({
    super.key,
    required this.avatars,
    this.settings,
    this.infoWidgetBuilder,
    this.width,
    this.height,
    this.borderWidth,
    this.borderColor,
  });

  /// List of avatars.
  /// If you have avatars in Internet you can use [NetworkImage],
  /// for assets you can use [ExactAssetImage]
  /// for file you can use [FileImage]
  final List<ImageProvider<Object>> avatars;

  /// Algorithm for calculating positions
  final Positions? settings;

  /// Callback for drawing information of hidden widgets. Something like: (+7)
  final InfoWidgetBuilder? infoWidgetBuilder;

  /// Width of area the avatar stack is placed in.
  /// If [width] is not set it will be get from parent.
  final double? width;

  /// Height of the each elements of the avatar stack.
  /// If [height] is not set it will be get from parent.
  final double? height;

  /// Thickness of the avatar border
  final double? borderWidth;

  /// Color of the avatar border
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final _settings = settings ?? RestrictedPositions(maxCoverage: 0.3, minCoverage: 0.1);

    final border = BorderSide(
        color: borderColor ?? Theme.of(context).colorScheme.onPrimary, width: borderWidth ?? 2.0);

    Widget _textInfoWidgetBuilder(int surplus, BuildContext context) => BorderedCircleAvatar(
        border: border,
        child: FittedBox(
            fit: BoxFit.contain,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '+$surplus',
                style: Theme.of(context).textTheme.titleLarge,
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

/// Draws the avatar with border
class BorderedCircleAvatar extends StatelessWidget {
  const BorderedCircleAvatar({
    super.key,
    this.border = const BorderSide(),
    this.backgroundImage,
    this.backgroundColor,
    this.constraints = const BoxConstraints(),
    this.child,
  });

  final BorderSide border;
  final ImageProvider<Object>? backgroundImage;
  final Color? backgroundColor;
  final Widget? child;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: constraints,
      child: CircleAvatar(
        backgroundColor: border.color,
        child: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: Padding(
            padding: EdgeInsets.all(border.width),
            child: CircleAvatar(
              backgroundImage: backgroundImage,
              backgroundColor: backgroundColor,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
