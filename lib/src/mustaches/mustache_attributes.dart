class MustacheAttribute {
  final String name;
  final String type;
  final String description;
  final String defaultValue;

  MustacheAttribute({
    required this.name,
    this.type = '',
    this.description = '',
    this.defaultValue = '',
  });

  Map<String, dynamic> values() {
    return {
      'name': name,
      'description': description,
      'default': defaultValue,
      'type': type,
    };
  }
}
