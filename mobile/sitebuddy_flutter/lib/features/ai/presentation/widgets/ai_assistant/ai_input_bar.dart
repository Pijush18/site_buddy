import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

class AiInputBar extends StatefulWidget {
  final Function(String) onChanged;
  final VoidCallback onSubmit;
  final bool isLoading;

  const AiInputBar({
    super.key,
    required this.onChanged,
    required this.onSubmit,
    this.isLoading = false,
  });

  @override
  State<AiInputBar> createState() => _AiInputBarState();
}

class _AiInputBarState extends State<AiInputBar> {
  late final TextEditingController _textController;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    // Maintain strict controller instances outside the build method
    // to prevent rebuilds from wiping or aggressively refocusing the bar.
    _textController = TextEditingController();
    _focusNode = FocusNode();

    _textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    widget.onChanged(_textController.text);
    // Trigger localized rebuilds strictly for the button's enabled/disabled state
    // as the user types, rather than blasting the whole provider tree.
    setState(() {});
  }

  void _handleSubmit() {
    final text = _textController.text.trim();
    if (text.isEmpty || widget.isLoading) return;

    // 🔥 CRITICAL: Unfocus explicitly before executing ANY domain submission
    // to guarantee the keyboard dismisses successfully across routing boundaries.
    FocusScope.of(context).unfocus();

    widget.onSubmit();

    // Clear raw text physically so the next state finds a clean slate.
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final bool canSubmit =
        _textController.text.trim().isNotEmpty && !widget.isLoading;

    return TapRegion(
      // Native hook to catch stray taps anywhere outside this widget's bounds.
      onTapOutside: (_) {
        if (_focusNode.hasFocus) {
          _focusNode.unfocus();
        }
      },
      child: SbCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: SbInput(
              controller: _textController,
              hint: 'Design slab 4m x 5m / Concrete quantity for footing / IS code for beam design',
              prefixIcon: Icon(
                SbIcons.assistant,
                color: Theme.of(context).colorScheme.primary,
              ),
              enabled: !widget.isLoading,
              textInputAction: TextInputAction.send,
              onFieldSubmitted: (_) => _handleSubmit(),
              maxLines: 4,
              minLines: 1,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          SizedBox(
            width: 44,
            height: 44,
            child: AppIconButton(
              icon: SbIcons.send,
              onPressed: canSubmit ? _handleSubmit : null,
              isLoading: widget.isLoading,
            ),
          ),
        ],
      ),
      ),
    );
  }
}




