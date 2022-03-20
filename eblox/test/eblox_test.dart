import 'package:flutter_test/flutter_test.dart';

import 'package:eblox/eblox.dart';

void main() {
  test('adds one to input values', () {
    MyModel("xxx");
  });
}

class MyModel with Blox{
  MyModel._();
  factory MyModel(String string) = _MyModel;

  void _sub(){
    print("sub");
  }
}

// class _$MyModel extends MyModel{
//   _$MyModel._(){}
//
//
//   factory _$MyModel() = MyModel;
// }

class _MyModel extends MyModel{

  _MyModel(String string):super._(){
    print("_MyModel");
    onAction();

    super._sub();
  }


}