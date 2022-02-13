import 'package:args/args.dart';

class Env {
  Env(
    this.argResults,
  );

  final ArgResults argResults;

  String get specName => argResults['input'];

  String get projectName => argResults['output'];

  final templateFolder = 'templates/dart/package';

  String get projectPath => projectName;
}
