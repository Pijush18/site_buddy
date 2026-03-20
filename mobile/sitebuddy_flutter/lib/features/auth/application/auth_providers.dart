import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/features/auth/domain/auth_repository.dart';
import 'package:site_buddy/features/auth/data/firebase_auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FirebaseAuthRepository();
});

final authStateProvider = StreamProvider<SiteUser?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});



