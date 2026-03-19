import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/widgets/smart_assistant_input.dart';
import 'package:site_buddy/core/localization/generated/app_localizations.dart';
import 'package:site_buddy/features/subscription/application/subscription_providers.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/constants/app_strings.dart';

/// CLASS: SbSmartAssistantCard
/// PURPOSE: Premium hero card for launching the Smart Assistant Chat.
/// Standardized replacement for AssistantHeroCard.
class SbSmartAssistantCard extends ConsumerStatefulWidget {
  const SbSmartAssistantCard({super.key});

  @override
  ConsumerState<SbSmartAssistantCard> createState() => _SbSmartAssistantCardState();
}

class _SbSmartAssistantCardState extends ConsumerState<SbSmartAssistantCard> {
  final TextEditingController _controller = TextEditingController();

  void _launchChat() {
    final isPremium = ref.read(isPremiumProvider);
    
    if (!isPremium) {
      _showUpgradeDialog();
      return;
    }

    final text = _controller.text.trim();
    _controller.clear();
    context.push('/ai/chat', extra: text.isNotEmpty ? text : null);
  }

  void _showUpgradeDialog() {
    SbFeedback.showDialog(
      context: context,
      title: AppStrings.goPremium,
      content: const Text(AppStrings.premiumFeatureNotice),
      confirmLabel: AppStrings.upgradeNow,
      onConfirm: () {
        context.pop();
        context.push('/subscription');
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SbModuleHero(
      icon: SbIcons.psychology,
      title: l10n.smartAssistant,
      subtitle: l10n.aiHeroSubtitle,
      margin: EdgeInsets.zero,
      child: SmartAssistantInput(
        controller: _controller,
        onSend: _launchChat,
        hintText: l10n.aiInputHint,
      ),
    );
  }
}
