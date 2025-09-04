import 'package:logging/logging.dart';

abstract class Secrets {
  static final Logger log = Logger("Secrets");

  static String get googleId {
    if (!const bool.hasEnvironment("GOOGLE_ID")) {
      log.severe("Failed to find GOOGLE_ID!");
    }
    return const String.fromEnvironment("GOOGLE_ID");
  }

  static String get googleSecret {
    if (!const bool.hasEnvironment("GOOGLE_SECRET")) {
      log.severe("Failed to find GOOGLE_SECRET!");
    }
    return const String.fromEnvironment("GOOGLE_SECRET");
  }

  static String get outlookId {
    if (!const bool.hasEnvironment("OUTLOOK_ID")) {
      log.severe("Failed to find OUTLOOK_ID!");
    }
    return const String.fromEnvironment("OUTLOOK_ID");
  }

  static String get outlookSecret {
    if (!const bool.hasEnvironment("OUTLOOK_SECRET")) {
      log.severe("Failed to find OUTLOOK_SECRET!");
    }
    return const String.fromEnvironment("OUTLOOK_SECRET");
  }
}
