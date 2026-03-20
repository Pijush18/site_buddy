import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/features/auth/application/auth_providers.dart';

class AuthController extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  AuthController(this._ref) : super(const AsyncData(null));

  Future<void> loginWithEmail(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => _ref.read(authRepositoryProvider).loginWithEmail(email, password));
  }

  Future<void> registerWithEmail(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => _ref.read(authRepositoryProvider).registerWithEmail(email, password));
  }

  Future<void> loginWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => _ref.read(authRepositoryProvider).signInWithGoogle());
  }

  Future<void> sendPasswordResetEmail(String email) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => _ref.read(authRepositoryProvider).sendPasswordResetEmail(email));
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _ref.read(authRepositoryProvider).logout());
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  return AuthController(ref);
});



