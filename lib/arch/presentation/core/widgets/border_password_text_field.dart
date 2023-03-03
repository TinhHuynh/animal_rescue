import 'package:flutter/material.dart';

import '../../../../gen/colors.gen.dart';
import '../decorations/decorations.dart';
import 'base_border_text_field.dart';

class BorderPasswordTextField extends StatefulWidget {
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final String? labelText;
  final String? errorText;
  final String? helperText;
  final InputDecoration Function(bool)? decoration;

  const BorderPasswordTextField({
    Key? key,
    this.focusNode,
    this.onChanged,
    this.decoration,
    this.labelText,
    this.errorText,
    this.helperText,
  }) : super(key: key);

  @override
  BaseBorderTextFieldState<BorderPasswordTextField> createState() =>
      _BorderPasswordTextFieldState();
}

class _BorderPasswordTextFieldState
    extends BaseBorderTextFieldState<BorderPasswordTextField> {
  var _obscurePassword = true;
  var _showVisibilityIcon = false;

  @override
  void initState() {
    focusNode = widget.focusNode ?? FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      keyboardType: TextInputType.text,
      obscureText: _obscurePassword,
      onChanged: (s) {
        _updateShowVisibilityIcon(s.isNotEmpty);
        widget.onChanged?.call(s);
      },
      decoration: widget.decoration?.call(isFocused) ??
        borderInputDecorator.copyWith(
              labelText: widget.labelText,
              errorText: widget.errorText,
              helperText: widget.helperText,
              floatingLabelStyle: TextStyle(
                  color: (widget.errorText != null)
                      ? Colors.red
                      : isFocused
                          ? ColorName.brand
                          : Colors.grey),
              suffixIcon: _showVisibilityIcon
                  ? GestureDetector(
                      onTap: _toggleShowPassword,
                      child: Icon(_obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                    )
                  : null),
    );
  }

  _toggleShowPassword() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _updateShowVisibilityIcon(bool value) {
    setState(() {
      _showVisibilityIcon = value;
    });
  }
}
