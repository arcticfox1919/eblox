
import 'package:eblox/blox.dart';
import 'package:example/counter/blox/counter_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  const len = 10;
  group('Counter test', () {
    setUp(() {
      I.put(CounterVModel());
    });

    tearDown(() {
      I.delete<CounterVModel>();
    });

    test('test add counter', () {
      for(var i = 0;i<len;i++){
        AddAction().to<CounterVModel>();
      }
      expect(Future(() => $<CounterVModel>().counter.data), completion(len));
    });

    test('test sub counter', () {
      for(var i = 0;i<len;i++){
        SubAction().to<CounterVModel>();
      }
      expect(Future(() => $<CounterVModel>().counter.data), completion(-10));
    });
  });
}