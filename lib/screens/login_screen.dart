import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:requests_with_riverpod/providers/business_logic/login_provider.dart';
import 'package:requests_with_riverpod/ui/widgets/input_field.dart';
import 'package:requests_with_riverpod/ui/widgets/label_text.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String? username;
  String? password;

  String? _usernameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Пожалуйста заполните поле';
    }
    return null;
  }

  void _onSavedUsername(String? value) {
    username = value;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Пожалуйста заполните поле';
    }
    return null;
  }

  void _onSavedPassword(String? value) {
    password = value;
  }

  void _onSubmit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    ref.read(loginProvider.notifier).login(
          username!,
          password!,
        );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    final loginState = ref.watch(loginProvider);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (loginState.isSuccess) {
          context.go('/cat-list');
          ref.read(loginProvider.notifier).backToInitial();
        } else if (loginState.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                loginState.errorMessage!,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
              backgroundColor: theme.colorScheme.errorContainer,
            ),
          );
          ref.read(loginProvider.notifier).backToInitial();
        }
      },
    );
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            width: mediaQuery.size.width * 0.9,
            padding: const EdgeInsets.symmetric(vertical: 12),
            height: 300,
            decoration: BoxDecoration(
              color: theme.colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const LabelText(
                    text: 'Имя:',
                    spaceBefore: 13,
                  ),
                  const SizedBox(
                    height: 6.0,
                  ),
                  InputField(
                    validator: _usernameValidator,
                    onSaved: _onSavedUsername,
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  const LabelText(
                    text: 'Пароль:',
                    spaceBefore: 13,
                  ),
                  const SizedBox(
                    height: 6.0,
                  ),
                  InputField(
                    validator: _passwordValidator,
                    onSaved: _onSavedPassword,
                    isObscure: true,
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  ElevatedButton(
                    onPressed: _onSubmit,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: theme.canvasColor,
                      backgroundColor: theme.primaryColor,
                    ),
                    child: loginState.isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Отправить'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
