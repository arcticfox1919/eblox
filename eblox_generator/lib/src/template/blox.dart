import '../blox_generator.dart';

class BloxTemplate {
  final String className;

  final Map<String, String> actionFields;
  final Map<String, StateFieldInfo> stateFields;
  List<ActionMethodInfo> actionMethods;
  bool isMixin;

  BloxTemplate(
      this.className, this.actionMethods, this.actionFields, this.stateFields,this.isMixin);

  String get name => className;

  @override
  String toString() {
    var newClzName = '_$className';

    var stateBuff = StringBuffer();
    var mixinField = StringBuffer();
    if (stateFields.isNotEmpty) {
      stateFields.forEach((type, info) {
        if(info.isAsync){
          stateBuff.writeln('final $type<${info.valueType}> __${info.name} = $type<${info.valueType}>(${info.initialValue});');
          if(isMixin) stateBuff.writeln('@override');
          stateBuff.writeln('$type<${info.valueType}> get ${info.name} => __${info.name}.copy(data:_${info.name});');
        }else{
          if(isMixin) stateBuff.writeln('@override');
          stateBuff.writeln('$type<${info.valueType}> get ${info.name} => $type<${info.valueType}>(_${info.name});');
        }

        mixinField.writeln('$type<${info.valueType}> get ${info.name} => throw UnimplementedError("${info.name}");');
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
          mtBuff.writeln('bool r = super.${m.displayName}(${m.callParam});');
          mtBuff.writeln('if(r){');
          mtBuff.writeln('emit($getter);');
          mtBuff.writeln('}');
          mtBuff.writeln('return r;');
          mtBuff.writeln('}');
          mtBuff.writeln();
        }
      });
    }

    var registerAction =
        actionFields.isNotEmpty ? 'registerAction($actionFields);' : '';
    var registerState =
        stateFields.isNotEmpty ? 'registerState(${stateFields.map((k, v) => MapEntry(k, v.name))});' : '';


    var mixinBlock = isMixin ? '''
        mixin _\$$className{
          $mixinField
        }
    ''' : '';

    return '''
    class $newClzName extends $className{
    
      $newClzName():super._(){
          $registerAction
          $registerState
          onAction();
          super.init();
      }
    
      $stateBuff
      
      $mtBuff
    }
    
    $mixinBlock
    ''';
  }
}
