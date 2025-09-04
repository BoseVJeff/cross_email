/// The base class for all log outputs
// TODO: Implement other outputs
abstract class LogOutput {
  const LogOutput();

  /// Write the message to the output
  ///
  /// This method will guarantee a line break after each message.
  Future<void> write(String message);
}

class ConsoleLogOutput implements LogOutput {
  const ConsoleLogOutput() : super();

  @override
  Future<void> write(String message) async {
    print(message);
  }
}

class FileLogOutput implements LogOutput {
  @override
  Future<void> write(String message) {
    throw UnsupportedError("File IO is not supported here.");
  }
}
