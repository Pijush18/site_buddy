import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
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
              style: SbTextStyles.caption(context).copyWith(
                color: colorScheme.secondary,
              ),
            ),
            AppLayout.vGap8,
            Text(
              state.convertedAmount != null
                  ? state.convertedAmount!.toStringAsFixed(2)
                  : '-',
              style: SbTextStyles.headlineLarge(context).copyWith(
                color: colorScheme.primary,
              ),
            ),
            AppLayout.vGap16,
            Divider(color: colorScheme.outlineVariant),
            AppLayout.vGap16,
            Text(
              'Rate: ${state.rate?.toStringAsFixed(6) ?? '-'}',
              style: SbTextStyles.body(context).copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            AppLayout.vGap8,
            Text(
              'Last Updated: ${state.lastUpdated != null ? state.lastUpdated!.toLocal().toString().split('.')[0] : '-'}',
              style: SbTextStyles.bodySecondary(context).copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return SbPage.detail(
      title: 'Currency Converter',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppLayout.vGap24,
          Text(
            'Market Exchange Rates',
            style: SbTextStyles.title(context),
            textAlign: TextAlign.center,
          ),
          AppLayout.vGap24,
          AppNumberField(
            label: 'Amount to Convert',
            suffixIcon: SbIcons.payments,
            onChanged: controller.updateAmount,
          ),
          AppLayout.vGap16,
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: AppLayout.pTiny,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'From',
                            style: SbTextStyles.caption(context).copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          AppLayout.vGap4,
                        ],
                      ),
                    ),
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
                  horizontal: AppLayout.pSmall,
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
                    Padding(
                      padding: const EdgeInsets.only(
                        left: AppLayout.pTiny,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'To',
                            style: SbTextStyles.caption(context).copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          AppLayout.vGap4,
                        ],
                      ),
                    ),
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
          AppLayout.vGap24,
          if (state.error != null) ...[
            Text(
              state.error!,
              style: SbTextStyles.body(context).copyWith(
                color: colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            AppLayout.vGap24,
          ],
          if (state.convertedAmount != null) ...[
            buildResultCard(),
            AppLayout.vGap24,
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
