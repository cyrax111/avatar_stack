import 'package:avatar_stack/animated_avatar_stack.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: AnimatedAvatarStack(
            height: 50,
            avatars: [
              for (var n = 0; n < 15; n++) NetworkImage('https://i.pravatar.cc/150?img=$n'),
            ],
          ),
        ),
      ),
    ));
