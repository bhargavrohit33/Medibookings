import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medibookings/common/utils.dart';


TextFormField textFormField({
  required TextEditingController textEditingController,
  InputDecoration? decoration,
  TextInputType? keyboardType,
  TextCapitalization textCapitalization = TextCapitalization.none,
  bool autocorrect = false,
  bool enableSuggestions = false,
  int maxLength = TextField.noMaxLength,
  bool showLengthCount = false,
  String? Function(String?)? validator,
  bool obscureText = false,asdasd
}) {
  final inputDecoration = decoration ?? defaultInputDecoration();
  final hasLengthCounter = maxLength != TextField.noMaxLength && showLengthCount;
  final effectiveDecoration = inputDecoration.copyWith(
    counterText: hasLengthCounter ? null : '',
  );

  return TextFormField(
    obscureText: obscureText,
    controller: textEditingController,
    decoration: effectiveDecoration,
    keyboardType: keyboardType,
    textCapitalization: textCapitalization,
    autocorrect: autocorrect,
    enableSuggestions: enableSuggestions,
    maxLength: maxLength,
    validator: validator,
    maxLengthEnforcement: showLengthCount ? MaxLengthEnforcement.enforced : MaxLengthEnforcement.none,
  );
}
