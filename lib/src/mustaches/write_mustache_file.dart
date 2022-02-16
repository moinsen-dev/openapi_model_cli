import 'dart:io';

import 'package:mustache_template/mustache.dart';
import 'package:openapi_model_cli/src/mustaches/_index.dart';

void bla() {
  Uri filePath = Platform.script.resolve('../lib/templates/README.md');
  var file = File.fromUri(filePath);

  var content = file.readAsStringSync();
  print('BLA:$content');
}

void writeMustacheFile(
  MustacheArgs args, {
  String includePath = 'templates/',
  bool updateIndexFile = true,
}) {
  var template = Template(
    args.mustacheFileName,
    htmlEscapeValues: false,
    partialResolver: (path) {
      var resolvedFile = File(includePath + '/' + path);
      if (resolvedFile.existsSync()) {
        var resolvedString = resolvedFile.readAsStringSync();
        return Template(resolvedString);
      } else {
        throw ArgumentError(
            'Trying to include file "$path" at "${resolvedFile.absolute.path}" but no file found. Hint: You can configure the base include path with the "includePath" parameter.');
      }
    },
  );

  var output = template.renderString(
    {
      'fileName': args.schemaName.toLowerCase(),
      'className': args.schemaName,
      'dollarClassName': '\$${args.schemaName}',
      'attrs': args.values(),
    },
  );

  File('${args.path}${args.fileName}').writeAsStringSync(output);

  if (updateIndexFile) {
    File('${args.path}_index.dart').writeAsStringSync(
      'export \'${args.fileName}\';\n',
      mode: FileMode.append,
    );
  }
}
