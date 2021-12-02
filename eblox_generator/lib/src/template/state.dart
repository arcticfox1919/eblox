class StateTemplate {
  final String className;


  StateTemplate(this.className);

  @override
  String toString() {
    return '''
    class $className<T> extends BloxSingleState<T>{
      $className(data) : super(data);
    }
    ''';
  }
}

