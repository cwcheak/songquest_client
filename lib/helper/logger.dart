import 'package:logger/logger.dart' as logger;

class Logger {
  static final logger.Logger instance = logger.Logger(
    printer: logger.PrettyPrinter(
      lineLength: 120,
      dateTimeFormat: logger.DateTimeFormat.dateAndTime,
      colors: true,
      // noBoxingByDefault: true,
    ),
    output: logger.MultiOutput([logger.ConsoleOutput()]),
  );
}
