import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:requests_with_riverpod/providers/business_logic/cats_by_kind_provider.dart';
import 'package:requests_with_riverpod/ui/widgets/cat_list_item.dart';
import 'package:requests_with_riverpod/ui/widgets/custom_app_bar.dart';
import 'package:requests_with_riverpod/ui/widgets/error_warning.dart';
import 'package:requests_with_riverpod/ui/widgets/loading_indicator.dart';

class KindDetailScreen extends ConsumerWidget {
  const KindDetailScreen({
    super.key,
    required this.id,
  });

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catsByKindList = ref.watch(catsByKindProvider(id));
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async => ref.refresh(catsByKindProvider(id)),
        child: CustomScrollView(
          slivers: [
            CustomAppBar(
              backButton: IconButton(
                onPressed: () => context.go('/kinds'),
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            catsByKindList.when(
              data: (data) => SliverList.builder(
                itemCount: data.length,
                itemBuilder: (context, i) => CatListItem(cat: data[i]),
              ),
              error: (error, stackTrace) => const ErrorWarning(),
              loading: () => const LoadingIndicator(),
            )
          ],
        ),
      ),
    );
  }
}
