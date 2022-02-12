import 'package:args/args.dart';
import 'package:openapi_model_cli/src/generator.dart';
import 'package:openapi_model_cli/src/yaml.dart';

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

    YamlHelper yamlHelper = YamlHelper(
      argResults!['input'],
    );

    yamlHelper.parseFile();

    Generator gen = Generator(projectName: argResults!['output']);
    gen();
  }
}
