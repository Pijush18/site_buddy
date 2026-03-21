import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/branding/branding_model.dart';

/// CLASS: BrandingState
/// PURPOSE: Encapsulates the branding profile data alongside its synchronization status.
class BrandingState {
  /// The current professional profile data.
  final BrandingModel profile;

  /// The status of the last/ongoing synchronization attempt with the backend.
  /// - [AsyncLoading]: Update is in progress.
  /// - [AsyncData]: Update was successful or idle.
  /// - [AsyncError]: Update failed.
  final AsyncValue<void> syncStatus;

  const BrandingState({
    required this.profile,
    required this.syncStatus,
  });

  /// Factory for the initial state.
  factory BrandingState.initial() {
    return BrandingState(
      profile: BrandingModel.defaultBranding(),
      syncStatus: const AsyncData(null),
    );
  }

  /// Whether a synchronization attempt is currently active.
  bool get isLoading => syncStatus is AsyncLoading;

  /// Returns the current error message if a sync attempt failed.
  String? get errorMessage => syncStatus.whenOrNull(error: (e, _) => e.toString());

  /// Whether the last sync attempt was successful.
  bool get isSuccess => !isLoading && errorMessage == null && syncStatus is AsyncData;

  BrandingState copyWith({
    BrandingModel? profile,
    AsyncValue<void>? syncStatus,
  }) {
    return BrandingState(
      profile: profile ?? this.profile,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }
}
