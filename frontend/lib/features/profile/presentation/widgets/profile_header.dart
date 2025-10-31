// features/profile/presentation/widgets/profile_header.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/user_profile_entity.dart';

class ProfileHeader extends StatelessWidget {
  final UserProfileEntity profile;
  final bool isOwnProfile;
  final VoidCallback onFollowTap;

  const ProfileHeader({
    super.key,
    required this.profile,
    required this.isOwnProfile,
    required this.onFollowTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.primaryGreen.withOpacity(0.2),
                backgroundImage: profile.avatar != null
                    ? CachedNetworkImageProvider(profile.avatar!)
                    : null,
                child: profile.avatar == null
                    ? Text(
                  profile.name[0].toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                )
                    : null,
              ),

              const SizedBox(width: 16),

              // Name, username, stats
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.name,
                      style: AppTypography.headlineSmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      profile.username,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildStat(
                          context,
                          profile.followersCount.toString(),
                          'Followers',
                        ),
                        const SizedBox(width: 20),
                        _buildStat(
                          context,
                          profile.followingCount.toString(),
                          'Following',
                        ),
                        const SizedBox(width: 20),
                        _buildStat(
                          context,
                          profile.postsCount.toString(),
                          'Posts',
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Follow/Edit button
              isOwnProfile
                  ? Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryButtonGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 20,
                ),
              )
                  : Container(
                decoration: BoxDecoration(
                  color: profile.isFollowing
                      ? AppColors.surfaceDark
                      : AppColors.primaryGreen,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: profile.isFollowing
                        ? AppColors.borderColor
                        : AppColors.primaryGreen,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onFollowTap,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Icon(
                        profile.isFollowing ? Icons.check : Icons.add,
                        color: profile.isFollowing
                            ? AppColors.textPrimary
                            : Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Bio
          Text(
            profile.bio,
            style: AppTypography.bodyMedium.copyWith(
              height: 1.5,
            ),
          ),

          const SizedBox(height: 16),

          // Social Links
          Row(
            children: [
              if (profile.socialLinks.isNotEmpty)
                ...profile.socialLinks.map((link) {
                  IconData icon;
                  if (link.contains('github')) {
                    icon = Icons.code;
                  } else if (link.contains('twitter')) {
                    icon = Icons.tag;
                  } else {
                    icon = Icons.link;
                  }

                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () async {
                        final uri = Uri.parse(link);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceDark,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.borderColor,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              icon,
                              size: 16,
                              color: AppColors.primaryGreen,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              link.contains('github')
                                  ? 'GitHub'
                                  : link.contains('twitter')
                                  ? 'Twitter'
                                  : 'Link',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
