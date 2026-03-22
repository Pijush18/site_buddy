import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/features/auth/application/auth_providers.dart';
import 'package:site_buddy/features/subscription/application/subscription_providers.dart';
import 'package:site_buddy/features/subscription/domain/subscription_status.dart';
import 'package:site_buddy/features/auth/domain/models/user_model.dart';
import 'package:site_buddy/features/auth/data/user_repository.dart';
import 'package:site_buddy/features/auth/application/profile_controller.dart';

/// REPOSITORY PROVIDER
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return HiveUserRepository();
});

/// USER PROFILE PROVIDER
/// Fetches the dynamic User profile data (name, email, image).
final userProvider = FutureProvider<User?>((ref) async {
  final repository = ref.watch(userRepositoryProvider);
  final existingUser = await repository.getUser();
  
  // If no user exists in Hive, initialize with auth data
  if (existingUser == null) {
    final authUser = await ref.watch(authStateProvider.future);
    if (authUser == null) return null;
    
    final newUser = User(
      id: authUser.id,
      name: '', // Initial empty name
      email: authUser.email,
    );
    await repository.saveUser(newUser);
    return newUser;
  }
  
  return existingUser;
});

/// PROFILE CONTROLLER PROVIDER
final profileControllerProvider = StateNotifierProvider<ProfileController, AsyncValue<void>>((ref) {
  return ProfileController(ref);
});

/// MODEL: AccountData (Renamed from UserData)
class AccountData {
  final User profile;
  final SubscriptionStatus subscription;

  AccountData({
    required this.profile,
    required this.subscription,
  });
}

/// PROVIDER: accountDataProvider (Renamed from userProvider)
/// Aggregates data for the Settings/Account UI.
final accountDataProvider = FutureProvider<AccountData?>((ref) async {
  final user = await ref.watch(userProvider.future);
  if (user == null) return null;

  final subscription = await ref.watch(subscriptionStatusProvider.future);

  return AccountData(
    profile: user,
    subscription: subscription,
  );
});
