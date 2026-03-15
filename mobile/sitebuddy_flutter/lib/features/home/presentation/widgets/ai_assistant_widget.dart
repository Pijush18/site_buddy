import 'package:site_buddy/core/design_system/sb_icons.dart';


/// FILE HEADER
/// ----------------------------------------------
/// File: ai_assistant_widget.dart
/// Feature: home
/// Layer: presentation
///
/// PURPOSE:
/// Anchor point on the Home Screen to launch the Smart Assistant Chat.
///
/// RESPONSIBILITIES:
/// - Provides a quick text input block for UX.
/// - Pushes initial queries into the `/ai/chat` engine.
///
/// ----------------------------------------------

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/widgets/sb_module_hero.dart';
import 'package:site_buddy/core/widgets/smart_assistant_input.dart';
import 'package:site_buddy/core/localization/generated/app_localizations.dart';
import 'package:site_buddy/features/subscription/application/subscription_providers.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/theme/app_layout.dart';

/// CLASS: AiAssistantWidget
class AiAssistantWidget extends ConsumerStatefulWidget {
  const AiAssistantWidget({super.key});

  @override
  ConsumerState<AiAssistantWidget> createState() => _AiAssistantWidgetState();
}

class _AiAssistantWidgetState extends ConsumerState<AiAssistantWidget> {
  final TextEditingController _controller = TextEditingController();

  void _launchChat() {
    final isPremium = ref.read(isPremiumProvider);
    
    if (!isPremium) {
      _showUpgradeDialog();
      return;
    }

    final text = _controller.text.trim();
    // Clean local field
    _controller.clear();
    // Launch the persistent chat screen
    context.push('/ai/chat', extra: text.isNotEmpty ? text : null);
  }

  void _showUpgradeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(SbIcons.premium, color: Colors.amber),
            AppLayout.hGap8,
            Text('Go Premium'),
          ],
        ),
        content: const Text(
          'Smart AI Assistant is a premium feature. Upgrade now to unlock advanced engineering intelligence and report syncing.',
        ),
        actions: [
          SbButton.ghost(
            label: 'Close',
            onPressed: () => context.pop(),
          ),
          SbButton.primary(
            label: 'Upgrade Now',
            onPressed: () {
              context.pop();
              context.push('/subscription');
            },
          ),
        ],
      ),
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
      child: SmartAssistantInput(
        controller: _controller,
        onSend: _launchChat,
        hintText: l10n.aiInputHint,
      ),
    );
  }
}