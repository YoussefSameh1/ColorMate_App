import 'package:colormate_app/core/widget/labels/custom_field_label.dart';
import 'package:colormate_app/core/model/text_field_model/text_field_model.dart';
import 'package:colormate_app/core/widget/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class CustomFormSection extends StatelessWidget {
  const CustomFormSection({
    super.key,
    required this.label,
    required this.textFieldModel,
    this.isRequired = false,
    this.spacing = 12,
  });

  final String label;
  final TextFieldModel textFieldModel;
  final bool isRequired;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomFieldLabel(label: label, isRequired: isRequired),
        SizedBox(height: spacing),
        CustomTextFormField(textFieldModel: textFieldModel),
      ],
    );
  }
}
