import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';

import 'package:site_buddy/core/theme/app_layout.dart';

/// ----------------------------------------------

import 'package:flutter/material.dart';

///
/// PURPOSE:
/// Quick entry tool for adding levelling inputs rapidly on-site.
/// ----------------------------------------------

import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/localization/generated/app_localizations.dart';

class QuickEntryPanel extends StatefulWidget {
  final void Function({
    required String station,
    double? bs,
    double? isReading,
    double? fs,
  })
  onAdd;

  const QuickEntryPanel({super.key, required this.onAdd});

  @override
  State<QuickEntryPanel> createState() => _QuickEntryPanelState();
}

class _QuickEntryPanelState extends State<QuickEntryPanel> {
  final _stationCtrl = TextEditingController();
  final _bsCtrl = TextEditingController();
  final _isCtrl = TextEditingController();
  final _fsCtrl = TextEditingController();

  @override
  void dispose() {
    _stationCtrl.dispose();
    _bsCtrl.dispose();
    _isCtrl.dispose();
    _fsCtrl.dispose();
    super.dispose();
  }

  void _submit(AppLocalizations l10n) {
    if (_stationCtrl.text.isEmpty &&
        _bsCtrl.text.isEmpty &&
        _isCtrl.text.isEmpty &&
        _fsCtrl.text.isEmpty) {
      return;
    }

    int fieldsFilled = 0;
    if (_bsCtrl.text.isNotEmpty) fieldsFilled++;
    if (_isCtrl.text.isNotEmpty) fieldsFilled++;
    if (_fsCtrl.text.isNotEmpty) fieldsFilled++;

    if (fieldsFilled > 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.oneReadingAllowedError),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    widget.onAdd(
      station: _stationCtrl.text.isNotEmpty ? _stationCtrl.text : 'STN',
      bs: double.tryParse(_bsCtrl.text),
      isReading: double.tryParse(_isCtrl.text),
      fs: double.tryParse(_fsCtrl.text),
    );

    _bsCtrl.clear();
    _isCtrl.clear();
    _fsCtrl.clear();

    _autoIncrementStation();

    FocusScope.of(context).unfocus();
  }

  void _autoIncrementStation() {
    final current = _stationCtrl.text;
    if (current.isEmpty) return;

    final match = RegExp(r'^(.+?)(\d+)$').firstMatch(current);
    if (match != null) {
      final prefix = match.group(1)!;
      final numberStr = match.group(2)!;
      final nextNumber = int.parse(numberStr) + 1;
      _stationCtrl.text = '$prefix$nextNumber';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppLayout.cardPadding),
      decoration: AppLayout.sbCommonDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.quickReadingEntry.toUpperCase(),
            style: SbTextStyles.caption(context).copyWith(
              color: colorScheme.primary,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: AppLayout.cardPadding),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _QuickInput(
                  label: l10n.point,
                  controller: _stationCtrl,
                  hint: 'P1',
                ),
              ),
              const SizedBox(width: AppLayout.sm),
              Expanded(
                flex: 1,
                child: _QuickInput(
                  label: 'BS',
                  controller: _bsCtrl,
                  isNumber: true,
                ),
              ),
              const SizedBox(width: AppLayout.sm),
              Expanded(
                flex: 1,
                child: _QuickInput(
                  label: 'IS',
                  controller: _isCtrl,
                  isNumber: true,
                ),
              ),
              const SizedBox(width: AppLayout.sm),
              Expanded(
                flex: 1,
                child: _QuickInput(
                  label: 'FS',
                  controller: _fsCtrl,
                  isNumber: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppLayout.cardPadding),
          SbButton.primary(
            label: l10n.addReading,
            icon: SbIcons.add,
            onPressed: () => _submit(l10n),
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}

class _QuickInput extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool isNumber;

  const _QuickInput({
    required this.label,
    required this.controller,
    this.hint = '-',
    this.isNumber = false,
  });

  @override
  Widget build(BuildContext context) {
//     final theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      keyboardType: isNumber
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppLayout.sm,
          vertical: AppLayout.sm,
        ),
        isDense: true,
        labelStyle: SbTextStyles.bodySecondary(context),
      ),
      style: SbTextStyles.body(context),
      textAlign: isNumber ? TextAlign.center : TextAlign.left,
    );
  }
}