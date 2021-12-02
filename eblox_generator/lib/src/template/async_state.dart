class AsyncStateTemplate {
  final String className;


  AsyncStateTemplate(this.className);

  @override
  String toString() {
    return '''
    class $className<T> extends BloxAsyncState<T>{
      $className(data) : super(data);
      
      @override
      $className<T> copy({T? data, BloxStatus? status, errorMessage}) {
        var d = data ?? this.data;
        status ??= this.status;
        errorMessage ??= this.errorMessage;

        return $className<T>(d)..status=status..errorMessage=errorMessage;
      }
    }
    ''';
  }
}

