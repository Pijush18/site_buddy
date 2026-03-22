
import 'package:site_buddy/core/engineering/standards/transport/road_standard.dart';
import 'package:site_buddy/features/transport/road/domain/models/traffic_input.dart';
import 'package:site_buddy/features/transport/road/domain/models/traffic_result.dart';

/// SERVICE: TrafficAnalysisService
/// PURPOSE: Performs IRC calculations for traffic load (ESAL -> MSA).
class TrafficAnalysisService {
  final RoadStandard standard;

  TrafficAnalysisService(this.standard);

  TrafficResult analyzeTraffic(TrafficInput input) {
    // Formula: MSA = 365 * CVPD * [(1+r)^n - 1]/r * VDF * LDF
    // Handled inside calculateESAL
    final double cumulTraffic = standard.calculateESAL(
      initialTraffic: input.initialTraffic,
      growthRate: input.growthRate,
      designLife: input.designLife,
      vdf: input.vdf,
      ldf: input.ldf,
    );

    final double msa = standard.msaFromTraffic(cumulTraffic);
    final String category = standard.classifyTraffic(msa);

    return TrafficResult(
      cumulativeESAL: cumulTraffic,
      msa: msa,
      trafficCategory: category,
    );
  }
}
