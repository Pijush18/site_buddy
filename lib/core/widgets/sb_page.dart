import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/app_scaffold.dart';

/// ENUM: SbPageType
/// Distinguishes how [SbPage] lays out its content.
enum _SbPageType { form, list, detail, scaffold }

/// WIDGET: SbPage
/// PURPOSE: Universal screen-level template. Guarantees identical edge
/// padding, AppBar title style, and primary-action placement on every screen.
///
/// Variants:
///   [SbPage.form]     — Scrollable form. Primary action pinned to a bottom bar.
///   [SbPage.list]     — Full-height list with optional header action slot.
///   [SbPage.detail]   — Read-only scrollable detail view, no bottom bar.
///   [SbPage.scaffold] — Generic scaffold with padding but no automatic scrolling.
///
/// Rule: All variants use AppLayout.pMedium (16px) for edge insets.
class SbPage extends StatelessWidget {
  // ── Common ────────────────────────────────────────────────────────────────
  final String title;
  final List<Widget>? appBarActions;
  final bool automaticallyImplyLeading;
  final _SbPageType _type;

  // ── form / detail ─────────────────────────────────────────────────────────
  final Widget? formBody;

  /// Pinned bottom-bar widget (used by form variant for primary actions).
  final Widget? bottomAction;

  // ── list ──────────────────────────────────────────────────────────────────
  /// Optional banner/action shown above the list (e.g. "New Project" button).
  final Widget? listHeader;

  /// The list content. Typically a [ListView] or [Column] with item widgets.
  final Widget? listBody;

  // ─────────────────────────────────────────────────────────────────────────
  // Named constructors
  // ─────────────────────────────────────────────────────────────────────────

  /// Creates a form-style page with:
  /// - Scrollable [body] wrapped in standard edge padding
  /// - [primaryAction] pinned to a safe-area bottom bar
  const SbPage.form({
    super.key,
    required this.title,
    required Widget body,
    required Widget primaryAction,
    this.appBarActions,
    this.automaticallyImplyLeading = true,
  }) : _type = _SbPageType.form,
       formBody = body,
       bottomAction = primaryAction,
       listHeader = null,
       listBody = null;

  /// Creates a list-style page with:
  /// - Optional [header] widget pinned above the list (for primary CTAs)
  /// - Full-height [body] list / empty-state
  const SbPage.list({
    super.key,
    required this.title,
    Widget? header,
    required Widget body,
    this.appBarActions,
    this.automaticallyImplyLeading = true,
  }) : _type = _SbPageType.list,
       listHeader = header,
       listBody = body,
       formBody = null,
       bottomAction = null;

  /// Creates a detail-style page with:
  /// - Scrollable [body] with standard edge padding
  /// - No bottom bar
  const SbPage.detail({
    super.key,
    required this.title,
    required Widget body,
    this.appBarActions,
    this.automaticallyImplyLeading = true,
  }) : _type = _SbPageType.detail,
       formBody = body,
       bottomAction = null,
       listHeader = null,
       listBody = null;

  /// Creates a raw scaffold-style page with:
  /// - [body] used as is (no automatic scroll view)
  /// - Standard edge padding applied to [body]
  /// - [footer] typically used for primary actions
  const SbPage.scaffold({
    super.key,
    required this.title,
    required Widget body,
    this.appBarActions,
    this.automaticallyImplyLeading = true,
    this.bottomAction,
  }) : _type = _SbPageType.scaffold,
       formBody = body,
       listHeader = null,
       listBody = null;

  // ─────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    switch (_type) {
      case _SbPageType.form:
        return _buildFormPage(context);
      case _SbPageType.list:
        return _buildListPage(context);
      case _SbPageType.detail:
        return _buildDetailPage(context);
      case _SbPageType.scaffold:
        return _buildScaffoldPage(context);
    }
  }

  // ── Form ──────────────────────────────────────────────────────────────────
  Widget _buildFormPage(BuildContext context) {
    return AppScaffold(
      title: title,
      actions: appBarActions,
      automaticallyImplyLeading: automaticallyImplyLeading,
      padding: EdgeInsets.zero,
      bottomNavigationBar: _BottomActionBar(child: bottomAction!),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppLayout.maxContentWidth,
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(AppLayout.pMedium),
            child: formBody!,
          ),
        ),
      ),
    );
  }

  // ── List ──────────────────────────────────────────────────────────────────
  Widget _buildListPage(BuildContext context) {
    return AppScaffold(
      title: title,
      actions: appBarActions,
      automaticallyImplyLeading: automaticallyImplyLeading,
      padding: EdgeInsets.zero,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppLayout.maxContentWidth,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (listHeader != null) ...[
                Padding(
                  padding: const EdgeInsets.all(AppLayout.pMedium),
                  child: listHeader,
                ),
                const Divider(height: 1),
              ],
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppLayout.pMedium,
                    vertical: AppLayout.pSmall,
                  ),
                  child: listBody!,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Detail ────────────────────────────────────────────────────────────────
  Widget _buildDetailPage(BuildContext context) {
    return AppScaffold(
      title: title,
      actions: appBarActions,
      automaticallyImplyLeading: automaticallyImplyLeading,
      padding: EdgeInsets.zero,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppLayout.maxContentWidth,
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(AppLayout.pMedium),
            child: formBody!,
          ),
        ),
      ),
    );
  }

  // ── Scaffold ──────────────────────────────────────────────────────────────
  Widget _buildScaffoldPage(BuildContext context) {
    return AppScaffold(
      title: title,
      actions: appBarActions,
      automaticallyImplyLeading: automaticallyImplyLeading,
      bottomNavigationBar: bottomAction != null
          ? _BottomActionBar(child: bottomAction!)
          : null,
      body: formBody!, // Padding is already applied by AppScaffold by default
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Internal: pinned bottom action bar
// ─────────────────────────────────────────────────────────────────────────────

class _BottomActionBar extends StatelessWidget {
  final Widget child;
  const _BottomActionBar({required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(AppLayout.pMedium),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant,
              width: 1,
            ),
          ),
        ),
        child: child,
      ),
    );
  }
}
