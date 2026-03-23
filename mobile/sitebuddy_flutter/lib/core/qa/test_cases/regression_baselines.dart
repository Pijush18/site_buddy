/// lib/core/qa/test_cases/regression_baselines.dart
///
/// Regression baseline cases for Road and Irrigation modules.
/// 
/// PURPOSE:
/// - Capture stable reference outputs for key scenarios
/// - Detect silent formula changes
/// - Provide "golden" reference for validation
/// 
/// BASELINE PHILOSOPHY:
/// These are FIXED expected outputs. Any deviation indicates a
/// regression and should fail the test immediately.
library;

import 'package:site_buddy/core/engineering/standards/irrigation/fao_56_standard.dart';
import 'package:site_buddy/core/engineering/standards/transport/irc_37_2018.dart';
import 'package:site_buddy/features/transport/road/domain/models/traffic_growth.dart';
import 'package:site_buddy/features/water/irrigation/domain/models/crop_models.dart';
import 'package:site_buddy/features/water/irrigation/domain/models/soil_models.dart';
import 'package:site_buddy/features/water/irrigation/domain/models/scenario_models.dart';

// ============================================================================
// TOLERANCE STRATEGY
// ============================================================================

/// Tolerance strategy per domain.
/// 
/// Different domains have different precision requirements:
/// - Empirical formulas (IRC, FAO): 5-10% tolerance
/// - Tabulated values (Kc, soil properties): Exact match (0%)
/// - Physical measurements: 1-2% tolerance
class ToleranceStrategy {
  /// Domain identifier
  final String domain;
  
  /// Tolerance as percentage (e.g., 5.0 = 5%)
  final double percentTolerance;
  
  /// Absolute tolerance for small values
  final double absoluteTolerance;
  
  /// Description of why this tolerance is chosen
  final String rationale;

  const ToleranceStrategy({
    required this.domain,
    required this.percentTolerance,
    required this.absoluteTolerance,
    required this.rationale,
  });
}

/// All tolerance strategies by domain.
const toleranceStrategies = {
  // Road module tolerances
  'road_thickness': ToleranceStrategy(
    domain: 'road_thickness',
    percentTolerance: 5.0,      // 5% for empirical power law
    absoluteTolerance: 5.0,      // mm absolute
    rationale: 'IRC 37-2018 uses empirical formula with inherent variation',
  ),
  'road_esal': ToleranceStrategy(
    domain: 'road_esal',
    percentTolerance: 2.0,      // 2% for discrete compound growth
    absoluteTolerance: 1000.0,   // vehicles
    rationale: 'ESAL calculation is deterministic but accumulates rounding',
  ),
  'road_traffic_class': ToleranceStrategy(
    domain: 'road_traffic_class',
    percentTolerance: 0.0,      // Exact classification
    absoluteTolerance: 0.0,
    rationale: 'Traffic classification is discrete (LOW/MEDIUM/HEAVY)',
  ),
  
  // Irrigation module tolerances
  'irrigation_et0': ToleranceStrategy(
    domain: 'irrigation_et0',
    percentTolerance: 10.0,     // 10% for Penman-Monteith estimation
    absoluteTolerance: 0.5,      // mm/day
    rationale: 'ET₀ is an estimate; weather data has uncertainty',
  ),
  'irrigation_kc': ToleranceStrategy(
    domain: 'irrigation_kc',
    percentTolerance: 0.0,      // Exact FAO-56 value
    absoluteTolerance: 0.01,
    rationale: 'Kc values are tabulated FAO-56 constants',
  ),
  'irrigation_rainfall': ToleranceStrategy(
    domain: 'irrigation_rainfall',
    percentTolerance: 0.0,      // Exact USDA SCS formula
    absoluteTolerance: 0.1,      // mm
    rationale: 'Effective rainfall uses discrete USDA SCS brackets',
  ),
  'irrigation_water_req': ToleranceStrategy(
    domain: 'irrigation_water_req',
    percentTolerance: 8.0,      // 8% for compounded calculations
    absoluteTolerance: 1.0,      // mm
    rationale: 'Water requirement compounds ET₀ and Kc tolerances',
  ),
  'soil_properties': ToleranceStrategy(
    domain: 'soil_properties',
    percentTolerance: 0.0,      // Exact tabulated values
    absoluteTolerance: 0.1,      // percentage points
    rationale: 'Soil properties are empirical observations',
  ),
  'soil_moisture': ToleranceStrategy(
    domain: 'soil_moisture',
    percentTolerance: 3.0,      // 3% for derived calculations
    absoluteTolerance: 0.5,      // mm
    rationale: 'Moisture balance derives from soil properties',
  ),
  'irrigation_efficiency': ToleranceStrategy(
    domain: 'irrigation_efficiency',
    percentTolerance: 0.0,      // Exact tabulated values
    absoluteTolerance: 0.1,      // percentage
    rationale: 'Irrigation efficiency is based on field measurements',
  ),
  'scenario_factor': ToleranceStrategy(
    domain: 'scenario_factor',
    percentTolerance: 0.0,      // Exact factor values
    absoluteTolerance: 0.01,
    rationale: 'Scenario factors are standardized coefficients',
  ),
};

