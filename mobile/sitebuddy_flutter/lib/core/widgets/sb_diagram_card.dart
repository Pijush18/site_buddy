import 'package:flutter/material.dart';
import 'package:site_buddy/core/design_system/sb_radius.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/widgets/sb_card.dart';

/// WIDGET: SbDiagramCard
/// PURPOSE: Standardized card wrapper for engineering diagrams.
/// FEATURES:
/// - Consistent header with title, subtitle, and optional actions
/// - Diagram content area with proper constraints
/// - Optional footer for notes or metadata
/// - Built-in action buttons (expand, export, info)
/// - Hooks for future zoom/pan/export features
///
/// USAGE:
/// ```dart
/// SbDiagramCard(
///   title: 'Beam Cross Section',
///   subtitle: 'Main reinforcement detail',
///   actions: [
///     DiagramAction.expand,
///     DiagramAction.export,
///   ],
///   onAction: (action) => handleAction(action),
///   footer: Text('Ref: IS 456 Cl. 26.5.1'),
///   child: CustomPaint(painter: BeamSectionPainter()),
/// )
/// ```
class SbDiagramCard extends StatelessWidget {
  /// Optional title to display at the top.
  final String? title;

  /// Optional subtitle below the title.
  final String? subtitle;

  /// The diagram widget to display.
  final Widget child;

  /// Optional footer widget (notes, metadata, etc.).
  final Widget? footer;

  /// Whether to fill available space.
  final bool expanded;

  /// Height constraint for the diagram area.
  final double? height;

  /// Background color for the diagram area.
  final Color? backgroundColor;

  /// Actions to show in the header.
  final List<DiagramAction> actions;

  /// Callback for action button taps.
  /// Returns the action that was triggered.
  final void Function(DiagramAction action)? onAction;

  /// Callback for when expand action is triggered.
  /// Can be used to implement fullscreen view.
  final VoidCallback? onExpand;

  /// Callback for when export action is triggered.
  /// Can be used to implement export functionality.
  final VoidCallback? onExport;

  /// Callback for when info action is triggered.
  /// Can be used to show diagram information.
  final VoidCallback? onInfo;

  /// Whether to show a divider between header and content.
  final bool showDivider;

  /// Whether to clip overflow in the content area.
  final bool clipContent;

  /// Custom padding for the content area.
  final EdgeInsetsGeometry? contentPadding;

  const SbDiagramCard({
    super.key,
    this.title,
    this.subtitle,
    required this.child,
    this.footer,
    this.expanded = false,
    this.height,
    this.backgroundColor,
    this.actions = const [],
    this.onAction,
    this.onExpand,
    this.onExport,
    this.onInfo,
    this.showDivider = true,
    this.clipContent = true,
    this.contentPadding,
  });

  /// Checks if any action is requested.
  bool get hasActions => actions.isNotEmpty || onAction != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bgColor = backgroundColor ?? colorScheme.surface;

    return SbCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
        children: [
          // Header section
          if (title != null || subtitle != null || hasActions)
            _buildHeader(context),

          // Divider
          if (showDivider && (title != null || hasActions))
            Divider(
              height: 1,
              thickness: 1,
              color: colorScheme.outlineVariant,
            ),

          // Content section
          _buildContent(context, bgColor),

          // Footer section
          if (footer != null) ...[
            Divider(
              height: 1,
              thickness: 1,
              color: colorScheme.outlineVariant,
            ),
            _buildFooter(context),
          ],
        ],
      ),
    );
  }

  /// Builds the header section with title, subtitle, and actions.
  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: SbSpacing.md,
        vertical: SbSpacing.sm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Text(
                    title!,
                    style: theme.textTheme.titleSmall,
                  ),
                if (subtitle != null) ...[
                  if (title != null) const SizedBox(height: SbSpacing.xs),
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Action buttons
          if (hasActions) ...[
            const SizedBox(width: SbSpacing.sm),
            _buildActionButtons(context),
          ],
        ],
      ),
    );
  }

  /// Builds the action buttons row.
  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: actions.map((action) {
        return Padding(
          padding: const EdgeInsets.only(left: SbSpacing.xs),
          child: _DiagramActionButton(
            action: action,
            onTap: () => _handleAction(action),
          ),
        );
      }).toList(),
    );
  }

  /// Handles action button tap.
  void _handleAction(DiagramAction action) {
    switch (action) {
      case DiagramAction.expand:
        onExpand?.call();
        break;
      case DiagramAction.export:
        onExport?.call();
        break;
      case DiagramAction.info:
        onInfo?.call();
        break;
    }
    onAction?.call(action);
  }

  /// Builds the diagram content area.
  Widget _buildContent(BuildContext context, Color bgColor) {
    final padding = contentPadding ??
        const EdgeInsets.symmetric(
          horizontal: SbSpacing.md,
          vertical: SbSpacing.sm,
        );

    Widget content = Padding(
      padding: padding,
      child: child,
    );

    if (clipContent) {
      content = ClipRect(child: content);
    }

    if (height != null) {
      return SizedBox(
        height: height,
        child: Container(
          color: bgColor,
          child: content,
        ),
      );
    }

    if (expanded) {
      return Expanded(child: Container(color: bgColor, child: content));
    }

    return Container(
      constraints: const BoxConstraints(minHeight: 150),
      color: bgColor,
      child: content,
    );
  }

  /// Builds the footer section.
  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: SbSpacing.md,
        vertical: SbSpacing.sm,
      ),
      child: footer!,
    );
  }
}

