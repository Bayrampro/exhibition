import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:requests_with_riverpod/models/cat.dart';
import 'package:requests_with_riverpod/models/kind.dart';
import 'package:requests_with_riverpod/providers/business_logic/cat_list_provider.dart';

import '../test.mocks.dart';

void main() {
  late MockApiService mockApiService;
  late ProviderContainer container;

  setUp(
    () {
      mockApiService = MockApiService();
      container = ProviderContainer(overrides: [
        catListProvider.overrideWith(
          (ref) async {
            return await mockApiService
                .getCats()
                .timeout(const Duration(seconds: 15));
          },
        )
      ]);
    },
  );

  group(
    "Тест на получение котов",
    () {
      test(
        "Успешный ответ",
        () async {
          when(mockApiService.getCats()).thenAnswer(
            (_) async => [
              Cat(
                id: 1,
                age: 22,
                averageRating: 3.0,
                color: '#fffff',
                description: '...',
                kind: Kind(id: 1, name: 'Тест парода 1'),
                userId: 1,
              ),
              Cat(
                id: 2,
                age: 11,
                averageRating: 2.0,
                color: '#fffff',
                description: '...',
                kind: Kind(id: 1, name: 'Тест парода 2'),
                userId: 1,
              )
            ],
          );

          final result = await container.read(catListProvider.future);

          expect(result.length, 2);
          expect(result, isA<List<Cat>>());
          expect(result[0].age, 22);
        },
      );

      test(
        "Ошибка при запросе",
        () async {
          when(mockApiService.getCats()).thenThrow(Exception('Bad request'));

          expect(container.read(catListProvider.future), throwsException);
        },
      );

      test(
        "Тайм аут ошибка",
        () async {
          when(mockApiService.getCats()).thenAnswer((_) async {
            await Future.delayed(const Duration(seconds: 20));
            return [
              Cat(
                id: 1,
                age: 22,
                averageRating: 3.0,
                color: '#fffff',
                description: '...',
                kind: Kind(id: 1, name: 'Тест парода 1'),
                userId: 1,
              ),
              Cat(
                id: 2,
                age: 11,
                averageRating: 2.0,
                color: '#fffff',
                description: '...',
                kind: Kind(id: 1, name: 'Тест парода 2'),
                userId: 1,
              )
            ];
          });

          expect(
            container.read(catListProvider.future),
            throwsA(
              isA<TimeoutException>(),
            ),
          );
        },
      );
    },
  );
}
