import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';

class LifecycleObserver extends WidgetsBindingObserver {
  static final Logger log = Logger("LifecycleObserver");

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    log.finest("App state: ${state.name}");
    super.didChangeAppLifecycleState(state);
  }
}
