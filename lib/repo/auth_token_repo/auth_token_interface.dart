import 'package:requests_with_riverpod/api/api_service.dart';

abstract interface class AuthTokenInterface {
  void initialize(ApiService apiService);
  Future<void> saveTokens(String access, String? refresh);
  Map<String, dynamic> getTokens();
  Future<void> deleteTokens();
  bool get isFirstTime;
  bool? get isAuthenticated;
  Future<String?> refreshAccessToken(String refreshToken);
  int getUserIdfromToken(String access);
}
