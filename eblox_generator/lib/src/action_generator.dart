import 'package:analyzer/dart/element/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/analysis/results.dart';

import 'package:eblox_generator/src/template/action.dart';
import 'package:eblox_generator/src/utils.dart';

import 'package:source_gen/source_gen.dart';
import 'package:eblox_annotation/src/annotations.dart';
import 'base_generator.dart';

class BloxActionGenerator extends GeneratorForAnnotatedMethod<ActionX> {
  @override
  String generateForAnnotatedMethod(
      MethodElement method, ConstantReader annotation) {

    if(method.displayName.startsWith('_')){
      var cr = annotation.peek('name');
      var actionName = method.displayName.replaceFirst('_', '');
      var className = cr == null ? '${actionName.capitalize()}Action': cr.stringValue;
      var visitor = ActionVisitor(className);
      visitor.visitMethodElement(method);
      if (visitor.template != null) return visitor.template.toString();
    }else{
      throw Exception('Please use the "_" prefix to declare the action method:[${method.displayName}] !');
    }
    return '';
  }
}


class ActionVisitor extends SimpleElementVisitor<void> {
  String className;

  ActionVisitor(this.className);

  ActionTemplate? template;

  @override
  void visitMethodElement(MethodElement element) {
    var params = element.parameters;
    if (params.isNotEmpty) {
      var parameter = StringBuffer();

      if (params.every((p) => p.isPositional)) {
        var positionalArgs = [];
        var len = params.length;
        for (var i = 0; i < len; i++) {
          var str = i == (len - 1)
              ? '${params[i].type} ${params[i].name}'
              : '${params[i].type} ${params[i].name},';

          positionalArgs.add(params[i].name);
          parameter.write(str);
        }
        template = ActionTemplate(className,
            isPositional: true,
            parameter: parameter.toString(),
            positionalArgs: positionalArgs);
      } else if (params.every((p) => p.isNamed)) {
        Map<String, dynamic>? namedArgs = {};
        parameter.write('{');
        params.forEach((e) {
          var str = e.isRequiredNamed
              ? 'required ${e.type} ${e.name},'
              : '${e.type} ${e.name},';
          parameter.write(str);
          namedArgs["'${e.name}'"] = e.name;
        });
        parameter.write('}');

        template = ActionTemplate(className,
            isPositional: false,
            parameter: parameter.toString(),
            namedArgs: namedArgs);
      } else {
        throw Exception(
            'The annotated method [${element.displayName}] parameter is wrong! It can only be a named parameter or a positional parameter.');
      }
    } else {
      template = ActionTemplate(className);
    }
  }

  AstNode getAstNodeFromElement(Element element) {
    var session = element.session!;
    var parsedLibResult = session.getParsedLibraryByElement(element.library!) as ParsedLibraryResult;
    var elDeclarationResult = parsedLibResult.getElementDeclaration(element);
    return elDeclarationResult!.node;
  }
}
