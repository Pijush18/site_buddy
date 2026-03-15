import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/features/unit_converter/application/usecases/convert_unit_usecase.dart';
import 'package:site_buddy/features/unit_converter/application/usecases/parse_ai_query_usecase.dart';

final convertUnitUseCaseProvider = Provider<ConvertUnitUseCase>((ref) {
  return const ConvertUnitUseCase();
});

final parseAiQueryUseCaseProvider = Provider<ParseAiQueryUseCase>((ref) {
  return const ParseAiQueryUseCase();
});
