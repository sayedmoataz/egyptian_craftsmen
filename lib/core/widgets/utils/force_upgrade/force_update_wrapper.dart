import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../services/firebase/remote_config_service.dart';
import '../../../utils/constants.dart';
import 'force_update.dart';

/// A wrapper widget that checks if a force update is required
/// and displays the ForceUpdate screen when necessary.
class ForceUpdateWrapper extends StatefulWidget {
  /// The child widget to display when no update is required
  final Widget child;

  const ForceUpdateWrapper({required this.child, super.key});

  @override
  State<ForceUpdateWrapper> createState() => _ForceUpdateWrapperState();
}

class _ForceUpdateWrapperState extends State<ForceUpdateWrapper> {
  bool _isLoading = true;
  bool _isUpdateRequired = false;

  @override
  void initState() {
    super.initState();
    // Wait for next frame to ensure Firebase services are initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForUpdate();
    });
  }

  Future<void> _checkForUpdate() async {
    // Wait for RemoteConfigService to be registered (max 5 seconds)
    // This handles the case where Firebase is still initializing
    final isRegistered = await _waitForServiceRegistration(
      timeout: const Duration(seconds: 5),
    );

    if (!isRegistered) {
      // Service not registered (non-production mode or timeout)
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isUpdateRequired = false;
        });
      }
      return;
    }

    try {
      final remoteConfigService = GetIt.instance<RemoteConfigService>();

      // Initialize remote config first
      await remoteConfigService.initialize();

      // Check if update is required
      final isUpdateRequired = await remoteConfigService.isUpdateRequired();

      if (mounted) {
        setState(() {
          _isLoading = false;
          _isUpdateRequired = isUpdateRequired;
        });
      }
    } catch (e) {
      // On error, allow app to continue
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isUpdateRequired = false;
        });
      }
    }
  }

  /// Waits for RemoteConfigService to be registered with a timeout
  Future<bool> _waitForServiceRegistration({required Duration timeout}) async {
    final stopwatch = Stopwatch()..start();

    while (stopwatch.elapsed < timeout) {
      if (GetIt.instance.isRegistered<RemoteConfigService>()) {
        stopwatch.stop();
        return true;
      }
      // Check every 100ms
      await Future.delayed(const Duration(milliseconds: 100));
    }

    stopwatch.stop();
    return false;
  }

  Future<void> _openStore() async {
    final String storeUrl = Platform.isIOS
        ? AppConstants.appStoreUrl
        : AppConstants.playStoreUrl;

    final uri = Uri.parse(storeUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show force update screen if update is required
    if (!_isLoading && _isUpdateRequired) {
      return ForceUpdate(isLoading: false, onRetry: _openStore);
    }

    // While loading or when no update is needed, show normal app content
    return widget.child;
  }
}
