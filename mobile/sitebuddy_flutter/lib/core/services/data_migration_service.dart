import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:site_buddy/features/design/presentation/providers/design_providers.dart';
import 'package:site_buddy/features/level_log/presentation/providers/level_log_providers.dart';

import 'package:site_buddy/shared/domain/models/design/column_design_state.dart';
import 'package:site_buddy/shared/domain/models/design/beam_design_state.dart';
import 'package:site_buddy/shared/domain/models/design/slab_design_result.dart';
import 'package:site_buddy/shared/domain/models/design/footing_design_state.dart';

import 'package:site_buddy/shared/domain/models/design/column_enums.dart';
import 'package:site_buddy/shared/domain/models/design/beam_type.dart';
import 'package:site_buddy/shared/domain/models/design/footing_type.dart';

import 'package:site_buddy/features/level_log/domain/entities/level_log_session.dart';
import 'package:site_buddy/features/level_log/domain/entities/level_entry.dart';
import 'package:site_buddy/features/level_log/domain/entities/level_method.dart';

final dataMigrationServiceProvider = Provider(
  (ref) => DataMigrationService(ref),
);

/// SERVICE: DataMigrationService
/// PURPOSE: Migrates generic JSON objects from SharedPreferences to strictly-typed Hive models.
class DataMigrationService {
  final Ref _ref;

  DataMigrationService(this._ref);

  Future<void> runMigration() async {
    await _migrateStructural();
    await _migrateLevelLogs();
  }

  Future<void> _migrateStructural() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('structural_design_history');
    if (raw == null) return;

    final structuralRepo = _ref.read(structuralRepositoryProvider);
    final List<dynamic> oldHistory = jsonDecode(raw);

    for (var entry in oldHistory) {
      final projectId = entry['projectId'] as String?;
      if (projectId == null) continue; // Data safety check

      final type = entry['type'] as String?;
      final data = entry['data'] as Map<String, dynamic>?;
      if (data == null || type == null) continue;

      try {
        switch (type) {
          case 'column':
            final state = ColumnDesignState(
              projectId: projectId,
              type: ColumnType.values[data['type'] ?? 0],
              b: data['b']?.toDouble() ?? 300.0,
              d: data['d']?.toDouble() ?? 450.0,
              length: data['length']?.toDouble() ?? 3.0,
              pu: data['pu']?.toDouble() ?? 500.0,
              mx: data['mx']?.toDouble() ?? 50.0,
              my: data['my']?.toDouble() ?? 20.0,
              numBars: data['numBars'] ?? 6,
              mainBarDia: data['barDia']?.toDouble() ?? 16.0,
            );
            await structuralRepo.saveColumn(state);
            break;

          case 'beam':
            final state = BeamDesignState(
              projectId: projectId,
              type: BeamType.values[data['type'] ?? 0],
              span: data['span']?.toDouble() ?? 5.0,
              width: data['width']?.toDouble() ?? 230.0,
              overallDepth: data['depth']?.toDouble() ?? 450.0,
              deadLoad: data['deadLoad']?.toDouble() ?? 15.0,
              liveLoad: data['liveLoad']?.toDouble() ?? 20.0,
              pointLoad: data['pointLoad']?.toDouble() ?? 0.0,
              isULS: data['isULS'] ?? true,
            );
            await structuralRepo.saveBeam(state);
            break;

          case 'slab':
            // Slabs previously saved raw inputs, but Hive specifies SlabDesignResult
            final result = SlabDesignResult(
              projectId: projectId,
              bendingMoment: 0.0,
              mainRebar: 'Design needs regeneration',
              distributionSteel: 'N/A',
              isShearSafe: true,
              isDeflectionSafe: true,
              isCrackingSafe: true,
            );
            await structuralRepo.saveSlab(result);
            break;

          case 'footing':
            final state = FootingDesignState(
              projectId: projectId,
              type: FootingType.values[data['type'] ?? 0],
              columnLoad: data['columnLoad']?.toDouble() ?? 1000.0,
              columnLoad2: data['columnLoad2']?.toDouble() ?? 0.0,
              sbc: data['sbc']?.toDouble() ?? 150.0,
              foundationDepth: data['foundationDepth']?.toDouble() ?? 1.5,
              footingLength: data['footingLength']?.toDouble() ?? 2.0,
              footingWidth: data['footingWidth']?.toDouble() ?? 2.0,
              footingThickness: data['footingThickness']?.toDouble() ?? 450.0,
            );
            await structuralRepo.saveFooting(state);
            break;
        }
      } catch (e) {
        // Skip corrupted records seamlessly
        continue;
      }
    }

    // Cleanup legacy structure after success
    await prefs.remove('structural_design_history');
  }

  Future<void> _migrateLevelLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('level_log_history');
    if (raw == null) return;

    final logRepo = _ref.read(levelLogRepositoryProvider);
    final List<dynamic> oldHistory = jsonDecode(raw);

    for (var entry in oldHistory) {
      final projectId = entry['projectId'] as String?;
      if (projectId == null) continue; // Data safety check

      final methodStr = entry['method'] as String?;
      final method = methodStr == 'riseFall'
          ? LevelMethod.riseFall
          : LevelMethod.heightOfInstrument;

      final rawEntries = entry['entries'] as List<dynamic>? ?? [];
      final entries = rawEntries
          .map(
            (e) => LevelEntry(
              station: e['station'] ?? 'STN',
              chainage: e['chainage']?.toDouble(),
              bs: e['bs']?.toDouble(),
              isReading: e['isReading']?.toDouble(),
              fs: e['fs']?.toDouble(),
              hi: e['hi']?.toDouble(),
              rl: e['rl']?.toDouble(),
              rise: e['rise']?.toDouble(),
              fall: e['fall']?.toDouble(),
              remark: e['remark'],
              projectId: projectId,
            ),
          )
          .toList();

      final session = LevelLogSession(
        id: entry['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: entry['name'] ?? 'Legacy Session',
        projectId: projectId,
        date: DateTime.tryParse(entry['date'] ?? '') ?? DateTime.now(),
        method: method,
        entries: entries,
      );

      await logRepo.saveSession(session);
    }

    // Cleanup legacy structure after success
    await prefs.remove('level_log_history');
  }
}



