// import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/avatar_stack.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: AvatarStackExample()));
}

class AvatarStackExample extends StatefulWidget {
  const AvatarStackExample({Key? key}) : super(key: key);

  @override
  State<AvatarStackExample> createState() => _AvatarStackExampleState();
}

class _AvatarStackExampleState extends State<AvatarStackExample> {
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
                'Examples:',
              ),
              AvatarStack(
                height: 50,
                avatars: [
                  for (var n = 0; n < 30; n++)
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
