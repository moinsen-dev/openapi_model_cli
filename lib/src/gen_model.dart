import 'dart:io';

import 'package:mustache_template/mustache.dart';
import 'package:yaml/yaml.dart';

import 'env.dart';

class GenModel {
  GenModel(this.env, this.name, this.data);

  final Env env;
  final String name;
  final YamlMap data;

  void _writeModelFile({
    required String path,
    required String fileName,
    required String schemaName,
    required List<Map<String, dynamic>> attrs,
  }) {
    final _dartModelFile = '''
// ignore_for_file: unused_import
import 'package:freezed_annotation/freezed_annotation.dart';

import '_index.dart';

part '{{ fileName }}.freezed.dart';
part '{{ fileName }}.g.dart';

@freezed
class {{ className }} with _{{ dollarClassName }} {
  {{# attrs }}
  static const attr_{{ name }} = '{{ name }}';
  {{/ attrs }}

  factory {{ className }}({
  {{# attrs }}
   {{ default }}{{ type }} {{ name }},
  {{/ attrs }}
  }) = _{{ className }};      

  factory {{ className }}.fromJson(Map<String, dynamic> json) => _{{ dollarClassName }}FromJson(json);
}
	''';

    var template = Template(_dartModelFile, htmlEscapeValues: false);

    var output = template.renderString(
      {
        'fileName': schemaName.toLowerCase(),
        'className': schemaName,
        'dollarClassName': '\$$schemaName',
        'attrs': attrs,
      },
    );

    File('$path$fileName').writeAsStringSync(output);

    File('${path}_index.dart').writeAsStringSync(
      'export \'$fileName\';\n',
      mode: FileMode.append,
    );
  }

  void _writeEnumFile({
    required String path,
    required String fileName,
    required String schemaName,
    required List<Map<String, dynamic>> attrs,
  }) {
    final _dartEnumFile = '''

  enum {{ className }} {
    {{# attrs }}
      {{ name }},
    {{/ attrs }}
  }

	''';

    var template = Template(_dartEnumFile, htmlEscapeValues: false);

    var output = template.renderString(
      {
        'fileName': schemaName.toLowerCase(),
        'className': schemaName,
        'dollarClassName': '\$$schemaName',
        'attrs': attrs,
      },
    );

    File('$path$fileName').writeAsStringSync(output);

    File('${path}_index.dart').writeAsStringSync(
      'export \'$fileName\';\n',
      mode: FileMode.append,
    );
  }

  List<Map<String, dynamic>> _properties2Args(YamlMap modelProperties) {
    List<Map<String, dynamic>> result = [];

    modelProperties.forEach(
      (propName, propData) {
        String propType = propData['type'] ?? 'string';
        String? propFormat = propData['format'];
        dynamic propDefault = propData['default'];
        String? propRef = propData['\$ref'];
        String attrType = 'String?';
        String attrDefault = '';

        // TODO Handle propFormat date-time

        // TODO Gen enum type

        if (propRef != null) {
          final ref = propRef.split('/').last;
          attrType = '$ref?';
        } else {
          switch (propType) {
            case 'integer':
              if (propDefault != null) {
                attrDefault = '@Default(${propDefault.toString()}) ';
              }
              attrType = 'int?';
              break;
            case 'string':
              if (propDefault != null) {
                attrDefault = '@Default(\'${propDefault.toString()}\') ';
              }
              attrType = 'String?';
              break;
            default:
              attrType = 'String?';
          }
        }

        Map<String, dynamic> attr = {
          'name': propName,
          'type': attrType,
          'default': attrDefault,
        };
        result.add(attr);
      },
    );

    return result;
  }

  List<Map<String, dynamic>> _enumList2Args(YamlList enumList) {
    List<Map<String, dynamic>> result = [];

    for (var propName in enumList) {
      Map<String, dynamic> attr = {
        'name': propName,
        'type': propName,
        'default': '',
      };
      result.add(attr);
    }

    return result;
  }

  void generateModel() {
    print('generateModel $name');

    var modelType = data['type'];
    var modelEnum = data['enum'];
    var modelProperties = data['properties'];
    var modelRequired = data['required'];

    if (modelEnum != null) {
      _writeEnumFile(
        schemaName: name,
        path: '${env.projectPath}/lib/models/',
        fileName: '${name.toLowerCase()}.dart',
        attrs: _enumList2Args(modelEnum),
      );
    } else {
      _writeModelFile(
        schemaName: name,
        path: '${env.projectPath}/lib/models/',
        fileName: '${name.toLowerCase()}.dart',
        attrs: _properties2Args(modelProperties),
      );
    }
  }
}
