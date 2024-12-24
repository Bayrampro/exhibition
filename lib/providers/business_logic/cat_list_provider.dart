import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:requests_with_riverpod/api/api_service.dart';
import '../../models/models.dart';

final catListProvider = FutureProvider<List<Cat>>(
  (ref) async {
    final apiService = GetIt.I.get<ApiService>();
    final postsList = await apiService.getCats().timeout(
          const Duration(
            seconds: 15,
          ),
        );
    return postsList;
  },
);
