import 'package:flutter_riverpod/flutter_riverpod.dart';

/// PROVIDER: isProUserProvider
/// PURPOSE: Tracks the subscription status of the user (Mocked for demonstration).
final isProUserProvider = StateProvider<bool>((ref) {
  // TODO: Link with actual subscription/payment service
  return false;
});
