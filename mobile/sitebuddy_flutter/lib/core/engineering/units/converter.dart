/// CLASS: UnitConverter
/// PURPOSE: Provides static utility methods for converting between engineering units.
/// Strict adherence to conversion factors used in civil engineering.
class UnitConverter {
  // --- LENGTH CONVERSIONS ---

  /// Converts millimeters (mm) to inches.
  /// Factor: 1 mm = 0.0393701 inches.
  static double mmToInch(double mm) => mm * 0.0393701;

  /// Converts inches to millimeters (mm).
  /// Factor: 1 inch = 25.4 mm.
  static double inchToMm(double inch) => inch * 25.4;

  // --- FORCE CONVERSIONS ---

  /// Converts KiloNewtons (kN) to Pound-force (lbf).
  /// Factor: 1 kN = 224.809 lbf.
  static double knToLbf(double kn) => kn * 224.809;

  /// Converts Pound-force (lbf) to KiloNewtons (kN).
  /// Factor: 1 lbf = 0.00444822 kN.
  static double lbfToKn(double lbf) => lbf * 0.00444822;

  // --- AREA CONVERSIONS ---

  /// Converts square millimeters (mm²) to square inches (in²).
  static double mm2ToInch2(double mm2) => mm2 * 0.0015500031;

  /// Converts square inches (in²) to square millimeters (mm²).
  static double inch2ToMm2(double inch2) => inch2 * 645.16;
}
