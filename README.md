# EbloX

An easy Flutter state management library.It is similar to Bloc, but it uses a lot of annotations and separates business logic from UI through the concepts of **Action** and **State**.

![](https://gitee.com/arcticfox1919/ImageHosting/raw/master/img/2021-12-02-001.png)

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

Derive a class from Blox, where we write business logic. This is the ViewModel in MVVM. Note that in order to facilitate annotation to generate code, the class must use the `_` prefix. Finally, we used the `@bloX` annotation on this class.



`@StateX` is used to decorate the state we need, it will automatically generate a State class with a specified name for packaging the modified data:

```dart
// **************************************************************************
// BloxStateGenerator
// **************************************************************************

class CounterState<T> extends BloxSingleState<T> {
  CounterState(data) : super(data);
}
```

If you do not specify a name, the state class will be generated according to the default rules. E.g:

```dart
@StateX()
Color _color = Colors.white; 
```

Will generate `ColorState`.



`@ActionX` is used to generate the Action class, and the name can also be specified. The `bind` is used to specify which State class to associate this Action with. In addition, it also associates the decorated method with the generated Action, and this method is called when the Action is sent.



An `@AsyncX` annotation is also currently provided to decorate asynchronous state:

```dart
part 'search_view_model.g.dart';

@bloX
class _SearchVModel extends Blox{

  @AsyncX(name: 'SongListState')
  SongListModel _songModel = SongListModel();

  @ActionX(bind: 'SongListState',bindAsync: true)
  Future<SongListModel> _search(String name){
    return SearchService.search(name);
  }
}
```

`@ActionX` decorated method can also declare parameters, the generated class will automatically include:

```dart
// **************************************************************************
// BloxActionGenerator
// **************************************************************************

class SearchAction extends BloxAction {
  SearchAction(String name) : super.argsByPosition([name]);
}
```

The method associated with the asynchronous state should always return a Future, which wraps the data that needs to be loaded asynchronously.

In the UI, you can use `BloxView` to handle asynchronous states:

```dart
class SearchPage extends StatelessWidget {
  SearchPage({Key? key}) : super(key: key);

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Song search'),),
      body: SafeArea(
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  suffix: IconButton(
                icon: const Icon(Icons.search_rounded),
                onPressed: (){
                  if(_controller.text.isNotEmpty) {
                    SearchAction(_controller.text).to<SearchVModel>();
                  }
                },
              )),
            ),
            Flexible(
                child: BloxView<SearchVModel, SongListState<SongListModel>>(
              create: () => SearchVModel(),
              onLoading: () => const Center(child: CircularProgressIndicator()),
              onEmpty: ()=> const Center(child: Text("Empty")),
              builder: (state) {
                return ListView.builder(
                    itemCount: state.data.songs.length,
                    itemBuilder: (ctx, i) {
                      return Container(
                        alignment: Alignment.center,
                        height: 40,
                        child: Text(state.data.songs[i],style: const TextStyle(color: Colors.blueGrey,fontSize: 20),),
                      );
                    });
              },
            )),
          ],
        ),
      ),
    );
  }
}

```

`BloxView` provides `onLoading`, `onEmpty`, `builder` to handle the UI display during and after loading.

![](https://gitee.com/arcticfox1919/ImageHosting/raw/master/img/GIF2021-12-3_1-36-46.gif)

Please check [here](https://github.com/arcticfox1919/eblox/tree/main/example/lib) for detailed examples.
