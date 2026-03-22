import 'package:site_buddy/core/engineering/standards/design_code.dart';
import 'package:site_buddy/core/engineering/standards/rcc/design_standard.dart';
import 'package:site_buddy/core/engineering/standards/rcc/is_456_standard.dart';

/// CLASS: DesignStandardResolver
/// PURPOSE: Central registry to resolve a DesignCode to its concrete DesignStandard implementation.
class DesignStandardResolver {
  /// Maps DesignCode to DesignStandard.
  /// Defaults to IS456Standard if not found or unimplemented.
  static DesignStandard resolve(DesignCode code) {
    switch (code) {
      case DesignCode.is456:
        return IS456Standard();
      case DesignCode.aci318:
      case DesignCode.eurocode:
        // These can be implemented in future phases.
        throw UnimplementedError('Standard ${code.name} is not yet implemented.');
    }
  }
}
