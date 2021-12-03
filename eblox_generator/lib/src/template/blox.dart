import '../blox_generator.dart';

class BloxTemplate {
  final String className;

  final Map<String, String> actionFields;
  final Map<String, StateFieldInfo> stateFields;
  List<ActionMethodInfo> actionMethods;

  BloxTemplate(
      this.className, this.actionMethods, this.actionFields, this.stateFields);

  String get name => className;

  @override
  String toString() {
    var newClzName = className.replaceFirst('_', '');

    var stateBuff = StringBuffer();
    if (stateFields.isNotEmpty) {
      stateFields.forEach((type, info) {
        if(info.isAsync){
          stateBuff.writeln('final $type<${info.valueType}> __${info.name} = $type<${info.valueType}>(${info.initialValue});');
          stateBuff.writeln('$type<${info.valueType}> get ${info.name} => __${info.name}.copy(data:_${info.name});');
        }else{
          stateBuff.writeln('$type<${info.valueType}> get ${info.name} => $type<${info.valueType}>(_${info.name});');
        }
      });
    }

    var mtBuff = StringBuffer();
    if (actionMethods.isNotEmpty) {
      actionMethods.forEach((m) {
        mtBuff.writeln('@override');
        mtBuff.write(m.declaration);
        mtBuff.writeln('{');

        var getter = stateFields[m.bindState]!.name;
        if(m.isAsyncState){
          mtBuff.write('''
              var task = super.${m.displayName}(${m.callParam});
              runZoned(task,
                zoneSpecification: ZoneSpecification(run: <R>(self, parent, zone, f) {
                __$getter.status = BloxStatus.loading;
                emit(__$getter.copy());
                var r = f();
                (r as Future).then((result) {
                 _$getter = result;
                 __$getter.data = result;
                 __$getter.status = __$getter.isEmpty() ? BloxStatus.none:BloxStatus.ok;
                  emit($getter);
                });
                return r;
               },handleUncaughtError: (self, parent, zone,error, stackTrace) {
                  __$getter.status = BloxStatus.error;
                  debugPrint(error.toString());
                  emit(__$getter.copy(errorMessage:error));
                }));
          return task;
          ''');
          mtBuff.writeln('}');
          mtBuff.writeln();
        }else{
          mtBuff.writeln('super.${m.displayName}(${m.callParam});');
          mtBuff.writeln('emit($getter);');
          mtBuff.writeln('}');
          mtBuff.writeln();
        }
      });
    }

    var registerAction =
        actionFields.isNotEmpty ? 'registerAction($actionFields);' : '';
    var registerState =
        stateFields.isNotEmpty ? 'registerState(${stateFields.map((k, v) => MapEntry(k, v.name))});' : '';
    return '''
    class $newClzName extends $className{
    
      $newClzName(){
          $registerAction
          $registerState
      }
    
      $stateBuff
      
      $mtBuff
    }
    ''';
  }
}
