import 'package:yaml/yaml.dart';

enum AttributeTypes {
  aString,
  aBool,
  aEnum,
  aIntegeer,
  aObject,
  aUndef,
}

class Schema {
  final String name;
  final Map schemaMap;

  AttributeTypes type = AttributeTypes.aString;

  bool isEnum = false;

  YamlMap? attrProperties;
  List? enumProperties;

  List? requiredProperties;

  Schema(this.name, this.schemaMap) {
    enumProperties = schemaMap['enum'];
    isEnum = enumProperties?.isNotEmpty ?? false;

    type = mapType(schemaMap['type']);

    attrProperties = schemaMap['properties'];
    requiredProperties = schemaMap['required'];
  }

  AttributeTypes mapType(String? type) {
    if (isEnum) {
      return AttributeTypes.aEnum;
    } else if (type != null) {
      switch (type) {
        case 'object':
          return AttributeTypes.aObject;
        case 'string':
          return AttributeTypes.aString;
        case 'integer':
          return AttributeTypes.aIntegeer;
      }
    }

    return AttributeTypes.aUndef;
  }
}
