import 'package:flutter/material.dart';

class QuestionDialog extends StatelessWidget {
  const QuestionDialog({
    super.key,
    required this.titleText,
    required this.questionText,
    required this.yesOnPressed,
    required this.noOnPressed,
  });

  final String titleText;
  final String questionText;
  final void Function() yesOnPressed;
  final void Function() noOnPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        titleText,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
      ),
      content: Text(
        questionText,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      actions: [
        TextButton(
          key: const ValueKey('yes'),
          onPressed: yesOnPressed,
          child: const Text('Да'),
        ),
        TextButton(
          key: const ValueKey('no'),
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Нет'),
        ),
      ],
    );
  }
}
