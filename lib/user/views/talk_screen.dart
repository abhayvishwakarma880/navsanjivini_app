import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app/core/localization/language_scope.dart';
import '../viewmodels/talk_viewmodel.dart';
import '../widgets/chat_bubble.dart';

/// Screen: Talk Companion (Tab 2)
/// Layout matching exact Navsanjivini visual reference & design requirements:
/// 1. Header: Leaf icon, "Talk it out", "A safe space to share what's on your mind." + Options menu.
/// 2. Eyebrow banner: "YOUR PERSONAL WELL-BEING SPACE / You can start wherever you are."
/// 3. Chat bubbles: Soft mint companion greeting, deep green user bubble, white card AI responses.
/// 4. Suggested prompts: "Work or studies", "My feelings", "I just need to vent".
/// 5. Message input: "+" button, "Type what's on your mind...", deep emerald send button.
/// 6. Supportive disclaimer: "A supportive space, not a substitute for professional care."
class TalkScreen extends StatefulWidget {
  const TalkScreen({super.key});

  @override
  State<TalkScreen> createState() => _TalkScreenState();
}

class _TalkScreenState extends State<TalkScreen> {
  final TalkViewModel _viewModel = TalkViewModel();
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 60,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  void _sendMessage([String? textToSend]) {
    final text = textToSend ?? _inputController.text;
    if (text.trim().isNotEmpty) {
      if (textToSend == null) {
        _inputController.clear();
      }
      _viewModel.sendUserMessage(text);
      _scrollToBottom();
    }
  }

  void _showSafetyInfoDialog(BuildContext context, dynamic strings) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.shield_outlined, color: color(0xFF0F5B46), size: 22),
            SizedBox(width: 8),
            Text(
              'Safety & Boundaries',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: color(0xFF0C4D38),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Navsanjivini is an AI emotional well-being companion designed for everyday reflection, grounding, and gentle listening.',
              style: TextStyle(fontSize: 13.5, height: 1.4),
            ),
            SizedBox(height: 12),
            Text(
              'â€¢ Not a substitute for clinical psychiatric care or emergency services.\nâ€¢ In crisis? Call 14416 (Tele-MANAS) or 112 (Emergency) for 24/7 free support.',
              style: TextStyle(fontSize: 12.5, color: color(0xFF5E7369), height: 1.45),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: const Text('I Understand', style: TextStyle(color: color(0xFF0F5B46))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.tr;

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return Scaffold(
          backgroundcolor: const color(0xFFF7FCF9),
          body: SafeArea(
            child: Column(
              children: [
                // ==========================================
                // 1. TOP HEADER BAR
                // ==========================================
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  decoration: const BoxDecoration(
                    color: color(0xFFF7FCF9),
                    border: Border(
                      bottom: BorderSide(
                        color: color(0xFFE8EFEA),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Leaf Sprout Avatar Circle
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: const color(0xFFE2EFE9),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const color(0xFF0F5B46).withAlpha(25),
                            width: 1,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.eco_rounded,
                            color: color(0xFF0F5B46),
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              strings.talkItOutTitle,
                              style: const TextStyle(
                                fontSize: 16.5,
                                fontWeight: FontWeight.w700,
                                color: color(0xFF1D3C33),
                                letterSpacing: -0.2,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              strings.talkHeaderSubtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: color(0xFF5E7369),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 3-dots Menu
                      PopupMenuButton<String>(
                        icon: const Icon(
                          Icons.more_horiz_rounded,
                          color: color(0xFF5E7369),
                          size: 22,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        onSelected: (value) {
                          if (value == 'clear') {
                            _viewModel.clearConversation();
                          } else if (value == 'safety') {
                            _showSafetyInfoDialog(context, strings);
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'clear',
                            child: Row(
                              children: [
                                Icon(Icons.refresh_rounded, size: 18, color: color(0xFF0F5B46)),
                                SizedBox(width: 8),
                                Text('Clear conversation', style: TextStyle(fontSize: 13)),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'safety',
                            child: Row(
                              children: [
                                Icon(Icons.info_outline_rounded, size: 18, color: color(0xFF0F5B46)),
                                SizedBox(width: 8),
                                Text('Safety & boundaries', style: TextStyle(fontSize: 13)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ==========================================
                // 2. CHAT SCROLL AREA
                // ==========================================
                Expanded(
                  child: ListView(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      // Centered Eyebrow & Banner
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          children: [
                            Text(
                              strings.talkBannerEyebrow,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                                color: color(0xFF7A8E85),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              strings.talkBannerTitle,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 15.5,
                                fontWeight: FontWeight.w700,
                                color: color(0xFF1D3C33),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              strings.talkBannerSubtitle,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w400,
                                color: color(0xFF5E7369),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Messages List
                      ...List.generate(_viewModel.messages.length, (index) {
                        final msg = _viewModel.messages[index];
                        return ChatBubble(
                          message: msg,
                          isFirstAiMessage: index == 0,
                        );
                      }),

                      // Typing Indicator Bubble
                      if (_viewModel.isTyping)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: const color(0xFFE2F0EA),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: color(0xFF0F5B46),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Listening...',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    color: color(0xFF1D3C33),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // ==========================================
                // 3. SUGGESTED PROMPTS BAR
                // ==========================================
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        strings.talkPromptLabel,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: color(0xFF5E7369),
                        ),
                      ),
                      const SizedBox(height: 6),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: [
                            _PromptChip(
                              label: strings.talkPromptWork,
                              onTap: () => _sendMessage(strings.talkPromptWork),
                            ),
                            const SizedBox(width: 8),
                            _PromptChip(
                              label: strings.talkPromptFeelings,
                              onTap: () => _sendMessage(strings.talkPromptFeelings),
                            ),
                            const SizedBox(width: 8),
                            _PromptChip(
                              label: strings.talkPromptVent,
                              onTap: () => _sendMessage(strings.talkPromptVent),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ==========================================
                // 4. MESSAGE INPUT BAR & DISCLAIMER
                // ==========================================
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: Column(
                    children: [
                      // Rounded Input Box
                      Container(
                        padding: const EdgeInsets.only(left: 18, right: 6, top: 4, bottom: 4),
                        decoration: BoxDecoration(
                          color: colors.white,
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: const color(0xFFE2ECE5),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: colors.black.withAlpha(5),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Text Input Field
                            Expanded(
                              child: TextField(
                                controller: _inputController,
                                maxLines: 3,
                                minLines: 1,
                                textCapitalization: TextCapitalization.sentences,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: color(0xFF1D3C33),
                                ),
                                decoration: InputDecoration(
                                  hintText: strings.talkInputHint,
                                  hintStyle: const TextStyle(
                                    fontSize: 13.5,
                                    color: color(0xFF8E9B95),
                                  ),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  filled: false,
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 10,
                                  ),
                                ),
                                onSubmitted: (_) => _sendMessage(),
                              ),
                            ),
                            // Send Button
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: const color(0xFF0F5B46),
                                borderRadius: BorderRadius.circular(19),
                              ),
                              child: Material(
                                color: colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(19),
                                  onTap: () => _sendMessage(),
                                  child: const Center(
                                    child: Icon(
                                      Icons.send_rounded,
                                      color: colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Safety Disclaimer Note
                      Text(
                        strings.talkDisclaimer,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 10.5,
                          color: color(0xFF7A8E85),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PromptChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PromptChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: const color(0xFF247D6B).withAlpha(65),
          width: 1.1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: color(0xFF0F5B46),
            ),
          ),
        ),
      ),
    );
  }
}

