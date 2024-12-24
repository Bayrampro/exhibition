import 'package:flutter/material.dart';
import 'package:requests_with_riverpod/router/router.dart';
import 'package:requests_with_riverpod/ui/ui.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'CatEx',
      theme: theme,
      routerConfig: router,
    );
  }
}
