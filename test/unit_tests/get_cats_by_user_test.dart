import 'dart:async';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:requests_with_riverpod/models/cat.dart';
import 'package:requests_with_riverpod/models/kind.dart';
import 'package:requests_with_riverpod/providers/business_logic/cats_by_user_provider.dart';

import 'refresh_token_test.mocks.dart';
import '../test.mocks.dart';

void main() {
  late MockApiService mockApiService;
  late MockAuthTokenInterface mockAuthRepo;
  late ProviderContainer container;

  setUp(
    () {
      mockApiService = MockApiService();
      mockAuthRepo = MockAuthTokenInterface();
      container = ProviderContainer(overrides: [
        catsByUserProvider.overrideWith(
          (ref) async {
            final tokens = mockAuthRepo.getTokens();
            int userId;

            if (tokens['access'] == null || tokens['access'] == '') {
              throw Exception('Токен не валидный');
            }

            userId = mockAuthRepo.getUserIdfromToken(tokens['access']);

            final catsByUserList = await mockApiService
                .getCatsByUser(userId)
                .timeout(const Duration(seconds: 15));

            return catsByUserList;
          },
        )
      ]);
    },
  );

  group(
    "Тест на получение списка котов по user id",
    () {
      test(
        "Успешный ответ",
        () async {
          final jwt = JWT({
            'exp': DateTime.now().millisecondsSinceEpoch ~/ 1000,
            'user_id': 1
          });
          final validToken = jwt.sign(SecretKey('test_secret_key'));
          when(mockAuthRepo.getTokens()).thenReturn({
            'access': validToken,
            'refresh': validToken,
          });

          when(mockAuthRepo.getUserIdfromToken(validToken)).thenReturn(1);

          when(mockApiService.getCatsByUser(any)).thenAnswer(
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

          final result = await container.read(catsByUserProvider.future);
          expect(result, isA<List<Cat>>());
          expect(result.length, 2);
          expect(result[0].age, 22);
        },
      );

      test(
        "Если токен null или пустая строка выбрасывает ошибку",
        () async {
          when(mockAuthRepo.getTokens()).thenReturn({
            'access': null,
            'refresh': null,
          });

          try {
            await container.read(catsByUserProvider.future);
          } catch (_) {}

          expect(container.read(catsByUserProvider.future), throwsException);
          verifyNever(mockAuthRepo.getUserIdfromToken(any));
          verifyNever(mockApiService.getCatsByUser(any));
        },
      );

      test(
        "Любая ошибка при запросе",
        () {
          final jwt = JWT({
            'exp': DateTime.now().millisecondsSinceEpoch ~/ 1000,
            'user_id': 1
          });
          final validToken = jwt.sign(SecretKey('test_secret_key'));
          when(mockAuthRepo.getTokens()).thenReturn({
            'access': validToken,
            'refresh': validToken,
          });

          when(mockAuthRepo.getUserIdfromToken(validToken)).thenReturn(1);

          when(mockApiService.getCatsByUser(any)).thenThrow(
            Exception('Bad request'),
          );

          expect(container.read(catsByUserProvider.future), throwsException);
        },
      );

      test(
        "Тайм аут ошибка",
        () async {
          final jwt = JWT({
            'exp': DateTime.now().millisecondsSinceEpoch ~/ 1000,
            'user_id': 1
          });
          final validToken = jwt.sign(SecretKey('test_secret_key'));
          when(mockAuthRepo.getTokens()).thenReturn({
            'access': validToken,
            'refresh': validToken,
          });

          when(mockAuthRepo.getUserIdfromToken(validToken)).thenReturn(1);

          when(mockApiService.getCatsByUser(any)).thenAnswer((_) async {
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
            container.read(catsByUserProvider.future),
            throwsA(
              isA<TimeoutException>(),
            ),
          );
        },
      );
    },
  );
}
