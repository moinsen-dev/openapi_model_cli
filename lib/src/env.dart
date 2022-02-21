import 'dart:io';

import 'package:args/args.dart';
import 'package:yaml/yaml.dart';

class Env {
  Env(
    this.argResults,
  ) {
    loadInputSpec();
  }

  final ArgResults argResults;

  String get specName => argResults['input'];

  String get projectName => argResults['output'];

  bool get doUpdateModels => argResults['update'];

  final templateFolder = 'templates/dart/package';

  String get projectPath => projectName;

  dynamic yaml;

  Map? schemas;

  void loadInputSpec() {
    var myFile = File(specName);

    String yamlString = myFile.readAsStringSync();
    yaml = loadYaml(yamlString) as Map;

    schemas = yaml?['components']?['schemas'] ?? {};
  }
}
