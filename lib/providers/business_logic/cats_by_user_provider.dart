import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:requests_with_riverpod/api/api_service.dart';
import 'package:requests_with_riverpod/models/cat.dart';
import 'package:requests_with_riverpod/repo/auth_token_repo/auth_token_interface.dart';

final catsByUserProvider = FutureProvider<List<Cat>>((ref) async {
  try {
    final apiService = GetIt.I.get<ApiService>();
    final authTokenRepo = GetIt.I.get<AuthTokenInterface>();
    final tokens = authTokenRepo.getTokens();
    int userId;

    if (tokens['access'] == null || tokens['access'] == '') {
      throw Exception('Токен не валидный');
    }

    userId = authTokenRepo.getUserIdfromToken(tokens['access']);

    final catsByUserList = await apiService
        .getCatsByUser(userId)
        .timeout(const Duration(seconds: 15));

    return catsByUserList;
  } catch (e) {
    Logger().e(e);
    rethrow;
  }
});
