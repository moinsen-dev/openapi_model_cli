import 'dart:io';

import 'package:path/path.dart';

class Generator {
  Generator({
    required this.projectName,
    this.clean = true,
  });

  final String projectName;
  final bool clean;
  final String? _workingDirectory = 'temp';

  void _createFlutterPackage() async {
    var result = await Process.run(
      'flutter',
      [
        'create',
        '--template=package',
        projectName,
      ],
      workingDirectory: _workingDirectory,
    );

    print(result.stderr);
    print(result.stdout);
  }

  void _appDependencies(List<String> deps, {bool dev = false}) async {
    String add = 'dependencies:\\n  http: any';

    var result = await Process.run(
      'sed',
      [
        "-i ''",
        's/dependencies:/' + add + '/g',
        'pubspec.yaml',
      ],
      workingDirectory: projectPath,
    );

    print(result.stderr);
    print(result.stdout);
  }

  String get projectPath =>
      (_workingDirectory != null ? '$_workingDirectory/' : '') + projectName;

  Future<void> copyPath(String from, String to) async {
    await Directory(to).create(recursive: true);
    await for (final file in Directory(from).list(recursive: true)) {
      final copyTo = join(to, relative(file.path, from: from));
      if (file is Directory) {
        await Directory(copyTo).create(recursive: true);
      } else if (file is File) {
        await File(file.path).copy(copyTo);
      } else if (file is Link) {
        await Link(copyTo).create(await file.target(), recursive: true);
      }
    }
  }

  void _copyTemplateFiles() async {
    copyPath('template/project', projectPath);
  }

  void call() {
    print('Generate project $projectName');

    _createFlutterPackage();

    _copyTemplateFiles();

    _appDependencies(
      ['freezed'],
    );
  }
}
