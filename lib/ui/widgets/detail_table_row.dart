import 'package:flutter/material.dart';

class DetailTableRow extends StatelessWidget {
  const DetailTableRow({
    super.key,
    required this.rowName,
    this.dataWidget,
    this.dataString,
  });

  final String rowName;
  final Widget? dataWidget;
  final String? dataString;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            rowName,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          dataWidget != null
              ? dataWidget!
              : SizedBox(
                  width: 80,
                  child: Text(
                    dataString!,
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
        ],
      ),
    );
  }
}
