import 'dart:async';

import 'package:flutter/material.dart';

class AvatarProvider {
  AvatarProvider([this.cacheCapacity = avatarsAmount]);
  final int cacheCapacity;

  static const int avatarsAmount = 200;

  Future<void> precacheImages(BuildContext context) async {
    for (var i = 0; i < cacheCapacity; i++) {
      _precacheImage(i, context);
    }
  }

  ImageProvider getAvatar(int n, BuildContext context) {
    // unawaited(_precacheImage(n + cacheCapacity, context));
    final image = AssetImage(_getPath(n));
    return image;
  }

  String _getPath(int n) {
    return 'assets/avatar/avatar_$n.png';
  }

  Future<void> _precacheImage(int n, BuildContext context) async {
    if (_precached.contains(n)) {
      return;
    }
    final image = AssetImage(_getPath(n));
    await precacheImage(image, context);
    _precached.add(n);
  }

  final Set<int> _precached = {};
}

class PrecacheLoading extends StatefulWidget {
  const PrecacheLoading({super.key, required AvatarProvider avatarProvider, required this.child})
      : _avatarProvider = avatarProvider;

  final AvatarProvider _avatarProvider;
  final Widget child;

  @override
  State<PrecacheLoading> createState() => _PrecacheLoadingState();
}

class _PrecacheLoadingState extends State<PrecacheLoading> {
  Future<void>? _isImagesPrecached;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _isImagesPrecached ??= widget._avatarProvider.precacheImages(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _isImagesPrecached,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return widget.child;
          } else {
            return const Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text('Precaching avatars'),
                  ),
                ],
              ),
            );
          }
        });
  }
}
