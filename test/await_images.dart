import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

extension AwaitImages on WidgetTester {
  /// Pauses test until images are ready to be rendered.
  Future<void> awaitImages() async {
    await runAsync(() async {
      for (final element in find.byType(Image).evaluate().toList()) {
        final widget = element.widget as Image;
        final image = widget.image;
        await precacheImage(image, element);
        await pump();
      }

      for (final element in find.byType(FadeInImage).evaluate().toList()) {
        final widget = element.widget as FadeInImage;
        final image = widget.image;
        final pumpDurationInMilliseconds = max(
          widget.fadeInDuration.inMilliseconds,
          widget.fadeOutDuration.inMilliseconds,
        );
        await precacheImage(image, element);
        await pump(Duration(milliseconds: pumpDurationInMilliseconds));
      }

      for (final element in find.byType(DecoratedBox).evaluate().toList()) {
        final widget = element.widget as DecoratedBox;
        final decoration = widget.decoration;
        if (decoration is BoxDecoration) {
          final image = decoration.image?.image;
          if (image != null) {
            await precacheImage(image, element);
            await pump();
          }
        }
      }
    });
  }
}
