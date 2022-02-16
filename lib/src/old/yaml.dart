import 'dart:io';

import 'package:openapi_model_cli/src/old/gen_model.dart';
import 'package:yaml/yaml.dart';

import '../env.dart';

class YamlHelper {
  final Env env;

  Map? yaml;

  YamlHelper(this.env);

  void generateFiles() {
    try {
      var myFile = File(env.specName);

      String yamlString = myFile.readAsStringSync();
      yaml = loadYaml(yamlString) as Map;

      Map schemas = yaml?['components']?['schemas'] ?? {};

      // TODO Cleanup model/_index.dart

      schemas.forEach(
        (key, value) {
          GenModel genModel = GenModel(env, key, value);
          genModel.generateModel();
        },
      );
    } catch (e) {
      print(e);
    }
  }
}
