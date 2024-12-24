import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:requests_with_riverpod/api/api_service.dart';
import 'package:requests_with_riverpod/models/models.dart';

final catDetailProvider = FutureProvider.family<Cat, int>((ref, id) async {
  final apiService = GetIt.I.get<ApiService>();
  final cat = await apiService.getCatsDetail(id).timeout(
        const Duration(seconds: 15),
      );
  return cat;
});
