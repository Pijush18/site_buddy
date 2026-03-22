
import 'dart:math' as math;
import 'package:site_buddy/features/water/irrigation/domain/models/flow_input.dart';
import 'package:site_buddy/features/water/irrigation/domain/models/flow_result.dart';

/// SERVICE: FlowSimulationService
/// PURPOSE: Simulates water flow variation and energy loss along a channel.
class FlowSimulationService {
  
  FlowResult simulate(FlowInput input) {
    if (!input.isProUser) {
      return _generateBasicResult(input);
    }

    final double dx = input.totalLength / input.segments;
    final List<double> distances = [];
    final List<double> velocities = [];
    final List<double> discharges = [];
    final List<double> depths = [];

    double currentV = input.initialVelocity;
    double currentY = input.initialDepth;
    double totalLoss = 0.0;
    
    // Constant Discharge Check (Q = A * V)
    final double Q = (input.bedWidth * input.initialDepth) * input.initialVelocity;

    for (int i = 0; i <= input.segments; i++) {
      final double distance = i * dx;
      distances.add(distance);
      velocities.add(currentV);
      discharges.add(Q);
      depths.add(currentY);

      if (i < input.segments) {
        // Friction Loss estimation (Manning's based hf = [n * V * dx / R^(2/3)]^2 * ... no, simple form)
        // hf = (n² * V² / R^(4/3)) * dx
        final double A = input.bedWidth * currentY;
        final double P = input.bedWidth + (2 * currentY);
        final double R = A / P;
        
        final double hf = (math.pow(input.roughness, 2) * math.pow(currentV, 2) / math.pow(R, 4/3)) * dx;
        totalLoss += hf;

        // Simplified Non-uniform flow adjustment (gradually varied flow)
        // Adjust velocity based on energy balance (Bernoulli)
        // In this simulation, we assume steady state but track the energy gradient
        // For demonstration, we simulate the 'Drawdown' or 'Backwater' trend roughly.
        // V_new = V_old * factor (friction vs slope)
        final double slopeEffect = input.slope * dx;
        final double energyChange = slopeEffect - hf;
        
        // If energy increases, velocity slightly increases; if friction dominates, it decreases.
        if (energyChange > 0) {
          currentV += 0.01 * math.sqrt(energyChange);
        } else {
          currentV -= 0.01 * math.sqrt(energyChange.abs());
        }
        
        // Depth must adjust to keep Q constant
        currentY = Q / (input.bedWidth * currentV);
      }
    }

    return FlowResult(
      distancePoints: distances,
      velocityProfile: velocities,
      dischargeProfile: discharges,
      depthProfile: depths,
      totalHeadLoss: totalLoss,
      simulationSummary: "Simulation complete over ${input.totalLength}m. " 
                         "Net Head Loss: ${totalLoss.toStringAsFixed(3)}m. "
                         "Flow Type: ${totalLoss > (input.slope * input.totalLength) ? 'Subcritical/Friction Dominant' : 'Supercritical/Slope Dominant'}.",
    );
  }

  FlowResult _generateBasicResult(FlowInput input) {
    // Basic service for free users (no profile)
    return FlowResult(
      distancePoints: [0.0, input.totalLength],
      velocityProfile: [input.initialVelocity, input.initialVelocity],
      dischargeProfile: [0.0, 0.0],
      depthProfile: [input.initialDepth, input.initialDepth],
      totalHeadLoss: 0.0,
      simulationSummary: "[PRO FEATURE] Longitudinal velocity profile and friction analysis locked.",
    );
  }
}
