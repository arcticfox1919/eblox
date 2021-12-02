import 'package:get_it/get_it.dart';

abstract class Provider {
  void put<T extends Object>(T dependency, {String? tag});

  T find<T extends Object>({String? tag});

  bool check<T extends Object>({T? instance, String? tag});

  bool delete<T extends Object>({T? instance, String? tag});
}

class SimpleProvider implements Provider {
  factory SimpleProvider() => _instance ??= SimpleProvider._();

  static SimpleProvider? _instance;

  SimpleProvider._();

  static final Map<Symbol, _InstanceInfo> _single = {};

  @override
  void put<T extends Object>(T dependency, {String? tag}) {
    final key = _getKey(T, tag);
    _single.putIfAbsent(key, () => _InstanceInfo<T>(dependency));
  }

  @override
  T find<T extends Object>({String? tag}) {
    final newKey = _getKey(T, tag);
    var info = _single[newKey];

    if (info?.value != null) {
      return info!.value;
    } else {
      throw '"$T" not found. You need to call "Easy.put($T())""';
    }
  }

  @override
  bool delete<T extends Object>({T? instance, String? tag}) {
    final newKey = _getKey(T, tag);
    if (!_single.containsKey(newKey)) {
      return false;
    }
    _single.remove(newKey);
    return true;
  }

  Symbol _getKey(Type type, String? name) {
    return name == null ? #type : Symbol(name);
  }

  @override
  bool check<T extends Object>({T? instance, String? tag}) {
    throw UnimplementedError();
  }
}

class _InstanceInfo<T> {
  _InstanceInfo(this.value);

  T value;
}

const BloxProvider I = BloxProvider();

T $<T extends Object>({String? tag}) {
  return I.find<T>(tag: tag);
}

final getIt = GetIt.instance;

class BloxProvider implements Provider {
  const BloxProvider();

  @override
  bool delete<T extends Object>({T? instance, String? tag}) {
    getIt.unregister<T>(instanceName: tag);
    return true;
  }

  @override
  T find<T extends Object>({String? tag}) {
    return getIt.get<T>(instanceName: tag);
  }

  @override
  void put<T extends Object>(T dependency, {String? tag}) {
    getIt.registerSingleton<T>(dependency, instanceName: tag);
  }

  @override
  bool check<T extends Object>({T? instance, String? tag}) {
    return getIt.isRegistered<T>(instanceName: tag);
  }
}
