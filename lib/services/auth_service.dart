import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'secure_storage_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return AuthService(storage);
});

class AuthService {
  final SecureStorageService _storage;
  final _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
  final _localAuth = LocalAuthentication();

  AuthService(this._storage);

  Future<bool> isBiometricAvailable() async {
    final canCheck = await _localAuth.canCheckBiometrics;
    final isDeviceSupported = await _localAuth.isDeviceSupported();
    return canCheck && isDeviceSupported;
  }

  Future<bool> authenticateWithBiometrics() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'Authenticate to access Discord Bot Manager',
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }

  Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) return null;
      final auth = await account.authentication;
      return {
        'email': account.email,
        'name': account.displayName,
        'photo': account.photoUrl,
        'id_token': auth.idToken,
        'access_token': auth.accessToken,
      };
    } catch (_) {
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
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
