import 'dart:io';

import 'package:args/args.dart';

import 'env.dart';
import 'schema_manager.dart';
import 'yaml.dart';

class App {
  ArgResults? argResults;

  App(this.arguments);
  final List<String> arguments;

  bool _init() {
    exitCode = 0;

    var parser = ArgParser()
      ..addFlag(
        'update',
        abbr: 'u',
        help: 'Only the model files will be regenerated.',
      )
      ..addOption(
        'output',
        abbr: 'o',
        mandatory: true,
        help: 'Name of the flutter dart package with the generated modesl.',
        valueHelp: 'FILE',
      )
      ..addOption(
        'input',
        abbr: 'i',
        mandatory: true,
        help: 'YAML Open Api input spec file.',
        valueHelp: 'FILE',
      );

    try {
      argResults = parser.parse(arguments);
    } catch (e) {
      exitCode = 1;
      stdout.writeln(parser.usage);
      return false;
    }

    return true;
  }

  void call() {
    if (_init()) {
      Env env = Env(argResults!);

      SchemaManager schemaManager = SchemaManager(env);

      YamlHelper yamlHelper = YamlHelper(env);
      yamlHelper.generateFiles();
    }
  }
}
