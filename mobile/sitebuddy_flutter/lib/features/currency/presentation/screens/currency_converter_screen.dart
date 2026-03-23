import 'package:site_buddy/core/design_system/sb_icons.dart';

import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
              style: Theme.of(context).textTheme.labelMedium!,
            ),
            const SizedBox(height: SbSpacing.sm),
            Text(
              state.convertedAmount != null
                  ? state.convertedAmount!.toStringAsFixed(2)
                  : '-',
              style: Theme.of(context).textTheme.titleLarge!,
            ),
            const SizedBox(height: SbSpacing.lg),
            Divider(color: colorScheme.outlineVariant),
            const SizedBox(height: SbSpacing.lg),
            Text(
              'Rate: ${state.rate?.toStringAsFixed(6) ?? '-'}',
              style: Theme.of(context).textTheme.bodyLarge!,
            ),
            const SizedBox(height: SbSpacing.sm),
            Text(
              'Last Updated: ${state.lastUpdated != null ? state.lastUpdated!.toLocal().toString().split('.')[0] : '-'}',
              style: Theme.of(context).textTheme.labelMedium!,
            ),
          ],
        ),
      );
    }

    return SbPage.scaffold(
      title: 'Currency Converter',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: SbSpacing.xxl),
          Text(
            'Market Exchange Rates',
            style: Theme.of(context).textTheme.titleMedium!,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: SbSpacing.xxl),
          SbInput(
            label: 'Amount to Convert',
            suffixIcon: const Icon(SbIcons.payments),
            onChanged: controller.updateAmount,
          ),
          const SizedBox(height: SbSpacing.lg),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'From',
                      style: Theme.of(context).textTheme.labelMedium!,
                    ),
                    const SizedBox(height: SbSpacing.sm / 2),
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
                  horizontal: SbSpacing.lg,
                ),
                child: AppIconButton(
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
                      style: Theme.of(context).textTheme.labelMedium!,
                    ),
                    const SizedBox(height: SbSpacing.sm / 2),
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
          const SizedBox(height: SbSpacing.xxl),
          if (state.error != null) ...[
            Text(
              state.error!,
              style: Theme.of(context).textTheme.bodyLarge!,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: SbSpacing.xxl),
          ],
          if (state.convertedAmount != null) ...[
            buildResultCard(),
            const SizedBox(height: SbSpacing.xxl),
          ],
          PrimaryCTA(
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











