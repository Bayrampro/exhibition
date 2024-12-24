import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:requests_with_riverpod/interceptors/auth_interceptor.dart';
import 'package:requests_with_riverpod/repo/auth_token_repo/auth_token_interface.dart';

import 'refresh_token_test.mocks.dart';

@GenerateMocks([AuthTokenInterface])
void main() {
  late MockAuthTokenInterface mockAuthTokenRepo;
  late AuthInterceptor authInterceptor;
  late RequestOptions requestOptions;
  setUp(
    () {
      mockAuthTokenRepo = MockAuthTokenInterface();
      authInterceptor = AuthInterceptor(authTokenRepo: mockAuthTokenRepo);
      requestOptions = RequestOptions(path: '/api/test');
    },
  );

  group(
    "Тест AuthInterceptor",
    () {
      test(
        "Когда истек access токен",
        () async {
          final jwt =
              JWT({'exp': DateTime.now().millisecondsSinceEpoch ~/ 1000 - 10});

          final expiredToken = jwt.sign(SecretKey('test_secret_key'));

          final validToken = JWT({
            'exp': DateTime.now()
                    .add(const Duration(hours: 1))
                    .microsecondsSinceEpoch ~/
                1000
          }).sign(SecretKey('test_secret_key'));

          when(mockAuthTokenRepo.getTokens()).thenReturn({
            'access': expiredToken,
            'refresh': validToken,
          });

          when(mockAuthTokenRepo.refreshAccessToken(any))
              .thenAnswer((_) async => 'new_access');

          final handler = RequestInterceptorHandler();

          await authInterceptor.onRequest(requestOptions, handler);

          expect(requestOptions.headers['Authorization'], 'Bearer new_access');
          verify(mockAuthTokenRepo.refreshAccessToken(validToken)).called(1);
        },
      );

      test(
        "Запрос с валидным токеном",
        () async {
          final DateTime exp = DateTime.now().add(const Duration(hours: 1));
          final jwt = JWT({
            'exp': exp.millisecondsSinceEpoch ~/ 1000,
          });
          final String goodToken = jwt.sign(SecretKey('test_secret_key'));

          when(mockAuthTokenRepo.getTokens()).thenReturn({
            'access': goodToken,
            'refresh': goodToken,
          });

          final handler = RequestInterceptorHandler();

          await authInterceptor.onRequest(requestOptions, handler);

          expect(requestOptions.headers['Authorization'], 'Bearer $goodToken');

          verifyNever(mockAuthTokenRepo.refreshAccessToken(goodToken));
        },
      );
    },
  );
}
