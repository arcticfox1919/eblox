import 'package:flutter/widgets.dart';

import '../eblox.dart';
import 'blox_base.dart';
import 'blox_state.dart';

class BloxView<T extends Blox, S extends BloxAsyncState>
    extends StatelessWidget {
  final Widget Function()? onLoading;
  final Widget Function()? onEmpty;
  final Widget Function(dynamic message)? onError;
  final Widget Function(S state) builder;
  final void Function(BloxProvider injection)? inject;

  const BloxView({Key? key,
    this.onLoading,
    this.onEmpty,
    this.onError,
    this.inject,
    required this.builder})
      : super(key: key);

  _checkFunction(Function? f) => f != null;

  @override
  Widget build(BuildContext context) {
    late BloxBuilder bloxBuilder;
    bloxBuilder = BloxBuilder<T, S>(
        inject: inject,
        builder: (state) {
          if (state is BloxAsyncState) {
            var status = state.status;
            if (status == BloxStatus.loading && _checkFunction(onLoading)) {
              return onLoading!();
            } else if (status == BloxStatus.error && _checkFunction(onError)) {
              return onError!(state.errorMessage);
            } else if (status == BloxStatus.none && _checkFunction(onEmpty)) {
              return onEmpty!();
            } else {
              return builder(state as S);
            }
          }
        },
        unpack: false);
    return bloxBuilder;
  }
}
