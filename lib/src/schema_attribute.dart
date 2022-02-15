class SchemaAttribute {
  final Map schemaMap;
  SchemaAttribute(this.schemaMap);

  String? propType;
  String? propFormat;
  dynamic propDefault;
  String? propRef;
  String? propDescription;

  String attrType = 'String?';
  String attrDefault = '';
}