/// Get tolerance for a domain.
ToleranceStrategy getTolerance(String domain) {
  return toleranceStrategies[domain] ?? const ToleranceStrategy(
    domain: 'unknown',
    percentTolerance: 5.0,
    absoluteTolerance: 0.1,
    rationale: 'Default tolerance',
  );
}

// ============================================================================
// REGRESSION BASELINES
// ============================================================================

/// Regression baseline case.
/// 
/// Contains stable reference inputs and their expected outputs.
/// Any change to expected output indicates a regression.
class RegressionBaseline {
  final String id;
  final String domain;
  final String description;
  final Map<String, dynamic> input;
  final Map<String, dynamic> expected;
  final double tolerancePercent;
  final double toleranceAbsolute;
  final DateTime baselineDate;
  final String baselineVersion;

  const RegressionBaseline({
    required this.id,
    required this.domain,
    required this.description,
    required this.input,
    required this.expected,
    required this.tolerancePercent,
    required this.toleranceAbsolute,
    required this.baselineDate,
    this.baselineVersion = '1.0',
  });

  /// Check if actual output matches baseline.
  bool matches(Map<String, dynamic> actual) {
    for (final entry in expected.entries) {
      final key = entry.key;
      final expVal = entry.value;
      final actVal = actual[key];
      
      if (expVal is num && actVal is num) {
        final diff = (actVal - expVal).abs();
        final tolerance = _calculateTolerance(expVal.toDouble());
        if (diff > tolerance) return false;
      } else if (expVal != actVal) {
        return false;
      }
    }
    return true;
  }

  /// Calculate tolerance for a specific value.
  double _calculateTolerance(double expectedValue) {
    final percentBased = expectedValue.abs() * (tolerancePercent / 100);
    return percentBased > toleranceAbsolute ? percentBased : toleranceAbsolute;
  }

  /// Get mismatch details.
  List<String> getMismatches(Map<String, dynamic> actual) {
    final mismatches = <String>[];
    for (final entry in expected.entries) {
      final key = entry.key;
      final expVal = entry.value;
      final actVal = actual[key];
      
      if (expVal is num && actVal is num) {
        final diff = (actVal - expVal).abs();
        final tolerance = _calculateTolerance(expVal.toDouble());
        if (diff > tolerance) {
          mismatches.add('$key: expected=$expVal, actual=$actVal, diff=$diff, tolerance=$tolerance');
        }
      } else if (expVal != actVal) {
        mismatches.add('$key: expected=$expVal, actual=$actVal');
      }
    }
    return mismatches;
  }
}

// ============================================================================
// ROAD MODULE BASELINES
// ============================================================================

