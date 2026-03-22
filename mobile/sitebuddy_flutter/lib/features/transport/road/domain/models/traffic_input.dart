
/// MODEL: TrafficInput
/// PURPOSE: Captures traffic data for IRC flexible pavement design.
class TrafficInput {
  final double initialTraffic; // A (CVPD)
  final double growthRate;    // r (%)
  final int designLife;       // n (years)
  final double vdf;           // Vehicle Damage Factor
  final double ldf;           // Lane Distribution Factor (D)
  
  const TrafficInput({
    required this.initialTraffic,
    required this.growthRate,
    required this.designLife,
    required this.vdf,
    required this.ldf,
  });

  Map<String, dynamic> toMap() => {
    'initialTraffic': initialTraffic,
    'growthRate': growthRate,
    'designLife': designLife,
    'vdf': vdf,
    'ldf': ldf,
  };
}
