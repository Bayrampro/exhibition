import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:requests_with_riverpod/api/api_service.dart';
import 'package:requests_with_riverpod/models/cat.dart';
import 'package:requests_with_riverpod/models/kind.dart';
import 'package:requests_with_riverpod/ui/widgets/my_cats_list_item.dart';

import '../test.mocks.dart';

void main() {
  late MockApiService mockApiService;

  setUp(
    () {
      mockApiService = MockApiService();
      GetIt.I.registerSingleton<ApiService>(mockApiService);
    },
  );

  tearDown(
    () {
      GetIt.I.reset();
    },
  );

  group(
    "Тест Dismissible виджета",
    () {
      final testCatList = [
        Cat(
          id: 1,
          color: '#75A686',
          age: 1,
          description: '...',
          userId: 1,
          kind: Kind(id: 1, name: '...'),
          averageRating: 0.0,
        ),
        Cat(
          id: 2,
          color: '#75A686',
          age: 14,
          description: '...',
          userId: 1,
          kind: Kind(id: 1, name: '...'),
          averageRating: 0.0,
        )
      ];

      testWidgets(
        "Если удаление подтвердилось",
        (WidgetTester tester) async {
          Future<bool> mockConfirmDismiss(DismissDirection direction) async {
            testCatList.removeAt(0);
            await mockApiService.deleteCatById(1);
            return true;
          }

          when(mockApiService.deleteCatById(any)).thenAnswer((_) async {});

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: ListView(
                  children: testCatList
                      .asMap()
                      .entries
                      .map(
                        (entry) => MyCatsListItem(
                          cat: entry.value,
                          index: entry.key,
                          listLength: testCatList.length,
                          onEdit: () {},
                          confirmDismiss: mockConfirmDismiss,
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          );

          await tester.drag(
              find.byKey(const ValueKey(1)), const Offset(-500, 0));
          await tester.pumpAndSettle();

          expect(find.byKey(const ValueKey(1)), findsNothing);
          verify(mockApiService.deleteCatById(1)).called(1);
        },
      );
      testWidgets(
        "Если удаление нет подтвердилось",
        (WidgetTester tester) async {
          Future<bool> mockConfirmDismiss(DismissDirection direction) async {
            return false;
          }

          when(mockApiService.deleteCatById(any)).thenAnswer((_) async {});

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: ListView(
                  children: testCatList
                      .asMap()
                      .entries
                      .map(
                        (entry) => MyCatsListItem(
                          cat: entry.value,
                          index: entry.key,
                          listLength: testCatList.length,
                          onEdit: () {},
                          confirmDismiss: mockConfirmDismiss,
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          );

          await tester.drag(
              find.byKey(const ValueKey(1)), const Offset(-500, 0));
          await tester.pumpAndSettle();

          expect(find.byKey(const ValueKey(1)), findsOneWidget);
          verifyNever(mockApiService.deleteCatById(1));
        },
      );
    },
  );
}
