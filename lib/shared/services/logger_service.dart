import 'package:logger/logger.dart';
import 'dart:io'; 

import 'package:path/path.dart' as path;
class LoggerService {
  static late Logger logger;
  static Future<void> init() async {
    final output = await FileOutput.create();
    logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 100,
        colors: false,
        printEmojis: false,
        printTime: true,
      ),
      output: output,
    );
  }
}
class FileOutput extends LogOutput {
  final File logFile;

  FileOutput._(this.logFile);

  static Future<FileOutput> create() async {
    final userProfile = Platform.environment['USERPROFILE']; // C:\Users\volker
    if (userProfile == null) {
      throw Exception('USERPROFILE not found');
    }

    final logDirPath = path.join(userProfile, 'Documents', 'MyAppLogs');
    final logDir = Directory(logDirPath);
    if (!await logDir.exists()) {
      await logDir.create(recursive: true); // 👈 will now work!
    }

    final logFile = File(path.join(logDirPath, 'app_log.txt'));
    if (!await logFile.exists()) {
      await logFile.create();
    }

    return FileOutput._(logFile);
  }

  @override
  void output(OutputEvent event) {
    for (var line in event.lines) {
      logFile.writeAsStringSync('$line\n', mode: FileMode.append);
    }
  }
}