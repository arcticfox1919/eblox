

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:eblox_annotation/src/annotations.dart';
import 'package:eblox_generator/src/template/blox.dart';
import 'package:eblox_generator/src/utils.dart';
import 'package:source_gen/source_gen.dart';

import 'base_generator.dart';



class BloXVisitor extends SimpleElementVisitor<void> {

  BloXVisitor(this.buildStep);

  String? className;
  BuildStep buildStep;

  Map<String, String> actionFields = {};
  Map<String, StateFieldInfo> stateFields = {};
  List<ActionMethodInfo> actionMethods = [];

  @override
  void visitConstructorElement(ConstructorElement element) {
    className = element.type.returnType.toString();
    if(!className!.startsWith('_')){
      throw Exception(
          'Please use the "_" prefix to declare the [$className] !');
    }
  }

  @override
  void visitFieldElement(FieldElement element) {
    final annotation = getAnnotation<StateBase>(element);
    if (annotation != null) {
      var reader = ConstantReader(annotation);
      if (element.displayName.startsWith('_')) {
        var stateName = element.name.replaceFirst('_', '');
        var cr = reader.peek('name');
        var stateType =
            cr == null ? '${stateName.capitalize()}State' : cr.stringValue;
        var initialValue = element.hasInitializer
            ? getAstFromElement(element).childEntities.last.toString()
            : 'null';
        var r = reader.instanceOf(TypeChecker.fromRuntime(StateX));

        stateFields[stateType] = StateFieldInfo(stateType, stateName,element.type.toString(),
            isAsync: !r, initialValue: initialValue);
      } else {
        throw Exception(
            'Please use the "_" prefix to declare the state field:[${element.name}] !');
      }
    }
  }

  @override
  void visitMethodElement(MethodElement element) {
    final annotation =  getAnnotation<ActionX>(element);
    if (annotation != null) {
      if(element.displayName.startsWith('_')){
        var cr = ConstantReader(annotation).peek('name');
        var actionName = element.name.replaceFirst('_', '');
        var actionType = cr == null ? '${actionName.capitalize()}Action': cr.stringValue;

        actionFields[actionType] = '${element.displayName}';
        var bindState = ConstantReader(annotation).read('bind').stringValue;
        var bindAsync = getAnnotation<BindAsync>(element) != null;
        _parseBindState(element,bindState,bindAsync);
      }else{
        throw Exception('Please use the "_" prefix to declare the action method:[${element.displayName}] !');
      }
    }
  }

  void _parseBindState(MethodElement element, String bindState, bool bindAsync) {
    var params = element.parameters;
    var parameter = '';
    if (params.isNotEmpty) {
      if (params.every((p) => p.isPositional)) {
        parameter = params.map((e) => e.name).join(',');
      } else if (params.every((p) => p.isNamed)) {
        parameter = params.map((e) => '${e.name}:${e.name}').join(',');
        parameter = '{$parameter}';
      } else {
        throw Exception(
            'The annotated method [${element.displayName}] parameter is wrong! It can only be a named parameter or a positional parameter.');
      }
    }
    actionMethods.add(ActionMethodInfo(element.displayName,
        element.declaration.toString(), parameter, bindState,bindAsync));
  }
}

AstNode getAstFromElement(Element element) {
  var parsedLibResult = element.session!.getParsedLibraryByElement(element.library!);
  return (parsedLibResult as ParsedLibraryResult).getElementDeclaration(element)!.node;
}

class StateFieldInfo{
  String type;
  String name;
  bool isAsync;
  String initialValue;
  String valueType;

  StateFieldInfo(this.type,this.name,this.valueType,{this.isAsync=false,this.initialValue='null'});
}

class ActionMethodInfo{

  ActionMethodInfo(this.displayName,this.declaration,this.callParam,this.bindState,[this.isAsyncState=false]);

  String displayName;
  String declaration;
  String callParam;
  String bindState;
  bool isAsyncState;
}

class BloXGenerator extends GeneratorForAnnotation<BloX>{

  @override
  String generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    final visitor = BloXVisitor(buildStep);
    element.visitChildren(visitor);
    var template = BloxTemplate(visitor.className!, visitor.actionMethods,
        visitor.actionFields,visitor.stateFields);
    return template.toString();
  }
}
