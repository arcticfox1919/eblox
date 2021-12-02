



import 'package:build_test/build_test.dart';
import 'package:eblox_generator/src/action_generator.dart';
import 'package:source_gen/source_gen.dart';

void main() {
  testBuilder(SharedPartBuilder([BloxActionGenerator()], 'action_generator'),{});
}
