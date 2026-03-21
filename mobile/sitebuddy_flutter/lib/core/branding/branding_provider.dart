/// FILE HEADER
/// ----------------------------------------------
/// File: branding_provider.dart
/// Feature: core/branding
/// Layer: application/providers
///
/// PURPOSE:
/// Manages the persistent, globally accessible user-level branding settings.
///
/// RESPONSIBILITIES:
/// - Initialize settings via SharedPreferences securely.
/// - Holds state defining the global Branding overrides.
/// - Notifies subscribers instantly on branding profile modifications.
/// ----------------------------------------------
library;


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:site_buddy/core/branding/branding_model.dart';
import 'package:site_buddy/core/branding/branding_state.dart';
import 'package:site_buddy/features/auth/application/auth_providers.dart';
import 'package:site_buddy/core/backend/backend_client.dart';
import 'dart:developer' as developer;

const String _brandingBoxName = 'brandingBox';
const String _brandingKey = 'current_profile';

/// NOTIFIER: BrandingNotifier
/// PURPOSE: Manages the professional profile with secure backend synchronization.
class BrandingNotifier extends Notifier<BrandingState> {
  @override
  BrandingState build() {
    // 1. Initial local load (non-blocking for UI)
    Future.microtask(() => _initialize());

    // 2. React to Auth changes to refresh profile
    ref.listen(authStateProvider, (previous, next) {
      final user = next.value;
      if (user != null && previous?.value == null) {
        // Refresh from cloud on fresh login
        _fetchFromBackend();
      } else if (user == null && previous?.value != null) {
        // Reset to default on logout
        state = BrandingState.initial();
      }
    });

    return BrandingState.initial();
  }

  /// Composite initialization: Hive Load -> Background Cloud Sync.
  Future<void> _initialize() async {
    await _loadFromHive();
    
    // Background sync if authenticated
    if (ref.read(authStateProvider).value != null) {
      _fetchFromBackend();
    }
  }

  /// Loads the persisted profile from the dedicated Hive box.
  Future<void> _loadFromHive() async {
    try {
      final box = await Hive.openBox<BrandingModel>(_brandingBoxName);
      final profile = box.get(_brandingKey);
      if (profile != null) {
        state = state.copyWith(profile: profile);
      }
    } catch (e) {
      developer.log('Failed to load branding from Hive: $e', name: 'BrandingNotifier');
    }
  }

  /// Fetches profile from backend and persists locally.
  Future<void> _fetchFromBackend() async {
    try {
      final backend = ref.read(backendClientProvider);
      final rawData = await backend.fetchProfile();
      
      if (rawData.isNotEmpty) {
        final serverProfile = BrandingModel.fromMap(rawData);
        
        // Save to Hive
        final box = await Hive.openBox<BrandingModel>(_brandingBoxName);
        await box.put(_brandingKey, serverProfile);
        
        // Update State
        state = state.copyWith(profile: serverProfile);
        developer.log('Cloud profile synced successfully', name: 'BrandingNotifier');
      }
    } catch (e) {
      developer.log('Background profile sync failed: $e', name: 'BrandingNotifier');
    }
  }

  /// PRODUCTION UPDATE FLOW: API First -> On Success: Update Local Cache & State.
  Future<void> updateProfile({
    String? companyName,
    String? engineerName,
    String? logoPath,
    bool clearLogo = false,
  }) async {
    // 1. Prevent duplicate submissions
    if (state.isLoading) return;

    // 2. Set Loading State
    state = state.copyWith(syncStatus: const AsyncLoading());

    try {
      // 3. Prepare Payload
      final candidateProfile = state.profile.copyWith(
        companyName: companyName,
        engineerName: engineerName,
        logoPath: logoPath,
        clearLogo: clearLogo,
      );

      // 4. API CALL (Backend as Source of Truth)
      final backend = ref.read(backendClientProvider);
      await backend.updateProfile(candidateProfile.toMap());

      // 5. ON SUCCESS: Update Hive + State
      final box = await Hive.openBox<BrandingModel>(_brandingBoxName);
      await box.put(_brandingKey, candidateProfile);

      state = state.copyWith(
        profile: candidateProfile,
        syncStatus: const AsyncData(null),
      );
      
      developer.log('Profile updated and synced successfully', name: 'BrandingNotifier');
    } catch (e, stack) {
      // 6. ON FAILURE: Reset status without changing local profile data
      developer.log('Profile update failed: $e', name: 'BrandingNotifier');
      state = state.copyWith(
        syncStatus: AsyncError(e, stack),
      );
      rethrow; // Allow UI to handle if needed
    }
  }

  /// Triggers a manual refresh from the cloud.
  Future<void> refresh() async {
    await _fetchFromBackend();
  }

  /// Wipes local and remote profile to defaults.
  Future<void> resetToDefault() async {
    try {
      final defaultProfile = BrandingModel.defaultBranding();
      
      // Try to sync with backend if possible
      final backend = ref.read(backendClientProvider);
      await backend.updateProfile(defaultProfile.toMap());

      final box = await Hive.openBox<BrandingModel>(_brandingBoxName);
      await box.delete(_brandingKey);
      
      state = BrandingState.initial();
    } catch (e) {
      developer.log('Reset failed: $e', name: 'BrandingNotifier');
    }
  }
}

/// GLOBAL PROVIDER: brandingProvider
/// Now returns [BrandingState] which includes sync status.
final brandingProvider = NotifierProvider<BrandingNotifier, BrandingState>(() {
  return BrandingNotifier();
});



