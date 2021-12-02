

import 'package:eblox/eblox.dart';
import 'package:eblox_annotation/eblox_annotation.dart';
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