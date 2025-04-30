/*
import '../../core/api/api_service.dart';
import '../models/user_model.dart';

class AuthRepository {
  final ApiService api;

  AuthRepository({required this.api});

  Future<void> sendPhone(String p) => api.registerPhone(p);

  Future<void> verify(String p, String c) => api.verifyCode(p, c);

  Future<UserModel> finishProfile(Map d) async {
    final r = await api.updateProfile(d);
    return UserModel.fromJson(r);
  }

  Future<UserModel?> tryAutoLogin() async {
    await api.init();
    try {
      final r = await api.getProfile();
      return UserModel.fromJson(r);
    } catch (_) {
      return null;
    }
  }

  Future<void> logout() => api.clearToken();
}
*/
