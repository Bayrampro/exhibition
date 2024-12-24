// ignore_for_file: deprecated_member_use

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:requests_with_riverpod/providers/business_logic/delete_cat_provider.dart';

import '../test.mocks.dart';

void main() {
  late MockApiService mockApiService;
  late DeleteCatNotifier deleteCatNotifier;

  setUp(
    () {
      mockApiService = MockApiService();
      deleteCatNotifier = DeleteCatNotifier(mockApiService);
    },
  );

  group(
    "Тест на удаление котенка",
    () {
      test(
        "Успешный ответ",
        () async {
          when(mockApiService.deleteCatById(any)).thenAnswer((_) async {});

          await deleteCatNotifier.deleteCat(1);

          expect(deleteCatNotifier.debugState.isSuccess, true);
          expect(deleteCatNotifier.debugState.errorMessage, null);
        },
      );

      test(
        "При любой ошибке",
        () async {
          when(mockApiService.deleteCatById(any)).thenThrow(
            DioException(
              requestOptions: RequestOptions(path: ''),
              response: Response(
                requestOptions: RequestOptions(path: ''),
              ),
            ),
          );

          await deleteCatNotifier.deleteCat(1);

          expect(deleteCatNotifier.debugState.isSuccess, false);
          expect(
            deleteCatNotifier.debugState.errorMessage,
            'Что-то пошло не так...',
          );
        },
      );

      test(
        "При тайм аут ошибке",
        () async {
          when(mockApiService.deleteCatById(any)).thenAnswer((_) async {
            await Future.delayed(const Duration(seconds: 20));
          });

          await deleteCatNotifier.deleteCat(1);

          expect(deleteCatNotifier.debugState.isSuccess, false);
          expect(
            deleteCatNotifier.debugState.errorMessage,
            'Проверьте соеденение с интерентом',
          );
        },
      );
    },
  );
}
