import 'package:flutter/material.dart';

class ErrorWarning extends StatelessWidget {
  const ErrorWarning({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SliverFillRemaining(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error,
            color: theme.colorScheme.error,
            size: 70,
          ),
          const SizedBox(height: 10),
          Text(
            'Не удалось загрузить данные',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }
}
