import 'package:hive/hive.dart';

part 'subscription_tier.g.dart';

/// ENUM: SubscriptionTier
/// Defines the subscription level for the user.
@HiveType(typeId: 30)
enum SubscriptionTier {
  @HiveField(0)
  free('free', 'Free'),
  @HiveField(1)
  pro('pro', 'Pro'),
  @HiveField(2)
  premium('premium', 'Premium');

  final String id;
  final String displayName;
  const SubscriptionTier(this.id, this.displayName);
}

/// ENUM: FeatureType
/// All features that can be gated.
enum FeatureType {
  // Calculation Features
  basicCalculations,
  unlimitedCalculations,
  
  // Project Features
  limitedProjects,
  unlimitedProjects,
  
  // Diagram Features
  basicDiagrams,
  fullDiagramFeatures,
  highResExport,
  
  // Annotation Features
  annotations,
  advancedAnnotations,
  
  // Export Features
  lowResExport,
  highResPdfExport,
  multiPageReports,
  
  // History Features
  recentProjects,
  fullHistory,
  
  // Advanced Features
  measurementTools,
  snappingRefinement,
  priorityFeatures,
}

/// Set of features for Free tier
final Set<FeatureType> _freeTierFeatures = {
  FeatureType.basicCalculations,
  FeatureType.limitedProjects,
  FeatureType.basicDiagrams,
  FeatureType.lowResExport,
  FeatureType.recentProjects,
};

/// Set of features for Pro tier
final Set<FeatureType> _proTierFeatures = {
  ..._freeTierFeatures,
  FeatureType.unlimitedCalculations,
  FeatureType.unlimitedProjects,
  FeatureType.fullDiagramFeatures,
  FeatureType.highResExport,
  FeatureType.annotations,
  FeatureType.fullHistory,
};

/// MODEL: SubscriptionInfo
/// Stores subscription state and limits.
class SubscriptionInfo {
  final SubscriptionTier tier;
  final DateTime? expiresAt;
  final bool isActive;
  final String? purchaseId;

  const SubscriptionInfo({
    this.tier = SubscriptionTier.free,
    this.expiresAt,
    this.isActive = true,
    this.purchaseId,
  });

  /// Check if a feature is available
  bool hasFeature(FeatureType feature) {
    switch (tier) {
      case SubscriptionTier.free:
        return _freeTierFeatures.contains(feature);
      case SubscriptionTier.pro:
        return _proTierFeatures.contains(feature);
      case SubscriptionTier.premium:
        return true; // All features
    }
  }

  /// Get max projects allowed
  int get maxProjects {
    switch (tier) {
      case SubscriptionTier.free:
        return 3;
      case SubscriptionTier.pro:
        return -1; // Unlimited
      case SubscriptionTier.premium:
        return -1; // Unlimited
    }
  }

  /// Check if user can create more projects
  bool canCreateProject(int currentCount) {
    if (maxProjects == -1) return true;
    return currentCount < maxProjects;
  }

  /// Check if high-res export is available
  bool get canHighResExport => 
      tier == SubscriptionTier.pro || tier == SubscriptionTier.premium;

  /// Check if multi-page PDF is available
  bool get canMultiPagePdf => tier == SubscriptionTier.premium;

  /// Check if annotations are available
  bool get canAnnotate =>
      tier != SubscriptionTier.free;

  /// Check if advanced snapping is available
  bool get canAdvancedSnapping => tier == SubscriptionTier.premium;

  /// Get export resolution multiplier
  double get exportResolutionMultiplier {
    switch (tier) {
      case SubscriptionTier.free:
        return 0.5; // Low-res
      case SubscriptionTier.pro:
        return 2.0; // High-res
      case SubscriptionTier.premium:
        return 3.0; // Ultra high-res
    }
  }

  SubscriptionInfo copyWith({
    SubscriptionTier? tier,
    DateTime? expiresAt,
    bool? isActive,
    String? purchaseId,
  }) {
    return SubscriptionInfo(
      tier: tier ?? this.tier,
      expiresAt: expiresAt ?? this.expiresAt,
      isActive: isActive ?? this.isActive,
      purchaseId: purchaseId ?? this.purchaseId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tier': tier.id,
      'expiresAt': expiresAt?.toIso8601String(),
      'isActive': isActive,
      'purchaseId': purchaseId,
    };
  }

  factory SubscriptionInfo.fromJson(Map<String, dynamic> json) {
    return SubscriptionInfo(
      tier: SubscriptionTier.values.firstWhere(
        (e) => e.id == json['tier'],
        orElse: () => SubscriptionTier.free,
      ),
      expiresAt: json['expiresAt'] != null 
          ? DateTime.parse(json['expiresAt'] as String) 
          : null,
      isActive: json['isActive'] as bool? ?? true,
      purchaseId: json['purchaseId'] as String?,
    );
  }

  /// Default free tier
  static const free = SubscriptionInfo(tier: SubscriptionTier.free);
}

/// Pricing constants for India market
class PricingConstants {
  // Monthly subscription (INR)
  static const double proMonthlyInr = 199.0;
  static const double premiumMonthlyInr = 499.0;
  
  // Yearly subscription (INR) - with discount
  static const double proYearlyInr = 1499.0;
  static const double premiumYearlyInr = 2999.0;
  
  // One-time lifetime (INR)
  static const double proLifetimeInr = 1499.0;
  static const double premiumLifetimeInr = 2999.0;
  
  // Display strings
  static const String proMonthlyDisplay = '₹199/month';
  static const String proYearlyDisplay = '₹1,499/year';
  static const String proLifetimeDisplay = '₹1,499 lifetime';
  
  static const String premiumMonthlyDisplay = '₹499/month';
  static const String premiumYearlyDisplay = '₹2,999/year';
  static const String premiumLifetimeDisplay = '₹2,999 lifetime';
}
