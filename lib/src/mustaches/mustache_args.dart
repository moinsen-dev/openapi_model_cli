import 'mustache_attributes.dart';

class MustacheArgs {
  final String path;
  final String fileName;
  final String mustacheFileName;
  final String schemaName;
  final List<MustacheAttribute> attrs;

  MustacheArgs({
    required this.path,
    required this.fileName,
    required this.mustacheFileName,
    required this.schemaName,
    required this.attrs,
  });

  List<Map<String, dynamic>> values() {
    return attrs.map((e) => e.values()).toList();
  }
}
