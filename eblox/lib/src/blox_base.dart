import 'dart:async';

import 'package:eblox/src/blox_provider.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math;

abstract class BloxAction {
  final List<dynamic>? positionalArguments;
  final Map<String, dynamic>? namedArguments;

  const BloxAction()
      : positionalArguments = null,
        namedArguments = null;

  const BloxAction.argsByName(this.namedArguments) : positionalArguments = null;

  const BloxAction.argsByPosition(this.positionalArguments)
      : namedArguments = null;

  void to<T extends Blox>() {
    var blox = I.find<T>();
    blox.add(this);
  }
}

enum BloxStatus{
  idle,loading,error,ok,none
}

abstract class BloxState<T>{}

abstract class BloxSingleState<T> extends BloxState{
  T data;

  BloxSingleState(this.data);
}

abstract class BloxAsyncState<T> extends BloxSingleState<T>{
  BloxAsyncState(T data) : super(data);

  BloxStatus status = BloxStatus.idle;

  dynamic errorMessage;

  BloxAsyncState<T> copy({T? data,BloxStatus? status,dynamic errorMessage});

  bool isEmpty(){
    bool b = false;
    if(data == null){
      b = true;
    }else if(data is List){
      b = (data as List).isEmpty;
    }else if(data is Map){
      b = (data as Map).isEmpty;
    }else if(data is Set){
      b = (data as Set).isEmpty;
    }
    return b;
  }
}


abstract class Blox{

  final Map<Type,Function> _registry = {};
  final Map<Type,BloxState> _states = {};

  final StreamController<BloxState> _stateController = StreamController.broadcast();
  final StreamController<BloxAction> _actionController = StreamController.broadcast();

  Blox(){
    _onAction();
  }

  void _onAction() {
    _actionController.stream.listen((action) {
      if (!handleAction(action)) {
        Type t = action.runtimeType;
        var func = _registry[t];
        if (func != null) {
          Function.apply(
              func,
              action.positionalArguments,
              action.namedArguments
                  ?.map((key, value) => MapEntry(Symbol(key), value)));
        }
      }
    });
  }

  void registerState(Map<Type,BloxState> states){
    _states.addAll(states);
  }

  void registerAction(Map<Type,Function> registry){
    _registry.addAll(registry);
  }

  bool handleAction(BloxAction action) => false;

  void add(BloxAction action){
    if(_actionController.isClosed) return;
    _actionController.add(action);
  }

  void emit(BloxState state){
    if(_stateController.isClosed) return;
    _stateController.add(state);
  }

  void dispose(){
    _stateController.close();
    _actionController.close();
  }
}

// ignore: must_be_immutable
class _BloxBase<T extends Blox> extends StatefulWidget {

  Stream<BloxState>? stream;
  late final Blox blox;
  bool unpack;

  _BloxBase({Key? key,T Function()? create,this.unpack = true}) : super(key: key){
    if(I.check<T>()){
      blox = I.find<T>();
    }else{
      assert(create != null);
      var _blox =  create!();
      I.put(_blox);
      blox = _blox;
    }
    stream = blox._stateController.stream;
  }

  bool condition(BloxState state) => false;

  void onListen(BloxState state){}

  Widget build(){return Container();}

  @override
  _BloxBaseState createState() => _BloxBaseState();
}

class _BloxBaseState extends State<_BloxBase> {
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _subscribe();
  }

  @override
  void dispose() {
    _unsubscribe();
    widget.blox.dispose();
    if(I.check(instance: widget.blox)) I.delete(instance: widget.blox);
    super.dispose();
  }

  void _subscribe() {
    if(widget.stream != null){
      var stream = widget.stream!.where((state) {
        return widget.condition(state);
      });

      widget.stream = stream;

      _subscription = widget.stream!.listen((state) {
        setState(() {
          widget.onListen(state);
        });
      });
    }
  }

  void _unsubscribe() {
    if (_subscription != null) {
      _subscription!.cancel();
      _subscription = null;
    }
  }

  @override
  Widget build(BuildContext context) => widget.build();
}

typedef BloxStateFilter = List<Type> Function();


// ignore: must_be_immutable
class MultiBuilder<T extends Blox> extends _BloxBase<T>{
  final BloxStateFilter filter;
  final Function builder;
  final Map<Type,BloxState> states = {};


  MultiBuilder({Key? key,required this.filter,required this.builder,bool unpack=true}) : super(key: key,unpack: unpack){
    for (var type in filter()) {
      states[type] = blox._states[type]!;
    }
  }

  @override
  void onListen(BloxState state){
    for(var type in states.keys){
      if(_compare(state.runtimeType, type)){
        states[type] = state;
      }
    }
  }

  @override
  bool condition(BloxState state){
    return filter().every((type)=> _compare(state.runtimeType,type));
  }

  bool _compare(Type current,Type restrict){
    var cur = current.toString();
    var res = restrict.toString();
    var len = math.min(cur.length,res.length);
    for(var i = 0;i<len;i++){
      if(cur[i] == '<' || res[i] == '<') break;
      if(cur[i] != res[i]) return false;
    }
    return true;
  }

  @override
  Widget build() {
    return Function.apply(
        builder,
        states.values.map((e){
          if(unpack && e is BloxSingleState){
            return e.data;
          }
          return e;
        }).toList()
    );
  }
}

// ignore: must_be_immutable
class BloxBuilder<T extends Blox,S extends BloxState> extends _BloxBase<T> {

  late S currentState;
  final Function builder;

  BloxBuilder({Key? key,required this.builder,bool unpack=true}) : super(key: key,unpack: unpack){
    for (var state in blox._states.values) {
      if(state is S) currentState = state;
    }
  }

  @override
  void onListen(BloxState state){
    currentState = state as S;
  }

  @override
  bool condition(BloxState state){
    return state is S;
  }

  @override
  Widget build() {
    return Function.apply(
        builder,
        unpack && currentState is BloxSingleState
            ? [(currentState as BloxSingleState).data]
            : [currentState]);
  }
}