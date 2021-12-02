
import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/constant/value.dart';

abstract class GeneratorForAnnotatedMethod<AnnotationType> extends Generator {

  @override
  String generate(LibraryReader library, BuildStep buildStep) {
    final values = <String>{};
    for (final element in library.allElements) {
      if (element is ClassElement && !element.isEnum) {
        for (final method in element.methods) {
          final annotation = getAnnotation<AnnotationType>(method);
          if (annotation != null) {
            values.add(generateForAnnotatedMethod(method, ConstantReader(annotation),
            ));
          }
        }
      }
    }
    return values.join('\n');
  }

  String generateForAnnotatedMethod(MethodElement method, ConstantReader annotation);
}

abstract class GeneratorForAnnotatedField<AnnotationType> extends Generator {


  @override
  String generate(LibraryReader library, BuildStep buildStep) {
    final values = <String>{};
    for (final element in library.allElements) {
      if (element is ClassElement && !element.isEnum) {
        for (final field in element.fields) {
          final annotation = getAnnotation<AnnotationType>(field);
          if (annotation != null) {
            values.add(generateForAnnotatedField(field, ConstantReader(annotation),
            ));
          }
        }
      }
    }
    return values.join('\n');
  }

  String generateForAnnotatedField(FieldElement field, ConstantReader annotation);
}

DartObject? getAnnotation<T>(Element element) {
  final annotations = TypeChecker.fromRuntime(T).annotationsOf(element);
  if (annotations.isEmpty) {
    return null;
  }
  if (annotations.length > 1) {
    throw Exception('You tried to add multiple @$T() annotations to the '
        "same element (${element.name}), but that's not possible.");
  }
  return annotations.single;
}