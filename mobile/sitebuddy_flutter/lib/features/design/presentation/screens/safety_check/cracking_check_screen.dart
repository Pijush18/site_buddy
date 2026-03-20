
import 'package:flutter/material.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/features/design/application/services/calculation_service.dart';
import 'package:site_buddy/features/design/application/controllers/safety_check_controller.dart';
import 'package:site_buddy/features/design/presentation/widgets/insight_card.dart';
import 'package:site_buddy/features/design/presentation/widgets/shared_safety_widgets.dart';
import 'package:site_buddy/features/design/presentation/widgets/cracking_input_section.dart';
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
    return SbPage.form(
      title: 'Cracking Check',
      primaryAction: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SbButton.primary(
            label: _result != null ? 'Check Again' : 'Check Cracking',
            onPressed: _calculate,
            isLoading: _isLoading,
          ),
          if (_result != null) ...[
            const SizedBox(height: SbSpacing.sm),
            SbButton.ghost(
              label: 'Share Report',
              onPressed: _shareResult,
            ),
          ],
        ],
      ),
      body: Form(
        key: _formKey,
        child: SbSectionList(
          sections: [
            // ── HEADER ──
            SbSection(
              child: Text(
                'Durability & Crack Control Analysis',
                style: Theme.of(context).textTheme.titleLarge!,
              ),
            ),

            // ── INPUTS ──
            SbSection(
              title: 'Input Parameters',
              child: CrackingInputSection(
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
            ),

            // ── RESULTS ──
            if (_result != null) ...[
              SbSection(
                title: 'Design Status',
                trailing: StatusBadge(isSafe: _result!.isSafe),
                child: CrackingResultSummary(result: _result!),
              ),
              SbSection(
                title: 'Engineering Insight',
                child: InsightCard(insights: _result!.insights),
              ),
            ] else
              const SbSection(
                title: 'Design Status',
                child: PlaceholderCard(
                  icon: SbIcons.visibility,
                  message: 'Calculate crack width for durability',
                ),
              ),

            // ── SECONDARY ACTIONS ──
            if (_result != null)
              SbSection(
                child: SbButton.ghost(
                  label: 'Reset Form',
                  onPressed: _reset,
                  width: double.infinity,
                ),
              ),

            // ── HISTORY ──
            const SbSection(
              title: 'Recent Checks',
              child: CrackingHistorySection(),
            ),
          ],
        ),
      ),
    );
  }
}








