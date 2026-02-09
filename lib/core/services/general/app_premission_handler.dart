import 'dart:developer' show log;
import 'dart:io';

import 'package:aelanji/core/widgets/custom_toast/custom_toast.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../widgets/utils/premission_request_screen.dart';

class AppPermissionHandler {
  static final AppPermissionHandler _instance =
      AppPermissionHandler._internal();

  factory AppPermissionHandler() {
    return _instance;
  }

  AppPermissionHandler._internal();

  Future<bool> requestCameraPermission({
    required BuildContext context,
    bool showErrorMessages = true,
  }) async {
    try {
      final PermissionStatus currentStatus = await Permission.camera.status;

      if (currentStatus.isGranted || currentStatus.isLimited) {
        return true;
      }

      if (currentStatus.isRestricted) {
        CustomToast.loading(context);
        return false;
      }

      final PermissionStatus requestResult = await Permission.camera.request();

      if (requestResult.isGranted || requestResult.isLimited) {
        return true;
      }

      if (requestResult.isPermanentlyDenied) {
        return await _handlePermanentlyDeniedPermission(
          context,
          Permission.camera,
          PermissionType.camera,
          showErrorMessages,
        );
      }

      return false;
    } catch (e) {
      log('request camera permission error is: $e');
      if (showErrorMessages) {
        CustomToast.error(context, 'Error requesting camera permission: $e');
      }
      return false;
    }
  }

  Future<bool> requestCameraPermissionWithBetterHandling({
    required BuildContext context,
    bool showErrorMessages = true,
    bool isRetry = false,
  }) async {
    try {
      final PermissionStatus currentStatus = await Permission.camera.status;

      if (currentStatus.isGranted || currentStatus.isLimited) {
        return true;
      }

      if (currentStatus.isRestricted) {
        if (showErrorMessages) {
          CustomToast.error(context, 'Camera permission is restricted');
        }
        return false;
      }

      if (currentStatus.isPermanentlyDenied) {
        return await _handlePermanentlyDeniedPermission(
          context,
          Permission.camera,
          PermissionType.camera,
          showErrorMessages,
        );
      }

      if (currentStatus.isDenied) {
        final PermissionStatus requestResult = await Permission.camera
            .request();

        if (requestResult.isGranted || requestResult.isLimited) {
          return true;
        }

        if (requestResult.isPermanentlyDenied) {
          return await _handlePermanentlyDeniedPermission(
            context,
            Permission.camera,
            PermissionType.camera,
            showErrorMessages,
          );
        }
        return false;
      }

      return false;
    } catch (e) {
      log('request camera permission error is: $e');
      if (showErrorMessages) {
        CustomToast.error(context, 'Error requesting camera permission: $e');
      }
      return false;
    }
  }

  Future<bool> requestMicrophonePermission({
    required BuildContext context,
    bool showErrorMessages = true,
  }) async {
    try {
      final PermissionStatus status = await Permission.microphone.status;

      if (status.isGranted) return true;

      if (status.isDenied) {
        final PermissionStatus requestResult = await Permission.microphone
            .request();
        if (requestResult.isGranted) return true;
        if (requestResult.isPermanentlyDenied) {
          return await _handlePermanentlyDeniedPermission(
            context,
            Permission.microphone,
            PermissionType.microphone,
            showErrorMessages,
          );
        }
        return false;
      }

      if (status.isPermanentlyDenied) {
        return await _handlePermanentlyDeniedPermission(
          context,
          Permission.microphone,
          PermissionType.microphone,
          showErrorMessages,
        );
      }

      return false;
    } catch (e) {
      log('request microphone permission error is: $e');
      if (showErrorMessages) {
        CustomToast.error(context, 'Error requesting microphone permission');
      }
      return false;
    }
  }

  Future<bool> _handlePermanentlyDeniedPermission(
    BuildContext context,
    Permission permission,
    PermissionType permissionType,
    bool showErrorMessages,
  ) async {
    if (showErrorMessages) {
      final bool? openSettings = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (context) =>
              PermissionRequestScreen(permissionType: permissionType),
        ),
      );

      if (openSettings ?? false) {
        await openAppSettings();
        await Future.delayed(const Duration(milliseconds: 500));
        return await permission.isGranted;
      }
    }
    return false;
  }

  Future<bool> requestNotificationPermission({
    required BuildContext context,
    bool showErrorMessages = true,
  }) async {
    final PermissionStatus status = await Permission.notification.status;

    if (status.isGranted) return true;

    if (status.isDenied) {
      final PermissionStatus requestResult = await Permission.notification
          .request();
      if (requestResult.isGranted) return true;
      if (requestResult.isPermanentlyDenied) {
        return await _handlePermanentlyDeniedPermission(
          context,
          Permission.notification,
          PermissionType.notification,
          showErrorMessages,
        );
      }
      return false;
    }

    if (status.isPermanentlyDenied) {
      return await _handlePermanentlyDeniedPermission(
        context,
        Permission.notification,
        PermissionType.notification,
        showErrorMessages,
      );
    }

    return false;
  }

  Future<bool> checkAllPermissions({
    required BuildContext context,
    bool showErrorMessages = true,
  }) async {
    try {
      final bool cameraPermission = await requestCameraPermission(
        context: context,
        showErrorMessages: showErrorMessages,
      );

      final bool microphonePermission = await requestMicrophonePermission(
        context: context,
        showErrorMessages: showErrorMessages,
      );

      final bool notificationPermission = await requestNotificationPermission(
        context: context,
        showErrorMessages: showErrorMessages,
      );

      return cameraPermission && microphonePermission && notificationPermission;
    } catch (e) {
      log('check all permissions error is: $e');
      return false;
    }
  }

  bool isPermissionGranted(PermissionType permissionType) {
    return true;
  }

  void togglePermission(PermissionType permissionType, bool value) {
    log('Toggled $permissionType to $value');
  }

  Future<bool> checkAndRequestPermissions({required bool skipIfExists}) async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      return false; // Only Android and iOS platforms are supported
    }

    if (Platform.isAndroid) {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = deviceInfo.version.sdkInt;

      if (skipIfExists) {
        // Read permission is required to check if the file already exists
        return sdkInt >= 33
            ? await Permission.photos.request().isGranted
            : await Permission.storage.request().isGranted;
      } else {
        // No read permission required for Android SDK 29 and above
        return sdkInt >= 29
            ? true
            : await Permission.storage.request().isGranted;
      }
    } else if (Platform.isIOS) {
      // iOS permission for saving images to the gallery
      return skipIfExists
          ? await Permission.photos.request().isGranted
          : await Permission.photosAddOnly.request().isGranted;
    }

    return false; // Unsupported platforms
  }
}
