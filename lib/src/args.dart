import 'package:openapi_model_cli/src/yaml.dart';

class Args {
  final List<String> args;

  Args(this.args);

  void start() {
    print(
      args.toString(),
    );

    YamlHelper yamlHelper = YamlHelper(args[0]);
    yamlHelper.parseFile();
  }
}
