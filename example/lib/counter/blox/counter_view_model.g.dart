// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_view_model.dart';

// **************************************************************************
// BloxActionGenerator
// **************************************************************************

class AddAction extends BloxAction {}

class SubAction extends BloxAction {}

// **************************************************************************
// BloXGenerator
// **************************************************************************

class CounterVModel extends _CounterVModel {
  CounterVModel() {
    registerAction({AddAction: _add, SubAction: _sub});
    registerState({CounterState: counter});
  }

  CounterState<int> get counter => CounterState<int>(_counter);

  @override
  void _add() {
    super._add();
    emit(counter);
  }

  @override
  void _sub() {
    super._sub();
    emit(counter);
  }
}

// **************************************************************************
// BloxStateGenerator
// **************************************************************************

class CounterState<T> extends BloxSingleState<T> {
  CounterState(data) : super(data);
}
