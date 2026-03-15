import 'dart:developer' as developer;
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:site_buddy/core/backend/backend_client.dart';
import 'package:site_buddy/features/subscription/domain/subscription_repository.dart';
import 'package:site_buddy/features/subscription/domain/subscription_status.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final BackendClient _backendClient;
  final InAppPurchase _iap = InAppPurchase.instance;

  SubscriptionRepositoryImpl({required BackendClient backendClient})
      : _backendClient = backendClient;

  @override
  Future<SubscriptionStatus> getSubscriptionStatus() async {
    try {
      final response = await _backendClient.getSubscriptionStatus();
      return SubscriptionStatus.fromJson(response);
    } catch (e) {
      developer.log('Failed to fetch subscription status: $e', name: 'SubscriptionRepo');
      return SubscriptionStatus.free();
    }
  }

  @override
  Future<void> purchasePremium() async {
    final bool available = await _iap.isAvailable();
    if (!available) {
      throw Exception('Store not available');
    }

    const Set<String> kIds = <String>{'sitebuddy_premium_monthly'};
    final ProductDetailsResponse response = await _iap.queryProductDetails(kIds);

    if (response.notFoundIDs.isNotEmpty) {
      throw Exception('Product not found');
    }

    final PurchaseParam purchaseParam = PurchaseParam(productDetails: response.productDetails.first);
    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  @override
  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }
}
