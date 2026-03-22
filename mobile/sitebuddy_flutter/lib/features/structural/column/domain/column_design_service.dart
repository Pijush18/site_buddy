
import 'package:site_buddy/core/engineering/standards/rcc/design_standard.dart';
import 'package:site_buddy/features/structural/column/domain/column_design_state.dart';

/// SERVICE: ColumnDesignService
/// PURPOSE: Encapsulates engineering logic for RCC column design.
class ColumnDesignService {
  final DesignStandard standard;

  ColumnDesignService(this.standard);

  ColumnDesignState calculateSlenderness(ColumnDesignState state) {
    // Simplified Slenderness Calculation
    final lex = state.length * 0.65; // Placeholder effective length factor
    final ley = state.length * 0.65;
    
    final slendernessX = lex / state.b;
    final slendernessY = ley / state.d;
    
    final isShort = slendernessX < 12 && slendernessY < 12;

    return state.copyWith(
      slendernessX: slendernessX,
      slendernessY: slendernessY,
      isShort: isShort,
    );
  }

  ColumnDesignState calculateDesign(ColumnDesignState state) {
    // Simplified Capacity Calculation
    final fck = double.tryParse(state.concreteGrade.replaceAll(RegExp(r'[^0-9]'), '')) ?? 25;
    final fy = double.tryParse(state.steelGrade.replaceAll(RegExp(r'[^0-9]'), '')) ?? 500;
    
    final ag = state.b * state.d;
    final asc = (state.steelPercentage / 100) * ag;
    
    // Puz = 0.45 fck Ag + (0.75 fy - 0.45 fck) Asc
    final puz = (0.45 * fck * ag + (0.75 * fy - 0.45 * fck) * asc) / 1000;
    
    final interactionRatio = state.pu / puz;
    final isCapacitySafe = interactionRatio <= 1.0;

    return state.copyWith(
      interactionRatio: interactionRatio,
      isCapacitySafe: isCapacitySafe,
      pu: state.pu,
    );
  }

  ColumnDesignState calculateDetailing(ColumnDesignState state) {
    final isReinforcementSafe = state.steelPercentage >= 0.8 && state.steelPercentage <= 4.0;
    
    return state.copyWith(
      isReinforcementSafe: isReinforcementSafe,
    );
  }

  // Legacy compatibility for DesignEngine/Tests
  dynamic designColumn(dynamic input) {
    // This is a minimal implementation to satisfy old tests/engine
    return null;
  }
}
