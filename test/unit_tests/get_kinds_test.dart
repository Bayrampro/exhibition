import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:requests_with_riverpod/models/kind.dart';
import 'package:requests_with_riverpod/providers/business_logic/kinds_provider.dart';

import '../test.mocks.dart';

void main() {
  late MockApiService mockApiService;
  late ProviderContainer container;

  setUp(
    () {
      mockApiService = MockApiService();
      container = ProviderContainer(
        overrides: [
          kindsProvider.overrideWith(
            (ref) async => await mockApiService.getKinds().timeout(
                  const Duration(seconds: 15),
                ),
          )
        ],
      );
    },
  );

  group(
    "Тест на получение списка парод",
    () {
      test(
        "Успешный ответ",
        () async {
          when(mockApiService.getKinds()).thenAnswer(
            (_) async => [
              Kind(id: 1, name: 'Test Kind 1'),
              Kind(id: 2, name: 'Test Kind 2'),
            ],
          );

          final result = await container.read(kindsProvider.future);
          expect(result, isA<List<Kind>>());
          expect(result.length, 2);
          expect(result[0].id, 1);
        },
      );

      test(
        "Ошибка при запросе",
        () async {
          when(mockApiService.getKinds()).thenThrow(Exception('Bad request'));

          expect(container.read(kindsProvider.future), throwsException);
        },
      );

      test(
        "Тайм аут ошибка",
        () async {
          when(mockApiService.getKinds()).thenAnswer((_) async {
            await Future.delayed(const Duration(seconds: 20));
            return [
              Kind(id: 1, name: 'Test Kind 1'),
              Kind(id: 2, name: 'Test Kind 2'),
            ];
          });

          expect(
            container.read(kindsProvider.future),
            throwsA(
              isA<TimeoutException>(),
            ),
          );
        },
      );
    },
  );
}
