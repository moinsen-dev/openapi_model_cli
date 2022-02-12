import 'dart:io';

import 'package:yaml/yaml.dart';

class YamlHelper {
  final String fileName;

  Map? yaml;

  YamlHelper(this.fileName);

  void genModel(String name, Map data) {
    print(name);
  }

  Future<bool> parseFile() async {
    try {
      var myFile = File(fileName);

      String yamlString = await myFile.readAsString();
      yaml = loadYaml(yamlString) as Map;

      Map schemas = yaml?['components']?['schemas'] ?? {};

      schemas.forEach(
        (key, value) {
          print('Schema $key with $value');
          genModel(key, value);
        },
      );
    } catch (e) {
      print(e);
      return false;
    }

    return true;
  }
}
