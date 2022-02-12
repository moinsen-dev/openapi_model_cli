import 'dart:io';

import 'package:openapi_model_cli/src/gen_model.dart';
import 'package:yaml/yaml.dart';

class YamlHelper {
  final String fileName;

  Map? yaml;

  YamlHelper(this.fileName);

  Future<bool> parseFile() async {
    try {
      var myFile = File(fileName);

      String yamlString = await myFile.readAsString();
      yaml = loadYaml(yamlString) as Map;

      Map schemas = yaml?['components']?['schemas'] ?? {};

      schemas.forEach(
        (key, value) {
          print('Schema $key with $value');
          GenModel genModel = GenModel(key, value);
          genModel.testMustache();
        },
      );
    } catch (e) {
      print(e);
      return false;
    }

    return true;
  }
}
