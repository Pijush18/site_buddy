import 'package:site_buddy/core/design_system/sb_icons.dart';

import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/features/design/application/services/calculation_service.dart';
import 'package:site_buddy/features/design/application/controllers/safety_check_controller.dart';
import 'package:site_buddy/features/design/presentation/widgets/insight_card.dart';
import 'package:site_buddy/features/design/presentation/widgets/shared_safety_widgets.dart';
import 'package:site_buddy/features/design/presentation/widgets/shear_input_section.dart';
import 'package:site_buddy/features/design/presentation/widgets/shear_result_summary.dart';
import 'package:site_buddy/features/design/presentation/widgets/shear_history_section.dart';

class ShearCheckScreen extends ConsumerStatefulWidget {
  const ShearCheckScreen({super.key});

  @override
  ConsumerState<ShearCheckScreen> createState() => _ShearCheckScreenState();
}

class _ShearCheckScreenState extends ConsumerState<ShearCheckScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _dController = TextEditingController();
  final TextEditingController _bController = TextEditingController();
  final TextEditingController _vuController = TextEditingController();
  final TextEditingController _ptController = TextEditingController();

  String _selectedConcrete = 'M25';
  String _selectedSteel = 'Fe500';
  bool _isLoading = false;

  ShearResult? _result;

  @override
  void dispose() {
    _dController.dispose();
    _bController.dispose();
    _vuController.dispose();
    _ptController.dispose();
    super.dispose();
  }

  Future<void> _calculate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    HapticFeedback.mediumImpact();

    await Future.delayed(const Duration(milliseconds: 500));

    final double d = double.parse(_dController.text);
    final double b = double.parse(_bController.text);
    final double vu = double.parse(_vuController.text);
    final double pt = double.parse(_ptController.text);

    final result = CalculationService.calculateShear(
      vu: vu,
      b: b,
      d: d,
      pt: pt,
      concreteGrade: _selectedConcrete,
    );

    ref.read(safetyCheckControllerProvider.notifier).saveCheck({
      'type': 'Shear',
      'date': DateTime.now().toIso8601String(),
      'isSafe': result.isSafe,
      'tv': result.tv,
      'tc': result.tc,
    });

    setState(() {
      _result = result;
      _isLoading = false;
    });
  }

  void _reset() {
    setState(() {
      _dController.clear();
      _bController.clear();
      _vuController.clear();
      _ptController.clear();
      _selectedConcrete = 'M25';
      _result = null;
    });
  }

  void _shareResult() {
    if (_result == null) return;
    ref
        .read(safetyCheckControllerProvider.notifier)
        .shareResult(
          title: 'Shear Check Report',
          inputs: {
            'Depth (d)': '${_dController.text} mm',
            'Width (b)': '${_bController.text} mm',
            'Vu': '${_vuController.text} kN',
            'Steel (pt)': '${_ptController.text} %',
            'Concrete': _selectedConcrete,
          },
          results: {
            'τv': '${_result!.tv.toStringAsFixed(3)} N/mm²',
            'τc': '${_result!.tc.toStringAsFixed(3)} N/mm²',
          },
          isSafe: _result!.isSafe,
        );
  }

  @override
  Widget build(BuildContext context) {
    return SbPage.form(
      title: 'Shear Check',
      primaryAction: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryCTA(
            label: 'Calculate',
            onPressed: _calculate,
            isLoading: _isLoading,
          ),
          if (_result != null) ...[
            const SizedBox(height: SbSpacing.sm),
            GhostButton(
              label: 'Report',
              onPressed: _shareResult,
            ),
            const SizedBox(height: SbSpacing.sm),
            GhostButton(
              label: 'Reset',
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
                'Assessment',
                style: Theme.of(context).textTheme.titleLarge!,
              ),
            ),

            // ── INPUTS ──
            SbSection(
              title: 'Input Parameters',
              child: ShearInputSection(
                dController: _dController,
                bController: _bController,
                vuController: _vuController,
                ptController: _ptController,
                selectedConcrete: _selectedConcrete,
                selectedSteel: _selectedSteel,
                onConcreteChanged: (v) {
                  if (v != null) setState(() => _selectedConcrete = v);
                },
                onSteelChanged: (v) {
                  if (v != null) setState(() => _selectedSteel = v);
                },
              ),
            ),

            // ── RESULTS ──
            if (_result != null) ...[
              SbSection(
                title: 'Design Status',
                trailing: StatusBadge(isSafe: _result!.isSafe),
                child: ShearResultSummary(result: _result!),
              ),
              SbSection(
                title: 'Engineering Insight',
                child: InsightCard(insights: _result!.insights),
              ),
            ] else
              const SbSection(
                title: 'Design Status',
                child: PlaceholderCard(
                  icon: SbIcons.analytics,
                  message: 'Enter parameters to generate report',
                ),
              ),

            // ── HISTORY ──
            const SbSection(
              title: 'Recent Checks',
              child: ShearHistorySection(),
            ),
          ],
        ),
      ),
    );
  }
}










