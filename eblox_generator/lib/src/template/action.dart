class ActionTemplate {
  final String className;
  final bool isPositional;
  final String? parameter;
  final List<dynamic>? positionalArgs;
  final Map<String, dynamic>? namedArgs;

  ActionTemplate(this.className, {this.isPositional = false, this.parameter,this.positionalArgs,this.namedArgs});

  @override
  String toString() {
    var construction = '';
    if (parameter != null) {
      construction = isPositional
          ? '$className($parameter):super.argsByPosition($positionalArgs);'
          : '$className($parameter):super.argsByName($namedArgs);';
    }

    return '''
    class $className extends BloxAction{
      $construction
    }
    ''';
  }
}

