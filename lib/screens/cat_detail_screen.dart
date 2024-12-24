import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:requests_with_riverpod/providers/business_logic/cat_detail_provider.dart';
import 'package:requests_with_riverpod/providers/business_logic/cat_list_provider.dart';
import 'package:requests_with_riverpod/providers/business_logic/rate_provider.dart';
import 'package:requests_with_riverpod/ui/widgets/loading_indicator.dart';
import 'package:requests_with_riverpod/ui/widgets/custom_app_bar.dart';
import 'package:requests_with_riverpod/ui/widgets/error_warning.dart';
import 'package:requests_with_riverpod/utils/hex_string_to_color.dart';
import 'package:requests_with_riverpod/ui/widgets/detail_table_row.dart';

class CatDetailScreen extends ConsumerWidget {
  const CatDetailScreen({
    super.key,
    required this.id,
  });

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final catDetail = ref.watch(catDetailProvider(id));
    final rateState = ref.watch(rateProvider);
    final rateNotifier = ref.read(rateProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (rateState.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Вы успешно оценили котика',
                style: TextStyle(
                  color: Color.fromARGB(255, 34, 119, 37),
                ),
              ),
              backgroundColor: Colors.green,
            ),
          );
          // ignore: unused_result
          ref.refresh(catDetailProvider(id));
        } else if (rateState.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                rateState.errorMessage!,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
              backgroundColor: theme.colorScheme.errorContainer,
            ),
          );
        }
        rateNotifier.backToInitial();
      },
    );
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async => ref.refresh(catDetailProvider(id)),
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
              actions: [
                PopupMenuButton(
                  icon: const Icon(Icons.stars_outlined),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      onTap: () => rateNotifier.rate(id, 1),
                      child: IconButton(
                        onPressed: () => rateNotifier.rate(id, 1),
                        icon: const Icon(
                          Icons.star,
                          color: Colors.yellow,
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () => rateNotifier.rate(id, 2),
                      child: IconButton(
                        onPressed: () => rateNotifier.rate(id, 2),
                        icon: Row(
                          children: List.generate(
                            2,
                            (index) => const Icon(
                              Icons.star,
                              color: Colors.yellow,
                            ),
                          ),
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () => rateNotifier.rate(id, 3),
                      child: IconButton(
                        onPressed: () => rateNotifier.rate(id, 3),
                        icon: Row(
                          children: List.generate(
                            3,
                            (index) => const Icon(
                              Icons.star,
                              color: Colors.yellow,
                            ),
                          ),
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () => rateNotifier.rate(id, 4),
                      child: IconButton(
                        onPressed: () => rateNotifier.rate(id, 4),
                        icon: Row(
                          children: List.generate(
                            4,
                            (index) => const Icon(
                              Icons.star,
                              color: Colors.yellow,
                            ),
                          ),
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () => rateNotifier.rate(id, 5),
                      child: IconButton(
                        onPressed: () => rateNotifier.rate(id, 5),
                        icon: Row(
                          children: List.generate(
                            5,
                            (index) => const Icon(
                              Icons.star,
                              color: Colors.yellow,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            catDetail.when(
              data: (data) => SliverPadding(
                padding: const EdgeInsets.all(30),
                sliver: SliverToBoxAdapter(
                  child: Container(
                    height: 400,
                    decoration: BoxDecoration(
                      color: theme.canvasColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        DetailTableRow(
                          rowName: 'Цвет',
                          dataWidget: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: hexStringToColor(data.color),
                            ),
                            width: 50,
                            height: 50,
                          ),
                        ),
                        DetailTableRow(
                          rowName: 'Возраст',
                          dataString: '${data.age}',
                        ),
                        DetailTableRow(
                          rowName: 'Описание',
                          dataString: data.description,
                        ),
                        DetailTableRow(
                          rowName: 'Парода',
                          dataString: data.kind.name,
                        ),
                        DetailTableRow(
                          rowName: 'Общий рейтинг',
                          dataString: '${data.averageRating}',
                        ),
                      ],
                    ),
                  ),
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
