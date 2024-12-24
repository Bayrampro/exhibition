import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:introduction_screen/introduction_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pageDecoration = PageDecoration(
      pageColor: theme.primaryColor,
      titleTextStyle: theme.textTheme.titleLarge!.copyWith(
        color: theme.canvasColor,
      ),
      bodyTextStyle: theme.textTheme.titleMedium!.copyWith(
        color: theme.canvasColor,
      ),
    );
    return Scaffold(
      body: IntroductionScreen(
        globalBackgroundColor: theme.primaryColor,
        pages: [
          PageViewModel(
            title: "Добро пожаловать",
            body: "Всемирная платформа выставка котов",
            image: Center(
              child: Image.asset(
                'assets/images/cat_logo.png',
                width: 200,
                height: 200,
              ),
            ),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: 'Список всех котов',
            body: 'Возможность увидеть всех котов! Выбери лучшего',
            image: Center(
              child: Image.asset('assets/images/list.png'),
            ),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: 'Добавляй своих любимчиков',
            body: 'И пусть их увидет весь мир!',
            image: Center(
              child: Image.asset(
                'assets/images/add.png',
                width: 200,
                height: 200,
              ),
            ),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: 'Голосуй и продвигай своего кота',
            body: 'Дай оценку другим котикам',
            image: Center(
              child: Image.asset(
                'assets/images/rate.png',
                width: 200,
                height: 200,
              ),
            ),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: 'Начни свой путь',
            body: 'Авторизуйся для начало работы',
            image: Center(
              child: Image.asset(
                'assets/images/start.png',
                width: 200,
                height: 200,
              ),
            ),
            decoration: pageDecoration,
          ),
        ],
        done: const Text('Логин'),
        onDone: () => context.go('/login'),
        showDoneButton: true,
        showNextButton: false,
        showSkipButton: true,
        skip: const Text("Пропустить"),
        skipStyle: TextButton.styleFrom(
          foregroundColor: theme.canvasColor,
        ),
        doneStyle: TextButton.styleFrom(
          foregroundColor: theme.canvasColor,
        ),
        dotsContainerDecorator: BoxDecoration(
          color: theme.primaryColor,
        ),
        dotsDecorator: DotsDecorator(
          activeColor: theme.canvasColor,
        ),
      ),
    );
  }
}
