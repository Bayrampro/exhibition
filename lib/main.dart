import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:requests_with_riverpod/api/api_service.dart';
import 'package:requests_with_riverpod/app/app.dart';
import 'package:requests_with_riverpod/interceptors/auth_interceptor.dart';
import 'package:requests_with_riverpod/repo/auth_token_repo/auth_token_interface.dart';
import 'package:requests_with_riverpod/repo/auth_token_repo/auth_token_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger_observer.dart';

final getIt = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  getIt.registerLazySingleton<AuthTokenInterface>(
    () => AuthTokenRepo(
      prefs: prefs,
    ),
  );

  getIt.registerLazySingleton<AuthInterceptor>(
    () => AuthInterceptor(
      authTokenRepo: getIt<AuthTokenInterface>(),
    ),
  );

  final dio = Dio();
  dio.interceptors.add(getIt<AuthInterceptor>());

  getIt.registerSingleton<ApiService>(
    ApiService(
      dio,
      baseUrl: 'http://10.0.2.2:8000/api/v1',
    ),
  );

  getIt<AuthTokenInterface>().initialize(getIt<ApiService>());

  runApp(
    ProviderScope(
      observers: [
        TalkerRiverpodObserver(),
      ],
      child: const App(),
    ),
  );
}
