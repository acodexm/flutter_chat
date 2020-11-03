import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter_chat/core/models/enums/connectivity_status.dart';
import 'package:flutter_chat/core/services/stoppable_service.dart';
import 'package:flutter_chat/utils/logger.dart';

abstract class ConnectivityService implements StoppableService {
  Stream<ConnectivityStatus> get connectivity$;

  Future<bool> get isConnected;
}

class ConnectivityServiceImpl implements ConnectivityService {
  final _connectivityResultController = StreamController<ConnectivityStatus>();
  final _connectivity = Connectivity();

  StreamSubscription<ConnectivityResult> _subscription;
  ConnectivityResult _lastResult;
  bool _serviceStopped = false;

  ConnectivityServiceImpl() {
    _subscription = _connectivity.onConnectivityChanged.listen(_emitConnectivity);
  }

  @override
  Stream<ConnectivityStatus> get connectivity$ => _connectivityResultController.stream;

  @override
  bool get serviceStopped => _serviceStopped;

  @override
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    switch (result) {
      case ConnectivityResult.mobile:
      case ConnectivityResult.wifi:
        return true;
      case ConnectivityResult.none:
      default:
        return false;
    }
  }

  @override
  void start() async {
    Log.d('ConnectivityService resumed');
    _serviceStopped = false;

    await _resumeSignal();
    _subscription.resume();
  }

  @override
  void stop() {
    Log.d('ConnectivityService paused');
    _serviceStopped = true;

    _subscription.pause(_resumeSignal());
  }

  void _emitConnectivity(ConnectivityResult event) {
    if (event == _lastResult) return;

    Log.d('Connectivity status changed to $event');
    _connectivityResultController.add(_convertResult(event));
    _lastResult = event;
  }

  ConnectivityStatus _convertResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.mobile:
        return ConnectivityStatus.Cellular;
      case ConnectivityResult.wifi:
        return ConnectivityStatus.WiFi;
      case ConnectivityResult.none:
        return ConnectivityStatus.Offline;
      default:
        return ConnectivityStatus.Offline;
    }
  }

  Future<void> _resumeSignal() async => true;
}