/// ENUM: DiagramAction
/// Defines available action buttons for diagram cards.
enum DiagramAction {
  /// Expand action for fullscreen view.
  expand,

  /// Export action for exporting diagram.
  export,

  /// Info action for showing diagram information.
  info,
}

/// WIDGET: _DiagramActionButton
/// Internal action button widget.
class _DiagramActionButton extends StatelessWidget {
  final DiagramAction action;
  final VoidCallback? onTap;

  const _DiagramActionButton({
    required this.action,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    IconData icon;
    String tooltip;

    switch (action) {
      case DiagramAction.expand:
        icon = Icons.fullscreen;
        tooltip = 'Expand';
        break;
      case DiagramAction.export:
        icon = Icons.download;
        tooltip = 'Export';
        break;
      case DiagramAction.info:
        icon = Icons.info_outline;
        tooltip = 'Info';
        break;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: SbRadius.borderSmall,
        child: Tooltip(
          message: tooltip,
          child: Padding(
            padding: const EdgeInsets.all(SbSpacing.xs),
            child: Icon(
              icon,
              size: 20,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

/// BUILDER: SbDiagramCardBuilder
/// Builder pattern for constructing SbDiagramCard with fluent API.
class SbDiagramCardBuilder {
  String? _title;
  String? _subtitle;
  Widget? _child;
  Widget? _footer;
  bool _expanded = false;
  double? _height;
  Color? _backgroundColor;
  List<DiagramAction> _actions = [];
  void Function(DiagramAction)? _onAction;
  VoidCallback? _onExpand;
  VoidCallback? _onExport;
  VoidCallback? _onInfo;
  bool _showDivider = true;
  bool _clipContent = true;
  EdgeInsetsGeometry? _contentPadding;

  /// Sets the title.
  SbDiagramCardBuilder title(String? title) {
    _title = title;
    return this;
  }

  /// Sets the subtitle.
  SbDiagramCardBuilder subtitle(String? subtitle) {
    _subtitle = subtitle;
    return this;
  }

  /// Sets the child diagram widget.
  SbDiagramCardBuilder child(Widget child) {
    _child = child;
    return this;
  }

  /// Sets the footer widget.
  SbDiagramCardBuilder footer(Widget? footer) {
    _footer = footer;
    return this;
  }

  /// Sets whether the card should expand.
  SbDiagramCardBuilder expanded(bool expanded) {
    _expanded = expanded;
    return this;
  }

  /// Sets the height constraint.
  SbDiagramCardBuilder height(double? height) {
    _height = height;
    return this;
  }

  /// Sets the background color.
  SbDiagramCardBuilder backgroundColor(Color? color) {
    _backgroundColor = color;
    return this;
  }

  /// Sets the actions.
  SbDiagramCardBuilder actions(List<DiagramAction> actions) {
    _actions = actions;
    return this;
  }

  /// Sets the action callback.
  SbDiagramCardBuilder onAction(void Function(DiagramAction)? callback) {
    _onAction = callback;
    return this;
  }

  /// Sets the expand callback.
  SbDiagramCardBuilder onExpand(VoidCallback? callback) {
    _onExpand = callback;
    return this;
  }

  /// Sets the export callback.
  SbDiagramCardBuilder onExport(VoidCallback? callback) {
    _onExport = callback;
    return this;
  }

  /// Sets the info callback.
  SbDiagramCardBuilder onInfo(VoidCallback? callback) {
    _onInfo = callback;
    return this;
  }

  /// Sets whether to show divider.
  SbDiagramCardBuilder showDivider(bool show) {
    _showDivider = show;
    return this;
  }

  /// Sets whether to clip content.
  SbDiagramCardBuilder clipContent(bool clip) {
    _clipContent = clip;
    return this;
  }

  /// Sets the content padding.
  SbDiagramCardBuilder contentPadding(EdgeInsetsGeometry? padding) {
    _contentPadding = padding;
    return this;
  }

  /// Builds the SbDiagramCard widget.
  /// [child] is required.
  SbDiagramCard build() {
    if (_child == null) {
      throw StateError('SbDiagramCardBuilder: child is required');
    }

    return SbDiagramCard(
      title: _title,
      subtitle: _subtitle,
      footer: _footer,
      expanded: _expanded,
      height: _height,
      backgroundColor: _backgroundColor,
      actions: _actions,
      onAction: _onAction,
      onExpand: _onExpand,
      onExport: _onExport,
      onInfo: _onInfo,
      showDivider: _showDivider,
      clipContent: _clipContent,
      contentPadding: _contentPadding,
      child: _child!,
    );
  }
}
