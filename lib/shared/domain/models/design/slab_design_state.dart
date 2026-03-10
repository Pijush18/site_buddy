import 'package:hive/hive.dart';
import 'package:site_buddy/shared/domain/models/design/slab_design_result.dart';
import 'package:site_buddy/shared/domain/models/design/slab_type.dart';

part 'slab_design_state.g.dart';

@HiveType(typeId: 12)
class SlabDesignState {
  @HiveField(0)
  final SlabType type;
  @HiveField(1)
  final double lx;
  @HiveField(2)
  final double ly;
  @HiveField(3)
  final double d;
  @HiveField(4)
  final double deadLoad;
  @HiveField(5)
  final double liveLoad;
  @HiveField(6)
  final SlabDesignResult? result;
  @HiveField(7)
  final String? error;
  @HiveField(8)
  final String? projectId;

  const SlabDesignState({
    this.type = SlabType.oneWay,
    this.lx = 4.0,
    this.ly = 6.0,
    this.d = 150,
    this.deadLoad = 1.0,
    this.liveLoad = 2.0,
    this.result,
    this.error,
    this.projectId,
  });

  SlabDesignState copyWith({
    SlabType? type,
    double? lx,
    double? ly,
    double? d,
    double? deadLoad,
    double? liveLoad,
    SlabDesignResult? result,
    String? error,
    bool clearResult = false,
    bool clearError = false,
    String? projectId,
  }) {
    return SlabDesignState(
      type: type ?? this.type,
      lx: lx ?? this.lx,
      ly: ly ?? this.ly,
      d: d ?? this.d,
      deadLoad: deadLoad ?? this.deadLoad,
      liveLoad: liveLoad ?? this.liveLoad,
      result: clearResult ? null : (result ?? this.result),
      error: clearError ? null : (error ?? this.error),
      projectId: projectId ?? this.projectId,
    );
  }
}
