import 'dart:async';

import 'package:avatar_stack/animated_avatar_stack.dart';
import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
import 'package:flutter/material.dart' hide Action;

/// Animated widget that animates transition for adding, removing, moving stacked widget.
/// Usually it is used in [widgetChangeBuilder].
///
/// Example:
/// ```dart
/// AnimatedWidgetStack(
///   positions: positions,
///   stackedWidgets: stackedWidgets,
///   widgetChangeBuilder: (context, action, constraints) {
///     return WidgetWithParameters(
///       widget: DefaultAnimatedAction(
///         key: action.key,
///         action: action,
///         size: constraints.biggest,
///         infoWidgetBuilder: _infoItemBuilder,
///       ),
///     );
///   },
/// );
class DefaultAnimatedAction extends StatefulWidget {
  const DefaultAnimatedAction({
    super.key,
    required this.action,
    required this.size,
    required this.infoWidgetBuilder,
    this.animationDuration = const Duration(milliseconds: 1400),
  });

  final Action action;
  final Size size;
  final InfoWidgetBuilder infoWidgetBuilder;
  final Duration animationDuration;

  @override
  State<DefaultAnimatedAction> createState() => _DefaultAnimatedActionState();
}

class _DefaultAnimatedActionState extends State<DefaultAnimatedAction>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: widget.animationDuration,
    vsync: this,
  );

  late Animation<Rect?> _animation;
  late Animatable<Rect?> _rectTween;
  late Rect _itemPositionRect;
  late Rect _oldItemPositionRect;

  late int _amountAdditionalItems;
  late bool _isInfoWidget;

  @override
  void initState() {
    super.initState();

    final itemPosition = widget.action.itemPosition;
    if (itemPosition is InfoItemPosition) {
      _amountAdditionalItems = itemPosition.amountAdditionalItems;
      _isInfoWidget = true;
    } else {
      _amountAdditionalItems = 0;
      _isInfoWidget = false;
    }

    _itemPositionRect = itemPosition.rect;

    if (widget.action.type == ActionType.added) {
      final isVerticalLayout = widget.size.height > widget.size.width;
      if (isVerticalLayout) {
        _oldItemPositionRect = Offset(widget.size.width / 2, -2 * widget.size.width) & Size.zero;
      } else {
        _oldItemPositionRect = Offset(-2 * widget.size.height, widget.size.height / 2) & Size.zero;
      }
      _controller.forward(from: 0.0);
    } else {
      _oldItemPositionRect = _itemPositionRect;
    }

    _setRectTween(_oldItemPositionRect, Curves.elasticOut);
    _animation = _controller.drive(_rectTween);
  }

  @override
  void didUpdateWidget(covariant DefaultAnimatedAction oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.action.itemPosition.rect != _itemPositionRect) {
      _oldItemPositionRect = _itemPositionRect;
      final curve = _setNewItemPositionRectAndCurve();
      final beginRect = _setBeginRect();
      _setInfoWidgetTransition(oldWidget);
      _setRectTween(beginRect, curve);
      _animation = _controller.drive(_rectTween);
      _controller.forward(from: 0.0);
    }
  }

  void _setRectTween(Rect? beginRect, Curve curve) {
    _rectTween = RectTween(
      begin: beginRect,
      end: _itemPositionRect,
    ).chain(CurveTween(
      curve: curve,
    ));
  }

  void _setInfoWidgetTransition(DefaultAnimatedAction oldWidget) {
    final itemPosition = widget.action.itemPosition;
    final oldItemPosition = oldWidget.action.itemPosition;
    final needSwitchToInfoItem =
        itemPosition is InfoItemPosition && oldItemPosition is! InfoItemPosition;
    final needSwitchFromInfoItem =
        itemPosition is! InfoItemPosition && oldItemPosition is InfoItemPosition;
    final dontNeedSwitchFromInfoItem =
        itemPosition is InfoItemPosition && oldItemPosition is InfoItemPosition;
    if (needSwitchToInfoItem) {
      _amountAdditionalItems = itemPosition.amountAdditionalItems;
      _isInfoWidget = false;
      Timer(Duration.zero, () {
        if (mounted) {
          _isInfoWidget = true;
          setState(() {});
        }
      });
    } else if (needSwitchFromInfoItem) {
      _isInfoWidget = true;
      Timer(Duration.zero, () {
        if (mounted) {
          _isInfoWidget = false;
          setState(() {});
        }
      });
    }
    if (dontNeedSwitchFromInfoItem) {
      _isInfoWidget = true;
    } else {
      // don't need to switch
      _isInfoWidget = false;
    }
  }

  Rect? _setBeginRect() {
    final Rect? beginRect;
    if (_controller.isCompleted) {
      beginRect = _oldItemPositionRect;
    } else {
      beginRect = _rectTween.evaluate(_controller);
    }
    return beginRect;
  }

  Curve _setNewItemPositionRectAndCurve() {
    final Curve curve;
    switch (widget.action.itemPosition.runtimeType) {
      case const (HiddenItemPosition):
      case const (RemovedPosition):
        _itemPositionRect = _oldItemPositionRect.center & Size.zero;
        curve = Curves.easeOutExpo;
        break;
      default:
        _itemPositionRect = widget.action.itemPosition.rect;
        curve = Curves.elasticOut;
    }
    return curve;
  }

  @override
  Widget build(BuildContext context) {
    return RelativePositionedTransition(
      size: widget.size,
      rect: _animation,
      child: SizedBox.fromSize(
        size: widget.action.itemPosition.size,
        child: AnimatedSwitcher(
            duration: widget.animationDuration,
            switchInCurve: Curves.easeOutQuart,
            switchOutCurve: Curves.easeInQuart,
            // https://github.com/flutter/flutter/issues/121336
            transitionBuilder: (Widget child, Animation<double> animation) => FadeTransition(
                  // key: ValueKey<Key?>(child.key),
                  opacity: animation,
                  child: child,
                ),
            child: _isInfoWidget
                ? widget.infoWidgetBuilder(_amountAdditionalItems, context)
                : widget.action.stackedWidget),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
