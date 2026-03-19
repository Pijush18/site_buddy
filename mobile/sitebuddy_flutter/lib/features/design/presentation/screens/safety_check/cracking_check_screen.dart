import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_font_sizes.dart';
import 'package:site_buddy/core/widgets/app_screen_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/features/design/application/services/calculation_service.dart';
import 'package:site_buddy/features/design/application/controllers/safety_check_controller.dart';
import 'package:site_buddy/features/design/presentation/widgets/insight_card.dart';
import 'package:site_buddy/features/design/presentation/widgets/shared_safety_widgets.dart';
import 'package:site_buddy/features/design/presentation/widgets/cracking_input_section.dart';
import 'package:site_buddy/features/design/presentation/widgets/shared_action_buttons.dart';
import 'package:site_buddy/features/design/presentation/widgets/cracking_result_summary.dart';
import 'package:site_buddy/features/design/presentation/widgets/cracking_history_section.dart';

class CrackingCheckScreen extends ConsumerStatefulWidget {
  const CrackingCheckScreen({super.key});

  @override
  ConsumerState<CrackingCheckScreen> createState() =>
      _CrackingCheckScreenState();
}

class _CrackingCheckScreenState extends ConsumerState<CrackingCheckScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _concreteGrades = ['M20', 'M25', 'M30', 'M35', 'M40'];
  final List<String> _steelGrades = ['Fe415', 'Fe500'];

  final TextEditingController _spacingController = TextEditingController();
  final TextEditingController _fsController = TextEditingController();
  final TextEditingController _coverController = TextEditingController();

  String _selectedConcrete = 'M25';
  String _selectedSteel = 'Fe500';
  bool _isLoading = false;

  CrackingResult? _result;

  @override
  void dispose() {
    _spacingController.dispose();
    _fsController.dispose();
    _coverController.dispose();
    super.dispose();
  }

  Future<void> _calculate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    HapticFeedback.heavyImpact();

    await Future.delayed(const Duration(milliseconds: 500));

    final double spacing = double.tryParse(_spacingController.text) ?? 0;
    final double fs = double.tryParse(_fsController.text) ?? 0;
    final double cover = double.tryParse(_coverController.text) ?? 0;

    final result = CalculationService.calculateCracking(
      spacing: spacing,
      fs: fs,
      cover: cover,
    );

    ref.read(safetyCheckControllerProvider.notifier).saveCheck({
      'type': 'Cracking',
      'date': DateTime.now().toIso8601String(),
      'isSafe': result.isSafe,
      'crackWidth': result.crackWidth,
    });

    setState(() {
      _result = result;
      _isLoading = false;
    });
  }

  void _reset() {
    setState(() {
      _spacingController.clear();
      _fsController.clear();
      _coverController.clear();
      _selectedConcrete = 'M25';
      _selectedSteel = 'Fe500';
      _result = null;
    });
  }

  void _shareResult() {
    if (_result == null) return;
    ref
        .read(safetyCheckControllerProvider.notifier)
        .shareResult(
          title: 'Cracking Check Report',
          inputs: {
            'Spacing': '${_spacingController.text} mm',
            'Cover': '${_coverController.text} mm',
            'Stress (fs)': '${_fsController.text} MPa',
          },
          results: {
            'Crack Width': '${_result!.crackWidth.toStringAsFixed(3)} mm',
            'Limit': '0.3 mm',
          },
          isSafe: _result!.isSafe,
        );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppScreenWrapper(
      title: 'Cracking Check',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Durability & Crack Control Visualization',
              style: TextStyle(
                fontSize: AppFontSizes.subtitle,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
            CrackingInputSection(
              spacingController: _spacingController,
              coverController: _coverController,
              fsController: _fsController,
              selectedConcrete: _selectedConcrete,
              selectedSteel: _selectedSteel,
              concreteGrades: _concreteGrades,
              steelGrades: _steelGrades,
              onDropdownChanged: (label, value) {
                setState(() {
                  if (label == 'Concrete') {
                    _selectedConcrete = value;
                  } else {
                    _selectedSteel = value;
                  }
                });
              },
            ),
            const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
            SharedActionButtons(
              calculateLabel: 'Check Cracking',
              isLoading: _isLoading,
              onCalculate: _calculate,
              onReset: _reset,
              onShare: _shareResult,
            ),
            const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
            if (_result != null) ...[
              CrackingResultSummary(result: _result!),
              const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
              InsightCard(insights: _result!.insights),
            ] else
              const PlaceholderCard(
                icon: SbIcons.visibility,
                message: 'Calculate crack width for durability',
              ),
            const SizedBox(height: AppSpacing.lg * 1.5), // Replaced AppLayout.vGap32
            const CrackingHistorySection(),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}
