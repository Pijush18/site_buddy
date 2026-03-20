import 'package:site_buddy/core/theme/app_text_styles.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/widgets/app_screen_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/features/design/application/services/calculation_service.dart';
import 'package:site_buddy/features/design/application/controllers/safety_check_controller.dart';
import 'package:site_buddy/features/design/presentation/widgets/insight_card.dart';
import 'package:site_buddy/features/design/presentation/widgets/shared_safety_widgets.dart';
import 'package:site_buddy/features/design/presentation/widgets/deflection_input_section.dart';
import 'package:site_buddy/features/design/presentation/widgets/shared_action_buttons.dart';
import 'package:site_buddy/features/design/presentation/widgets/deflection_result_summary.dart';
import 'package:site_buddy/features/design/presentation/widgets/deflection_history_section.dart';

class DeflectionCheckScreen extends ConsumerStatefulWidget {
  const DeflectionCheckScreen({super.key});

  @override
  ConsumerState<DeflectionCheckScreen> createState() =>
      _DeflectionCheckScreenState();
}

class _DeflectionCheckScreenState extends ConsumerState<DeflectionCheckScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dController = TextEditingController();
  final TextEditingController _spanController = TextEditingController();
  final TextEditingController _ptController = TextEditingController();
  final TextEditingController _pcController = TextEditingController();

  String _selectedSpanType = 'Simply Supported';
  bool _isLoading = false;

  DeflectionResult? _result;

  @override
  void dispose() {
    _dController.dispose();
    _spanController.dispose();
    _ptController.dispose();
    _pcController.dispose();
    super.dispose();
  }

  Future<void> _calculate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    HapticFeedback.lightImpact();

    await Future.delayed(const Duration(milliseconds: 500));

    final double d = double.parse(_dController.text);
    final double span = double.parse(_spanController.text);

    final result = CalculationService.calculateDeflection(
      span: span,
      d: d,
      isContinuous: _selectedSpanType == 'Continuous',
    );

    ref.read(safetyCheckControllerProvider.notifier).saveCheck({
      'type': 'Deflection',
      'date': DateTime.now().toIso8601String(),
      'isSafe': result.isSafe,
      'actual': result.actualRatio,
      'allowable': result.allowableRatio,
    });

    setState(() {
      _result = result;
      _isLoading = false;
    });
  }

  void _reset() {
    setState(() {
      _dController.clear();
      _spanController.clear();
      _ptController.clear();
      _pcController.clear();
      _selectedSpanType = 'Simply Supported';
      _result = null;
    });
  }

  void _shareResult() {
    if (_result == null) return;
    ref
        .read(safetyCheckControllerProvider.notifier)
        .shareResult(
          title: 'Deflection Check Report',
          inputs: {
            'Depth (d)': '${_dController.text} mm',
            'Span (L)': '${_spanController.text} mm',
            'Type': _selectedSpanType,
          },
          results: {
            'Actual L/d': _result!.actualRatio.toStringAsFixed(2),
            'Allowable L/d': _result!.allowableRatio.toStringAsFixed(2),
          },
          isSafe: _result!.isSafe,
        );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppScreenWrapper(
      title: 'Deflection Check',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Span-to-Depth Ratio Analysis',
              style: AppTextStyles.body(context).copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
            DeflectionInputSection(
              dController: _dController,
              spanController: _spanController,
              ptController: _ptController,
              pcController: _pcController,
              selectedSpanType: _selectedSpanType,
              onSpanTypeChanged: (v) {
                if (v != null) setState(() => _selectedSpanType = v);
              },
            ),
            const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
            SharedActionButtons(
              calculateLabel: 'Check Deflection',
              isLoading: _isLoading,
              onCalculate: () => _calculate(),
              onReset: _reset,
              onShare: _shareResult,
            ),
            const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
            if (_result != null) ...[
              DeflectionResultSummary(result: _result!),
              const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
              InsightCard(insights: _result!.insights),
            ] else
              const PlaceholderCard(
                icon: Icons.query_stats,
                message: 'Calculate ratio to check safety',
              ),
            const SizedBox(height: AppSpacing.lg * 1.5), // Replaced AppLayout.vGap32
            const DeflectionHistorySection(),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}