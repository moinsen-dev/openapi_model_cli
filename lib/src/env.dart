import 'package:args/args.dart';

class Env {
  Env(
    this.argResults, {
    this.workingDirectory = '../temp',
  });

  final ArgResults argResults;

  String get specName => argResults['input'];

  String get projectName => argResults['output'];

  final templateFolder = 'templates/dart/package';

  final String? workingDirectory;

  String get projectPath =>
      (workingDirectory != null ? '$workingDirectory/' : '') + projectName;
}
