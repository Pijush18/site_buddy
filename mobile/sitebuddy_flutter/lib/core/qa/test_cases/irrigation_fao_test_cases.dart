import 'package:site_buddy/core/qa/golden_test_cases.dart';
import 'package:site_buddy/core/engineering/standards/irrigation/fao_56_standard.dart';
import 'package:site_buddy/features/water/irrigation/domain/models/crop_models.dart';

/// Irrigation FAO-56 domain test cases.
/// 
/// Tests FAO-56 Penman-Monteith calculations including:
/// - Reference evapotranspiration (ET₀)
/// - Crop coefficients (Kc)
/// - Crop evapotranspiration (ETc)
/// - Effective rainfall
/// - Gross irrigation requirement
class IrrigationFAOTestInput {
  final ClimateData climate;
  final CropType cropType;
  final CropGrowthStage growthStage;

  const IrrigationFAOTestInput({
    required this.climate,
    required this.cropType,
    required this.growthStage,
  });
}

class IrrigationFAOTestExpected {
  final double et0;
  final double kc;
  final double etc;
  final double effectiveRainfall;

  const IrrigationFAOTestExpected({
    required this.et0,
    required this.kc,
    required this.etc,
    required this.effectiveRainfall,
  });
}

/// Golden test cases for FAO-56 calculations.
/// 
/// Test IDs: IR_`NNN`
/// Priority: P0-Critical
final irrigationFAOTestCases = [
  const GoldenTestCase<IrrigationFAOTestInput, IrrigationFAOTestExpected>(
    id: 'IR_001',
    description: 'Standard temperate climate, wheat mid-season',
    input: IrrigationFAOTestInput(
      climate: ClimateData(
        temperature: 25.0,
        humidity: 60.0,
        windSpeed: 2.0,
        sunshineHours: 8.0,
        solarRadiation: 18.0,
        rainfall: 100.0,
      ),
      cropType: CropType.wheat,
      growthStage: CropGrowthStage.midSeason,
    ),
    expected: IrrigationFAOTestExpected(
      et0: 4.5,    // Approximate ET₀ for temperate climate
      kc: 1.15,   // FAO-56 wheat mid-season Kc
      etc: 5.2,   // ET₀ × Kc
      effectiveRainfall: 60.0, // USDA SCS: 100mm → 60% = 60mm
    ),
    tolerance: 10.0, // 10% tolerance for empirical ET₀
  ),
  const GoldenTestCase<IrrigationFAOTestInput, IrrigationFAOTestExpected>(
    id: 'IR_002',
    description: 'Hot dry climate, rice paddy',
    input: IrrigationFAOTestInput(
      climate: ClimateData(
        temperature: 32.0,
        humidity: 40.0,
        windSpeed: 3.0,
        sunshineHours: 10.0,
        solarRadiation: 22.0,
        rainfall: 50.0,
      ),
      cropType: CropType.rice,
      growthStage: CropGrowthStage.midSeason,
    ),
    expected: IrrigationFAOTestExpected(
      et0: 6.5,    // Higher ET₀ for hot climate
      kc: 1.20,   // FAO-56 rice mid-season Kc
      etc: 7.8,    // ET₀ × Kc
      effectiveRainfall: 30.0, // USDA SCS: 50mm → 60% = 30mm
    ),
    tolerance: 15.0, // 15% for high evaporation conditions
  ),
  const GoldenTestCase<IrrigationFAOTestInput, IrrigationFAOTestExpected>(
    id: 'IR_003',
    description: 'Wheat initial stage (low Kc)',
    input: IrrigationFAOTestInput(
      climate: ClimateData(
        temperature: 20.0,
        humidity: 70.0,
        windSpeed: 1.5,
        sunshineHours: 6.0,
        solarRadiation: 14.0,
        rainfall: 80.0,
      ),
      cropType: CropType.wheat,
      growthStage: CropGrowthStage.initial,
    ),
    expected: IrrigationFAOTestExpected(
      et0: 3.0,
      kc: 0.35,   // Low Kc for initial stage
      etc: 1.05,
      effectiveRainfall: 48.0, // 80mm → 60%
    ),
    tolerance: 10.0,
  ),
  const GoldenTestCase<IrrigationFAOTestInput, IrrigationFAOTestExpected>(
    id: 'IR_004',
    description: 'High rainfall region',
    input: IrrigationFAOTestInput(
      climate: ClimateData(
        temperature: 28.0,
        humidity: 85.0,
        windSpeed: 1.0,
        sunshineHours: 5.0,
        solarRadiation: 16.0,
        rainfall: 400.0,
      ),
      cropType: CropType.maize,
      growthStage: CropGrowthStage.midSeason,
    ),
    expected: IrrigationFAOTestExpected(
      et0: 4.0,
      kc: 1.20,   // FAO-56 maize mid-season Kc
      etc: 4.8,
      effectiveRainfall: 187.5, // USDA SCS: 250mm base + 37.5mm
    ),
    tolerance: 10.0,
  ),
  const GoldenTestCase<IrrigationFAOTestInput, IrrigationFAOTestExpected>(
    id: 'IR_005',
    description: 'Drip irrigation crop, high efficiency',
    input: IrrigationFAOTestInput(
      climate: ClimateData(
        temperature: 30.0,
        humidity: 50.0,
        windSpeed: 2.5,
        sunshineHours: 9.0,
        solarRadiation: 20.0,
        rainfall: 30.0,
      ),
      cropType: CropType.citrus,
      growthStage: CropGrowthStage.midSeason,
    ),
    expected: IrrigationFAOTestExpected(
      et0: 5.5,
      kc: 0.95,   // FAO-56 citrus mid-season Kc
      etc: 5.2,
      effectiveRainfall: 18.0, // USDA SCS: 30mm → 60%
    ),
    tolerance: 10.0,
  ),
];