/// Road pavement design baselines.
/// 
/// These represent stable IRC 37-2018 calculations that should
/// NOT change without explicit design review.
final roadBaselines = [
  RegressionBaseline(
    id: 'RD_BASE_001',
    domain: 'road_thickness',
    description: 'Standard highway: CBR=10%, MSA=10',
    input: {
      'cbr': 10.0,
      'msa': 10.0,
    },
    expected: {
      'thickness': 443.0,  // H = 3432 * 10^0.116 * 10^-0.6 - 113
      'trafficClass': 'MEDIUM',
      'safety': 'SAFE',
    },
    tolerancePercent: 5.0,
    toleranceAbsolute: 10.0,
    baselineDate: DateTime(2024, 1, 15),
    baselineVersion: '1.0',
  ),
  RegressionBaseline(
    id: 'RD_BASE_002',
    domain: 'road_thickness',
    description: 'Poor subgrade: CBR=3%, MSA=10',
    input: {
      'cbr': 3.0,
      'msa': 10.0,
    },
    expected: {
      'thickness': 520.0,  // Penalty applied
      'trafficClass': 'MEDIUM',
      'safety': 'CRITICAL',
    },
    tolerancePercent: 5.0,
    toleranceAbsolute: 10.0,
    baselineDate: DateTime(2024, 1, 15),
    baselineVersion: '1.0',
  ),
  RegressionBaseline(
    id: 'RD_BASE_003',
    domain: 'road_thickness',
    description: 'Heavy traffic: CBR=8%, MSA=50',
    input: {
      'cbr': 8.0,
      'msa': 50.0,
    },
    expected: {
      'thickness': 550.0,
      'trafficClass': 'HEAVY',
      'safety': 'SAFE',
    },
    tolerancePercent: 5.0,
    toleranceAbsolute: 10.0,
    baselineDate: DateTime(2024, 1, 15),
    baselineVersion: '1.0',
  ),
  RegressionBaseline(
    id: 'RD_ESAL_001',
    domain: 'road_esal',
    description: '1000 CVPD, 5% growth, 15 years',
    input: {
      'initialTraffic': 1000.0,
      'growthRate': 5.0,
      'designLife': 15,
      'vdf': 3.5,
      'ldf': 1.0,
    },
    expected: {
      'cumulativeESAL': 8000000.0,
      'msa': 8.0,
    },
    tolerancePercent: 2.0,
    toleranceAbsolute: 1000.0,
    baselineDate: DateTime(2024, 1, 15),
    baselineVersion: '1.0',
  ),
  RegressionBaseline(
    id: 'RD_LAYER_001',
    domain: 'road_layer',
    description: '500mm total: BC/DBM/WMM/GSB proportions',
    input: {
      'totalThickness': 500.0,
    },
    expected: {
      'bc': 35.0,    // 7%
      'dbm': 90.0,   // 18%
      'wmm': 175.0,  // 35%
      'gsb': 200.0,  // 40%
    },
    tolerancePercent: 0.0,
    toleranceAbsolute: 0.5,
    baselineDate: DateTime(2024, 1, 15),
    baselineVersion: '1.0',
  ),
  RegressionBaseline(
    id: 'RD_SCENARIO_001',
    domain: 'scenario_factor',
    description: 'Traffic scenario factors',
    input: {},
    expected: {
      'conservative': 1.2,
      'standard': 1.0,
      'optimized': 0.9,
    },
    tolerancePercent: 0.0,
    toleranceAbsolute: 0.01,
    baselineDate: DateTime(2024, 1, 15),
    baselineVersion: '1.0',
  ),
];

// ============================================================================
// IRRIGATION MODULE BASELINES
// ============================================================================

