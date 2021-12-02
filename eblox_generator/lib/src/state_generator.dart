import 'package:analyzer/dart/element/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:eblox_generator/src/template/async_state.dart';
import 'package:eblox_generator/src/template/state.dart';
import 'package:eblox_generator/src/utils.dart';

import 'package:source_gen/source_gen.dart';
import 'package:eblox_annotation/src/annotations.dart';
import 'base_generator.dart';

class BloxStateGenerator extends GeneratorForAnnotatedField<StateBase> {

  @override
  String generateForAnnotatedField(FieldElement field, ConstantReader annotation) {
    if(field.displayName.startsWith('_')){
      var stateName = field.displayName.replaceFirst('_', '');
      var cr = annotation.peek('name');
      var className = cr == null ? '${stateName.capitalize()}State': cr.stringValue;

      var r = annotation.instanceOf(TypeChecker.fromRuntime(StateX));
      var visitor = r ? StateXVisitor(className): AsyncStateXVisitor(className);
      visitor.visitFieldElement(field);
      return visitor.getTemplate();
    }else{
      throw Exception('Please use the "_" prefix to declare the state field:[${field.name}] !');
    }
  }
}


abstract class StateBaseVisitor<R> extends SimpleElementVisitor<R>{
  late String className;

  String getTemplate();
}

class StateXVisitor extends StateBaseVisitor{

  @override
  String className;

  StateXVisitor(this.className);

  StateTemplate template  = StateTemplate('');

  @override
  void visitFieldElement(FieldElement element) {
      template = StateTemplate(className);
  }

  @override
  String getTemplate() {
    return template.toString();
  }

}

class AsyncStateXVisitor extends StateBaseVisitor{
  @override
  String className;

  AsyncStateXVisitor(this.className);

  AsyncStateTemplate template = AsyncStateTemplate('');

  @override
  void visitFieldElement(FieldElement element) {
    template = AsyncStateTemplate(className);
  }

  @override
  String getTemplate() {
    return template.toString();
  }

}