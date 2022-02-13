import 'package:args/args.dart';
import 'package:openapi_model_cli/src/yaml.dart';

import 'env.dart';
import 'package_generator.dart';

class App {
  ArgResults? argResults;

  App(this.args);
  final List<String> args;

  void _init() {
    var parser = ArgParser()
      ..addFlag('clean', abbr: 'x')
      ..addOption(
        'output',
        abbr: 'o',
        mandatory: true,
      )
      ..addOption(
        'input',
        abbr: 'i',
        mandatory: true,
      );

    argResults = parser.parse(args);
  }

  void call() {
    _init();

    assert(argResults != null, 'Empty arguments');

    Env env = Env(argResults!);

    PackageGenerator packageGenerator = PackageGenerator(env);
    packageGenerator();

    YamlHelper yamlHelper = YamlHelper(env);
    yamlHelper.generateFiles();

    packageGenerator.buildModels();
  }
}