/// Crop coefficient test cases (Kc values).
class KcTestInput {
  final CropType cropType;
  final CropGrowthStage growthStage;

  const KcTestInput({
    required this.cropType,
    required this.growthStage,
  });
}

class KcTestExpected {
  final double kc;

  const KcTestExpected({required this.kc});
}

/// Golden test cases for crop coefficients (Kc).
/// 
/// Test IDs: KC_`NNN`
final kcTestCases = [
  const GoldenTestCase<KcTestInput, KcTestExpected>(
    id: 'KC_001',
    description: 'Wheat mid-season Kc = 1.15',
    input: KcTestInput(
      cropType: CropType.wheat,
      growthStage: CropGrowthStage.midSeason,
    ),
    expected: KcTestExpected(kc: 1.15),
    tolerance: 0.0, // Exact FAO-56 value
  ),
  const GoldenTestCase<KcTestInput, KcTestExpected>(
    id: 'KC_002',
    description: 'Rice mid-season Kc = 1.20',
    input: KcTestInput(
      cropType: CropType.rice,
      growthStage: CropGrowthStage.midSeason,
    ),
    expected: KcTestExpected(kc: 1.20),
    tolerance: 0.0,
  ),
  const GoldenTestCase<KcTestInput, KcTestExpected>(
    id: 'KC_003',
    description: 'Maize mid-season Kc = 1.20',
    input: KcTestInput(
      cropType: CropType.maize,
      growthStage: CropGrowthStage.midSeason,
    ),
    expected: KcTestExpected(kc: 1.20),
    tolerance: 0.0,
  ),
  const GoldenTestCase<KcTestInput, KcTestExpected>(
    id: 'KC_004',
    description: 'Potato mid-season Kc = 1.15',
    input: KcTestInput(
      cropType: CropType.potato,
      growthStage: CropGrowthStage.midSeason,
    ),
    expected: KcTestExpected(kc: 1.15),
    tolerance: 0.0,
  ),
  const GoldenTestCase<KcTestInput, KcTestExpected>(
    id: 'KC_005',
    description: 'Cotton mid-season Kc = 1.15',
    input: KcTestInput(
      cropType: CropType.cotton,
      growthStage: CropGrowthStage.midSeason,
    ),
    expected: KcTestExpected(kc: 1.15),
    tolerance: 0.0,
  ),
];

/// Effective rainfall test cases (USDA SCS method).
class EffectiveRainfallTestInput {
  final double totalRainfall;

  const EffectiveRainfallTestInput({required this.totalRainfall});
}

class EffectiveRainfallTestExpected {
  final double effectiveRainfall;

  const EffectiveRainfallTestExpected({required this.effectiveRainfall});
}

