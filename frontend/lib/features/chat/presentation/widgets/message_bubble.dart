// features/chat/presentation/widgets/message_bubble.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/message_entity.dart';

class MessageBubble extends StatelessWidget {
  final MessageEntity message;
  final bool showAvatar;

  const MessageBubble({
    super.key,
    required this.message,
    required this.showAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: message.isSentByMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!message.isSentByMe && showAvatar) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primaryGreen.withOpacity(0.2),
              child: Text(
                message.senderName?[0].toUpperCase() ?? 'U',
                style: const TextStyle(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          if (!message.isSentByMe && !showAvatar) const SizedBox(width: 40),
          Flexible(
            child: Column(
              crossAxisAlignment: message.isSentByMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                // Message content based on type
                if (message.type == MessageType.text)
                  _buildTextMessage(context)
                else if (message.type == MessageType.code)
                  _buildCodeMessage(context)
                else if (message.type == MessageType.file)
                    _buildFileMessage(context),

                const SizedBox(height: 4),

                // Timestamp
                Text(
                  message.formattedTime,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextMessage(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: message.isSentByMe
            ? AppColors.primaryGreen
            : AppColors.surfaceDark,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomLeft: Radius.circular(message.isSentByMe ? 16 : 4),
          bottomRight: Radius.circular(message.isSentByMe ? 4 : 16),
        ),
        border: message.isSentByMe
            ? null
            : Border.all(
          color: AppColors.borderColor,
          width: 1,
        ),
      ),
      child: Text(
        message.content,
        style: AppTypography.bodyMedium.copyWith(
          color: message.isSentByMe ? Colors.white : AppColors.textPrimary,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildCodeMessage(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 280),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Code language header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              border: Border.all(
                color: AppColors.borderColor,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.code,
                  size: 16,
                  color: AppColors.primaryGreen,
                ),
                const SizedBox(width: 8),
                Text(
                  message.codeLanguage ?? 'code',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: message.content));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Code copied to clipboard'),
                        duration: Duration(seconds: 2),
                        backgroundColor: AppColors.primaryGreen,
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.copy,
                    size: 16,
                    color: AppColors.iconColor,
                  ),
                ),
              ],
            ),
          ),

          // Code content
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              border: Border.all(
                color: AppColors.borderColor,
                width: 1,
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                message.content,
                style: const TextStyle(
                  fontFamily: 'Courier',
                  fontSize: 12,
                  color: AppColors.textPrimary,
                  height: 1.6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileMessage(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 260),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.borderColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.description,
              color: AppColors.primaryGreen,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.fileName ?? 'File',
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  message.fileSize ?? '0 KB',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              // TODO: Download file
            },
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.download,
                color: AppColors.primaryGreen,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
