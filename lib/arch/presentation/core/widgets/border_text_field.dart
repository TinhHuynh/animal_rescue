import 'package:flutter/material.dart';

import '../../../../gen/colors.gen.dart';
import '../decorations/decorations.dart';
import 'base_border_text_field.dart';


class BorderTextField extends StatefulWidget {
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final String? labelText;
  final String? errorText;
  final int? maxLines;
  final InputDecoration Function(bool)? decoration;

  const BorderTextField({
    Key? key,
    this.focusNode,
    this.keyboardType,
    this.onChanged,
    this.decoration,
    this.labelText,
    this.errorText,
    this.maxLines,
  }) : super(key: key);

  @override
  BaseBorderTextFieldState<BorderTextField> createState() =>
      _BorderTextFieldState();
}

class _BorderTextFieldState extends BaseBorderTextFieldState<BorderTextField> {
  @override
  void initState() {
    focusNode = widget.focusNode ?? FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      keyboardType: widget.keyboardType,
      onChanged: widget.onChanged,
      maxLines: widget.maxLines,
      decoration: widget.decoration?.call(isFocused) ??
          borderInputDecorator.copyWith(
              alignLabelWithHint: true,
              labelText: widget.labelText,
              errorText: widget.errorText,
              floatingLabelStyle: TextStyle(
                  color: (widget.errorText != null)
                      ? Colors.red
                      : isFocused
                          ? ColorName.brand
                          : Colors.grey)),
    );
  }
}
