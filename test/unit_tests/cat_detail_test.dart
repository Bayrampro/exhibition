import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:requests_with_riverpod/models/cat.dart';
import 'package:requests_with_riverpod/models/kind.dart';
import 'package:requests_with_riverpod/providers/business_logic/cat_detail_provider.dart';

import '../test.mocks.dart';

void main() {
  late MockApiService mockApiService;
  late ProviderContainer container;

  setUp(
    () {
      mockApiService = MockApiService();
      container = ProviderContainer(overrides: [
        catDetailProvider.overrideWith(
          (ref, id) async {
            return await mockApiService
                .getCatsDetail(id)
                .timeout(const Duration(seconds: 15));
          },
        )
      ]);
    },
  );

  group(
    "Тест детального просмотра котенка",
    () {
      test(
        "Успешный ответ",
        () async {
          when(mockApiService.getCatsDetail(1)).thenAnswer(
            (_) async => Cat(
              id: 1,
              age: 22,
              averageRating: 3.0,
              color: '#fffff',
              description: '...',
              kind: Kind(id: 1, name: 'Тест парода 1'),
              userId: 1,
            ),
          );

          final result = await container.read(catDetailProvider(1).future);

          expect(result, isA<Cat>());
          expect(result.id, 1);
        },
      );

      test(
        "Ошибка при запросе",
        () async {
          when(mockApiService.getCatsDetail(1))
              .thenThrow(Exception('Bad request'));

          expect(container.read(catDetailProvider(1).future), throwsException);
        },
      );

      test(
        "Тайм аут оишбка",
        () async {
          when(mockApiService.getCatsDetail(1)).thenAnswer((_) async {
            await Future.delayed(const Duration(seconds: 20));

            return Cat(
              id: 1,
              age: 22,
              averageRating: 3.0,
              color: '#fffff',
              description: '...',
              kind: Kind(id: 1, name: 'Тест парода 1'),
              userId: 1,
            );
          });

          expect(
            container.read(catDetailProvider(1).future),
            throwsA(
              isA<TimeoutException>(),
            ),
          );
        },
      );
    },
  );
}
