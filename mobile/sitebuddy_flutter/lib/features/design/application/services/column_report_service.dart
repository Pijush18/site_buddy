import 'package:site_buddy/shared/domain/models/design/column_design_state.dart';
import 'package:site_buddy/shared/domain/models/design/column_enums.dart';

class ColumnReportService {
  static String generateReport(ColumnDesignState state) {
    final buffer = StringBuffer();

    buffer.writeln('# Column Design Report (IS 456:2000)');
    buffer.writeln('Generated on: ${DateTime.now().toString().split('.')[0]}');
    buffer.writeln('\n---');

    buffer.writeln('\n## 1. Input Parameters');
    buffer.writeln(
      '- Column Type: ${state.type == ColumnType.circular ? "Circular" : "Rectangular"}',
    );
    buffer.writeln('- Dimensions: ${state.b} x ${state.d} mm');
    buffer.writeln('- Unsupported Length: ${state.length} m');
    buffer.writeln('- Concrete Grade: ${state.concreteGrade}');
    buffer.writeln('- Steel Grade: ${state.steelGrade}');

    buffer.writeln('\n## 2. Applied Loads (Factored)');
    buffer.writeln('- Axial Load (Pu): ${state.pu} kN');
    buffer.writeln('- Moment (Mux): ${state.mx} kNm');
    buffer.writeln('- Moment (Muy): ${state.my} kNm');

    buffer.writeln('\n## 3. Slenderness Check (Cl 39.7.1)');
    buffer.writeln(
      '- Effective Length (lex): ${(state.lex / 1000).toStringAsFixed(3)} m',
    );
    buffer.writeln(
      '- Effective Length (ley): ${(state.ley / 1000).toStringAsFixed(3)} m',
    );
    buffer.writeln(
      '- Slenderness Ratio (λx): ${state.slendernessX.toStringAsFixed(2)}',
    );
    buffer.writeln(
      '- Slenderness Ratio (λy): ${state.slendernessY.toStringAsFixed(2)}',
    );
    buffer.writeln(
      '- Classification: ${state.isShort ? "Short Column" : "Slender Column"}',
    );

    if (!state.isShort) {
      buffer.writeln('\n### Slender Column Effects');
      buffer.writeln(
        '- Magnified Mx: ${state.magnifiedMx.toStringAsFixed(2)} kNm',
      );
      buffer.writeln(
        '- Magnified My: ${state.magnifiedMy.toStringAsFixed(2)} kNm',
      );
    }

    buffer.writeln('\n## 4. Design Calculation');
    buffer.writeln(
      '- Required Gross Area (Ag): ${state.ag.toStringAsFixed(0)} mm²',
    );
    buffer.writeln(
      '- Provided Steel %: ${state.steelPercentage.toStringAsFixed(2)}%',
    );
    buffer.writeln(
      '- Required Steel Area (Asc): ${state.astRequired.toStringAsFixed(0)} mm²',
    );

    buffer.writeln('\n## 5. Interaction Check (Cl 39.6)');
    buffer.writeln(
      '- Interaction Ratio: ${state.interactionRatio.toStringAsFixed(3)}',
    );
    buffer.writeln('- Status: ${state.isCapacitySafe ? "PASS" : "FAIL"}');
    buffer.writeln('- Identified Failure Mode: ${state.failureMode.label}');

    buffer.writeln('\n## 6. Reinforcement Details');
    buffer.writeln(
      '- Main Bars: ${state.numBars} nos of ${state.mainBarDia}mm',
    );
    buffer.writeln('- Transverse Ties: 8mm @ ${state.tieSpacing} mm c/c');

    buffer.writeln('\n---');
    buffer.writeln(
      '\nDisclaimer: For engineering reference only. Final design must be vetted by a structural engineer.',
    );

    return buffer.toString();
  }
}



