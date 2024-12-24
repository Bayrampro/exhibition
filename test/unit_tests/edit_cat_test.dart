// ignore_for_file: deprecated_member_use

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:requests_with_riverpod/providers/business_logic/edit_cat_provider.dart';

import '../test.mocks.dart';

void main() {
  late MockApiService mockApiService;
  late EditCatNotifier editCatNotifier;

  setUp(
    () {
      mockApiService = MockApiService();
      editCatNotifier = EditCatNotifier(mockApiService);
    },
  );
  group(
    "Тест на изменение котенка",
    () {
      test(
        "Успешный ответ",
        () async {
          when(mockApiService.updateCatById(any, any)).thenAnswer((_) async {});

          await editCatNotifier.updateCat(1, {'kind_id': 2});

          expect(editCatNotifier.debugState.isSuccess, true);
          expect(editCatNotifier.debugState.errorMessage, null);
        },
      );

      test(
        "При любой ошибке",
        () async {
          when(mockApiService.updateCatById(any, any)).thenThrow(
            DioException(
              requestOptions: RequestOptions(path: ''),
            ),
          );

          await editCatNotifier.updateCat(1, {'kind_id': 2});

          expect(editCatNotifier.debugState.isSuccess, false);
          expect(
            editCatNotifier.debugState.errorMessage,
            'Что-то пошло не так...',
          );
        },
      );

      test(
        "При 400 ошибке",
        () async {
          when(mockApiService.updateCatById(any, any)).thenThrow(
            DioException(
              requestOptions: RequestOptions(path: ''),
              response: Response(
                requestOptions: RequestOptions(path: ''),
                statusCode: 400,
              ),
            ),
          );

          await editCatNotifier.updateCat(1, {'kind_id': 2});

          expect(editCatNotifier.debugState.isSuccess, false);
          expect(
            editCatNotifier.debugState.errorMessage,
            'Неправильные вводные данные',
          );
        },
      );

      test(
        "При тайм аут ошибке",
        () async {
          when(mockApiService.updateCatById(any, any)).thenAnswer((_) async {
            await Future.delayed(const Duration(seconds: 15));
          });

          await editCatNotifier.updateCat(1, {'kind_id': 2});

          expect(editCatNotifier.debugState.isSuccess, false);
          expect(
            editCatNotifier.debugState.errorMessage,
            'Проверьте соеденение с интерентом',
          );
        },
      );
    },
  );
}
