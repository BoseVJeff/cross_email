import 'dart:convert';

import 'package:logging/logging.dart';

/// Formatters for generating a log message from a [LogRecord].
///
/// Handling the stacktrace is not handled by any method of this class.
abstract class LogFormatter {
  /// Meant for simple debugging and printing to console.
  // Ref: https://learn.microsoft.com/en-us/dotnet/core/extensions/console-log-formatter#simple
  static String dotnetSimpleConsoleFormatter(LogRecord record) {
    StringBuffer buffer = StringBuffer();

    // Write the current time
    buffer.write(
      "${record.time.hour}:${record.time.minute}:${record.time.second}.${record.time.millisecond}",
    );

    buffer.write(" ");

    // Write the current level
    // TODO: Add color here
    buffer.write(record.level.name.toLowerCase());

    buffer.write(": ");

    // Write name of logger
    buffer.write(record.loggerName);

    buffer.write(" ");

    buffer.write(record.message);

    return buffer.toString();
  }

  /// Meant for simple debugging and printing to console
  // Ref: https://learn.microsoft.com/en-us/dotnet/core/extensions/console-log-formatter#systemd
  static String dotnetSystemdConsoleFormatter(LogRecord record) {
    StringBuffer buffer = StringBuffer();

    // Write priority
    // Padded to 4 digits to mantain alignment
    // TODO: Look into converting levels to the 0-7 scheme that actual `systemd` uses
    buffer.write("<${record.level.value.toRadixString(10).padLeft(4, "0")}>");

    // Write date & time
    buffer.write(
      "${record.time.hour}:${record.time.minute}:${record.time.second}.${record.time.millisecond}",
    );

    buffer.write(" ");

    buffer.write(record.loggerName);

    buffer.write(" ");

    buffer.write(record.message);

    return buffer.toString();
  }

  /// Meant for storing logs in plain text
  // Ref: https://learn.microsoft.com/en-us/dotnet/core/extensions/console-log-formatter#json
  static String dotnetJsonConsoleFormatter(LogRecord record, [String? indent]) {
    Map<String, dynamic> json = {};
    JsonEncoder jsonEncoder;
    if (indent != null) {
      jsonEncoder = JsonEncoder.withIndent(indent);
    } else {
      jsonEncoder = JsonEncoder();
    }

    // Write timestamp
    // Writing in a standard format as this is expected to be machine readable
    json.addAll({"Timestamp": record.time.toIso8601String()});

    // Write Event ID
    json.addAll({"EventId": record.sequenceNumber});

    // Write Log Level
    // This is being written as a `String` to allow Dart applications to easily decode this to a `Level`
    json.addAll({"LogLevel": record.level.name.toString()});

    // Write category
    // This is currently treated as the logger name
    json.addAll({"Category": record.loggerName});

    // Write message
    json.addAll({"Message": record.message});

    return jsonEncoder.convert(json);
  }

  /// Meant for simple debugging and printing to console.
  ///
  /// Intended to be reminescent of the default python `logging` module's output.
  // Ref: https://stackoverflow.com/a/1765705
  static String pythonStandardFormatter(LogRecord record) {
    StringBuffer buffer = StringBuffer();

    // Write date
    buffer.write(
      "${record.time.year}-${record.time.month.toRadixString(10).padLeft(2, "0")}-${record.time.day.toRadixString(10).padLeft(2, "0")}",
    );

    buffer.write(" ");

    buffer.write(
      "${record.time.hour.toRadixString(10).padLeft(2, "0")}:${record.time.minute.toRadixString(10).padLeft(2, "0")}:${record.time.second.toRadixString(10).padLeft(2, "0")},${record.time.millisecond.toRadixString(10).padLeft(3, "0")}",
    );

    buffer.write(" - ");

    buffer.write(record.loggerName);

    buffer.write(" - ");

    buffer.write(record.level.name.toUpperCase());

    buffer.write(" - ");

    buffer.write(record.message);

    return buffer.toString();
  }
}
