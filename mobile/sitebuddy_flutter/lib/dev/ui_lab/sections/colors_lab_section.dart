
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/design_system/sb_radius.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class ColorsLabSection extends StatelessWidget {
  const ColorsLabSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final colors = [
      _ColorData('Primary', colorScheme.primary, colorScheme.onPrimary),
      _ColorData(
        'Primary Container',
        colorScheme.primaryContainer,
        colorScheme.onPrimaryContainer,
      ),
      _ColorData('Secondary', colorScheme.secondary, colorScheme.onSecondary),
      _ColorData(
        'Secondary Container',
        colorScheme.secondaryContainer,
        colorScheme.onSecondaryContainer,
      ),
      _ColorData('Surface', colorScheme.surface, colorScheme.onSurface),
      _ColorData(
        'Surface Variant',
        colorScheme.surfaceContainerHighest,
        colorScheme.onSurfaceVariant,
      ),
      _ColorData('Outline', colorScheme.outline, Colors.white),
      _ColorData('Error', colorScheme.error, colorScheme.onError),
      _ColorData('Background', colorScheme.surface, colorScheme.onSurface),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Color System', style: Theme.of(context).textTheme.titleMedium!),
        const SizedBox(height: SbSpacing.lg),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.5,
            crossAxisSpacing: SbSpacing.sm,
            mainAxisSpacing: SbSpacing.sm,
          ),
          itemCount: colors.length,
          itemBuilder: (context, index) => _ColorCard(data: colors[index]),
        ),
      ],
    );
  }
}

class _ColorData {
  final String name;
  final Color color;
  final Color onColor;

  _ColorData(this.name, this.color, this.onColor);
}

class _ColorCard extends StatelessWidget {
  final _ColorData data;

  const _ColorCard({required this.data});

  String _toHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase().substring(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final hex = _toHex(data.color);
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: hex));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Copied $hex to clipboard'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: data.color,
          borderRadius: SbRadius.borderMd,
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
            width: 1,
          ),

        ),
        padding: const EdgeInsets.all(SbSpacing.sm),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.name,
              style: TextStyle(
                color: data.onColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            Text(
              hex,
              style: TextStyle(
                color: data.onColor.withValues(alpha: 0.7),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}








