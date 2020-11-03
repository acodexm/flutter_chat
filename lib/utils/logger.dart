import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat/utils/pretty_printer.dart' as offset;
import 'package:logger/logger.dart';
import 'package:mockito/mockito.dart';

void setupLogger({bool test = false}) {
  if (test) {
    Log.useClient(_MockClient());
  } else if (!kReleaseMode) {
    Logger.level = Level.verbose;
    Log.useClient(_DebugLoggerClient());
  } else {
    // Pass all uncaught errors from the framework to something like Crashlytics.
  }
}

class _MockClient extends Mock implements _LoggerClient {
  @override
  void log({LogLevel level, String message, e, StackTrace s}) {}
}

class Log {
  static _LoggerClient _client;

  /// Debug level logs
  static void d(
    String message, {
    dynamic e,
    StackTrace s,
  }) {
    _client.log(
      level: LogLevel.debug,
      message: message,
      e: e,
      s: s,
    );
  }

  // Warning level logs
  static void w(
    String message, {
    dynamic e,
    StackTrace s,
  }) {
    _client.log(
      level: LogLevel.warning,
      message: message,
      e: e,
      s: s,
    );
  }

  // info level logs
  static void i(
    String message, {
    dynamic e,
    StackTrace s,
  }) {
    _client.log(
      level: LogLevel.info,
      message: message,
      e: e,
      s: s,
    );
  }

  /// Error level logs
  /// Requires a current StackTrace to report correctly on Crashlytics
  /// Always reports as non-fatal to Crashlytics
  static void e(
    String message, {
    dynamic e,
    StackTrace s,
  }) {
    _client.log(
      level: LogLevel.error,
      message: message,
      e: e,
      s: s,
    );
  }

  static void useClient(_LoggerClient client) {
    _client = client;
  }
}

enum LogLevel { debug, warning, error, info }

abstract class _LoggerClient {
  void log({
    LogLevel level,
    String message,
    dynamic e,
    StackTrace s,
  });
}

/// Debug logger that just prints to console
class _DebugLoggerClient implements _LoggerClient {
  final Logger _logger = getLogger();

  @override
  void log({
    LogLevel level,
    String message,
    dynamic e,
    StackTrace s,
  }) {
    switch (level) {
      case LogLevel.debug:
        _handleLogs(_logger.d, message, e, s);
        break;
      case LogLevel.info:
        _handleLogs(_logger.i, message, e, s);
        break;
      case LogLevel.warning:
        _handleLogs(_logger.w, message, e, s);
        break;
      case LogLevel.error:
        if (e != null) {
          if (e is PlatformException)
            _logger.e(message, e.message, s ?? StackTrace.current);
          else
            _logger.e(message, e.toString(), s ?? StackTrace.current);
        } else {
          _logger.e(message, null, s ?? StackTrace.current);
        }
        break;
    }
  }

  void _handleLogs(Function(dynamic message, [dynamic error, StackTrace stackTrace]) logger,
      String message,
      dynamic e,
      StackTrace s,) {
    if (e != null) {
      logger(message, e.toString(), s ?? StackTrace.current);
    } else {
      logger(message);
    }
  }
}

Logger getLogger() {
  return Logger(
    printer: PrefixPrinter(
      offset.PrettyPrinter(
        lineLength: 120,
        methodOffset: 5,
        methodCount: 6,
        colors: false,
        printEmojis: false,
      ),
    ),
  );
}

class PrefixPrinter extends LogPrinter {
  final LogPrinter _realPrinter;
  Map<Level, String> _prefixMap;

  PrefixPrinter(this._realPrinter, {debug, verbose, wtf, info, warning, error}) {
    _prefixMap = {
      Level.debug: debug ?? 'DEBUG',
      Level.verbose: verbose ?? 'VERBOSE',
      Level.wtf: wtf ?? 'WTF',
      Level.info: info ?? 'INFO',
      Level.warning: warning ?? 'WARNING',
      Level.error: error ?? 'ERROR',
    };

    var len = _longestPrefixLength();
    _prefixMap.forEach((k, v) => _prefixMap[k] = '${v.padLeft(len)} ');
  }

  @override
  List<String> log(LogEvent event) {
    var realLogs = _realPrinter.log(event);
    return realLogs.map((s) => '${_prefixMap[event.level]}$s').toList();
  }

  int _longestPrefixLength() {
    var compFunc = (String a, String b) => a.length > b.length ? a : b;
    return _prefixMap.values
        .reduce(compFunc)
        .length;
  }
}
