import 'package:openapi_model_cli/src/env.dart';

import '../mustaches/_index.dart';
import 'schema.dart';

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

  List<MustacheAttribute> mustacheAttributes(Schema schema) {
    if (schema.isEnum && (schema.enumProperties?.isNotEmpty ?? false)) {
      return _enumValue2List(schema);
    } else if (!schema.isEnum && (schema.attrProperties?.isNotEmpty ?? false)) {
      return _properties2List(schema);
    }

    return [];
  }

  List<MustacheAttribute> _enumValue2List(Schema schema) {
    List<MustacheAttribute> result = [];

    for (var name in schema.enumProperties!) {
      result.add(
        MustacheAttribute(name: name),
      );
    }

    return result;
  }

  List<MustacheAttribute> _properties2List(Schema schema) {
    List<MustacheAttribute> result = [];

    schema.attrProperties?.forEach(
      (propName, propData) {
        String propType = propData['type'] ?? 'string';
        String? propFormat = propData['format'];
        dynamic propDefault = propData['default'];
        String? propRef = propData['\$ref']?.split('/').last;
        Schema? propRefSchema;
        String? propDescription = propData['description'];
        String attrType = propType;
        bool attrIsEnum = false;
        String attrDefault = '';

        if (propRef != null) {
          propRefSchema = byName(propRef);
          attrIsEnum = propRefSchema.isEnum;
          propType = 'enum';
        }

        // TODO Handle propFormat date-time

        // TODO Gen enum type

        // TODO Support more types

        if (propDefault != null) {
          if (attrIsEnum) {
            attrDefault = '@Default($propRef.${propDefault.toString()}) ';
          } else {
            attrDefault = '@Default(${propDefault.toString()}) ';
          }
        }

        switch (propType) {
          case 'integer':
            attrType = 'int?';
            break;
          case 'string':
            attrType = 'String?';
            break;
          case 'enum':
            attrType = propRef!;
            break;
          default:
            attrType = 'String?';
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
        final attrs = mustacheAttributes(schema);
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
