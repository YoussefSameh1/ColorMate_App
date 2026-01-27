import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class Validation {
  /// Empty Text Validation
  static String? validateEmptyText(String? fieldname, String? value) {
    if (value == null || value.isEmpty) {
      return '$fieldname is required.';
    }
    return null;
  }

  static String? emailValidation(value) {
    if (value == null || value.isEmpty) {
      return 'Email is required.';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Invalid email address.';
    }
    return null;
  }

  static String? validatePassword(value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }

    // Check for minimum password length
    if (value.length < 8) {
      return 'Password must be at least 8 characters long.';
    }

    // Check for uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter.';
    }

    // Check for lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter.';
    }

    // Check for digit
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number.';
    }

    // Check for special character
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character.';
    }

    return null;
  }

  static String? validateUserName(String? value) {
    if (value == null || value.isEmpty) {
      return 'please_enter_username'.tr();
    }

    final trimmedValue = value.trim();

    // Must be at least 3 characters
    if (trimmedValue.length < 3) {
      return 'username_must_be_at_least_3_characters'.tr();
    }

    // Can only contain letters, numbers, hyphens, and underscores
    final userNameRegex = RegExp(r'^[a-zA-Z0-9_-]+$');
    if (!userNameRegex.hasMatch(trimmedValue)) {
      return 'username_invalid_characters'.tr();
    }

    return null;
  }

  static String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter your full name.';
    }

    // Remove extra spaces and split by spaces
    final nameParts = value.trim().split(RegExp(r'\s+'));

    if (nameParts.length < 2) {
      return 'Enter your first and last name.';
    }

    // Check if each name part has at least 2 characters
    for (var part in nameParts) {
      if (part.length < 3) {
        return 'Name must be at least 2 characters.';
      }
    }

    return null;
  }

  static String? validateConfirmPassword(
    String? value,
    TextEditingController passwordController,
  ) {
    if (value == null || value.isEmpty) {
      return 'Confirm Password is required.';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match.';
    }
    return null;
  }

  static String? validateEgyptianPhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Standardize input for validation logic (Remove spaces, dashes, +)
    final cleaned = value.replaceAll(RegExp(r'[\s\-\+]'), '');

    // Regex Explanation:
    // ^              : Start
    // (20)?          : Optional Country Code '20'
    // (0)?           : Optional leading '0'
    // 1              : Must start with '1' (after prefix)
    // [0125]         : Next digit must be 0, 1, 2, or 5 (Vodafone, Etisalat, Orange, WE)
    // \d{8}          : Exactly 8 digits follow
    // $              : End
    final regex = RegExp(r'^(20)?(0)?1[0125]\d{8}$');

    if (!regex.hasMatch(cleaned)) {
      return 'Enter a valid Egyptian phone number (e.g. 010...)';
    }

    return null;
  }
}
