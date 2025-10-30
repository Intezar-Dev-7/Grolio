// features/feed/presentation/widgets/post_card.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/post_entity.dart';

class PostCard extends StatelessWidget {
  final PostEntity post;
  final VoidCallback onLike;
  final VoidCallback onBookmark;
  final VoidCallback onShare;
  final VoidCallback? onComment;
  final VoidCallback? onAuthorTap;

  const PostCard({
    super.key,
    required this.post,
    required this.onLike,
    required this.onBookmark,
    required this.onShare,
    this.onComment,
    this.onAuthorTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.borderColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author info
          GestureDetector(
            onTap: onAuthorTap,
            child: Row(
              children: [
                // Avatar
                _buildAvatar(),
                const SizedBox(width: 12),
                // Name and username
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.author.name,
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${post.author.username} • ${timeago.format(post.createdAt)}',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                // More options
                IconButton(
                  icon: const Icon(
                    Icons.more_horiz,
                    color: AppColors.iconColor,
                  ),
                  onPressed: () {
                    _showPostOptions(context);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Content
          Text(
            post.content,
            style: AppTypography.bodyMedium.copyWith(
              height: 1.5,
            ),
          ),

          const SizedBox(height: 12),

          // Tags
          if (post.tags.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: post.tags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: AppColors.primaryGreen.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    tag.startsWith('#') ? tag : '#$tag',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),

          // Post image
          if (post.imageUrl != null) ...[
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: post.imageUrl!,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 200,
                  color: AppColors.borderColor,
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primaryGreen,
                      ),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 200,
                  color: AppColors.borderColor,
                  child: const Icon(
                    Icons.broken_image_outlined,
                    color: AppColors.iconColor,
                    size: 48,
                  ),
                ),
              ),
            ),
          ],

          // Action buttons (GitHub/Demo)
          if (post.githubUrl != null || post.demoUrl != null) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                if (post.githubUrl != null)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _openUrl(context, post.githubUrl!);
                      },
                      icon: const Icon(
                        Icons.code,
                        size: 18,
                        color: AppColors.textPrimary,
                      ),
                      label: const Text(
                        'GitHub',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: AppColors.borderColor,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                if (post.githubUrl != null && post.demoUrl != null)
                  const SizedBox(width: 12),
                if (post.demoUrl != null)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _openUrl(context, post.demoUrl!);
                      },
                      icon: const Icon(
                        Icons.link,
                        size: 18,
                      ),
                      label: const Text('Live Demo'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],

          const SizedBox(height: 16),

          // Engagement stats
          Row(
            children: [
              _buildStatButton(
                icon: post.stats.isLiked
                    ? Icons.favorite
                    : Icons.favorite_outline,
                count: post.stats.likes,
                color: post.stats.isLiked
                    ? AppColors.error
                    : AppColors.iconColor,
                onTap: onLike,
              ),
              const SizedBox(width: 20),
              _buildStatButton(
                icon: Icons.chat_bubble_outline,
                count: post.stats.comments,
                color: AppColors.iconColor,
                onTap: onComment ?? () {},
              ),
              const SizedBox(width: 20),
              _buildStatButton(
                icon: Icons.share_outlined,
                count: post.stats.shares,
                color: AppColors.iconColor,
                onTap: onShare,
              ),
              const Spacer(),
              IconButton(
                icon: Icon(
                  post.stats.isBookmarked
                      ? Icons.bookmark
                      : Icons.bookmark_outline,
                  color: post.stats.isBookmarked
                      ? AppColors.primaryGreen
                      : AppColors.iconColor,
                ),
                onPressed: onBookmark,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    if (post.author.avatar != null) {
      return CircleAvatar(
        radius: 20,
        backgroundImage: CachedNetworkImageProvider(
          post.author.avatar!,
        ),
      );
    }

    return CircleAvatar(
      radius: 20,
      backgroundColor: AppColors.primaryGreen.withOpacity(0.2),
      child: Text(
        post.author.name[0].toUpperCase(),
        style: const TextStyle(
          color: AppColors.primaryGreen,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildStatButton({
    required IconData icon,
    required int count,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            _formatCount(count),
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  void _openUrl(BuildContext context, String url) {
    // TODO: Implement URL launcher
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening: $url'),
        backgroundColor: AppColors.primaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showPostOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.borderColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.bookmark_outline,
                  color: AppColors.iconColor,
                ),
                title: const Text(
                  'Save post',
                  style: TextStyle(color: AppColors.textPrimary),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onBookmark();
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.link,
                  color: AppColors.iconColor,
                ),
                title: const Text(
                  'Copy link',
                  style: TextStyle(color: AppColors.textPrimary),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Copy link
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.person_add_outlined,
                  color: AppColors.iconColor,
                ),
                title: Text(
                  'Follow ${post.author.username}',
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Follow user
                },
              ),
              const Divider(color: AppColors.borderColor),
              ListTile(
                leading: const Icon(
                  Icons.report_outlined,
                  color: AppColors.error,
                ),
                title: const Text(
                  'Report post',
                  style: TextStyle(color: AppColors.error),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Report post
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}
