import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

void main() {
  group(
    "Тест начального экрана в зависимости от токена в локальном хранилище",
    () {
      String initialLocation = '/cat-list';
      String getInitialLocation(
          bool? isAuthenticated, bool isFirstTime, Map<String, String> tokens) {
        if (isFirstTime) {
          initialLocation = '/';
          return initialLocation;
        } else if (isAuthenticated != null && !isAuthenticated ||
            JwtDecoder.isExpired(tokens['refresh']!)) {
          initialLocation = '/login';
          return initialLocation;
        }
        return initialLocation;
      }

      test(
        "Если все ок, возвращаем список котов",
        () {
          final DateTime exp = DateTime.now().add(const Duration(hours: 1));
          final jwt = JWT({
            'exp': exp.millisecondsSinceEpoch ~/ 1000,
          });
          final String goodToken = jwt.sign(SecretKey('test_secret_key'));
          final result = getInitialLocation(
            true,
            false,
            {'refresh': goodToken, 'access': goodToken},
          );
          expect(result, '/cat-list');
        },
      );

      test(
        "Если первый вход, возвращает главную страницу",
        () {
          final result = getInitialLocation(null, true, {});
          expect(result, '/');
        },
      );

      test(
        "Если не авторизован то возвращаем страницу логина",
        () {
          final result = getInitialLocation(
            false,
            false,
            {'refresh': '', 'access': ''},
          );
          expect(result, '/login');
        },
      );

      test(
        "Если есть рефреш токен но он истек возвращаем страницу логина",
        () {
          final jwt =
              JWT({'exp': DateTime.now().millisecondsSinceEpoch ~/ 1000 - 10});
          final String expiredToken = jwt.sign(SecretKey('test_secret_key'));
          final result = getInitialLocation(
            true,
            false,
            {'refresh': expiredToken, 'access': expiredToken},
          );
          expect(result, '/login');
        },
      );
    },
  );
}
