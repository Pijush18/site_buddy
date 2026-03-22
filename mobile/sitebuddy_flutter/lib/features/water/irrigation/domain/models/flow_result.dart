
/// MODEL: FlowResult
/// PURPOSE: Contains longitudinal simulation data (Velocity/Discharge profiles).
class FlowResult {
  final List<double> distancePoints;
  final List<double> velocityProfile;
  final List<double> dischargeProfile;
  final List<double> depthProfile;
  final double totalHeadLoss;
  final String simulationSummary;

  const FlowResult({
    required this.distancePoints,
    required this.velocityProfile,
    required this.dischargeProfile,
    required this.depthProfile,
    required this.totalHeadLoss,
    required this.simulationSummary,
  });
}
