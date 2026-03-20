/// FILE HEADER
/// ----------------------------------------------
/// File: branding_model.dart
/// Feature: core/branding
/// Layer: domain/models
///
/// PURPOSE:
/// Represents the visual identity and authorship details for generated reports.
///
/// RESPONSIBILITIES:
/// - Holds the core text branding (company, engineer name).
/// - Stores a potential path for a custom logo asset or file.
/// - Supports JSON serialization for local persistence storage mapping.
/// ----------------------------------------------
library;


class BrandingModel {
  final String companyName;
  final String engineerName;
  final String? logoPath;

  const BrandingModel({
    required this.companyName,
    required this.engineerName,
    this.logoPath,
  });

  /// Factory generic fallback "Site Buddy" template.
  factory BrandingModel.defaultBranding() {
    return const BrandingModel(
      companyName: 'Site Buddy',
      engineerName: 'Er. Pijush Debbarma',
      logoPath: null,
    );
  }

  /// Deserialization from map (e.g. SharedPreferences JSON strings)
  factory BrandingModel.fromMap(Map<String, dynamic> map) {
    return BrandingModel(
      companyName: map['companyName'] ?? 'Site Buddy',
      engineerName: map['engineerName'] ?? 'Er. Pijush Debbarma',
      logoPath: map['logoPath'],
    );
  }

  /// Serialization to map
  Map<String, dynamic> toMap() {
    return {
      'companyName': companyName,
      'engineerName': engineerName,
      'logoPath': logoPath,
    };
  }

  /// Creates a copy of this model with the given fields replaced with the new values.
  BrandingModel copyWith({
    String? companyName,
    String? engineerName,
    String? logoPath,
    bool clearLogo = false,
  }) {
    return BrandingModel(
      companyName: companyName ?? this.companyName,
      engineerName: engineerName ?? this.engineerName,
      logoPath: clearLogo ? null : (logoPath ?? this.logoPath),
    );
  }
}



