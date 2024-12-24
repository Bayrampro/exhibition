import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:requests_with_riverpod/screens/welcome_screen.dart';

void main() {
  testWidgets(
    "Тест Приветсенного экрана",
    (WidgetTester tester) async {
      final GoRouter router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const Scaffold(body: WelcomeScreen()),
          ),
          GoRoute(
            path: '/login',
            builder: (context, state) =>
                const Scaffold(body: Text('Login Page')),
          ),
        ],
      );
      await tester.pumpWidget(MaterialApp.router(routerConfig: router));

      await tester.tap(find.text('Пропустить'));
      await tester.pumpAndSettle();

      expect(find.text('Авторизуйся для начало работы'), findsOneWidget);
      expect(find.text('Логин'), findsOneWidget);

      //Первый свайп
      await tester.drag(
          find.text('Авторизуйся для начало работы'), const Offset(500, 0));
      await tester.pumpAndSettle();

      expect(find.text('Дай оценку другим котикам'), findsOneWidget);

      //Второй свайп
      await tester.drag(
          find.text('Дай оценку другим котикам'), const Offset(500, 0));
      await tester.pumpAndSettle();

      expect(find.text('И пусть их увидет весь мир!'), findsOneWidget);

      //Третий свайп
      await tester.drag(
          find.text('И пусть их увидет весь мир!'), const Offset(500, 0));
      await tester.pumpAndSettle();

      expect(
        find.text('Возможность увидеть всех котов! Выбери лучшего'),
        findsOneWidget,
      );

      //Четвертый свайп
      await tester.drag(
        find.text('Возможность увидеть всех котов! Выбери лучшего'),
        const Offset(500, 0),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Всемирная платформа выставка котов'),
        findsOneWidget,
      );

      await tester.tap(find.text('Пропустить'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Логин'));
      await tester.pumpAndSettle();

      expect(find.text('Login Page'), findsOneWidget);
    },
  );
}
