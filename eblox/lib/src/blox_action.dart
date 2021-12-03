import '../eblox.dart';

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