import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/user_model.dart';
import '../data/repositories/auth_repository.dart';

// Auth Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

// Auth State Provider - Stream of Firebase User
final authStateProvider = StreamProvider<User?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges;
});

// User Data Provider - Gets UserModel from Firestore
final userDataProvider = FutureProvider<UserModel?>((ref) async {
  final authState = ref.watch(authStateProvider);
  final authRepository = ref.watch(authRepositoryProvider);

  return authState.when(
    data: (user) {
      if (user != null) {
        return authRepository.getUserData(user.uid);
      }
      return null;
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

// Auth Controller - Handles auth actions
final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(ref);
});

class AuthController {
  final Ref _ref;

  AuthController(this._ref);

  Future<void> signInWithGoogle() async {
    final authRepository = _ref.read(authRepositoryProvider);
    await authRepository.signInWithGoogle();
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final authRepository = _ref.read(authRepositoryProvider);
    await authRepository.signInWithEmail(email: email, password: password);
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    final authRepository = _ref.read(authRepositoryProvider);
    await authRepository.signUpWithEmail(
      email: email,
      password: password,
      name: name,
    );
  }

  Future<void> signOut() async {
    final authRepository = _ref.read(authRepositoryProvider);
    await authRepository.signOut();
  }
}