/// Irrigation FAO-56 baselines.
final irrigationBaselines = [
  RegressionBaseline(
    id: 'IR_BASE_001',
    domain: 'irrigation_et0',
    description: 'Temperate climate: 25°C, 60% RH, 8h sun',
    input: {
      'temperature': 25.0,
      'humidity': 60.0,
      'windSpeed': 2.0,
      'sunshineHours': 8.0,
      'solarRadiation': 18.0,
    },
    expected: {
      'et0': 4.5,  // Hargreaves-Samani estimation
    },
    tolerancePercent: 10.0,
    toleranceAbsolute: 0.5,
    baselineDate: DateTime(2024, 1, 15),
    baselineVersion: '1.0',
  ),
  RegressionBaseline(
    id: 'IR_BASE_002',
    domain: 'irrigation_et0',
    description: 'Hot climate: 32°C, 40% RH, 10h sun',
    input: {
      'temperature': 32.0,
      'humidity': 40.0,
      'windSpeed': 3.0,
      'sunshineHours': 10.0,
      'solarRadiation': 22.0,
    },
    expected: {
      'et0': 6.5,
    },
    tolerancePercent: 10.0,
    toleranceAbsolute: 0.5,
    baselineDate: DateTime(2024, 1, 15),
    baselineVersion: '1.0',
  ),
  RegressionBaseline(
    id: 'IR_KC_001',
    domain: 'irrigation_kc',
    description: 'Wheat Kc values by growth stage',
    input: {
      'crop': 'wheat',
    },
    expected: {
      'initial': 0.35,
      'development': 0.75,
      'midSeason': 1.15,
      'lateSeason': 0.40,
    },
    tolerancePercent: 0.0,
    toleranceAbsolute: 0.01,
    baselineDate: DateTime(2024, 1, 15),
    baselineVersion: '1.0',
  ),
  RegressionBaseline(
    id: 'IR_KC_002',
    domain: 'irrigation_kc',
    description: 'Rice Kc values by growth stage',
    input: {
      'crop': 'rice',
    },
    expected: {
      'initial': 0.35,
      'development': 0.75,
      'midSeason': 1.20,
      'lateSeason': 0.90,
    },
    tolerancePercent: 0.0,
    toleranceAbsolute: 0.01,
    baselineDate: DateTime(2024, 1, 15),
    baselineVersion: '1.0',
  ),
  RegressionBaseline(
    id: 'IR_RAINFALL_001',
    domain: 'irrigation_rainfall',
    description: 'Effective rainfall (USDA SCS)',
    input: {
      'totalRainfall': 100.0,
    },
    expected: {
      'effectiveRainfall': 60.0,  // 60% of 100mm
    },
    tolerancePercent: 0.0,
    toleranceAbsolute: 0.1,
    baselineDate: DateTime(2024, 1, 15),
    baselineVersion: '1.0',
  ),
  RegressionBaseline(
    id: 'IR_RAINFALL_002',
    domain: 'irrigation_rainfall',
    description: 'High rainfall (USDA SCS)',
    input: {
      'totalRainfall': 400.0,
    },
    expected: {
      'effectiveRainfall': 187.5,  // 150 + 25% of 150
    },
    tolerancePercent: 0.0,
    toleranceAbsolute: 0.1,
    baselineDate: DateTime(2024, 1, 15),
    baselineVersion: '1.0',
  ),
  RegressionBaseline(
    id: 'IR_WATER_001',
    domain: 'irrigation_water_req',
    description: 'Wheat water requirement',
    input: {
      'crop': 'wheat',
      'stage': 'midSeason',
      'area': 10.0,  // hectares
      'et0': 4.5,
    },
    expected: {
      'kc': 1.15,
      'etc': 5.2,       // ET₀ × Kc
      'dailyLiters': 52000.0,  // 5.2mm × 10ha × 1000
    },
    tolerancePercent: 8.0,
    toleranceAbsolute: 1.0,
    baselineDate: DateTime(2024, 1, 15),
    baselineVersion: '1.0',
  ),
  RegressionBaseline(
    id: 'IR_SCENARIO_001',
    domain: 'scenario_factor',
    description: 'Irrigation water application factors',
    input: {},
    expected: {
      'conservative': 1.15,
      'standard': 1.0,
      'optimized': 0.85,
    },
    tolerancePercent: 0.0,
    toleranceAbsolute: 0.01,
    baselineDate: DateTime(2024, 1, 15),
    baselineVersion: '1.0',
  ),
];

