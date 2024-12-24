// ignore_for_file: deprecated_member_use

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:requests_with_riverpod/providers/business_logic/rate_provider.dart';

import '../test.mocks.dart';

void main() {
  late MockApiService mockApiService;
  late RateNotifier rateNotifier;

  setUp(
    () {
      mockApiService = MockApiService();
      rateNotifier = RateNotifier(mockApiService);
    },
  );

  group(
    "Тест оценки котенка",
    () {
      test(
        "Успешный ответ",
        () async {
          when(mockApiService.rateCat(any, any)).thenAnswer((_) async {});

          await rateNotifier.rate(1, 2);

          expect(rateNotifier.debugState.isSuccess, true);
          expect(rateNotifier.debugState.errorMessage, null);
        },
      );

      test(
        "При любой ошибке",
        () async {
          when(mockApiService.rateCat(any, any)).thenThrow(
            DioException(
              requestOptions: RequestOptions(path: ''),
            ),
          );

          try {
            await rateNotifier.rate(1, 2);
          } catch (_) {}

          expect(rateNotifier.debugState.isSuccess, false);
          expect(
            rateNotifier.debugState.errorMessage,
            'Что-то пошло не так...',
          );
        },
      );

      test(
        "При ошибке 500",
        () async {
          when(mockApiService.rateCat(any, any)).thenThrow(
            DioException(
              requestOptions: RequestOptions(path: ''),
              response: Response(
                requestOptions: RequestOptions(path: ''),
                statusCode: 500,
              ),
            ),
          );

          try {
            await rateNotifier.rate(1, 2);
          } catch (_) {}

          expect(rateNotifier.debugState.isSuccess, false);
          expect(
            rateNotifier.debugState.errorMessage,
            'Вы уже оценили этого котенка',
          );
        },
      );

      test(
        "При тайм-аут ошибке",
        () async {
          when(mockApiService.rateCat(any, any)).thenAnswer(
            (_) async => await Future.delayed(
              const Duration(seconds: 20),
            ),
          );

          try {
            await rateNotifier.rate(1, 2);
          } catch (_) {}

          expect(rateNotifier.debugState.isSuccess, false);
          expect(
            rateNotifier.debugState.errorMessage,
            'Проверьте соеденение с интерентом',
          );
        },
      );
    },
  );
}
