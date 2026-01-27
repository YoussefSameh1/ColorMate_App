import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldModel {
  final TextEditingController controller;
  final String? labelText;
  final TextInputType keyboardType;
  final String hintText;
  final IconData? icon;
  final String? Function(String?)? validator;
  final bool obscureText;
  final AutovalidateMode? autovalidateMode;
  final FocusNode? focusNode;
  void Function(String)? onFieldSubmitted;
  void Function(String)? onChanged;
  void Function()? onTap;
  final int maxLines;
  bool autofocus;
  final String? errorText;
  final bool ischangeColor;
  final bool readOnly;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;

  TextFieldModel({
    required this.controller,
    this.labelText,
    required this.keyboardType,
    required this.hintText,
    this.icon,
    required this.validator,
    this.obscureText = false,
    this.autovalidateMode,
    this.focusNode,
    this.autofocus = false,
    this.onFieldSubmitted,
    this.errorText,
    this.onChanged,
    this.onTap,
    this.maxLines = 1,
    this.ischangeColor = false,
    this.readOnly = false,
    this.textInputAction,
    this.inputFormatters,
  });
}
