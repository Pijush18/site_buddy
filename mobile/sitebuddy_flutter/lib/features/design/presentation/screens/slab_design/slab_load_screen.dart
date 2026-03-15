import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/widgets/app_number_field.dart';
import 'package:site_buddy/core/utils/validation_helper.dart';
import 'package:site_buddy/features/design/application/controllers/slab_design_controller.dart';

class SlabLoadScreen extends ConsumerStatefulWidget {
  const SlabLoadScreen({super.key});

  @override
  ConsumerState<SlabLoadScreen> createState() => _SlabLoadScreenState();
}

class _SlabLoadScreenState extends ConsumerState<SlabLoadScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _dlController;
  late final TextEditingController _llController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(slabDesignControllerProvider);
    _dlController = TextEditingController(text: state.deadLoad.toString());
    _llController = TextEditingController(text: state.liveLoad.toString());
  }

  @override
  void dispose() {
    _dlController.dispose();
    _llController.dispose();
    super.dispose();
  }

  void _onCalculate() {
    if (!_formKey.currentState!.validate()) return;

    ref.read(slabDesignControllerProvider.notifier).updateLoads(
      dl: double.parse(_dlController.text),
      ll: double.parse(_llController.text),
    );

    // Trigger calculation
    ref.read(slabDesignControllerProvider.notifier).calculate();

    context.push('/slab/analysis');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SbPage.detail(
      title: 'Slab Loading',
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Step 2 of 5: Load Definition',
              style: SbTextStyles.title(context).copyWith(color: colorScheme.primary),
            ),
            AppLayout.vGap24,

            SbCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                   Text('Loads (kN/m²)', style: SbTextStyles.title(context)),
                   AppLayout.vGap16,
                   AppNumberField(
                     controller: _dlController,
                     label: 'Dead Load (inc. Finishes)',
                     validator: (v) => ValidationHelper.validatePositive(v, 'Dead Load'),
                   ),
                   AppLayout.vGap16,
                   AppNumberField(
                     controller: _llController,
                     label: 'Live Load',
                     validator: (v) => ValidationHelper.validatePositive(v, 'Live Load'),
                   ),
                   AppLayout.vGap8,
                   Text(
                     'Note: Load factor of 1.5 will be applied automatically.',
                     style: SbTextStyles.caption(context),
                   ),
                ],
              ),
            ),
            AppLayout.vGap32,

            SbButton.primary(
              label: 'Next: Analysis Summary',
              onPressed: _onCalculate,
              icon: SbIcons.calculator,
            ),
          ],
        ),
      ),
    );
  }
}
