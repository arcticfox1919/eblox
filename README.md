# EbloX

An easy Flutter state management library.It is similar to Bloc, but it uses a lot of annotations and separates business logic from UI through the concepts of **Action** and **State**.

**Simpler, more reliable, easier to test !**

## Example

An example of a common counter.

Add dependency:
```yaml
dependencies:
  eblox:
  eblox_annotation:

dev_dependencies:
  build_runner:
  eblox_generator:

```

New `counter_view_model.dart`

```dart
import 'package:eblox/blox.dart';
import 'package:eblox_annotation/blox.dart';
import 'package:flutter/cupertino.dart';

part 'counter_view_model.g.dart';

@bloX
class _CounterVModel extends Blox{

  @StateX(name:'CounterState')
  int _counter = 0;

  @ActionX(bind: 'CounterState')
  void _add() async{
    _counter ++;
  }

  @ActionX(bind: 'CounterState')
  void _sub(){
    _counter--;
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint('CounterVModel dispose...');
  }
}
```

Execute `flutter pub run build_runner watch --delete-conflicting-outputs` command will generate the `counter_view_model.g.dart` file in the current directory.

It will automatically generate **Action** and **State** for us. Next, write the UI and use these Actions.

```dart
import 'package:eblox/blox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'blox/counter_view_model.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:BloxBuilder<CounterVModel,CounterState>(
            create:()=>CounterVModel(),
            builder: (count) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("$count"),
                    ElevatedButton(
                      onPressed: () {
                        AddAction().to<CounterVModel>();
                      },
                      child: const Text("+"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        SubAction().to<CounterVModel>();
                      },
                      child: const Text("-"),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
```
**So easy!**


## Usage
