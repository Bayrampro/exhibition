import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:requests_with_riverpod/repo/auth_token_repo/auth_token_interface.dart';
import 'package:requests_with_riverpod/ui/widgets/main_drawer.dart';
import 'package:requests_with_riverpod/ui/widgets/question_dialog.dart';

import '../unit_tests/refresh_token_test.mocks.dart';

void main() {
  late MockAuthTokenInterface mockAuthTokenRepo;

  setUp(
    () {
      mockAuthTokenRepo = MockAuthTokenInterface();
      GetIt.I.registerSingleton<AuthTokenInterface>(mockAuthTokenRepo);
    },
  );

  tearDown(
    () {
      GetIt.I.reset();
    },
  );

  group(
    "Тест на Диалогового окна в сайдбаре",
    () {
      testWidgets(
        "Если кнопка ДА нажата",
        (WidgetTester tester) async {
          final GoRouter firstRouter = GoRouter(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const Scaffold(body: MainDrawer()),
              ),
              GoRoute(
                path: '/login',
                builder: (context, state) =>
                    const Scaffold(body: Text('Login Page')),
              ),
            ],
          );

          await tester.pumpWidget(MaterialApp.router(
            routerConfig: firstRouter,
          ));

          await tester.tap(find.byKey(const ValueKey('logout')));
          await tester.pumpAndSettle();

          expect(find.byType(QuestionDialog), findsOneWidget);

          await tester.tap(find.byKey(const ValueKey('yes')));
          await tester.pumpAndSettle();

          verify(mockAuthTokenRepo.deleteTokens()).called(1);
          expect(find.text('Login Page'), findsOneWidget);
        },
      );

      testWidgets(
        "Если кнопка НЕТ нажата",
        (WidgetTester tester) async {
          final GoRouter secondRouter = GoRouter(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const Scaffold(body: MainDrawer()),
              ),
              GoRoute(
                path: '/login',
                builder: (context, state) =>
                    const Scaffold(body: Text('Login Page')),
              ),
            ],
          );

          await tester.pumpWidget(MaterialApp.router(
            routerConfig: secondRouter,
          ));

          await tester.tap(find.byKey(const ValueKey('logout')));
          await tester.pumpAndSettle();

          await tester.tap(find.byKey(const ValueKey('no')));
          await tester.pumpAndSettle();

          verifyNever(mockAuthTokenRepo.deleteTokens());
          expect(find.text('Login Page'), findsNothing);
          expect(find.byType(QuestionDialog), findsNothing);
        },
      );
    },
  );
}
