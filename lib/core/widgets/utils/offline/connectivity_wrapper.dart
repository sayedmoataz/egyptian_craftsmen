import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../../di/injection_container.dart';
import '../../../network/network_info.dart';
import '../../../theme/colors.dart';
import 'offline_screen.dart';

/// A wrapper widget that monitors network connectivity status
/// and displays an offline screen when there's no internet connection.
///
/// Designed to avoid false-positive "offline" states:
///  - Starts optimistically (assumes connected).
///  - On a `disconnected` event from the stream, performs TWO consecutive
///    connectivity checks with a 2-second gap. Only if BOTH fail does it
///    show the offline screen.
///  - Reconnection is applied instantly (no delay).
class ConnectivityWrapper extends StatefulWidget {
  /// The child widget to display when connected.
  final Widget child;

  const ConnectivityWrapper({required this.child, super.key});

  @override
  State<ConnectivityWrapper> createState() => _ConnectivityWrapperState();
}

class _ConnectivityWrapperState extends State<ConnectivityWrapper> {
  late final NetworkInfo _networkInfo;
  StreamSubscription<InternetConnectionStatus>? _subscription;
  bool _isConnected = true; // optimistic default
  bool _isCheckingConnection = false;
  Timer? _verifyTimer;

  @override
  void initState() {
    super.initState();
    _networkInfo = sl<NetworkInfo>();
    _listenToConnectivity();
  }

  void _listenToConnectivity() {
    _subscription = _networkInfo.onStatusChange.listen((status) {
      final connected = status == InternetConnectionStatus.connected;

      // Cancel any pending verification.
      _verifyTimer?.cancel();

      if (connected) {
        // Reconnected → show content immediately.
        _applyStatus(true);
      } else {
        // Stream says disconnected → perform double-verification.
        // Wait 2 seconds, check again. If still offline, wait another 2 seconds
        // and check a third time. Only show offline screen if all checks fail.
        _verifyTimer = Timer(const Duration(seconds: 2), () async {
          // First verification check
          final firstCheck = await _networkInfo.isConnected;
          if (firstCheck) {
            // False alarm - we're actually connected
            _applyStatus(true);
            return;
          }

          // First check failed, wait and try again
          await Future.delayed(const Duration(seconds: 2));

          // Second verification check
          final secondCheck = await _networkInfo.isConnected;
          if (secondCheck) {
            // Reconnected during verification
            _applyStatus(true);
            return;
          }

          // Both checks failed - we're really offline
          _applyStatus(false);
        });
      }
    });
  }

  void _applyStatus(bool connected) {
    if (mounted && _isConnected != connected) {
      setState(() => _isConnected = connected);
    }
  }

  /// Manual retry triggered by the user from the offline screen.
  Future<void> _retryConnection() async {
    setState(() => _isCheckingConnection = true);

    final isConnected = await _networkInfo.isConnected;

    if (mounted) {
      setState(() {
        _isConnected = isConnected;
        _isCheckingConnection = false;
      });
    }
  }

  @override
  void dispose() {
    _verifyTimer?.cancel();
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (!_isConnected)
          Positioned.fill(
            child: Material(
              color: AppColors.white,
              child: OfflineScreen(
                isLoading: _isCheckingConnection,
                onRetry: _retryConnection,
              ),
            ),
          ),
      ],
    );
  }
}
