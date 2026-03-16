import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_font_sizes.dart';
import 'package:site_buddy/core/widgets/app_screen_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/widgets/app_number_field.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/features/currency/application/controllers/currency_controller.dart';

class CurrencyConverterScreen extends ConsumerWidget {
  const CurrencyConverterScreen({super.key});

  static const _currencies = ['USD', 'EUR', 'INR'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(currencyControllerProvider);
    final controller = ref.read(currencyControllerProvider.notifier);

    Widget buildResultCard() {
      return SbCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Converted Amount',
              style: TextStyle(
                fontSize: AppFontSizes.tab,
                color: colorScheme.secondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap8
            Text(
              state.convertedAmount != null
                  ? state.convertedAmount!.toStringAsFixed(2)
                  : '-',
              style: TextStyle(
                fontSize: 32, // headlineLarge equivalent
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
            Divider(color: colorScheme.outlineVariant),
            const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
            Text(
              'Rate: ${state.rate?.toStringAsFixed(6) ?? '-'}',
              style: TextStyle(
                fontSize: AppFontSizes.subtitle,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap8
            Text(
              'Last Updated: ${state.lastUpdated != null ? state.lastUpdated!.toLocal().toString().split('.')[0] : '-'}',
              style: TextStyle(
                fontSize: AppFontSizes.tab,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return AppScreenWrapper(
      title: 'Currency Converter',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
          const Text(
            'Market Exchange Rates',
            style: TextStyle(
              fontSize: AppFontSizes.title,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
          AppNumberField(
            label: 'Amount to Convert',
            suffixIcon: SbIcons.payments,
            onChanged: controller.updateAmount,
          ),
          const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'From',
                      style: TextStyle(
                        fontSize: AppFontSizes.tab,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm / 2), // Replaced AppLayout.vGap4
                    SbDropdown<String>(
                      value: state.fromCurrency,
                      items: _currencies,
                      itemLabelBuilder: (s) => s,
                      onChanged: (v) {
                        if (v != null) controller.updateFromCurrency(v);
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                ),
                child: SbButton.icon(
                  icon: SbIcons.swap,
                  onPressed: controller.swapCurrencies,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'To',
                      style: TextStyle(
                        fontSize: AppFontSizes.tab,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm / 2), // Replaced AppLayout.vGap4
                    SbDropdown<String>(
                      value: state.toCurrency,
                      items: _currencies,
                      itemLabelBuilder: (s) => s,
                      onChanged: (v) {
                        if (v != null) controller.updateToCurrency(v);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
          if (state.error != null) ...[
            Text(
              state.error!,
              style: TextStyle(
                fontSize: AppFontSizes.subtitle,
                color: theme.colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
          ],
          if (state.convertedAmount != null) ...[
            buildResultCard(),
            const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
          ],
          SbButton(
            label: state.isLoading ? 'Processing...' : 'Calculate Conversion',
            icon: state.isLoading
                ? SbIcons.hourglass
                : SbIcons.currencyExchange,
            onPressed: controller.convert,
            isLoading: state.isLoading,
          ),
        ],
      ),
    );
  }
}
