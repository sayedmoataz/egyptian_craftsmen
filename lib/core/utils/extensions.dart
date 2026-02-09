import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';

import '../localization/localization_manager.dart';

/// String Extensions
extension StringExtension on String {
  /// Capitalizes first letter of the string
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitalizes first letter of each word
  String capitalizeWords() {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize()).join(' ');
  }

  /// Checks if string is a valid email
  bool get isValidEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  /// Checks if string is a valid phone number
  bool get isValidPhone {
    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
    return phoneRegex.hasMatch(this);
  }

  /// Checks if string is a valid URL
  bool get isValidUrl {
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );
    return urlRegex.hasMatch(this);
  }

  /// Removes all whitespace from string
  String removeWhitespace() {
    return replaceAll(RegExp(r'\s+'), '');
  }

  /// Truncates string to specified length with ellipsis
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$ellipsis';
  }

  /// Cleans phone number by removing non-digit characters except +
  String get cleanPhoneNumber => replaceAll(RegExp(r'[^\d+]'), '');

  /// Opens WhatsApp with this phone number.
  /// If [countryCode] is provided (e.g., '20' for Egypt), converts local numbers
  /// (starting with 0) to international format.
  Future<bool> openWhatsApp({
    String? countryCode,
    String? message,
    String? userName,
    String? adName,
  }) async {
    if (isEmpty) return false;

    String phoneNumber = cleanPhoneNumber;

    // If number doesn't start with + and we have a country code,
    // convert local format to international format
    if (!phoneNumber.startsWith('+') && countryCode != null) {
      // Remove leading 0 if present (local format)
      if (phoneNumber.startsWith('0')) {
        phoneNumber = phoneNumber.substring(1);
      }
      // Add country code
      phoneNumber = '+$countryCode$phoneNumber';
    }

    String? finalMessage = message;
    if (finalMessage == null && userName != null && adName != null) {
      finalMessage = LocalizationManager().translate(
        'whatsapp_predefined_message',
        namedArgs: {'userName': userName, 'adName': adName},
      );
    }

    final String url = finalMessage != null
        ? 'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(finalMessage)}'
        : 'https://wa.me/$phoneNumber';
    final uri = Uri.parse(url);
    log('WhatsApp URL: $uri');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return true;
    }
    return false;
  }

  /// Makes a phone call to this number
  Future<bool> callPhone() async {
    if (isEmpty) return false;
    final uri = Uri.parse('tel:$this');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      return true;
    }
    return false;
  }

  /// Sends SMS to this phone number
  Future<bool> sendSms({String? body}) async {
    if (isEmpty) return false;
    final uri = Uri.parse('sms:$this${body != null ? '?body=$body' : ''}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      return true;
    }
    return false;
  }

  /// Adds commas to the number
  String addCommas() {
    final number = num.tryParse(this);
    if (number == null) return this;
    return NumberFormat.decimalPattern().format(number);
  }
}

/// DateTime Extensions
extension DateTimeExtension on DateTime {
  /// Formats date as 'dd/MM/yyyy'
  String get formattedDate {
    return '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year';
  }

  /// Formats time as 'HH:mm'
  String get formattedTime {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  /// Formats datetime as 'dd/MM/yyyy HH:mm'
  String get formattedDateTime {
    return '$formattedDate $formattedTime';
  }

  /// Checks if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Checks if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Returns time ago string (e.g., '2 hours ago')
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);
    final lm = LocalizationManager();

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return years == 1
          ? lm.translate('time_ago_year_1')
          : lm.translate(
              'time_ago_year_plural',
              namedArgs: {'count': years.toString()},
            );
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return months == 1
          ? lm.translate('time_ago_month_1')
          : lm.translate(
              'time_ago_month_plural',
              namedArgs: {'count': months.toString()},
            );
    } else if (difference.inDays > 0) {
      final days = difference.inDays;
      return days == 1
          ? lm.translate('time_ago_day_1')
          : lm.translate(
              'time_ago_day_plural',
              namedArgs: {'count': days.toString()},
            );
    } else if (difference.inHours > 0) {
      final hours = difference.inHours;
      return hours == 1
          ? lm.translate('time_ago_hour_1')
          : lm.translate(
              'time_ago_hour_plural',
              namedArgs: {'count': hours.toString()},
            );
    } else if (difference.inMinutes > 0) {
      final minutes = difference.inMinutes;
      return minutes == 1
          ? lm.translate('time_ago_minute_1')
          : lm.translate(
              'time_ago_minute_plural',
              namedArgs: {'count': minutes.toString()},
            );
    } else {
      return lm.translate('time_ago_just_now');
    }
  }

  /// Returns compact time ago string (e.g., '2d', '3h', '5m')
  /// Useful for UI elements with limited space
  String get timeAgoShort {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'Now';
    }
  }

  /// Returns time ago with custom localized label for days
  /// Example: timeAgoWithLabel('days') returns '2 days'
  String timeAgoWithLabel(String daysLabel) {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 0) {
      return '${difference.inDays} $daysLabel';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'Now';
    }
  }
}

/// List Extensions
extension ListExtension<T> on List<T> {
  /// Returns true if list is null or empty
  bool get isNullOrEmpty => isEmpty;

  /// Returns true if list is not null and not empty
  bool get isNotNullOrEmpty => isNotEmpty;

  /// Returns first element or null if list is empty
  T? get isFirstOrNull => isEmpty ? null : first;

  /// Returns last element or null if list is empty
  T? get isLastOrNull => isEmpty ? null : last;
}

/// Num Extensions
extension NumExtension on num {
  /// Converts number to currency format
  String toCurrency({String symbol = '\$'}) {
    return '$symbol${toStringAsFixed(2)}';
  }

  /// Converts bytes to human readable format
  String toFileSize() {
    if (this < 1024) return '$this B';
    if (this < 1024 * 1024) return '${(this / 1024).toStringAsFixed(2)} KB';
    if (this < 1024 * 1024 * 1024) {
      return '${(this / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(this / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}
