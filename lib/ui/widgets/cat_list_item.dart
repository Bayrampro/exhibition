import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:requests_with_riverpod/models/cat.dart';
import 'package:requests_with_riverpod/utils/hex_string_to_color.dart';

class CatListItem extends ConsumerWidget {
  const CatListItem({
    super.key,
    required this.cat,
  });

  final Cat cat;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = cat.color;
    final averageRating = cat.averageRating;
    final kind = cat.kind;
    final age = cat.age;
    final id = cat.id;
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, top: 16),
      child: ListTile(
        onTap: () => context.go('/detail/$id'),
        minTileHeight: 90,
        leading: Container(
          decoration: BoxDecoration(
            color: hexStringToColor(color),
            borderRadius: BorderRadius.circular(50),
          ),
          height: 50,
          width: 50,
        ),
        title: Text(
          kind.name,
          style: theme.textTheme.titleMedium,
        ),
        subtitle: Text('Возраст: $age'),
        trailing: TextButton.icon(
          onPressed: null,
          label: Text('$averageRating'),
          icon: const Icon(Icons.star),
        ),
        tileColor: theme.canvasColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
