import 'package:site_buddy/core/models/code_reference.dart';

/// DATA: IS 456 References
/// PURPOSE: Centralized storage for engineering code clauses used in calculations.
class IS456References {
  static const String _code = 'IS 456:2000';

  // --- COLUMN REFERENCES ---
  static const slendernessRatio = CodeReference(
    code: _code,
    clause: 'Cl. 25.1.2',
    title: 'Slenderness Ratio',
    description:
        'The slenderness ratio of a compression member shall be the ratio of its effective length to its least lateral dimension.',
    formula: 'λ = l_eff / d',
  );

  static const minReinforcementColumn = CodeReference(
    code: _code,
    clause: 'Cl. 26.5.3.1',
    title: 'Minimum Reinforcement',
    description:
        'The cross-sectional area of longitudinal reinforcement shall be not less than 0.8 percent of the gross cross-sectional area of the column.',
    formula: 'A_sc,min = 0.008 * A_g',
  );

  static const maxReinforcementColumn = CodeReference(
    code: _code,
    clause: 'Cl. 26.5.3.1',
    title: 'Maximum Reinforcement',
    description:
        'The cross-sectional area of longitudinal reinforcement shall be not more than 6.0 percent of the gross cross-sectional area of the column.',
    formula: 'A_sc,max = 0.06 * A_g',
  );

  // --- BEAM REFERENCES ---
  static const tensionReinforcement = CodeReference(
    code: _code,
    clause: 'Cl. 26.5.1.1',
    title: 'Minimum Tension Reinforcement',
    description:
        'The minimum area of tension reinforcement shall be not less than that given by the following:',
    formula: 'A_s / (b*d) = 0.85 / f_y',
  );

  static const deflectionCheck = CodeReference(
    code: _code,
    clause: 'Cl. 23.2.1',
    title: 'Control of Deflection',
    description:
        'The vertical deflection limits may generally be assumed to be satisfied if the span to effective depth ratios are not greater than the values obtained.',
    formula: 'Span / d <= Basic Value * k_t * k_c * k_s',
  );

  // --- SLAB REFERENCES ---
  static const slabMinReinforcement = CodeReference(
    code: _code,
    clause: 'Cl. 26.5.2.1',
    title: 'Minimum Reinforcement in Slabs',
    description:
        'The mild steel reinforcement in either direction in slabs shall not be less than 0.15 percent of the total cross-sectional area. For high strength deformed bars, it shall be 0.12 percent.',
    formula: '0.12% for HYSD, 0.15% for Mild Steel',
  );

  // --- FOOTING REFERENCES ---
  static const footingMinReinforcement = CodeReference(
    code: _code,
    clause: 'Cl. 34.4',
    title: 'Minimum Reinforcement',
    description: 'The total reinforcement shall be similar to that for slabs.',
    formula: 'A_st,min = 0.12% of total sectional area',
  );

  static const soilPressure = CodeReference(
    code: _code,
    clause: 'Cl. 34.1',
    title: 'Soil Pressure',
    description:
        'The pressure on the soil shall be calculated using gross area of footing base.',
    formula: 'P_max = P/A + M/Z',
  );

  // Helper to map categories
  static List<CodeReference> getForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'column':
        return [
          slendernessRatio,
          minReinforcementColumn,
          maxReinforcementColumn,
        ];
      case 'beam':
        return [tensionReinforcement, deflectionCheck];
      case 'slab':
        return [slabMinReinforcement];
      case 'footing':
        return [footingMinReinforcement, soilPressure];
      default:
        return [];
    }
  }
}
