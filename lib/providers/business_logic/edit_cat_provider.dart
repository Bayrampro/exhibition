import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:requests_with_riverpod/api/api_service.dart';
import 'package:requests_with_riverpod/providers/states/edit_cat_state.dart';

class EditCatNotifier extends StateNotifier<EditCatState> {
  final ApiService _apiService;

  EditCatNotifier(this._apiService) : super(EditCatState.initial());

  Future<void> _generalLogic(Future<void> mainFunc) async {
    try {
      state =
          state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);
      await mainFunc.timeout(const Duration(seconds: 10));
      state = state.copyWith(isLoading: false, isSuccess: true);
    } on TimeoutException catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Проверьте соеденение с интерентом',
      );
    }
  }

  Future<void> updateCat(int id, Map<String, dynamic> body) async {
    try {
      await _generalLogic(_apiService.updateCatById(id, body));
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
    }
  }

  Future<void> updateWholeCat(int id, Map<String, dynamic> body) async {
    try {
      await _generalLogic(_apiService.updateWholeCatById(id, body));
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
    }
  }

  void backToInitial() {
    state = EditCatState.initial();
  }

  void noChangesAlert() {
    state = state.copyWith(
      errorMessage:
          'Изменении не обнаружены, измените прежние значение и попробуйте снова',
    );
  }
}

final editCatProvider =
    StateNotifierProvider<EditCatNotifier, EditCatState>((ref) {
  final apiService = GetIt.I.get<ApiService>();
  return EditCatNotifier(apiService);
});
