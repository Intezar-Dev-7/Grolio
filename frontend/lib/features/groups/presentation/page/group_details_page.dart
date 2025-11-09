// features/groups/presentation/pages/group_details_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/services/auth_service.dart';
import '../bloc/group_details_bloc.dart';
import '../widgets/group_media_preview.dart';
import '../widgets/group_member_tile.dart';
import '../widgets/group_actions_section.dart';

class GroupDetailsPage extends StatefulWidget {
  final String groupId;

  const GroupDetailsPage({
    super.key,
    required this.groupId,
  });

  @override
  State<GroupDetailsPage> createState() => _GroupDetailsPageState();
}

class _GroupDetailsPageState extends State<GroupDetailsPage> {
  @override
  void initState() {
    super.initState();
    context.read<GroupDetailsBloc>().add(
      GroupDetailsLoadRequested(widget.groupId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: BlocConsumer<GroupDetailsBloc, GroupDetailsState>(
        listener: (context, state) {
          if (state.status == GroupDetailsStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'An error occurred'),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == GroupDetailsStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryGreen,
                ),
              ),
            );
          }

          if (state.status == GroupDetailsStatus.error || state.group == null) {
            return const Center(
              child: Text('Failed to load group details'),
            );
          }

          final group = state.group!;

          return CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                backgroundColor: AppColors.backgroundDark,
                elevation: 0,
                pinned: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.iconColor),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.more_vert, color: AppColors.iconColor),
                    onPressed: () => _showOptionsMenu(context, group),
                  ),
                ],
              ),

              // Group Info Section
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // Group Avatar
                    GestureDetector(
                      onTap: () {
                        // TODO: Show full screen image
                      },
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 80,
                            backgroundColor: AppColors.primaryBlue.withOpacity(0.2),
                            backgroundImage: group.avatar != null
                                ? CachedNetworkImageProvider(group.avatar!)
                                : null,
                            child: group.avatar == null
                                ? const Icon(
                              Icons.group,
                              size: 60,
                              color: AppColors.primaryBlue,
                            )
                                : null,
                          ),
                          // Edit icon (only for admins)
                          if (group.isAdmin)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  // TODO: Change group icon
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryGreen,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.backgroundDark,
                                      width: 3,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Group Name
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        group.name,
                        style: AppTypography.headlineMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Group created info
                    Text(
                      'Group • ${group.membersCount} participants',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Group Description (if exists)
                    if (group.description != null && group.description!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.info_outline,
                                  size: 20,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Group description',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              group.description!,
                              style: AppTypography.bodyMedium,
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),

                    // Media, links, and docs
                    GroupMediaPreview(groupId: group.id),

                    const SizedBox(height: 16),

                    // Mute notifications
                    _buildSettingTile(
                      icon: Icons.notifications_off_outlined,
                      title: 'Mute notifications',
                      trailing: Switch(
                        value: false,
                        onChanged: (value) {
                          // TODO: Toggle mute
                        },
                        activeColor: AppColors.primaryGreen,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Participants Section
                    _buildSectionHeader(
                      '${group.membersCount} Participants',
                      onTap: group.isAdmin
                          ? () => _showAddMemberDialog(context)
                          : null,
                    ),

                    // Add participants button (only for members)
                    if (group.isMember)
                      _buildActionTile(
                        icon: Icons.person_add,
                        iconColor: AppColors.primaryGreen,
                        title: 'Add participants',
                        onTap: () => _showAddMemberDialog(context),
                      ),

                    // Participants List
                    ...group.members.map(
                          (member) => GroupMemberTile(
                        member: member,
                        isCurrentUserAdmin: group.isAdmin,
                        onTap: () {
                          // Navigate to user profile
                        },
                        onLongPress: group.isAdmin
                            ? () => _showMemberOptions(context, member, group)
                            : null,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Group Actions
                    GroupActionsSection(
                      groupName: group.name,
                      isAdmin: group.isAdmin,
                      isMember: group.isMember,
                      onExitGroup: () => _exitGroup(context),
                      onReportGroup: () => _reportGroup(context),
                    ),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.iconColor, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          if (onTap != null)
            IconButton(
              icon: const Icon(Icons.add, color: AppColors.primaryGreen),
              onPressed: onTap,
              iconSize: 24,
            ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOptionsMenu(BuildContext context, group) {
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
              if (group.isAdmin) ...[
                ListTile(
                  leading: const Icon(Icons.edit, color: AppColors.iconColor),
                  title: const Text('Edit group info'),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Edit group
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.link, color: AppColors.iconColor),
                  title: const Text('Group invite link'),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Show invite link
                  },
                ),
              ],
              ListTile(
                leading: const Icon(Icons.favorite_outline, color: AppColors.iconColor),
                title: const Text('Add to favourites'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Add to favourites
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showAddMemberDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Add Participants',
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                style: AppTypography.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Search contacts',
                  prefixIcon: const Icon(Icons.search, color: AppColors.iconColor),
                  filled: true,
                  fillColor: AppColors.backgroundDark,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.borderColor),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // TODO: Show list of contacts to add
              const Text('Select contacts to add...'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Add selected members
            },
            child: const Text(
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

  void _showMemberOptions(BuildContext context, member, group) {
    final isCurrentUser = member.id == 'current_user_id'; // TODO: Check with AuthService

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
                  member.name,
                  style: AppTypography.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.message, color: AppColors.iconColor),
                title: const Text('Message'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Open chat with member
                },
              ),
              ListTile(
                leading: const Icon(Icons.person, color: AppColors.iconColor),
                title: const Text('View profile'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to user profile
                },
              ),
              if (group.isAdmin && !isCurrentUser) ...[
                const Divider(color: AppColors.borderColor),
                if (!member.isAdmin)
                  ListTile(
                    leading: const Icon(
                      Icons.admin_panel_settings,
                      color: AppColors.primaryGreen,
                    ),
                    title: const Text('Make group admin'),
                    onTap: () {
                      Navigator.pop(context);
                      context.read<GroupDetailsBloc>().add(
                        GroupDetailsAdminPromoted(member.id),
                      );
                    },
                  )
                else
                  ListTile(
                    leading: const Icon(
                      Icons.remove_moderator,
                      color: AppColors.warning,
                    ),
                    title: const Text('Dismiss as admin'),
                    onTap: () {
                      Navigator.pop(context);
                      context.read<GroupDetailsBloc>().add(
                        GroupDetailsAdminDemoted(member.id),
                      );
                    },
                  ),
                ListTile(
                  leading: const Icon(Icons.person_remove, color: AppColors.error),
                  title: const Text('Remove from group'),
                  onTap: () {
                    Navigator.pop(context);
                    _confirmRemoveMember(context, member);
                  },
                ),
              ],
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _confirmRemoveMember(BuildContext context, member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Remove ${member.name}?',
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to remove this member from the group?',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<GroupDetailsBloc>().add(
                GroupDetailsMemberRemoved(member.id),
              );
            },
            child: const Text(
              'Remove',
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

  void _exitGroup(BuildContext context) {
    final group = context.read<GroupDetailsBloc>().state.group;
    if (group == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Exit Group?',
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          group.isAdmin
              ? 'You are an admin of this group. If you exit, you will no longer be an admin. Are you sure you want to exit?'
              : 'Are you sure you want to exit "${group.name}"?',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<GroupDetailsBloc>().add(
                const GroupDetailsExitRequested(),
              );
              Navigator.pop(context); // Go back to chat list
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('You have left "${group.name}"'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text(
              'Exit',
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

  void _reportGroup(BuildContext context) {
    // Similar to user report dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
            const Text('Report Group'),
          ],
        ),
        content: const Text('Report this group for inappropriate content?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<GroupDetailsBloc>().add(
                const GroupDetailsReportRequested(),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Group reported. Thank you for your feedback.'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text(
              'Report',
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
}
