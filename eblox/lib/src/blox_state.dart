
import '../eblox.dart';

enum BloxStatus {loading, error, ok, none }

abstract class BloxState<T> {}

abstract class BloxSingleState<T> extends BloxState {
  T data;

  BloxSingleState(this.data);
}

abstract class BloxAsyncState<T> extends BloxSingleState<T> {
  BloxAsyncState(T data) : super(data);

  BloxStatus status = BloxStatus.none;

  dynamic errorMessage;

  BloxAsyncState<T> copy({T? data, BloxStatus? status, dynamic errorMessage});

  bool isEmpty() {
    bool b = false;
    if (data == null) {
      b = true;
    } else if (data is List) {
      b = (data as List).isEmpty;
    } else if (data is Map) {
      b = (data as Map).isEmpty;
    } else if (data is Set) {
      b = (data as Set).isEmpty;
    } else if(data is BloxData){
      b = (data as BloxData).isEmpty;
    }
    return b;
  }
}