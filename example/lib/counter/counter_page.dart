
import 'package:eblox/eblox.dart';
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
            inject:(injection)=> injection.inject(CounterVModel()),
            builder: (count) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("$count"),
                    ElevatedButton(
                      onPressed: () {
                        $$<CounterVModel>(AddAction());
                      },
                      child: const Text("+"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        $$<CounterVModel>(SubAction());
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
