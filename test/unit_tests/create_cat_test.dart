// ignore_for_file: deprecated_member_use

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:requests_with_riverpod/models/kind.dart';
import 'package:requests_with_riverpod/providers/business_logic/create_cat_provider.dart';

import '../test.mocks.dart';

void main() {
  late MockApiService mockApiService;
  late CreateCatNotifier createCatNotifier;

  setUp(
    () {
      mockApiService = MockApiService();
      createCatNotifier = CreateCatNotifier(mockApiService);
    },
  );

  group(
    "Тест создание нового котенка",
    () {
      test(
        "Успешый овтет",
        () async {
          when(mockApiService.createCat(any)).thenAnswer((_) async {});

          await createCatNotifier.createNewCat({
            'age': 11,
            'color': '#fffff',
            'description': '...',
            'kind': Kind(id: 1, name: 'Тест парода 2'),
          });

          expect(createCatNotifier.debugState.isSuccess, true);
        },
      );

      test(
        "При любой ошибке",
        () async {
          when(mockApiService.createCat(any)).thenThrow(
            DioException(
              requestOptions: RequestOptions(path: ''),
            ),
          );

          try {
            await createCatNotifier.createNewCat({
              'age': 11,
              'color': '#fffff',
              'description': '...',
              'kind': Kind(id: 1, name: 'Тест парода 2'),
            });
          } catch (_) {}

          expect(createCatNotifier.debugState.isSuccess, false);
          expect(
            createCatNotifier.debugState.errorMessage,
            'Что-то пошло не так...',
          );
          expect(createCatNotifier.debugState.isLoading, false);
        },
      );

      test(
        "При ошибке 400",
        () async {
          when(mockApiService.createCat(any)).thenThrow(
            DioException(
              requestOptions: RequestOptions(path: ''),
              response: Response(
                requestOptions: RequestOptions(path: ''),
                statusCode: 400,
                data: {'detail': 'Bad request'},
              ),
            ),
          );

          try {
            await createCatNotifier.createNewCat({
              'age': 11,
              'color': '#fffff',
              'description': '...',
              'kind': Kind(id: 1, name: 'Тест порода 2'),
            });
          } catch (_) {}

          expect(createCatNotifier.debugState.isSuccess, false);
          expect(
            createCatNotifier.debugState.errorMessage,
            'Неправильные вводные данные',
          );
          expect(createCatNotifier.debugState.isLoading, false);
        },
      );

      test(
        "При Тайм-аут ошибке",
        () async {
          when(mockApiService.createCat(any)).thenAnswer((_) async {
            await Future.delayed(const Duration(seconds: 20));
          });

          try {
            await createCatNotifier.createNewCat({
              'age': 11,
              'color': '#fffff',
              'description': '...',
              'kind': Kind(id: 1, name: 'Тест порода 2'),
            });
          } catch (_) {}

          expect(createCatNotifier.debugState.isSuccess, false);
          expect(createCatNotifier.debugState.isLoading, false);
          expect(
            createCatNotifier.debugState.errorMessage,
            'Проверьте соеденение с интерентом',
          );
        },
      );
    },
  );
}
