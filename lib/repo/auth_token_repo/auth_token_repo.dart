import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:requests_with_riverpod/api/api_service.dart';
import 'package:requests_with_riverpod/repo/auth_token_repo/auth_token_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthTokenRepo implements AuthTokenInterface {
  AuthTokenRepo({
    required this.prefs,
  });

  final SharedPreferences prefs;
  late ApiService _apiService;

  final accessKey = 'ACCESS_KEY';
  final refreshKey = 'REFRESH_KEY';

  @override
  void initialize(ApiService apiService) {
    _apiService = apiService;
  }

  @override
  Future<void> saveTokens(String access, String? refresh) async {
    await prefs.setString(accessKey, access);
    await prefs.setString(refreshKey, refresh!);
  }

  @override
  Map<String, dynamic> getTokens() {
    final access = prefs.getString(accessKey);
    final refresh = prefs.getString(refreshKey);
    return {
      'access': access,
      'refresh': refresh,
    };
  }

  @override
  Future<void> deleteTokens() async {
    await prefs.setString(accessKey, '');
    await prefs.setString(refreshKey, '');
  }

  @override
  bool? get isAuthenticated {
    final access = prefs.getString(accessKey);
    return access?.isNotEmpty;
  }

  @override
  bool get isFirstTime {
    final access = prefs.getString(accessKey);
    return access == null;
  }

  @override
  Future<String?> refreshAccessToken(String refreshToken) async {
    try {
      final response = await _apiService.refreshAuthToken({
        'refresh': refreshToken,
      });
      await saveTokens(response.access, refreshToken);
      return response.access;
    } catch (e) {
      return null;
    }
  }

  @override
  int getUserIdfromToken(String access) {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(access);

    int userId = decodedToken['user_id'];

    return userId;
  }
}
