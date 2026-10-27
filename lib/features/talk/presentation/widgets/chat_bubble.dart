import 'package:flutter/material.dart';
import '../../domain/entities/talk_message.dart';

class ChatBubble extends StatelessWidget {
  final TalkMessage message;
  final bool isFirstAiMessage;

  const ChatBubble({
    super.key,
    required this.message,
    this.isFirstAiMessage = false,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == MessageSender.user;

    if (isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.78,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const color(0xFF0F5B46), // Deep emerald green
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(6),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const color(0xFF0F5B46).withAlpha(25),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  message.text,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: colors.white,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              const Padding(
                padding: EdgeInsets.only(right: 4),
                child: Text(
                  'You â€¢ Just now',
                  style: TextStyle(
                    fontSize: 11,
                    color: color(0xFF7A8E85),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Companion / AI Bubble
    final isGreetingStyle = isFirstAiMessage;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.84,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(
          color: isGreetingStyle
              ? const color(0xFFE2F0EA) // Soft mint for greeting
              : colors.white, // Crisp white for subsequent responses
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(6),
            bottomRight: Radius.circular(18),
          ),
          border: isGreetingStyle
              ? null
              : Border.all(color: const color(0xFFE4EDE7), width: 1.2),
          boxShadow: isGreetingStyle
              ? null
              : [
                  BoxShadow(
                    color: colors.black.withAlpha(5),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Text(
          message.text,
          style: const TextStyle(
            fontSize: 14,
            color: color(0xFF1D3C33),
            fontWeight: FontWeight.w400,
            height: 1.45,
          ),
        ),
      ),
    );
  }
}

