import 'package:flutter/material.dart';

class CustomPasswordField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String? hintText;

  const CustomPasswordField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.hintText,
  });

  @override
  State<CustomPasswordField> createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Color(0xFF6B3F2B),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: widget.controller,
          obscureText: _isObscured,
          decoration: InputDecoration(
            hintText: widget.hintText ?? widget.label,
            prefixIcon: const Icon(Icons.lock, color: Color(0xFF6B3F2B)),
            suffixIcon: IconButton(
              icon: Icon(
                _isObscured ? Icons.visibility_off : Icons.visibility,
                color: const Color(0xFF6B3F2B),
              ),
              onPressed: () => setState(() => _isObscured = !_isObscured),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF6B3F2B), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
          validator: widget.validator,
        ),
      ],
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType keyboardType;
  final String? hintText;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.hintText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Color(0xFF6B3F2B),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText ?? label,
            prefixIcon: Icon(icon, color: const Color(0xFF6B3F2B)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF6B3F2B), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
