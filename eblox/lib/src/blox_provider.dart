import 'package:eblox/eblox.dart';
// import 'package:get_it/get_it.dart';

abstract class Provider {
  void inject<T extends Blox>(T dependency, {String? tag,bool shared});

  T find<T extends Blox>({String? tag});

  bool check<T extends Blox>({T? instance, String? tag});

  bool delete<T extends Blox>({T? instance, String? tag});
}

class BloxProvider implements Provider {


  factory BloxProvider() => _instance ??= const BloxProvider._();

  static BloxProvider? _instance;

  const BloxProvider._();

  static final Map<Symbol, _InstanceInfo> _single = {};

  @override
  void inject<T extends Blox>(T dependency, {String? tag,bool shared=false}) {
    final key = _getKey(T, tag);
    var instance = _InstanceInfo<T>(dependency);
    if(shared){
      if(_single.containsKey(key)){
        instance = _single[key]! as _InstanceInfo<T>;
        instance.incCount();
      }else{
        instance.isShared = true;
        instance.incCount();
        _single[key] = instance;
      }
    }else{
      _single[key] = instance;
    }
  }

  @override
  T find<T extends Blox>({String? tag}) {
    final newKey = _getKey(T, tag);
    var info = _single[newKey];

    if (info?.value != null) {
      return info!.value;
    } else {
      throw '"$T" not found. You need to call "BloxProvider.inject($T())""';
    }
  }

  @override
  bool delete<T extends Blox>({T? instance, String? tag}) {
    final key = _getKey(T, tag);
    if (!_single.containsKey(key)) {
      return false;
    }

    var info = _single[key];
    if(info!.isShared){
      info.decCount();
    }

    if(info.isReleased){
      _single.remove(key);
    }
    return true;
  }

  Symbol _getKey(Type type, String? name) {
    return name == null ? #type : Symbol(name);
  }

  @override
  bool check<T extends Blox>({T? instance, String? tag}) {
    final key = _getKey(T, tag);
    return _single.containsKey(key);
  }
}

class _InstanceInfo<T> {
  _InstanceInfo(this.value);

  T value;
  int _refCount = 0;
  bool isShared = false;

  void incCount(){
    _refCount ++;
  }

  void decCount(){
    _refCount --;
  }

  bool get isReleased => _refCount == 0;

}

final It = BloxProvider();

T $<T extends Blox>({String? tag}) {
  return It.find<T>(tag: tag);
}

void $$<T extends Blox>(BloxAction action,{String? tag}) {
  var blox = It.find<T>(tag: tag);
  blox.add(action);
}

// final getIt = GetIt.instance;

// class BloxProvider implements Provider {
//   const BloxProvider();
//
//   @override
//   bool delete<T extends Blox>({T? instance, String? tag}) {
//     getIt.unregister<T>(instanceName: tag);
//     return true;
//   }
//
//   @override
//   T find<T extends Blox>({String? tag}) {
//     return getIt.get<T>(instanceName: tag);
//   }
//
//   @override
//   void inject<T extends Blox>(T dependency, {String? tag,bool shared=false}) {
//     getIt.registerSingleton<T>(dependency, instanceName: tag);
//   }
//
//   @override
//   bool check<T extends Blox>({T? instance, String? tag}) {
//     return getIt.isRegistered<T>(instanceName: tag);
//   }
// }
