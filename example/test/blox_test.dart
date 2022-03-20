
import 'package:eblox/eblox.dart';
import 'package:example/counter/blox/counter_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  const len = 10;
  group('Counter test', () {
    setUp(() {
      It.inject(CounterVModel());
    });

    tearDown(() {
      It.delete<CounterVModel>();
    });

    test('test add counter', () {
      for(var i = 0;i<len;i++){
        $$<CounterVModel>(AddAction());
      }
      expect(Future(() => $<CounterVModel>().counter.data), completion(len));
    });

    test('test sub counter', () {
      for(var i = 0;i<len;i++){
        $$<CounterVModel>(SubAction());
      }
      expect(Future(() => $<CounterVModel>().counter.data), completion(0));
    });
  });
}