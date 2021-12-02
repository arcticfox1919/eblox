import 'package:build/build.dart';
import 'package:eblox_generator/src/action_generator.dart';
import 'package:eblox_generator/src/blox_generator.dart';
import 'package:eblox_generator/src/state_generator.dart';
import 'package:source_gen/source_gen.dart';

Builder generateAction(BuilderOptions options) =>
    SharedPartBuilder([BloxActionGenerator()], 'action_generator');

Builder generateState(BuilderOptions options) =>
    SharedPartBuilder([BloxStateGenerator()], 'state_generator');


Builder generateBloX(BuilderOptions options) =>
    SharedPartBuilder([BloXGenerator()], 'blox_generator');