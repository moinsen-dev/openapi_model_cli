import 'package:openapi_model_cli/src/env.dart';
import 'package:openapi_model_cli/src/schema.dart';
import 'package:yaml/yaml.dart';

import 'mustaches/_index.dart';

class SchemaManager {
  final Env env;
  Set<Schema> schemes = {};

  SchemaManager(this.env) {
    env.schemas?.forEach(
      (name, schema) {
        schemes.add(
          Schema(
            name,
            schema,
          ),
        );
      },
    );
  }

  Schema byName(String name) {
    return schemes.firstWhere((element) => element.name == name);
  }

  List<MustacheAttribute> mustacheAttributes(String schemaName) {
    final schema = byName(schemaName);

    if (schema.isEnum && (schema.enumProperties?.isNotEmpty ?? false)) {
      return _enumValue2List(schema.enumProperties!);
    } else if (!schema.isEnum && (schema.attrProperties?.isNotEmpty ?? false)) {
      return _properties2List(schema.attrProperties!);
    }

    return [];
  }

  List<MustacheAttribute> _enumValue2List(List<dynamic> data) {
    List<MustacheAttribute> result = [];

    for (var name in data) {
      result.add(
        MustacheAttribute(name: name),
      );
    }

    return result;
  }

  List<MustacheAttribute> _properties2List(YamlMap data) {
    List<MustacheAttribute> result = [];

    data.forEach(
      (propName, propData) {
        String propType = propData['type'] ?? 'string';
        String? propFormat = propData['format'];
        dynamic propDefault = propData['default'];
        String? propRef = propData['\$ref'];
        String? propDescription = propData['description'];
        String attrType = 'String?';
        String attrDefault = '';

        // TODO Handle propFormat date-time

        // TODO Gen enum type

        // TODO Support more types

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

        result.add(MustacheAttribute(
          name: propName,
          type: attrType,
          description: propDescription != null ? '/// $propDescription' : '',
          defaultValue: attrDefault,
        ));
      },
    );

    return result;
  }

  void generateFiles() {
    try {
      for (var schema in schemes) {
        final attrs = mustacheAttributes(schema.name);
        print(attrs);
        writeMustacheFile(
          MustacheArgs(
            attrs: attrs,
            fileName: '${schema.name.toLowerCase()}.dart',
            mustacheFileName: schema.isEnum
                ? mustacheDartEnumEntity
                : mustacheDartFreezedEntity,
            schemaName: schema.name,
            path: '${env.projectPath}/lib/models/',
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }
}
