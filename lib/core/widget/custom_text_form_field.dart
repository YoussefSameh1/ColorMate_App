import 'package:colormate_app/core/model/text_field_model/text_field_model.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({super.key, required this.textFieldModel});

  final TextFieldModel textFieldModel;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool isObscured;

  @override
  void initState() {
    super.initState();
    isObscured = widget.textFieldModel.obscureText;
  }

  @override
  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: widget.textFieldModel.controller.text,
      validator: widget.textFieldModel.validator,
      autovalidateMode: widget.textFieldModel.autovalidateMode,
      builder: (FormFieldState<String> fieldState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: widget.textFieldModel.controller,
              cursorColor: const Color.fromARGB(255, 121, 85, 72),
              onChanged: (v) => fieldState.didChange(v),
              obscureText: isObscured,

              keyboardType: widget.textFieldModel.keyboardType,
              autofocus: widget.textFieldModel.autofocus,
              focusNode: widget.textFieldModel.focusNode,
              onSubmitted: widget.textFieldModel.onFieldSubmitted,
              style: TextStyle(
                color: const Color.fromARGB(255, 201, 120, 91),
                fontSize: 14,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                labelText: widget.textFieldModel.labelText,
                labelStyle: TextStyle(
                  color: const Color.fromARGB(255, 201, 120, 91),
                  fontWeight: FontWeight.w500,
                ),
                hintText: widget.textFieldModel.hintText,
                errorText: null,
                hintStyle: TextStyle(
                  color: const Color.fromARGB(255, 239, 178, 156),
                ),
                suffixIcon: widget.textFieldModel.obscureText
                    ? GestureDetector(
                        onTap: () {
                          isObscured = !isObscured;
                          setState(() {});
                        },
                        child: Icon(
                          isObscured
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.brown,
                        ),
                      )
                    : null,
                border: _customOutlineInputBorder(),
                focusedBorder: _customOutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.brown, width: 1.5),
                ),
              ),
            ),
            if (fieldState.errorText != null)
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 6.0),
                child: Text(
                  fieldState.errorText!,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 198, 40, 40),
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  OutlineInputBorder _customOutlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(
        color: const Color.fromARGB(255, 121, 85, 72),
        width: 2,
      ),
    );
  }
}
