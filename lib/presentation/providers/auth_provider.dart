import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthUser {
  final String id;
  final String username;
  final String discriminator;
  final String? avatar;
  final String email;
  final String accessToken;
  final String? refreshToken;

  const AuthUser({
    required this.id,
    required this.username,
    required this.discriminator,
    this.avatar,
    required this.email,
    required this.accessToken,
    this.refreshToken,
  });

  String get avatarUrl => avatar != null
      ? 'https://cdn.discordapp.com/avatars/$id/$avatar.png?size=256'
      : 'https://cdn.discordapp.com/embed/avatars/0.png';

  String get tag => discriminator == '0' ? username : '$username#$discriminator';

  static AuthUser get mock => const AuthUser(
        id: '123456789012345678',
        username: 'BotManager',
        discriminator: '0',
        email: 'botmanager@example.com',
        accessToken: 'mock_access_token',
      );
}

class AuthState {
  final AuthStatus status;
  final AuthUser? user;
  final String? error;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.error,
  });

  AuthState copyWith({
    AuthStatus? status,
    AuthUser? user,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isLoading => status == AuthStatus.loading;
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState()) {
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    state = state.copyWith(status: AuthStatus.loading);
    await Future.delayed(const Duration(milliseconds: 1500));
    // For demo, start unauthenticated
    state = state.copyWith(status: AuthStatus.unauthenticated);
  }

  Future<void> loginWithDiscord() async {
    state = state.copyWith(status: AuthStatus.loading);
    await Future.delayed(const Duration(seconds: 2));
    state = state.copyWith(
      status: AuthStatus.authenticated,
      user: AuthUser.mock,
    );
  }

  Future<void> loginWithGoogle() async {
    state = state.copyWith(status: AuthStatus.loading);
    await Future.delayed(const Duration(seconds: 2));
    state = state.copyWith(
      status: AuthStatus.authenticated,
      user: AuthUser.mock,
    );
  }

  Future<void> loginWithApple() async {
    state = state.copyWith(status: AuthStatus.loading);
    await Future.delayed(const Duration(seconds: 2));
    state = state.copyWith(
      status: AuthStatus.authenticated,
      user: AuthUser.mock,
    );
  }

  Future<void> loginWithGitHub() async {
    state = state.copyWith(status: AuthStatus.loading);
    await Future.delayed(const Duration(seconds: 2));
    state = state.copyWith(
      status: AuthStatus.authenticated,
      user: AuthUser.mock,
    );
  }

  Future<void> loginWithBiometric() async {
    state = state.copyWith(status: AuthStatus.loading);
    await Future.delayed(const Duration(milliseconds: 800));
    state = state.copyWith(
      status: AuthStatus.authenticated,
      user: AuthUser.mock,
    );
  }

  Future<void> logout() async {
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

final currentUserProvider = Provider<AuthUser?>((ref) {
  return ref.watch(authProvider).user;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});
