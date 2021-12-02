
import 'package:eblox/blox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'blox/counter_view_model.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:BloxBuilder<CounterVModel,CounterState>(
            create:()=>CounterVModel(),
            builder: (count) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("$count"),
                    ElevatedButton(
                      onPressed: () {
                        AddAction().to<CounterVModel>();
                      },
                      child: const Text("+"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        SubAction().to<CounterVModel>();
                      },
                      child: const Text("-"),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
