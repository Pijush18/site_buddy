import 'package:site_buddy/features/subscription/domain/subscription_status.dart';

abstract class SubscriptionRepository {
  Future<SubscriptionStatus> getSubscriptionStatus();
  Future<void> purchasePremium();
  Future<void> restorePurchases();
}
