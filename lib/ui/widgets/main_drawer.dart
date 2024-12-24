import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:requests_with_riverpod/repo/auth_token_repo/auth_token_interface.dart';
import 'package:requests_with_riverpod/ui/widgets/question_dialog.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({
    super.key,
  });

  Future<void> _questionWindow(BuildContext context, ThemeData theme) async {
    return await showDialog(
      context: context,
      builder: (context) => QuestionDialog(
        titleText: 'Выход из системы',
        questionText: 'Вы действительно хотите выйти из системы?',
        yesOnPressed: () {
          GetIt.I.get<AuthTokenInterface>().deleteTokens();
          context.go('/login');
        },
        noOnPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    return Stack(
      children: [
        Drawer(
          width: mediaQuery.size.width * 0.75,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          child: Column(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    theme.primaryColor,
                    theme.primaryColor.withOpacity(0.8),
                  ]),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      foregroundImage:
                          AssetImage('assets/images/cat_logo_white.png'),
                      radius: 50,
                    ),
                    const SizedBox(width: 20.0),
                    Text(
                      'Мяу!',
                      style: theme.textTheme.titleLarge
                          ?.copyWith(color: theme.canvasColor),
                    ),
                  ],
                ),
              ),
              ListTile(
                onTap: () => context.go('/kinds'),
                leading: const Icon(Icons.category),
                title: const Text('Пароды'),
              ),
              ListTile(
                onTap: () => context.go('/cats-by-user'),
                leading: const Icon(Icons.my_library_books_outlined),
                title: const Text('Мои котики'),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          child: SizedBox(
            width: mediaQuery.size.width * 0.75,
            child: ListTile(
              key: const ValueKey('logout'),
              leading: Icon(
                Icons.logout,
                color: theme.colorScheme.error,
              ),
              title: Text(
                'Выйти',
                style: TextStyle(
                  color: theme.colorScheme.error,
                ),
              ),
              onTap: () async => await _questionWindow(context, theme),
            ),
          ),
        )
      ],
    );
  }
}
