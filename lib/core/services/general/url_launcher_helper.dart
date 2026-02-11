import 'package:url_launcher/url_launcher.dart';

import '../../localization/localization_manager.dart';

/// Helper class for launching URLs (phone calls, WhatsApp, etc.)
class UrlLauncherHelper {
  UrlLauncherHelper._();

  /// Launch a phone call
  static Future<void> launchPhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch phone call to $phoneNumber';
    }
  }

  /// Launch WhatsApp chat
  static Future<void> launchWhatsApp(
    String phoneNumber, {
    String? message,
    String? userName,
    String? adName,
  }) async {
    // Remove any non-digit characters except +
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');

    String? finalMessage = message;
    if (finalMessage == null && userName != null && adName != null) {
      finalMessage = LocalizationManager().translate(
        'whatsapp_predefined_message',
        namedArgs: {'userName': userName, 'adName': adName},
      );
    }

    final String url = finalMessage != null
        ? 'https://wa.me/$cleanNumber?text=${Uri.encodeComponent(finalMessage)}'
        : 'https://wa.me/$cleanNumber';
    final Uri whatsappUri = Uri.parse(url);

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch WhatsApp for $phoneNumber';
    }
  }

  /// Launch SMS
  static Future<void> launchSMS(String phoneNumber, {String? body}) async {
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: body != null ? {'body': body} : null,
    );

    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      throw 'Could not launch SMS to $phoneNumber';
    }
  }

  /// Launch email
  static Future<void> launchEmail(
    String email, {
    String? subject,
    String? body,
  }) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {'subject': ?subject, 'body': ?body},
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch email to $email';
    }
  }

  /// Launch URL in browser
  static Future<void> launchWebUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch URL: $url';
    }
  }
}
