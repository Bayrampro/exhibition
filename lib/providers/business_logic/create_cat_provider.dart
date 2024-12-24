import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:requests_with_riverpod/api/api_service.dart';
import 'package:requests_with_riverpod/providers/states/new_cat_state.dart';

class CreateCatNotifier extends StateNotifier<NewCatState> {
  final ApiService _apiService;

  CreateCatNotifier(this._apiService) : super(NewCatState.initial());

  Future<void> createNewCat(Map<String, dynamic> body) async {
    try {
      state =
          state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);
      await _apiService.createCat(body).timeout(const Duration(seconds: 10));
      state = state.copyWith(isLoading: false, isSuccess: true);
    } on DioException catch (e) {
      if (e.response != null && e.response?.statusCode == 400) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Неправильные вводные данные',
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
    state = NewCatState.initial();
  }
}

final createCatProvider =
    StateNotifierProvider<CreateCatNotifier, NewCatState>((ref) {
  final apiService = GetIt.I.get<ApiService>();
  return CreateCatNotifier(apiService);
});
