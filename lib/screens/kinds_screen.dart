import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:requests_with_riverpod/providers/business_logic/cat_list_provider.dart';
import 'package:requests_with_riverpod/providers/business_logic/kinds_provider.dart';
import 'package:requests_with_riverpod/ui/widgets/custom_app_bar.dart';
import 'package:requests_with_riverpod/ui/widgets/error_warning.dart';
import 'package:requests_with_riverpod/ui/widgets/loading_indicator.dart';

class KindsScreen extends ConsumerWidget {
  const KindsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kindsList = ref.watch(kindsProvider);
    final theme = Theme.of(context);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async => ref.refresh(kindsProvider),
        child: CustomScrollView(
          slivers: [
            CustomAppBar(
              backButton: IconButton(
                onPressed: () {
                  // ignore: unused_result
                  ref.refresh(catListProvider);
                  context.go('/cat-list');
                },
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            kindsList.when(
              data: (data) => SliverPadding(
                padding: const EdgeInsets.all(8.0),
                sliver: SliverGrid.builder(
                  itemCount: data.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => context.go('/kind-detail/${data[index].id}'),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: const DecorationImage(
                            image: AssetImage("assets/images/grid-bg.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Text(
                          '${data[index].id}. ${data[index].name}',
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                    );
                  },
                ),
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
