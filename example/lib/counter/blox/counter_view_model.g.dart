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

class _CounterVModel extends CounterVModel {
  _CounterVModel() : super._() {
    registerAction({AddAction: _add, SubAction: _sub});
    registerState({CounterState: counter});
    onAction();
    super.init();
  }

  @override
  CounterState<int> get counter => CounterState<int>(_counter);

  @override
  bool _add() {
    bool r = super._add();
    if (r) {
      emit(counter);
    }
    return r;
  }

  @override
  bool _sub() {
    bool r = super._sub();
    if (r) {
      emit(counter);
    }
    return r;
  }
}

mixin _$CounterVModel {
  CounterState<int> get counter => throw UnimplementedError("counter");
}

// **************************************************************************
// BloxStateGenerator
// **************************************************************************

class CounterState<T> extends BloxSingleState<T> {
  CounterState(data) : super(data);
}
