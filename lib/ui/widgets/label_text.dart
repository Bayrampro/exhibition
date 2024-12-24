import 'package:flutter/material.dart';

class LabelText extends StatelessWidget {
  const LabelText({
    super.key,
    required this.text,
    required this.spaceBefore,
  });

  final String text;
  final double spaceBefore;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        SizedBox(width: spaceBefore),
        Text(
          text,
          style: theme.textTheme.titleMedium,
        ),
      ],
    );
  }
}
