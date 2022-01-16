# Avatar stack package for Flutter

Avatar stack is used to visually represent users, places, and things in an app.

![Example](https://github.com/cyrax111/blob/raw/master/avatar_stack/feature1.gif?raw=true)

## Installation

First, add `avatar_stack` as a [dependency in your pubspec.yaml file](https://flutter.dev/using-packages/).

## Example

```dart
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
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Example:',
              ),
              const SizedBox(height: 20),
              AvatarStack(
                height: 50,
                avatars: [
                  for (var n = 0; n < 15; n++)
                    NetworkImage('https://i.pravatar.cc/150?img=$n'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

You also can use the example from github [https://github.com/cyrax111/avatar_stack/tree/master/example](https://github.com/cyrax111/avatar_stack/tree/master/example)