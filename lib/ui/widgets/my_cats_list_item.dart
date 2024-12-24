import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:requests_with_riverpod/models/cat.dart';
import 'package:requests_with_riverpod/utils/hex_string_to_color.dart';

class MyCatsListItem extends ConsumerWidget {
  const MyCatsListItem({
    super.key,
    required this.cat,
    required this.index,
    required this.listLength,
    required this.onEdit,
    required this.confirmDismiss,
  });

  final Cat cat;
  final int index;
  final int listLength;
  final Future<bool?> Function(DismissDirection dir) confirmDismiss;
  final void Function() onEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Dismissible(
      confirmDismiss: confirmDismiss,
      key: ValueKey(cat.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.only(top: 8.0, right: 8.0, bottom: 3.0),
        color: theme.colorScheme.error,
        child: Icon(
          Icons.delete_sweep,
          color: theme.canvasColor,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 5,
          right: 5,
          top: 8,
          bottom: listLength == index + 1 ? 8.0 : 0.0,
        ),
        child: Stack(
          children: [
            Card(
              clipBehavior: Clip.hardEdge,
              child: Container(
                margin: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: hexStringToColor(cat.color),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            height: 90,
                            width: 90,
                          ),
                          const SizedBox(width: 16.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cat.kind.name,
                                style: theme.textTheme.titleMedium,
                              ),
                              Text('Возраст: ${cat.age}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: onEdit,
                      style: IconButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                      ),
                      icon: Icon(
                        Icons.edit,
                        color: theme.canvasColor,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: theme.colorScheme.error,
                  borderRadius:
                      const BorderRadius.only(bottomRight: Radius.circular(50)),
                ),
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: theme.canvasColor,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
