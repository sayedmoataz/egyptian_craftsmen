import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// App strings helper class for localization.
/// Use the `of(context)` method to get context-aware translations.
class AppStrings {
  final BuildContext _context;

  AppStrings._(this._context);

  /// Get an instance of AppStrings with the given context
  static AppStrings of(BuildContext context) => AppStrings._(context);

  /// Translate a key using the current context
  String tr(String key) => key.tr(context: _context);

  String trWithParams(String key, List<String> params) {
    String text = tr(key);
    for (int i = 0; i < params.length; i++) {
      text = text.replaceAll('{$i}', params[i]);
    }
    return text;
  }

  String get appName => tr('app_name');

  // Validation Errors
  String validationFieldRequired(String fieldName) =>
      trWithParams('validation_field_required', [fieldName]);
  String get validationEmailRequired => tr('validation_email_required');
  String get validationEmailInvalid => tr('validation_email_invalid');
  String get validationPasswordRequired => tr('validation_password_required');
  String validationPasswordMinLength(int length) =>
      trWithParams('validation_password_min_length', [length.toString()]);
  String get validationPasswordUppercase => tr('validation_password_uppercase');
  String get validationPasswordLowercase => tr('validation_password_lowercase');
  String get validationPasswordNumber => tr('validation_password_number');
  String get validationPasswordSpecial => tr('validation_password_special');
  String get validationConfirmPasswordRequired =>
      tr('validation_confirm_password_required');
  String get validationPasswordsDoNotMatch =>
      tr('validation_passwords_do_not_match');
  String get validationPhoneRequired => tr('validation_phone_required');
  String get validationPhoneInvalid => tr('validation_phone_invalid');
  String validationMinLength(String fieldName, int length) =>
      trWithParams('validation_min_length', [fieldName, length.toString()]);
  String validationMaxLength(String fieldName, int length) =>
      trWithParams('validation_max_length', [fieldName, length.toString()]);
  String validationMustBeNumber(String fieldName) =>
      trWithParams('validation_must_be_number', [fieldName]);
  String get validationUrlRequired => tr('validation_url_required');
  String get validationUrlInvalid => tr('validation_url_invalid');
  String get validationCreditCardRequired =>
      tr('validation_credit_card_required');
  String get validationCreditCardInvalid =>
      tr('validation_credit_card_invalid');
  String get validationDateRequired => tr('validation_date_required');
  String get validationDateFormat => tr('validation_date_format');
  String get validationDateInvalid => tr('validation_date_invalid');
  String get validationMonthInvalid => tr('validation_month_invalid');
  String get validationDayInvalid => tr('validation_day_invalid');
  String get savedToGallery => tr('saved_to_gallery');
  String get failedToSaveImage => tr('failed_to_save_image');
  String get errorSavingImage => tr('error_saving_image');
  String get permissionDeniedToSaveImageToGallery =>
      tr('permission_denied_to_save_image_to_gallery');
  String get camera => tr('camera');
  String get gallery => tr('gallery');


  // Permission strings
  String get enableLocationAccess => tr('enable_location_access');
  String get enableCameraAccess => tr('enable_camera_access');
  String get enableMicrophoneAccess => tr('enable_microphone_access');
  String get enableNotificationAccess => tr('enable_notification_access');
  String get enableGpsAccess => tr('enable_gps_access');
  String get locationAccessDescription => tr('location_access_description');
  String get cameraAccessDescription => tr('camera_access_description');
  String get microphoneAccessDescription => tr('microphone_access_description');
  String get notificationAccessDescription =>
      tr('notification_access_description');
  String get gpsAccessDescription => tr('gps_access_description');
  String get openSettings => tr('open_settings');
  String permissionsPermanentlyDenied(String permission) =>
      trWithParams('permissions_permanently_denied', [permission]);
  String errorRequestingCameraPermission(String error) =>
      trWithParams('error_requesting_camera_permission', [error]);
  String get locationPerimissionDesc => tr('location_permission_desc');
  String get cameraPerimissionDesc => tr('camera_permission_desc');
  String get microphonePerimissionDesc => tr('microphone_permission_desc');
  String get notificationPerimissionDesc => tr('notification_permission_desc');
  String get gpsPerimissionDesc => tr('gps_permission_desc');
  String get uploadImage => tr('upload_image');
  String get imageType => tr('image_type');


  // utils
  String get youAreOffline => tr('you_are_offline');
  String get youAreOfflineDescription => tr('you_are_offline_description');
  String get tryAgain => tr('try_again');
  String get forceUpdate => tr('force_update');
  String get forceUpdateDescription => tr('force_update_description');
  String get updateNow => tr('update_now');
}
