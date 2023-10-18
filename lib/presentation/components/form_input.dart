import 'package:flutter/material.dart';

class InputWidget extends StatelessWidget {
  final String? hintText;
  final String? errorText;
  final Widget? prefixIcon;
  final double? height;
  final bool? obscureText;
  final FormFieldSetter<String>? onSaved;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final Key? kKey;
  final TextEditingController? kController;
  final String? kInitialValue;
  final int maxLines;

  const InputWidget({
    Key? key,
    this.hintText,
    this.prefixIcon,
    this.height = 48.0,
    this.obscureText = false,
    required this.onSaved,
    this.keyboardType,
    this.errorText,
    this.onChanged,
    this.validator,
    this.kKey,
    this.kController,
    this.kInitialValue,
    this.maxLines = 1,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(color: Colors.white)),
      child: TextFormField(
        initialValue: kInitialValue,
        controller: kController,
        key: kKey,
        keyboardType: keyboardType,
        onSaved: onSaved,
        onChanged: onChanged,
        validator: validator,
        maxLines: maxLines,
        obscureText: obscureText!,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
            prefixIcon: prefixIcon,
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromRGBO(74, 77, 84, 0.2),
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            errorStyle: const TextStyle(height: 0, color: Colors.transparent),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).errorColor,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).errorColor,
              ),
            ),
            hintText: hintText,
            hintStyle: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(color: Colors.white54),
            errorText: errorText),
      ),
    );
  }
}
