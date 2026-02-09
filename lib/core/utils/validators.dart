import 'package:flutter/widgets.dart';

import 'app_strings.dart';

/// Form Validators
/// Provides validation functions for common form fields
/// All validator methods require a BuildContext for localization
class Validators {
  // Private constructor to prevent instantiation
  Validators._();

  /// Validates if field is not empty
  static String? required(
    BuildContext context,
    String? value, {
    String? fieldName,
  }) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.of(
        context,
      ).validationFieldRequired(fieldName ?? 'This field');
    }
    return null;
  }

  /// Validates email format
  static String? email(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.of(context).validationEmailRequired;
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return AppStrings.of(context).validationEmailInvalid;
    }

    return null;
  }

  /// Validates password strength
  static String? password(
    BuildContext context,
    String? value, {
    int minLength = 8,
  }) {
    if (value == null || value.isEmpty) {
      return AppStrings.of(context).validationPasswordRequired;
    }

    if (value.length < minLength) {
      return AppStrings.of(context).validationPasswordMinLength(minLength);
    }

    if (!value.contains(RegExp('[A-Z]'))) {
      return AppStrings.of(context).validationPasswordUppercase;
    }

    if (!value.contains(RegExp('[a-z]'))) {
      return AppStrings.of(context).validationPasswordLowercase;
    }

    if (!value.contains(RegExp('[0-9]'))) {
      return AppStrings.of(context).validationPasswordNumber;
    }

    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return AppStrings.of(context).validationPasswordSpecial;
    }

    return null;
  }

  /// Validates if passwords match
  static String? confirmPassword(
    BuildContext context,
    String? value,
    String? password,
  ) {
    if (value == null || value.isEmpty) {
      return AppStrings.of(context).validationConfirmPasswordRequired;
    }

    if (value != password) {
      return AppStrings.of(context).validationPasswordsDoNotMatch;
    }

    return null;
  }

  /// Validates phone number
  static String? phone(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.of(context).validationPhoneRequired;
    }

    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');

    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[\s-]'), ''))) {
      return AppStrings.of(context).validationPhoneInvalid;
    }

    return null;
  }

  /// Validates minimum length
  static String? minLength(
    BuildContext context,
    String? value,
    int length, {
    String? fieldName,
  }) {
    final field = fieldName ?? 'This field';
    if (value == null || value.isEmpty) {
      return AppStrings.of(context).validationFieldRequired(field);
    }

    if (value.length < length) {
      return AppStrings.of(context).validationMinLength(field, length);
    }

    return null;
  }

  /// Validates maximum length
  static String? maxLength(
    BuildContext context,
    String? value,
    int length, {
    String? fieldName,
  }) {
    if (value == null || value.isEmpty) {
      return null;
    }

    if (value.length > length) {
      return AppStrings.of(
        context,
      ).validationMaxLength(fieldName ?? 'This field', length);
    }

    return null;
  }

  /// Validates numeric input
  static String? numeric(
    BuildContext context,
    String? value, {
    String? fieldName,
  }) {
    final field = fieldName ?? 'This field';
    if (value == null || value.isEmpty) {
      return AppStrings.of(context).validationFieldRequired(field);
    }

    if (double.tryParse(value) == null) {
      return AppStrings.of(context).validationMustBeNumber(field);
    }

    return null;
  }

  /// Validates URL format
  static String? url(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.of(context).validationUrlRequired;
    }

    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );

    if (!urlRegex.hasMatch(value)) {
      return AppStrings.of(context).validationUrlInvalid;
    }

    return null;
  }

  /// Validates credit card number
  static String? creditCard(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.of(context).validationCreditCardRequired;
    }

    final cardNumber = value.replaceAll(RegExp(r'[\s-]'), '');

    if (cardNumber.length < 13 || cardNumber.length > 19) {
      return AppStrings.of(context).validationCreditCardInvalid;
    }

    // Luhn algorithm
    int sum = 0;
    bool alternate = false;

    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cardNumber[i]);

      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit = (digit % 10) + 1;
        }
      }

      sum += digit;
      alternate = !alternate;
    }

    if (sum % 10 != 0) {
      return AppStrings.of(context).validationCreditCardInvalid;
    }

    return null;
  }

  /// Validates date format (dd/MM/yyyy)
  static String? date(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.of(context).validationDateRequired;
    }

    final dateRegex = RegExp(r'^\d{2}/\d{2}/\d{4}$');

    if (!dateRegex.hasMatch(value)) {
      return AppStrings.of(context).validationDateFormat;
    }

    final parts = value.split('/');
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);

    if (day == null || month == null || year == null) {
      return AppStrings.of(context).validationDateInvalid;
    }

    if (month < 1 || month > 12) {
      return AppStrings.of(context).validationMonthInvalid;
    }

    if (day < 1 || day > 31) {
      return AppStrings.of(context).validationDayInvalid;
    }

    return null;
  }

  /// Combines multiple validators
  static String? Function(String?) combine(
    BuildContext context,
    List<String? Function(String?)> validators,
  ) {
    return (String? value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) {
          return result;
        }
      }
      return null;
    };
  }
}
