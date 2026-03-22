import 'dart:math' as math;
import 'package:site_buddy/core/engineering/standards/transport/road_standard.dart';

/// lib/core/engineering/standards/transport/irc_standard.dart
///
/// Implementation of RoadStandard based on Indian Roads Congress (IRC) guidelines.
class IRCStandard implements RoadStandard {
  @override
  String get codeIdentifier => 'IRC:37-2018';

  @override
  double get minCBR => 2.0;

  @override
  double get safetyFactor => 1.2;

  @override
  double thicknessFromCBR({required double cbr, required double traffic}) {
    if (cbr < minCBR) return 800.0; // Minimum thickess for very poor soil

    // Simplified IRC empirical formula for total pavement thickness (T)
    // T = [98.5 * (Traffic^0.116)] / (CBR^0.6)
    // This is a representative formula for demonstration.
    final double thickness = (98.5 * math.pow(traffic, 0.116)) / math.pow(cbr, 0.6);
    
    // Convert cm to mm (if formula gives cm)
    return (thickness * 10).clamp(300.0, 1000.0);
  }
}