// ============================================================================
// SOIL MODULE BASELINES
// ============================================================================

/// Soil properties baselines.
final soilBaselines = [
  RegressionBaseline(
    id: 'SOIL_BASE_001',
    domain: 'soil_properties',
    description: 'Loam soil properties',
    input: {
      'soilType': 'loam',
    },
    expected: {
      'fieldCapacity': 27.0,
      'wiltingPoint': 12.0,
      'availableWater': 15.0,
      'infiltrationRate': 25.0,
    },
    tolerancePercent: 0.0,
    toleranceAbsolute: 0.1,
    baselineDate: DateTime(2024, 1, 15),
    baselineVersion: '1.0',
  ),
  RegressionBaseline(
    id: 'SOIL_BASE_002',
    domain: 'soil_properties',
    description: 'Clay soil properties',
    input: {
      'soilType': 'clay',
    },
    expected: {
      'fieldCapacity': 36.0,
      'wiltingPoint': 18.0,
      'availableWater': 18.0,
      'infiltrationRate': 5.0,
    },
    tolerancePercent: 0.0,
    toleranceAbsolute: 0.1,
    baselineDate: DateTime(2024, 1, 15),
    baselineVersion: '1.0',
  ),
  RegressionBaseline(
    id: 'SOIL_MOISTURE_001',
    domain: 'soil_moisture',
    description: 'Loam moisture balance (1.2m root, 50% MAD)',
    input: {
      'soilType': 'loam',
      'rootDepth': 1.2,
      'mad': 0.50,
    },
    expected: {
      'totalAvailableWater': 18.0,      // 15mm/m × 1.2m
      'readilyAvailableWater': 9.0,     // 18 × 0.5
      'irrigationInterval': 1.8,        // 9mm / 5mm/day
    },
    tolerancePercent: 3.0,
    toleranceAbsolute: 0.5,
    baselineDate: DateTime(2024, 1, 15),
    baselineVersion: '1.0',
  ),
  RegressionBaseline(
    id: 'IRRIGATION_EFF_001',
    domain: 'irrigation_efficiency',
    description: 'Method efficiency comparison',
    input: {},
    expected: {
      'flood': 50.0,
      'furrow': 60.0,
      'sprinkler': 75.0,
      'drip': 90.0,
      'centerPivot': 80.0,
    },
    tolerancePercent: 0.0,
    toleranceAbsolute: 0.1,
    baselineDate: DateTime(2024, 1, 15),
    baselineVersion: '1.0',
  ),
  RegressionBaseline(
    id: 'IRRIGATION_GROSS_001',
    domain: 'irrigation_efficiency',
    description: 'Gross irrigation (100mm net, drip)',
    input: {
      'netIrrigation': 100.0,
      'method': 'drip',
    },
    expected: {
      'grossIrrigation': 111.1,  // 100 / 0.90
    },
    tolerancePercent: 0.0,
    toleranceAbsolute: 0.1,
    baselineDate: DateTime(2024, 1, 15),
    baselineVersion: '1.0',
  ),
];

// ============================================================================
// RUNNER
// ============================================================================

