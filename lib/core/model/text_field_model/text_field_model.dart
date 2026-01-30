import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldModel {
  final TextEditingController controller;
  final String? labelText;
  final TextInputType keyboardType;
  final String hintText;
   final List<TextInputFormatter>? inputFormatters;
  final IconData? icon;
  final String? Function(String?)? validator;
  final bool obscureText;
  final AutovalidateMode? autovalidateMode;
  final FocusNode? focusNode;
  void Function(String)? onFieldSubmitted;
  
  bool autofocus;
  final String? errorText;
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
     this.inputFormatters,
  });
}
