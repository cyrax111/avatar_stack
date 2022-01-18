# Avatar stack package for Flutter

Avatar stack is used to visually represent users, places, and things in an app.

![Example](https://github.com/cyrax111/blob/raw/master/avatar_stack/feature1.gif?raw=true)


## Features


### Restrict amount of items
Usually the stack avatar shows all items as possible but you can restrict it by, say, five items.
![Restrict amount of items](https://github.com/cyrax111/blob/raw/master/avatar_stack/restricted_amount.gif?raw=true)


### Alignment
By default the stack avatar has left alignment one can change it.
#### *center alignment*
![center alignment](https://github.com/cyrax111/blob/raw/master/avatar_stack/center_alignment.gif?raw=true)
#### *right alignment*
![right alignment](https://github.com/cyrax111/blob/raw/master/avatar_stack/right_alignment.gif?raw=true)


### Coverage
You can set how avatars will coverage each others. 
#### *max coverage is set to 70%*
![max coverage is set to 70%](https://github.com/cyrax111/blob/raw/master/avatar_stack/max_coverage.gif?raw=true)
#### *min coverage is set to minus 50%*
The negative coverage will set space between items.
![min coverage is set to minus 50%](https://github.com/cyrax111/blob/raw/master/avatar_stack/min_coverage.gif?raw=true)


### Any widget for stack
You can use any widget to stack not only avatars
![Any widget for stack](https://github.com/cyrax111/blob/raw/master/avatar_stack/stack_widgets.gif?raw=true)


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

You can also use the example from github [https://github.com/cyrax111/avatar_stack/tree/master/example](https://github.com/cyrax111/avatar_stack/tree/master/example)