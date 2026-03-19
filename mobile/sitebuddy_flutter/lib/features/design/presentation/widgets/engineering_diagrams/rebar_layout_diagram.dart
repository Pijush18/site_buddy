import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_text_styles.dart';
import 'package:site_buddy/shared/domain/models/design/column_enums.dart';
import 'package:site_buddy/features/design/presentation/widgets/engineering_diagrams/column_section_painter.dart';

class RebarLayoutDiagram extends StatelessWidget {
  final ColumnType type;
  final double width;
  final double depth;
  final int numBars;
  final double mainBarDia;
  final double ast;

  const RebarLayoutDiagram({
    super.key,
    required this.type,
    required this.width,
    required this.depth,
    required this.numBars,
    required this.mainBarDia,
    required this.ast,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: AppLayout.paddingMedium,

      child: AspectRatio(
        aspectRatio: 2.0, // Standard responsive ratio
        child: Row(
          children: [
            // Diagram
            Expanded(
              flex: 3,
              child: Center(
                child: CustomPaint(
                  size: const Size(160, 160),
                  painter: ColumnSectionPainter(
                    type: type,
                    width: width,
                    depth: depth,
                    numBars: numBars,
                    mainBarDia: mainBarDia,
                    cover: 40.0,
                    colorScheme: colorScheme,
                  ),
                ),
              ),
            ),
            // Info
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Steel Arrangement',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  AppLayout.vGap8,
                  Flexible(
                    child: Text(
                      '$numBars bars Ø${mainBarDia.toInt()}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.cardTitle,
                    ),
                  ),
                  AppLayout.vGap16,
                  Text(
                    'Total Steel Area',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  AppLayout.vGap4,
                  Flexible(
                    child: Text(
                      'Ast = ${ast.toInt()} mm²',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.cardTitle.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
