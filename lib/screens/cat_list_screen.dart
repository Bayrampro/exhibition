import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:requests_with_riverpod/providers/business_logic/cat_list_provider.dart';
import 'package:requests_with_riverpod/ui/widgets/loading_indicator.dart';
import 'package:requests_with_riverpod/ui/widgets/cat_list_item.dart';
import 'package:requests_with_riverpod/ui/widgets/custom_app_bar.dart';
import 'package:requests_with_riverpod/ui/widgets/error_warning.dart';
import 'package:requests_with_riverpod/ui/widgets/main_drawer.dart';

class CatListScreen extends ConsumerWidget {
  const CatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catList = ref.watch(catListProvider);

    return Scaffold(
      drawer: const MainDrawer(),
      body: RefreshIndicator(
        onRefresh: () async => ref.refresh(catListProvider),
        child: CustomScrollView(
          slivers: [
            const CustomAppBar(),
            catList.when(
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
