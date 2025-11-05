// features/user_details/presentation/pages/whatsapp_style_user_profile.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:frontend/features/user_details/presentation/widgets/user_bottom_actions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/services/auth_service.dart';
import '../bloc/user_details_bloc.dart';
import '../widgets/profile_action_button.dart';
import '../widgets/media_gallery_preview.dart';
import '../widgets/profile_settings_tile.dart';

class UserProfile extends StatefulWidget {
  final String userId;

  const UserProfile({super.key, required this.userId});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool _isCurrentUser = false;

  @override
  void initState() {
    super.initState();
    _checkIfCurrentUser();
    context.read<UserDetailsBloc>().add(
      UserDetailsLoadRequested(widget.userId),
    );
  }

  Future<void> _checkIfCurrentUser() async {
    final isCurrentUser = await AuthService.isCurrentUser(widget.userId);
    setState(() {
      _isCurrentUser = isCurrentUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: BlocBuilder<UserDetailsBloc, UserDetailsState>(
        builder: (context, state) {
          if (state.status == UserDetailsStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryGreen,
                ),
              ),
            );
          }

          if (state.status == UserDetailsStatus.error ||
              state.userProfile == null) {
            return const Center(child: Text('Failed to load user profile'));
          }

          final profile = state.userProfile!;

          return CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                backgroundColor: AppColors.backgroundDark,
                elevation: 0,
                pinned: true,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_rounded,
                    color: AppColors.iconColor,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(
                      Icons.more_vert,
                      color: AppColors.iconColor,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),

              // Profile Section
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // Profile Picture
                    GestureDetector(
                      onTap: () {
                        // TODO: Show full screen image
                      },
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: AppColors.primaryGreen.withOpacity(
                          0.2,
                        ),
                        backgroundImage:
                            profile.avatar != null
                                ? CachedNetworkImageProvider(profile.avatar!)
                                : null,
                        child:
                            profile.avatar == null
                                ? Text(
                                  profile.name[0].toUpperCase(),
                                  style: const TextStyle(
                                    color: AppColors.primaryGreen,
                                    fontSize: 60,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                                : null,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Name
                    Text(
                      profile.name,
                      style: AppTypography.headlineMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Phone Number (or username)
                    Text(
                      '${profile.username}', // or use actual phone
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Bio/Status
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        profile.bio,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 24),

                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              profile.isFollowing
                                  ? AppColors.surfaceDark
                                  : AppColors.primaryGreen,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color:
                                  profile.isFollowing
                                      ? AppColors.borderColor
                                      : AppColors.primaryGreen,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          context.read<UserDetailsBloc>().add(
                            UserDetailsFollowToggled(profile.id),
                          );
                        },
                        child: Text(
                          profile.isFollowing ? 'UNFOLLOW' : 'FOLLOW',
                          style: TextStyle(
                            color:
                                profile.isFollowing
                                    ? AppColors.textPrimary
                                    : Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Action Buttons Row
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ProfileActionButton(
                            icon: Icons.call,
                            label: 'Audio',
                            onTap: () {
                              // TODO: Implement audio call
                            },
                          ),
                          ProfileActionButton(
                            icon: Icons.videocam,
                            label: 'Video',
                            onTap: () {
                              // TODO: Implement video call
                            },
                          ),
                          ProfileActionButton(
                            icon: Icons.search,
                            label: 'Search',
                            onTap: () {
                              // TODO: Implement search in chat
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Media, links, and docs
                    MediaGalleryPreview(userId: profile.id),

                    const SizedBox(height: 8),

                    // Settings Sections
                    ProfileSettingsTile(
                      icon: Icons.notifications_outlined,
                      title: 'Notifications',
                      onTap: () {
                        // TODO: Navigate to notifications settings
                      },
                    ),
                    ProfileSettingsTile(
                      icon: Icons.image_outlined,
                      title: 'Media visibility',
                      onTap: () {
                        // TODO: Navigate to media visibility settings
                      },
                    ),
                    /*ProfileSettingsTile(
                      icon: Icons.lock_outline,
                      title: 'Encryption',
                      subtitle:
                      'Messages and calls are end-to-end encrypted. Tap to verify.',
                      onTap: () {
                        // TODO: Show encryption info
                      },
                    ),*/
                    ProfileSettingsTile(
                      icon: Icons.timer_outlined,
                      title: 'Disappearing messages',
                      subtitle: 'Off',
                      onTap: () {
                        // TODO: Configure disappearing messages
                      },
                    ),
                    /*ProfileSettingsTile(
                      icon: Icons.lock_person_outlined,
                      title: 'Chat lock',
                      subtitle: 'Lock and hide this chat on this device.',
                      trailing: Switch(
                        value: false,
                        onChanged: (value) {
                          // TODO: Toggle chat lock
                        },
                        activeColor: AppColors.primaryGreen,
                      ),
                      onTap: null,
                    ),
                    ProfileSettingsTile(
                      icon: Icons.shield_outlined,
                      title: 'Advanced chat privacy',
                      subtitle: 'Off',
                      onTap: () {
                        // TODO: Advanced privacy settings
                      },
                    ),*/
                    const SizedBox(height: 16),
                    UserBottomActions(
                      userName: profile.name,
                      onAddToFavourites: () {
                        _addToFavourites(context);
                      },
                      onAddToList: () {
                        _addToList(context);
                      },
                      onBlock: () {
                        _blockUser(context);
                      },
                      onReport: () {
                        _reportUser(context);
                      },
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _addToFavourites(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.surfaceDark,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: AppColors.primaryGreen,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Add to Favourites',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: Text(
              'Add this contact to your favourites list for quick access?',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // TODO: Implement add to favourites
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Added to favourites'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                },
                child: Text(
                  'Add',
                  style: TextStyle(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  void _addToList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.borderColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Add to List',
                  style: AppTypography.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: AppColors.primaryGreen,
                    size: 20,
                  ),
                ),
                title: const Text('Create new list'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Create new list
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.work_outline,
                    color: AppColors.primaryBlue,
                    size: 20,
                  ),
                ),
                title: const Text('Work'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Add to work list
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.group_outlined,
                    color: AppColors.warning,
                    size: 20,
                  ),
                ),
                title: const Text('Friends'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Add to friends list
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _blockUser(BuildContext context) {
    final user = context.read<UserDetailsBloc>().state.userProfile;
    if (user == null) return;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.surfaceDark,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.block,
                    color: AppColors.error,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Block ${user.name}?',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: Text(
              'Blocked contacts will no longer be able to call you or send you messages. This contact will not be notified.',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<UserDetailsBloc>().add(
                    const UserDetailsBlockRequested(),
                  );
                  // Navigate back to previous screen
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${user.name} has been blocked'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                },
                child: Text(
                  'Block',
                  style: TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  void _reportUser(BuildContext context) {
    final user = context.read<UserDetailsBloc>().state.userProfile;
    if (user == null) return;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.surfaceDark,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.report_outlined,
                    color: AppColors.error,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Report ${user.name}?',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What\'s wrong with this contact?',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                _buildReportOption('Spam', Icons.message),
                _buildReportOption('Harassment', Icons.person_off),
                _buildReportOption('Inappropriate content', Icons.block),
                _buildReportOption('Fake account', Icons.person_outline),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildReportOption(String label, IconData icon) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        context.read<UserDetailsBloc>().add(const UserDetailsReportRequested());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Report submitted. Thank you for your feedback.'),
            backgroundColor: AppColors.success,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.iconColor),
            const SizedBox(width: 12),
            Text(label, style: AppTypography.bodyMedium),
          ],
        ),
      ),
    );
  }
}
