import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:requests_with_riverpod/models/auth_response.dart';
import 'package:requests_with_riverpod/providers/business_logic/login_provider.dart';
import 'package:requests_with_riverpod/repo/auth_token_repo/auth_token_interface.dart';
import 'package:requests_with_riverpod/repo/auth_token_repo/auth_token_repo.dart';

import '../test.mocks.dart';

void main() {
  late MockApiService mockApiService;
  late MockSharedPreferences mockSharedPreferences;
  late AuthTokenInterface authTokenRepo;
  late LoginNotifier loginNotifier;

  setUp(
    () {
      mockApiService = MockApiService();
      mockSharedPreferences = MockSharedPreferences();
      authTokenRepo = AuthTokenRepo(prefs: mockSharedPreferences);
      loginNotifier = LoginNotifier(mockApiService, authTokenRepo);
    },
  );

  group(
    "Test Login",
    () {
      test(
        "При успеешном авторизации стейт меняется и токены сохраняются в локальном хранилище",
        () async {
          when(mockApiService.getAuthToken(any)).thenAnswer(
            (_) async => AuthResponse(
                refresh: 'refresh_token_value', access: 'access_token_value'),
          );

          when(mockSharedPreferences.setString(any, any))
              .thenAnswer((_) async => true);

          await loginNotifier.login('test_username', 'test_password');

          verify(authTokenRepo.saveTokens(
                  'access_token_value', 'refresh_token_value'))
              .called(1);

          // ignore: deprecated_member_use
          expect(loginNotifier.debugState.isSuccess, true);
        },
      );

      test(
        "При тайм-аут ошибке записывается errorMessage",
        () async {
          when(mockApiService.getAuthToken(any))
              .thenThrow(TimeoutException('Тайм-аут!'));

          await loginNotifier.login('test_username', 'test_password');

          // ignore: deprecated_member_use
          expect(loginNotifier.debugState.errorMessage,
              'Проверьте соеденение с интерентом');
        },
      );

      test(
        "При 401 ошибке записывается errorMessage",
        () async {
          when(mockApiService.getAuthToken(any)).thenThrow(
            DioException(
              requestOptions: RequestOptions(path: ''),
              response: Response(
                requestOptions: RequestOptions(path: ''),
                statusCode: 401,
                data: {'detail': 'Неверные учетные данные'},
              ),
            ),
          );

          await loginNotifier.login('wrong_username', 'wrong_password');

          expect(
            // ignore: deprecated_member_use
            loginNotifier.debugState.errorMessage,
            'Неверные учетные данные',
          );
        },
      );
    },
  );
}
