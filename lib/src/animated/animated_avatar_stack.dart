import 'package:avatar_stack/animated_avatar_stack.dart';
import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
import 'package:flutter/material.dart';

/// Draws avatar stack like [AvatarStack] and animates changes.
///
/// An example of using avatars from Internet:
/// ```dart
/// AnimatedAvatarStack(
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
class AnimatedAvatarStack extends StatelessWidget {
  const AnimatedAvatarStack({
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
  /// for assets you can use [ExactAssetImage],
  /// for file you can use [FileImage].
  /// [hashCode] is used to distinguish images from each other.
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
    final positions = settings ?? RestrictedPositions(maxCoverage: 0.3, minCoverage: 0.1);

    final border = BorderSide(
        color: borderColor ?? Theme.of(context).colorScheme.onPrimary, width: borderWidth ?? 2.0);

    Widget textInfoWidgetBuilder(int surplus, BuildContext context) => BorderedCircleAvatar(
          border: border,
          constraints: BoxConstraints.expand(),
          child: FittedBox(
            fit: BoxFit.contain,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '+$surplus',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
        );
    final infoBuilder = infoWidgetBuilder ?? textInfoWidgetBuilder;

    return SizedBox(
      height: height,
      width: width,
      child: AnimatedWidgetStack(
        positions: positions,
        widgetChangeBuilder: (context, action, constraints) {
          return WidgetWithParameters(
            widget: DefaultAnimatedAction(
              key: action.key,
              action: action,
              size: constraints.biggest,
              infoWidgetBuilder: infoBuilder,
            ),
          );
        },
        stackedWidgets: avatars
            .map((avatar) => BorderedCircleAvatar(
                  key: ValueKey<int>(avatar.hashCode),
                  border: border,
                  backgroundImage: avatar,
                  constraints: BoxConstraints.expand(),
                ))
            .toList(),
      ),
    );
  }
}
