import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputField extends StatefulWidget {
  const InputField({
    super.key,
    required this.validator,
    required this.onSaved,
    this.isObscure,
    this.border,
    this.horizontalPaddingValue,
    this.keyboardType,
    this.inputFormatters,
    this.initialValue,
  });

  final String? Function(String? value) validator;
  final void Function(String? value) onSaved;
  final bool? isObscure;
  final BoxBorder? border;
  final double? horizontalPaddingValue;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? initialValue;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: widget.horizontalPaddingValue ?? 12.0),
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 6.0,
      ),
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: theme.canvasColor,
        border: widget.border,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              initialValue: widget.initialValue,
              decoration: const InputDecoration(
                border: InputBorder.none,
                label: null,
              ),
              validator: widget.validator,
              onSaved: widget.onSaved,
              obscureText: widget.isObscure ?? false ? obscure : false,
              obscuringCharacter: '*',
              keyboardType: widget.keyboardType,
              inputFormatters: widget.inputFormatters,
            ),
          ),
          if (widget.isObscure != null)
            IconButton(
              icon: Icon(obscure ? Icons.no_encryption : Icons.lock),
              onPressed: () => setState(() => obscure = !obscure),
            )
        ],
      ),
    );
  }
}
