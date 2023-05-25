import 'package:logging/logging.dart';

class TestLogger {
  final logger = Logger('${DateTime.now()}');
  List<String> logs = [];

  TestLogger() {
    _initLogger();
  }
  void _initLogger() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      logs.add('\n${record.message}');
    });
  }
}
