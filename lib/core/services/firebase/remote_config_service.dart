import 'dart:developer';
import 'dart:io' show Platform;

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> initialize() async {
    final startTime = DateTime.now();
    log(
      'Initialization started at ${startTime.toIso8601String()}',
      name: 'RemoteConfigService',
    );

    try {
      log('Setting default values...', name: 'RemoteConfigService');
      await _remoteConfig.setDefaults({
        'required_build_number_android': '1',
        'required_build_number_ios': '1',
      });
      log('Default values set successfully', name: 'RemoteConfigService');

      log(
        'Configuring fetch settings (timeout: 10s, min interval: 1h)...',
        name: 'RemoteConfigService',
      );
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(minutes: 1),
        ),
      );
      log('Fetch settings configured', name: 'RemoteConfigService');

      final lastFetchTime = _remoteConfig.lastFetchTime;
      log(
        'Last fetch time: ${lastFetchTime.toIso8601String()}',
        name: 'RemoteConfigService',
      );

      final lastFetchStatus = _remoteConfig.lastFetchStatus;
      log('Last fetch status: $lastFetchStatus', name: 'RemoteConfigService');

      bool fetchSuccessful = false;
      try {
        log('Attempting to fetch and activate...', name: 'RemoteConfigService');
        final fetchStartTime = DateTime.now();
        final activated = await _remoteConfig.fetchAndActivate();
        final fetchDuration = DateTime.now().difference(fetchStartTime);

        if (activated) {
          log(
            'Fetch and activate successful (took ${fetchDuration.inMilliseconds}ms)',
            name: 'RemoteConfigService',
          );
          log('New config values activated', name: 'RemoteConfigService');
        } else {
          log(
            'Fetch completed but no new values activated (took ${fetchDuration.inMilliseconds}ms)',
            name: 'RemoteConfigService',
          );
          log('Using cached config values', name: 'RemoteConfigService');
        }
        fetchSuccessful = true;
      } catch (fetchError) {
        if (fetchError.toString().contains('Too many server requests') ||
            fetchError.toString().contains('installations') ||
            fetchError.toString().contains('Code=2')) {
          log(
            'RATE LIMIT DETECTED: Firebase is throttling requests',
            name: 'RemoteConfigService',
          );
          log(
            'Continuing with cached/default values',
            name: 'RemoteConfigService',
          );
          log(
            'Last successful fetch: ${_remoteConfig.lastFetchTime.toIso8601String()}',
            name: 'RemoteConfigService',
          );
          log(
            'Last fetch status: ${_remoteConfig.lastFetchStatus}',
            name: 'RemoteConfigService',
          );
        } else {
          log('Fetch error: $fetchError', name: 'RemoteConfigService');
        }
      }

      final totalDuration = DateTime.now().difference(startTime);
      if (fetchSuccessful) {
        log(
          'Initialization completed successfully in ${totalDuration.inMilliseconds}ms',
          name: 'RemoteConfigService',
        );
      } else {
        log(
          'Initialization completed with fallback values in ${totalDuration.inMilliseconds}ms',
          name: 'RemoteConfigService',
        );
      }
    } catch (e) {
      final totalDuration = DateTime.now().difference(startTime);
      log(
        'Critical error during initialization after ${totalDuration.inMilliseconds}ms: $e',
        name: 'RemoteConfigService',
      );
      log(
        'App will continue with default hardcoded values',
        name: 'RemoteConfigService',
      );
    }
  }

  Future<bool> isUpdateRequired() async {
    try {
      final String platformKey = Platform.isAndroid
          ? 'required_build_number_android'
          : 'required_build_number_ios';

      final String requiredBuildNumber = _remoteConfig.getString(platformKey);

      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final String currentBuildNumber = packageInfo.buildNumber;
      final int required = int.tryParse(requiredBuildNumber) ?? 0;
      final int current = int.tryParse(currentBuildNumber) ?? 0;

      log('Platform Key: $platformKey', name: 'RemoteConfigService');
      log('Required Build Number: $required', name: 'RemoteConfigService');
      log('Current Build Number: $current', name: 'RemoteConfigService');

      return current < required;
    } catch (e) {
      log('Error checking update: $e', name: 'RemoteConfigService');
      return false;
    }
  }
}