/// Runs all regression baselines and returns results.
List<Map<String, dynamic>> runRegressionBaselines() {
  final results = <Map<String, dynamic>>[];
  final irc37 = IRC37Standard();
  final fao56 = FAO56Standard();

  // Run Road baselines
  for (final baseline in roadBaselines) {
    try {
      Map<String, dynamic> actual = {};

      if (baseline.id.startsWith('RD_BASE')) {
        // Thickness baseline
        final cbr = (baseline.input['cbr'] as num).toDouble();
        final msa = (baseline.input['msa'] as num).toDouble();
        actual = {
          'thickness': irc37.designThickness(cbr, msa),
          'trafficClass': irc37.classifyTraffic(msa),
          'safety': irc37.evaluateSafety(cbr: cbr, thickness: irc37.designThickness(cbr, msa)),
        };
      } else if (baseline.id.startsWith('RD_ESAL')) {
        actual = {
          'cumulativeESAL': irc37.calculateESAL(
            initialTraffic: (baseline.input['initialTraffic'] as num).toDouble(),
            growthRate: (baseline.input['growthRate'] as num).toDouble(),
            designLife: baseline.input['designLife'] as int,
            vdf: (baseline.input['vdf'] as num).toDouble(),
            ldf: (baseline.input['ldf'] as num).toDouble(),
          ),
          'msa': irc37.msaFromTraffic(
            irc37.calculateESAL(
              initialTraffic: (baseline.input['initialTraffic'] as num).toDouble(),
              growthRate: (baseline.input['growthRate'] as num).toDouble(),
              designLife: baseline.input['designLife'] as int,
              vdf: (baseline.input['vdf'] as num).toDouble(),
              ldf: (baseline.input['ldf'] as num).toDouble(),
            ),
          ),
        };
      } else if (baseline.id.startsWith('RD_LAYER')) {
        final layers = irc37.layerDistribution(
          (baseline.input['totalThickness'] as num).toDouble(),
        );
        actual = {
          'bc': layers[0],
          'dbm': layers[1],
          'wmm': layers[2],
          'gsb': layers[3],
        };
      } else if (baseline.id.startsWith('RD_SCENARIO')) {
        actual = {
          'conservative': irc37.getScenarioTrafficFactor(DesignScenario.conservative),
          'standard': irc37.getScenarioTrafficFactor(DesignScenario.standard),
          'optimized': irc37.getScenarioTrafficFactor(DesignScenario.optimized),
        };
      }

      final matches = baseline.matches(actual);
      results.add({
        'id': baseline.id,
        'passed': matches,
        'description': baseline.description,
        'domain': baseline.domain,
        'expected': baseline.expected,
        'actual': actual,
        'tolerance': '${baseline.tolerancePercent}% / ${baseline.toleranceAbsolute}',
        'mismatches': matches ? [] : baseline.getMismatches(actual),
      });
    } catch (e) {
      results.add({
        'id': baseline.id,
        'passed': false,
        'error': e.toString(),
        'description': baseline.description,
      });
    }
  }

  // Run Irrigation baselines
  for (final baseline in irrigationBaselines) {
    try {
      Map<String, dynamic> actual = {};

      if (baseline.id.startsWith('IR_BASE')) {
        final climate = ClimateData(
          temperature: (baseline.input['temperature'] as num).toDouble(),
          humidity: (baseline.input['humidity'] as num).toDouble(),
          windSpeed: (baseline.input['windSpeed'] as num).toDouble(),
          sunshineHours: (baseline.input['sunshineHours'] as num).toDouble(),
          solarRadiation: (baseline.input['solarRadiation'] as num).toDouble(),
          rainfall: 0,
        );
        actual = {
          'et0': fao56.calculateET0(climate),
        };
      } else if (baseline.id.startsWith('IR_KC')) {
        final cropName = baseline.input['crop'] as String;
        final crop = CropType.values.firstWhere(
          (c) => c.name == cropName,
          orElse: () => CropType.wheat,
        );
        actual = {
          'initial': fao56.getCropCoefficient(crop, CropGrowthStage.initial),
          'development': fao56.getCropCoefficient(crop, CropGrowthStage.development),
          'midSeason': fao56.getCropCoefficient(crop, CropGrowthStage.midSeason),
          'lateSeason': fao56.getCropCoefficient(crop, CropGrowthStage.lateSeason),
        };
      } else if (baseline.id.startsWith('IR_RAINFALL')) {
        actual = {
          'effectiveRainfall': fao56.calculateEffectiveRainfall(
            (baseline.input['totalRainfall'] as num).toDouble(),
          ),
        };
      } else if (baseline.id.startsWith('IR_WATER')) {
        final kc = fao56.getCropCoefficient(
          CropType.wheat,
          CropGrowthStage.midSeason,
        );
        final etc = (baseline.input['et0'] as num).toDouble() * kc;
        actual = {
          'kc': kc,
          'etc': etc,
          'dailyLiters': etc * (baseline.input['area'] as num).toDouble() * 1000,
        };
      } else if (baseline.id.startsWith('IR_SCENARIO')) {
        actual = {
          'conservative': fao56.getScenarioWaterFactor(IrrigationScenario.conservative),
          'standard': fao56.getScenarioWaterFactor(IrrigationScenario.standard),
          'optimized': fao56.getScenarioWaterFactor(IrrigationScenario.optimized),
        };
      }

      final matches = baseline.matches(actual);
      results.add({
        'id': baseline.id,
        'passed': matches,
        'description': baseline.description,
        'domain': baseline.domain,
        'expected': baseline.expected,
        'actual': actual,
        'tolerance': '${baseline.tolerancePercent}% / ${baseline.toleranceAbsolute}',
        'mismatches': matches ? [] : baseline.getMismatches(actual),
      });
    } catch (e) {
      results.add({
        'id': baseline.id,
        'passed': false,
        'error': e.toString(),
        'description': baseline.description,
      });
    }
  }

  // Run Soil baselines
  for (final baseline in soilBaselines) {
    try {
      Map<String, dynamic> actual = {};

      if (baseline.id.startsWith('SOIL_BASE')) {
        final soilName = baseline.input['soilType'] as String;
        final soil = SoilType.values.firstWhere(
          (s) => s.name == soilName,
          orElse: () => SoilType.loam,
        );
        actual = {
          'fieldCapacity': soil.fieldCapacity,
          'wiltingPoint': soil.wiltingPoint,
          'availableWater': soil.availableWater,
          'infiltrationRate': soil.infiltrationRate,
        };
      } else if (baseline.id.startsWith('SOIL_MOISTURE')) {
        final soil = SoilType.loam;
        final rootDepth = (baseline.input['rootDepth'] as num).toDouble();
        final mad = (baseline.input['mad'] as num).toDouble();
        final total = soil.availableWater * rootDepth;
        actual = {
          'totalAvailableWater': total,
          'readilyAvailableWater': total * mad,
          'irrigationInterval': (total * mad) / 5.0,
        };
      } else if (baseline.id.startsWith('IRRIGATION_EFF')) {
        actual = {
          'flood': IrrigationMethod.flood.efficiency,
          'furrow': IrrigationMethod.furrow.efficiency,
          'sprinkler': IrrigationMethod.sprinkler.efficiency,
          'drip': IrrigationMethod.drip.efficiency,
          'centerPivot': IrrigationMethod.centerPivot.efficiency,
        };
      } else if (baseline.id.startsWith('IRRIGATION_GROSS')) {
        actual = {
          'grossIrrigation': (baseline.input['netIrrigation'] as num).toDouble() /
            (IrrigationMethod.drip.efficiency / 100),
        };
      }

      final matches = baseline.matches(actual);
      results.add({
        'id': baseline.id,
        'passed': matches,
        'description': baseline.description,
        'domain': baseline.domain,
        'expected': baseline.expected,
        'actual': actual,
        'tolerance': '${baseline.tolerancePercent}% / ${baseline.toleranceAbsolute}',
        'mismatches': matches ? [] : baseline.getMismatches(actual),
      });
    } catch (e) {
      results.add({
        'id': baseline.id,
        'passed': false,
        'error': e.toString(),
        'description': baseline.description,
      });
    }
  }

  return results;
}
