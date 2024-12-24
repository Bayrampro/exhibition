import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:requests_with_riverpod/api/api_service.dart';
import 'package:requests_with_riverpod/providers/states/delete_state.dart';

class DeleteCatNotifier extends StateNotifier<DeleteState> {
  final ApiService _apiService;

  DeleteCatNotifier(this._apiService) : super(DeleteState.initial());

  Future<void> deleteCat(int id) async {
    try {
      state = state.copyWith(isLoading: true);
      await _apiService.deleteCatById(id).timeout(const Duration(seconds: 10));
      state = state.copyWith(isLoading: false, isSuccess: true);
    } on DioException catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Что-то пошло не так...',
      );
    } on TimeoutException catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Проверьте соеденение с интерентом',
      );
    }
  }

  Future<void> backToInitial() async {
    state = DeleteState.initial();
  }
}

final deleteCatProvider =
    StateNotifierProvider<DeleteCatNotifier, DeleteState>((ref) {
  final apiService = GetIt.I.get<ApiService>();

  return DeleteCatNotifier(apiService);
});
