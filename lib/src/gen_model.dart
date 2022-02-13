import 'dart:io';

import 'package:mustache_template/mustache.dart';
import 'package:yaml/yaml.dart';

import 'env.dart';

class GenModel {
  GenModel(this.env, this.name, this.data);

  final Env env;
  final String name;
  final YamlMap data;

  String get projectPath =>
      (env.workingDirectory != null ? '${env.workingDirectory}/' : '') +
      env.projectName;

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

    var template = Template(_dartModelFile);

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
        String propFormat = propData['format'] ?? 'string';
        String? propRef = propData['\$ref'];
        String attrType = 'String?';

        // TODO Handle propFormat date-time

        if (propRef != null) {
          final ref = propRef.split('/').last;
          attrType = '$ref?';
        } else {
          switch (propType) {
            case 'integer':
              attrType = 'int?';
              break;
            case 'string':
              attrType = 'String?';
              break;
            default:
              attrType = 'String?';
          }
        }

        Map<String, dynamic> attr = {
          'name': propName,
          'type': attrType,
          'default': '',
        };
        result.add(attr);
      },
    );

    return result;
  }

  void generateModel() {
    print('generateModel $name');

    var modelType = data['type'];
    var modelEnum = data['enum'];
    var modelProperties = data['properties'];
    var modelRequired = data['required'];

    if (modelEnum == null) {
      _writeModelFile(
        schemaName: name,
        path: '${env.projectPath}/lib/models/',
        fileName: '${name.toLowerCase()}.dart',
        attrs: _properties2Args(modelProperties),
        // attrs: [
        //   {
        //     'name': 'id',
        //     'type': 'String?',
        //     'default': '',
        //   },
        //   {
        //     'name': 'name',
        //     'type': 'String?',
        //     'default': '',
        //   },
        //   {
        //     'name': 'description',
        //     'type': 'String',
        //     'default': '@Default(\'\') ',
        //   },
        //   {
        //     'name': 'game',
        //     'type': 'Game',
        //     'default': '',
        //   },
        // ],
      );
    }
  }
}
