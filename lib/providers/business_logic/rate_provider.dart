import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:requests_with_riverpod/api/api_service.dart';
import 'package:requests_with_riverpod/providers/states/rate_state.dart';

class RateNotifier extends StateNotifier<RateState> {
  final ApiService _apiService;

  RateNotifier(this._apiService) : super(RateState.initial());

  Future<void> rate(int id, int score) async {
    try {
      await _apiService.rateCat(id, {
        'score': score,
      }).timeout(const Duration(seconds: 10));

      state = state.copyWith(isLoading: false, isSuccess: true);
    } on DioException catch (e) {
      if (e.response != null && e.response?.statusCode == 500) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Вы уже оценили этого котенка',
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
    state = RateState.initial();
  }
}

final rateProvider = StateNotifierProvider<RateNotifier, RateState>((ref) {
  final apiService = GetIt.I.get<ApiService>();
  return RateNotifier(apiService);
});
