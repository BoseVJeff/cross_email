import 'dart:async';

import 'package:cross_email/log/lifecycle_observer.dart';
import 'package:cross_email/log/log_formatter.dart';
import 'package:cross_email/log/log_output.dart';
import 'package:cross_email/secrets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:stack_trace/stack_trace.dart';

/// The minimum level at which the stack trace will be logged
const Level minStackTraceLevel = Level.WARNING;

/// The formatter for device logs
final String Function(LogRecord) logFormatter =
    LogFormatter.dotnetSimpleConsoleFormatter;

void main(List<String> args) {
  LogOutput output;

  // Logger setup
  if (kDebugMode) {
    Logger.root.level = Level.ALL;
    output = ConsoleLogOutput();
  } else {
    Logger.root.level = Level.CONFIG;
    // TODO: Find a better output
    output = ConsoleLogOutput();
  }

  Logger log = Logger("<main>");

  StreamSubscription<LogRecord> logSubscription = Logger.root.onRecord.listen((
    LogRecord record,
  ) {
    output.write(logFormatter(record));
    if (record.level >= minStackTraceLevel) {
      output.write(
        Trace.format(
          // If the record does not contain a trace, create one
          record.stackTrace ?? StackTrace.current,
          // Print the terse trace on debug mode to avoid logspam
          terse: kDebugMode,
        ),
      );
    }
  });

  // TODO: Implement this
  // FlutterError.onError = (FlutterErrorDetails details) {
  //   Level level;
  //   // Translate DiagnosticLevel to Level
  //   switch (details.summary.level) {
  //     case DiagnosticLevel.hidden:
  //       level = Level.FINEST;
  //     case DiagnosticLevel.fine:
  //       level = Level.FINE;
  //     case DiagnosticLevel.debug:
  //       level = Level.FINER;
  //     case DiagnosticLevel.info:
  //       level = Level.INFO;
  //     case DiagnosticLevel.warning:
  //       level = Level.WARNING;
  //     case DiagnosticLevel.hint:
  //       level = Level.FINER;
  //     case DiagnosticLevel.summary:
  //       level = Level.INFO;
  //     case DiagnosticLevel.error:
  //       level = Level.SEVERE;
  //     case DiagnosticLevel.off:
  //       level = Level.OFF;
  //   }

  //   // Log this error
  //   log.log(
  //     level,
  //     details.exceptionAsString(),
  //     details.exception,
  //     details.stack,
  //   );

  //   // Retain the default error screen for debugging
  //   if (kDebugMode) {
  //     FlutterError.presentError(details);
  //   }
  // };

  log.finest("Initialising bindings");
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  widgetsBinding.addObserver(LifecycleObserver());

  log.finest("Starting app");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static Logger log = Logger("MyApp");

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    log.finest("Item test!");
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
