import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/backend/backend_client.dart';
import 'package:site_buddy/features/subscription/domain/subscription_repository.dart';
import 'package:site_buddy/features/subscription/data/subscription_repository_impl.dart';
import 'package:site_buddy/features/subscription/domain/subscription_status.dart';

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) {
  final backendClient = ref.watch(backendClientProvider);
  return SubscriptionRepositoryImpl(backendClient: backendClient);
});

final subscriptionStatusProvider = FutureProvider<SubscriptionStatus>((ref) async {
  final repository = ref.watch(subscriptionRepositoryProvider);
  return repository.getSubscriptionStatus();
});

final isPremiumProvider = Provider<bool>((ref) {
  final status = ref.watch(subscriptionStatusProvider).value;
  return status?.isPremium ?? false;
});



