import 'package:logger/logger.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

class LoggerService {
  static late Logger logger;

  static Future<void> init() async {
    try {
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
      logger.i("Logger initialized successfully.");
    } catch (e) {
      // Fallback to console logger (release may ignore this)
      logger = Logger(
        printer: PrettyPrinter(printTime: true),
      );
      logger.e("Logger initialization failed: $e");
    }
  }
}

class FileOutput extends LogOutput {
  final File logFile;

  FileOutput._(this.logFile);

  static Future<FileOutput> create() async {
    try {
      final Directory baseDir;

      if (Platform.isWindows) {
        final userProfile = Platform.environment['USERPROFILE'];
        if (userProfile == null) {
          throw Exception('USERPROFILE not found');
        }
        baseDir = Directory(path.join(userProfile, 'Documents', 'MyAppLogs'));
      } else if (Platform.isLinux || Platform.isMacOS) {
        baseDir = Directory(path.join(Platform.environment['HOME']!, 'MyAppLogs'));
      } else {
        throw UnsupportedError('Unsupported OS');
      }

      if (!await baseDir.exists()) {
        await baseDir.create(recursive: true);
      }

      final File logFile = File(path.join(baseDir.path, 'app_log.txt'));
      if (!await logFile.exists()) {
        await logFile.create();
      }

      return FileOutput._(logFile);
    } catch (e) {
      throw Exception("Error creating log file: $e");
    }
  }

  @override
  void output(OutputEvent event) {
    try {
      for (var line in event.lines) {
        logFile.writeAsStringSync('$line\n', mode: FileMode.append);
      }
    } catch (e) {
      // Avoid crashing in release
    }
  }
}
