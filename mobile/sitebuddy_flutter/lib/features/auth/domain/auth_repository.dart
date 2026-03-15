import 'package:firebase_auth/firebase_auth.dart' as firebase;

class SiteUser {
  final String id;
  final String email;
  final bool isEmailVerified;

  const SiteUser({
    required this.id,
    required this.email,
    this.isEmailVerified = false,
  });

  factory SiteUser.fromFirebaseUser(firebase.User user) {
    return SiteUser(
      id: user.uid,
      email: user.email ?? '',
      isEmailVerified: user.emailVerified,
    );
  }
}

abstract class AuthRepository {
  Stream<SiteUser?> get authStateChanges;
  SiteUser? get currentUser;
  
  Future<void> loginWithEmail(String email, String password);
  Future<void> registerWithEmail(String email, String password);
  Future<firebase.UserCredential> signInWithGoogle();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> sendEmailVerification();
  Future<void> logout();
  Future<String?> getIdToken();
}
