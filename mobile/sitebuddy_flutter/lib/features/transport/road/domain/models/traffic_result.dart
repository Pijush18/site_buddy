
/// MODEL: TrafficResult
/// PURPOSE: Results of traffic load analysis (ESAL, MSA, Category).
class TrafficResult {
  final double cumulativeESAL;
  final double msa;
  final String trafficCategory; // LOW, MEDIUM, HEAVY
  
  const TrafficResult({
    required this.cumulativeESAL,
    required this.msa,
    required this.trafficCategory,
  });

  Map<String, dynamic> toMap() => {
    'cumulativeESAL': cumulativeESAL,
    'msa': msa,
    'trafficCategory': trafficCategory,
  };
}
