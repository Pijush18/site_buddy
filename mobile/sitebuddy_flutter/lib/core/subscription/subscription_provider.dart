import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:site_buddy/core/subscription/subscription_tier.dart';

/// Provider for subscription state
final subscriptionProvider = StateNotifierProvider<SubscriptionNotifier, SubscriptionInfo>((ref) {
  return SubscriptionNotifier();
});

/// Notifier for subscription state management
class SubscriptionNotifier extends StateNotifier<SubscriptionInfo> {
  static const String _boxName = 'subscription';
  late Box _box;

  SubscriptionNotifier() : super(SubscriptionInfo.free) {
    _loadSubscription();
  }

  Future<void> _loadSubscription() async {
    _box = await Hive.openBox(_boxName);
    final tierId = _box.get('tier', defaultValue: 'free') as String;
    final tier = SubscriptionTier.values.firstWhere(
      (e) => e.id == tierId,
      orElse: () => SubscriptionTier.free,
    );
    final expiresAt = _box.get('expiresAt') as DateTime?;
    final purchaseId = _box.get('purchaseId') as String?;
    
    state = SubscriptionInfo(
      tier: tier,
      expiresAt: expiresAt,
      isActive: _isActive(expiresAt),
      purchaseId: purchaseId,
    );
  }

  bool _isActive(DateTime? expiresAt) {
    if (expiresAt == null) return true; // Lifetime purchase
    return expiresAt.isAfter(DateTime.now());
  }

  Future<void> upgradeTo(SubscriptionTier tier, {DateTime? expiresAt, String? purchaseId}) async {
    await _box.put('tier', tier.id);
    if (expiresAt != null) {
      await _box.put('expiresAt', expiresAt);
    }
    if (purchaseId != null) {
      await _box.put('purchaseId', purchaseId);
    }
    
    state = SubscriptionInfo(
      tier: tier,
      expiresAt: expiresAt,
      isActive: _isActive(expiresAt),
      purchaseId: purchaseId,
    );
  }

  Future<void> downgrade() async {
    await _box.put('tier', SubscriptionTier.free.id);
    await _box.delete('expiresAt');
    await _box.delete('purchaseId');
    
    state = SubscriptionInfo.free;
  }

  void refresh() {
    state = state.copyWith(
      isActive: _isActive(state.expiresAt),
    );
  }
}

/// Extension for easy feature checking
extension SubscriptionFeatureCheck on SubscriptionInfo {
  /// Check if can access a feature
  bool can(FeatureType feature) => hasFeature(feature);
  
  /// Check if project limit reached
  bool get isProjectLimitReached {
    if (maxProjects == -1) return false;
    return false; // Actual check happens at usage site
  }
  
  /// Get tier badge text
  String get tierBadge {
    switch (tier) {
      case SubscriptionTier.free:
        return 'FREE';
      case SubscriptionTier.pro:
        return 'PRO';
      case SubscriptionTier.premium:
        return 'PREMIUM';
    }
  }
}
