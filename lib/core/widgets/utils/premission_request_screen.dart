import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../gen/assets.gen.dart';
import '../../theme/colors.dart';
import '../../utils/app_strings.dart';
import '../custom_button.dart';

enum PermissionType { location, camera, microphone, notification, gps }

class PermissionRequestScreen extends StatelessWidget {
  final PermissionType permissionType;

  const PermissionRequestScreen({required this.permissionType, super.key});

  String _getTitle(BuildContext context) {
    final strings = AppStrings.of(context);
    switch (permissionType) {
      case PermissionType.location:
        return strings.enableLocationAccess;
      case PermissionType.camera:
        return strings.enableCameraAccess;
      case PermissionType.microphone:
        return strings.enableMicrophoneAccess;
      case PermissionType.notification:
        return strings.enableNotificationAccess;
      case PermissionType.gps:
        return strings.enableGpsAccess;
    }
  }

  String _getDescription(BuildContext context) {
    final strings = AppStrings.of(context);
    switch (permissionType) {
      case PermissionType.location:
        return strings.locationAccessDescription;
      case PermissionType.camera:
        return strings.cameraAccessDescription;
      case PermissionType.microphone:
        return strings.microphoneAccessDescription;
      case PermissionType.notification:
        return strings.notificationAccessDescription;
      case PermissionType.gps:
        return strings.gpsAccessDescription;
    }
  }

  AssetGenImage _getIconAsset() {
    switch (permissionType) {
      case PermissionType.location:
      case PermissionType.gps:
        // Using a generic icon for location/gps - ideally add location icon to assets
        return Assets.icons.product.location06;
      case PermissionType.camera:
        // Using a generic icon - ideally add camera icon to assets
        return Assets.icons.home.add01;
      case PermissionType.microphone:
        // Using a generic icon - ideally add microphone icon to assets
        return Assets.icons.home.add01;
      case PermissionType.notification:
        return Assets.icons.home.notification03;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, info) {
        return Scaffold(
          body: Padding(
            padding: EdgeInsets.all(info.spacing(ResponsiveSpacing.md)),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Center(
                    child: _getIconAsset().image(
                      width: info.responsiveValue(mobile: 120.0, tablet: 160.0),
                      height: info.responsiveValue(
                        mobile: 120.0,
                        tablet: 160.0,
                      ),
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: info.spacing(ResponsiveSpacing.md)),
                  Text(
                    _getTitle(context),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: info.responsiveFontSize(18),
                    ),
                  ),
                  SizedBox(height: info.spacing(ResponsiveSpacing.md)),
                  Text(
                    _getDescription(context),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w400,
                      fontSize: info.responsiveFontSize(14),
                    ),
                  ),
                  const Spacer(),
                  CustomButton(
                    text: AppStrings.of(context).openSettings,
                    onPressed: () async {
                      await openAppSettings();
                      if (context.mounted) {
                        Navigator.of(context).pop(true);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
