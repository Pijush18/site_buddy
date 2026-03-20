import 'package:equatable/equatable.dart';

class SubscriptionStatus extends Equatable {
  final bool isPremium;
  final String plan;
  final String status;

  const SubscriptionStatus({
    required this.isPremium,
    required this.plan,
    required this.status,
  });

  factory SubscriptionStatus.free() {
    return const SubscriptionStatus(
      isPremium: false,
      plan: 'free',
      status: 'active',
    );
  }

  factory SubscriptionStatus.fromJson(Map<String, dynamic> json) {
    return SubscriptionStatus(
      isPremium: json['has_premium'] ?? false,
      plan: json['plan'] ?? 'free',
      status: json['status'] ?? 'inactive',
    );
  }

  @override
  List<Object?> get props => [isPremium, plan, status];
}