/// Golden test cases for effective rainfall.
/// 
/// USDA SCS Method:
/// - ≤250mm: 60% effective
/// - 250-500mm: 150 + 25% of excess
/// - >500mm: 212.5 + 10% of excess
/// 
/// Test IDs: RF_`NNN`
final effectiveRainfallTestCases = [
  const GoldenTestCase<EffectiveRainfallTestInput, EffectiveRainfallTestExpected>(
    id: 'RF_001',
    description: '100mm rainfall → 60mm effective',
    input: EffectiveRainfallTestInput(totalRainfall: 100.0),
    expected: EffectiveRainfallTestExpected(effectiveRainfall: 60.0),
    tolerance: 0.0,
  ),
  const GoldenTestCase<EffectiveRainfallTestInput, EffectiveRainfallTestExpected>(
    id: 'RF_002',
    description: '250mm rainfall → 150mm effective',
    input: EffectiveRainfallTestInput(totalRainfall: 250.0),
    expected: EffectiveRainfallTestExpected(effectiveRainfall: 150.0),
    tolerance: 0.0,
  ),
  const GoldenTestCase<EffectiveRainfallTestInput, EffectiveRainfallTestExpected>(
    id: 'RF_003',
    description: '400mm rainfall → 187.5mm effective',
    input: EffectiveRainfallTestInput(totalRainfall: 400.0),
    expected: EffectiveRainfallTestExpected(effectiveRainfall: 187.5),
    tolerance: 0.0,
  ),
  const GoldenTestCase<EffectiveRainfallTestInput, EffectiveRainfallTestExpected>(
    id: 'RF_004',
    description: '600mm rainfall → 222.5mm effective',
    input: EffectiveRainfallTestInput(totalRainfall: 600.0),
    expected: EffectiveRainfallTestExpected(effectiveRainfall: 222.5),
    tolerance: 0.0,
  ),
  const GoldenTestCase<EffectiveRainfallTestInput, EffectiveRainfallTestExpected>(
    id: 'RF_005',
    description: '1000mm rainfall → 272.5mm effective',
    input: EffectiveRainfallTestInput(totalRainfall: 1000.0),
    expected: EffectiveRainfallTestExpected(effectiveRainfall: 272.5),
    tolerance: 0.0,
  ),
];

/// Runs all irrigation FAO tests.
/// 
/// Returns list of test results for QA reporting.
List<Map<String, dynamic>> runIrrigationFAOTests() {
  final fao56 = FAO56Standard();
  final results = <Map<String, dynamic>>[];

  // Run ET₀ and Kc tests
  for (final test in irrigationFAOTestCases) {
    try {
      final et0 = fao56.calculateET0(test.input.climate);
      final kc = fao56.getCropCoefficient(test.input.cropType, test.input.growthStage);
      final etc = fao56.calculateETc(et0, kc);
      final effRain = fao56.calculateEffectiveRainfall(test.input.climate.rainfall);

      final et0Diff = (et0 - test.expected.et0).abs();
      final kcDiff = (kc - test.expected.kc).abs();
      final etcDiff = (etc - test.expected.etc).abs();
      final rainDiff = (effRain - test.expected.effectiveRainfall).abs();

      final tolerance = test.expected.et0 * (test.tolerance / 100);

      results.add({
        'id': test.id,
        'passed': 
          et0Diff <= tolerance &&
          kcDiff <= 0.01 &&
          etcDiff <= tolerance &&
          rainDiff <= 0.1,
        'description': test.description,
        'expected': {
          'et0': test.expected.et0,
          'kc': test.expected.kc,
          'etc': test.expected.etc,
          'effectiveRainfall': test.expected.effectiveRainfall,
        },
        'actual': {
          'et0': et0,
          'kc': kc,
          'etc': etc,
          'effectiveRainfall': effRain,
        },
        'tolerance': tolerance,
      });
    } catch (e) {
      results.add({
        'id': test.id,
        'passed': false,
        'error': e.toString(),
      });
    }
  }

  // Run Kc specific tests
  for (final test in kcTestCases) {
    try {
      final kc = fao56.getCropCoefficient(test.input.cropType, test.input.growthStage);
      results.add({
        'id': test.id,
        'passed': (kc - test.expected.kc).abs() <= test.tolerance,
        'description': test.description,
        'expected': test.expected.kc,
        'actual': kc,
      });
    } catch (e) {
      results.add({
        'id': test.id,
        'passed': false,
        'error': e.toString(),
      });
    }
  }

  // Run effective rainfall tests
  for (final test in effectiveRainfallTestCases) {
    try {
      final effRain = fao56.calculateEffectiveRainfall(test.input.totalRainfall);
      results.add({
        'id': test.id,
        'passed': (effRain - test.expected.effectiveRainfall).abs() <= 0.1,
        'description': test.description,
        'expected': test.expected.effectiveRainfall,
        'actual': effRain,
      });
    } catch (e) {
      results.add({
        'id': test.id,
        'passed': false,
        'error': e.toString(),
      });
    }
  }

  return results;
}
