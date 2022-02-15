import 'dart:io';

import 'package:mustache_template/mustache.dart';
import 'package:openapi_model_cli/src/mustaches/index.dart';

void writeMustacheFile(
  MustacheArgs args, {
  bool updateIndexFile = true,
}) {
  var template = Template(
    args.mustacheFileName,
    htmlEscapeValues: false,
  );

  var output = template.renderString(
    {
      'fileName': args.schemaName.toLowerCase(),
      'className': args.schemaName,
      'dollarClassName': '\$${args.schemaName}',
      'attrs': args.attrs,
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
