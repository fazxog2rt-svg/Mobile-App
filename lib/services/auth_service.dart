import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'secure_storage_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return AuthService(storage);
});

class AuthService {
  final SecureStorageService _storage;

  AuthService(this._storage);

  Future<bool> isBiometricAvailable() async => false; // stub — add local_auth later

  Future<bool> authenticateWithBiometrics() async => false; // stub

  Future<Map<String, dynamic>?> signInWithGoogle() async => null; // stub — add google_sign_in later

  Future<void> signOut() async {
    await _storage.clearAll();
  }

  Future<bool> isAuthenticated() async {
    return _storage.hasToken();
  }

  Future<String?> getToken() async {
    return _storage.getToken();
  }

  Future<void> saveTokens({required String accessToken, String? refreshToken}) async {
    await _storage.saveToken(accessToken);
    if (refreshToken != null) await _storage.saveRefreshToken(refreshToken);
  }
}
