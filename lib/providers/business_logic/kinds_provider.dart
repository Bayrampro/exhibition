import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:requests_with_riverpod/api/api_service.dart';
import 'package:requests_with_riverpod/models/kind.dart';

final kindsProvider = FutureProvider<List<Kind>>((ref) async {
  final apiService = GetIt.I.get<ApiService>();
  final kindsList = await apiService.getKinds().timeout(
        const Duration(seconds: 15),
      );
  return kindsList;
});
