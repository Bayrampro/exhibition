import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:requests_with_riverpod/api/api_service.dart';
import 'package:requests_with_riverpod/models/cat.dart';

final catsByKindProvider =
    FutureProvider.family<List<Cat>, int>((ref, id) async {
  final apiService = GetIt.I.get<ApiService>();
  final catsByKindList = await apiService.getCatsByKind(id).timeout(
        const Duration(seconds: 15),
      );
  return catsByKindList;
});
