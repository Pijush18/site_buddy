import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/features/ai/domain/usecases/get_knowledge_usecase.dart';
import 'package:site_buddy/features/ai/domain/usecases/parse_ai_input_usecase.dart';
import 'package:site_buddy/features/ai/domain/usecases/process_ai_request_usecase.dart';
import 'package:site_buddy/features/ai/domain/repositories/knowledge_repository.dart';
import 'package:site_buddy/features/ai/data/repositories/knowledge_repository_impl.dart';
import 'package:site_buddy/features/unit_converter/application/providers/unit_usecase_providers.dart';
import 'package:site_buddy/features/estimation/application/providers/estimation_usecase_providers.dart';

import 'package:site_buddy/core/services/knowledge_service.dart';

final knowledgeRepositoryProvider = Provider<KnowledgeRepository>((ref) {
  final service = ref.watch(knowledgeServiceProvider);
  return KnowledgeRepositoryImpl(service);
});


final getKnowledgeUseCaseProvider = Provider<GetKnowledgeUseCase>((ref) {
  final repo = ref.watch(knowledgeRepositoryProvider);
  return GetKnowledgeUseCase(repo);
});

final parseAiInputUseCaseProvider = Provider<ParseAiInputUseCase>((ref) {
  final legacyParser = ref.watch(parseAiQueryUseCaseProvider);
  final knowledgeService = ref.watch(knowledgeServiceProvider);
  return ParseAiInputUseCase(legacyParser, knowledgeService);
});


final processAiRequestUseCaseProvider = Provider<ProcessAiRequestUseCase>((
  ref,
) {
  final getKnowledge = ref.watch(getKnowledgeUseCaseProvider);
  final calculateMaterial = ref.watch(calculateMaterialUseCaseProvider);
  final convertUnit = ref.watch(convertUnitUseCaseProvider);

  return ProcessAiRequestUseCase(
    getKnowledgeUseCase: getKnowledge,
    calculateMaterialUseCase: calculateMaterial,
    convertUnitUseCase: convertUnit,
  );
});




