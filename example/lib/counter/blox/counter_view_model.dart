

import 'package:eblox/eblox.dart';
import 'package:eblox_annotation/eblox_annotation.dart';
import 'package:flutter/cupertino.dart';

part 'counter_view_model.g.dart';

@blox
class CounterVModel with Blox,_$CounterVModel{
  CounterVModel._();
  factory CounterVModel() = _CounterVModel;

  @override
  void init() {

  }

  @StateX()
  int _counter = 0;

  @ActionX(bind: 'CounterState')
  bool _add(){
    _counter ++;
    return true;
  }

  @ActionX(bind: 'CounterState')
  bool _sub(){
    if(_counter > 0){
      _counter--;
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint('CounterVModel dispose...');
  }
}