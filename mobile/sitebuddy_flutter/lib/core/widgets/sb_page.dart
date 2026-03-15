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
  final String? title;
  final List<Widget>? appBarActions;
  final bool automaticallyImplyLeading;
  final _SbPageType _type;
  final bool usePadding;

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
    this.title,
    required Widget body,
    Widget? primaryAction,
    this.appBarActions,
    this.automaticallyImplyLeading = true,
    this.usePadding = true,
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
    this.title,
    Widget? header,
    required Widget body,
    this.appBarActions,
    this.automaticallyImplyLeading = true,
    this.usePadding = true,
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
    this.title,
    required Widget body,
    this.appBarActions,
    this.automaticallyImplyLeading = true,
    this.usePadding = true,
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
    this.title,
    required Widget body,
    this.appBarActions,
    this.automaticallyImplyLeading = true,
    this.bottomAction,
    this.usePadding = true,
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
    final bottomInset = MediaQuery.of(context).padding.bottom + kBottomNavigationBarHeight;
    
    return AppScaffold(
      title: title,
      actions: appBarActions,
      automaticallyImplyLeading: automaticallyImplyLeading,
      padding: EdgeInsets.zero,
      bottomNavigationBar: bottomAction != null ? _BottomActionBar(child: bottomAction!) : null,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: (usePadding ? AppLayout.paddingMedium : EdgeInsets.zero).copyWith(
          bottom: bottomInset,
        ),
        child: formBody!,
      ),
    );
  }

  // ── List ──────────────────────────────────────────────────────────────────
  Widget _buildListPage(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom + kBottomNavigationBarHeight;

    return AppScaffold(
      title: title,
      actions: appBarActions,
      automaticallyImplyLeading: automaticallyImplyLeading,
      padding: EdgeInsets.zero,
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: (usePadding ? AppLayout.paddingMedium : EdgeInsets.zero).copyWith(
          bottom: bottomInset,
        ),
        children: [
          if (listHeader != null) ...[
            listHeader!,
            const SizedBox(height: AppLayout.pMedium),
            const Divider(height: 1),
            const SizedBox(height: AppLayout.pMedium),
          ],
          listBody!,
        ],
      ),
    );
  }

  // ── Detail ────────────────────────────────────────────────────────────────
  Widget _buildDetailPage(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom + kBottomNavigationBarHeight;

    return AppScaffold(
      title: title,
      actions: appBarActions,
      automaticallyImplyLeading: automaticallyImplyLeading,
      padding: EdgeInsets.zero,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: (usePadding ? AppLayout.paddingMedium : EdgeInsets.zero).copyWith(
          bottom: bottomInset,
        ),
        child: formBody!,
      ),
    );
  }

  // ── Scaffold ──────────────────────────────────────────────────────────────
  Widget _buildScaffoldPage(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom + kBottomNavigationBarHeight;

    return AppScaffold(
      title: title,
      actions: appBarActions,
      automaticallyImplyLeading: automaticallyImplyLeading,
      bottomNavigationBar: bottomAction != null
          ? _BottomActionBar(child: bottomAction!)
          : null,
      padding: (usePadding ? AppLayout.paddingMedium : EdgeInsets.zero).copyWith(
        bottom: bottomInset,
      ),
      body: formBody!,
    );
  }
}

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
