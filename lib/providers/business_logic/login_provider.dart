import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:requests_with_riverpod/api/api_service.dart';
import 'package:requests_with_riverpod/providers/states/login_state.dart';
import 'package:requests_with_riverpod/repo/auth_token_repo/auth_token_interface.dart';

class LoginNotifier extends StateNotifier<LoginState> {
  final ApiService _apiService;
  final AuthTokenInterface _authTokenRepo;

  LoginNotifier(this._apiService, this._authTokenRepo)
      : super(LoginState.initial());

  Future<void> login(String username, String password) async {
    state =
        state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);
    try {
      final response = await _apiService.getAuthToken({
        'username': username,
        'password': password,
      }).timeout(const Duration(seconds: 15));

      _authTokenRepo.saveTokens(response.access, response.refresh);

      state = state.copyWith(isLoading: false, isSuccess: true);
    } on DioException catch (e) {
      if (e.response != null && e.response?.statusCode == 401) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: e.response?.data['detail'],
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Что-то пошло не так...',
        );
      }
    } on TimeoutException catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Проверьте соеденение с интерентом',
      );
    }
  }

  Future<void> backToInitial() async {
    state = LoginState.initial();
  }
}

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  final apiService = GetIt.I.get<ApiService>();
  final authTokenRepo = GetIt.I.get<AuthTokenInterface>();
  return LoginNotifier(
    apiService,
    authTokenRepo,
  );
});
