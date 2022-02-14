import 'dart:io';

import 'package:path/path.dart';

import 'env.dart';

typedef VoidCallback = Function();

class PackageGenerator {
  PackageGenerator(this.env);

  final Env env;

  bool _executeCommand(
    String command, {
    List<String> args = const [],
    String? workingDirectory,
  }) {
    print(
      'Execute $command ${workingDirectory != null ? "in $workingDirectory" : ""}  ${args.toString()}',
    );

    try {
      var result = Process.runSync(
        command,
        args,
        workingDirectory: workingDirectory,
      );

      print(result.stderr);
      print(result.stdout);
    } catch (e) {
      print(e);
      return false;
    }

    return true;
  }

  void _createFlutterPackage() {
    _executeCommand(
      'flutter',
      args: [
        'create',
        '--suppress-analytics',
        '--template=package',
        env.projectName,
      ],
    );
  }

  void _updatePubSpec() {
    _executeCommand('sed',
        args: [
          "-i ''",
          's/^name: example_api/name: ${basename(env.projectName)}/g',
          'pubspec.yaml',
        ],
        workingDirectory: env.projectPath);
  }

  void copyPath(String from, String to) {
    if (!Directory(to).existsSync()) {
      Directory(to).createSync(recursive: true);
    }

    for (final file in Directory(from).listSync(recursive: true)) {
      final copyTo = join(to, relative(file.path, from: from));
      if (file is Directory) {
        if (!Directory(copyTo).existsSync()) {
          Directory(copyTo).createSync(recursive: true);
        }
      } else if (file is File) {
        if (File(copyTo).existsSync()) {
          File(copyTo).deleteSync();
        }

        File(file.path).copySync(copyTo);
      }
    }
  }

  void _copyTemplateFiles() async {
    final dartToolDir = '${env.templateFolder}/.dart_tool';
    if (Directory(dartToolDir).existsSync()) {
      Directory(dartToolDir).deleteSync(recursive: true);
    }

    final dartPackageFile = '${env.templateFolder}/.packages';
    if (File(dartPackageFile).existsSync()) {
      File(dartPackageFile).deleteSync();
    }

    final dartPubSpecLock = '${env.templateFolder}/pubspec.lock';
    if (File(dartPubSpecLock).existsSync()) {
      File(dartPubSpecLock).deleteSync();
    }

    copyPath(env.templateFolder, env.projectPath);
  }

  void call() {
    print('Generate project ${env.projectName}');

    _createFlutterPackage();

    _copyTemplateFiles();

    _updatePubSpec();
  }

  void buildModels() {
    _executeCommand(
      './build.sh',
      workingDirectory: env.projectPath,
    );
  }
}
