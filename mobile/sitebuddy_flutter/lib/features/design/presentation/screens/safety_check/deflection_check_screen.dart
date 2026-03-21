
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/features/design/application/services/calculation_service.dart';
import 'package:site_buddy/features/design/application/controllers/safety_check_controller.dart';
import 'package:site_buddy/features/design/presentation/widgets/insight_card.dart';
import 'package:site_buddy/features/design/presentation/widgets/shared_safety_widgets.dart';
import 'package:site_buddy/features/design/presentation/widgets/deflection_input_section.dart';
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
    return SbPage.form(
      title: 'Deflection Check',
      primaryAction: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryCTA(
            label: _result != null ? 'Check Again' : 'Check Deflection',
            onPressed: _calculate,
            isLoading: _isLoading,
          ),
          if (_result != null) ...[
            const SizedBox(height: SbSpacing.sm),
            GhostButton(
              label: 'Share Report',
              onPressed: _shareResult,
            ),
            const SizedBox(height: SbSpacing.sm),
            GhostButton(
              label: 'Reset Form',
              onPressed: _reset,
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
                'Span-to-Depth Ratio Analysis',
                style: Theme.of(context).textTheme.titleLarge!,
              ),
            ),

            // ── INPUTS ──
            SbSection(
              title: 'Input Parameters',
              child: DeflectionInputSection(
                dController: _dController,
                spanController: _spanController,
                ptController: _ptController,
                pcController: _pcController,
                selectedSpanType: _selectedSpanType,
                onSpanTypeChanged: (v) {
                  if (v != null) setState(() => _selectedSpanType = v);
                },
              ),
            ),

            // ── RESULTS ──
            if (_result != null) ...[
              SbSection(
                title: 'Design Status',
                trailing: StatusBadge(isSafe: _result!.isSafe),
                child: DeflectionResultSummary(result: _result!),
              ),
              SbSection(
                title: 'Engineering Insight',
                child: InsightCard(insights: _result!.insights),
              ),
            ] else
              const SbSection(
                title: 'Design Status',
                child: PlaceholderCard(
                  icon: Icons.query_stats,
                  message: 'Calculate ratio to check safety',
                ),
              ),

            // ── HISTORY ──
            const SbSection(
              title: 'Recent Checks',
              child: DeflectionHistorySection(),
            ),
          ],
        ),
      ),
    );
  }
}










