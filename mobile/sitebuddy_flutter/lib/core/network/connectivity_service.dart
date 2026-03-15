// FILE HEADER
// ----------------------------------------------
// File: connectivity_service.dart
// Feature: core (network)
// Layer: infrastructure/services
//
// PURPOSE:
// Real-time monitoring of device network connectivity.
// ----------------------------------------------

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Riverpod provider for the global ConnectivityService singleton.
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService();
});

/// Riverpod provider observing the current online status.
final connectivityProvider = StreamProvider<bool>((ref) {
  return ref.watch(connectivityServiceProvider).onConnectivityChanged;
});

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  
  // Internal controller to manage connection stream
  final _controller = StreamController<bool>.broadcast();

  ConnectivityService() {
    _init();
  }

  void _init() {
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      // Check if any result is not none
      final isConnected = results.any((result) => result != ConnectivityResult.none);
      _controller.add(isConnected);
    });
  }

  /// Returns true if the device is currently connected to a network.
  Future<bool> get isOnline async {
    final results = await _connectivity.checkConnectivity();
    return results.any((result) => result != ConnectivityResult.none);
  }

  /// Stream of boolean values indicating online (true) or offline (false) status.
  Stream<bool> get onConnectivityChanged => _controller.stream;

  void dispose() {
    _controller.close();
  }
}
