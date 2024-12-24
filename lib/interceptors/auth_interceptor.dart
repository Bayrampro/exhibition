import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:requests_with_riverpod/repo/auth_token_repo/auth_token_interface.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required AuthTokenInterface authTokenRepo,
  }) : _authTokenRepo = authTokenRepo;

  final AuthTokenInterface _authTokenRepo;

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final tokens = _authTokenRepo.getTokens();
    final String? access = tokens['access'];
    final String? refresh = tokens['refresh'];

    if (options.path.contains('/refresh')) {
      return handler.next(options);
    }

    if (options.path.contains('/token/')) {
      return handler.next(options);
    }

    if (access != null && access.isNotEmpty && JwtDecoder.isExpired(access)) {
      final newAccessToken = await _authTokenRepo.refreshAccessToken(refresh!);
      if (newAccessToken != null) {
        options.headers['Authorization'] = 'Bearer $newAccessToken';
      } else {
        return handler.reject(DioException(
          requestOptions: options,
          response: Response(
            requestOptions: options,
            statusCode: 401,
            statusMessage: "Unauthorized",
          ),
        ));
      }
    } else if (access != null && access.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $access';
    }

    super.onRequest(options, handler);
  }
}
