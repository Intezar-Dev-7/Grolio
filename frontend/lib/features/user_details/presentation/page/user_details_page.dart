// features/user_details/presentation/pages/user_details_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../bloc/user_details_bloc.dart';
import '../widgets/user_cover_section.dart';
import '../widgets/user_info_section.dart';
import '../widgets/user_stats_card.dart';
import '../widgets/user_actions_section.dart';
import '../widgets/user_about_section.dart';
import '../widgets/user_tech_stack_section.dart';
import '../widgets/user_recent_posts_section.dart';

class UserDetailsPage extends StatefulWidget {
  final String userId;

  const UserDetailsPage({
    super.key,
    required this.userId,
  });

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  final ScrollController _scrollController = ScrollController();
  bool _showTitleBar = false;

  @override
  void initState() {
    super.initState();
    context.read<UserDetailsBloc>().add(
      UserDetailsLoadRequested(widget.userId),
    );
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Show title bar when scrolled past 100 pixels
    if (_scrollController.offset > 100 && !_showTitleBar) {
      setState(() {
        _showTitleBar = true;
      });
    } else if (_scrollController.offset <= 100 && _showTitleBar) {
      setState(() {
        _showTitleBar = false;
      });
    }
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

          if (state.status == UserDetailsStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.errorMessage ?? 'Failed to load user details',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.read<UserDetailsBloc>().add(
                        UserDetailsLoadRequested(widget.userId),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state.userDetails == null) {
            return const SizedBox.shrink();
          }

          final user = state.userDetails!;

          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              // ✅ Collapsing App Bar with user info
              SliverAppBar(
                expandedHeight: 250,
                pinned: true,
                backgroundColor: AppColors.backgroundDark,
                leading: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _showTitleBar
                          ? AppColors.surfaceDark
                          : Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                // ✅ Show user info in title when collapsed
                title: AnimatedOpacity(
                  opacity: _showTitleBar ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.primaryGreen.withOpacity(0.2),
                        backgroundImage: user.avatar != null
                            ? CachedNetworkImageProvider(user.avatar!)
                            : null,
                        child: user.avatar == null
                            ? Text(
                          user.name[0].toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.primaryGreen,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              user.name,
                              style: AppTypography.titleSmall.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              user.username,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 11,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _showTitleBar
                            ? AppColors.surfaceDark
                            : Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    onPressed: () {
                      _showOptionsBottomSheet(context);
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: UserCoverSection(user: user),
                ),
              ),


              SliverToBoxAdapter(
                child: UserInfoSection(user: user),
              ),

              // Stats Cards
              SliverToBoxAdapter(
                child: UserStatsCard(user: user),
              ),

              // Action Buttons
              SliverToBoxAdapter(
                child: UserActionsSection(user: user),
              ),

              // About Section
              SliverToBoxAdapter(
                child: UserAboutSection(user: user),
              ),

              // Tech Stack Section
              SliverToBoxAdapter(
                child: UserTechStackSection(techStack: user.techStack),
              ),

              // Recent Posts Section
              SliverToBoxAdapter(
                child: UserRecentPostsSection(posts: user.recentPosts),
              ),

              // Bottom padding
              const SliverToBoxAdapter(
                child: SizedBox(height: 80),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showOptionsBottomSheet(BuildContext context) {
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
              ListTile(
                leading: const Icon(
                  Icons.block,
                  color: AppColors.error,
                ),
                title: const Text(
                  'Block User',
                  style: TextStyle(color: AppColors.error),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showBlockConfirmation(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.report,
                  color: AppColors.warning,
                ),
                title: const Text(
                  'Report User',
                  style: TextStyle(color: AppColors.warning),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showReportDialog(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.share,
                  color: AppColors.iconColor,
                ),
                title: const Text(
                  'Share Profile',
                  style: TextStyle(color: AppColors.textPrimary),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement share
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showBlockConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: const Text(
          'Block User?',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          'This user will no longer be able to message you or see your posts.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<UserDetailsBloc>().add(
                const UserDetailsBlockRequested(),
              );
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text(
              'Block',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: const Text(
          'Report User?',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          'Please provide a reason for reporting this user. Our team will review it.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<UserDetailsBloc>().add(
                const UserDetailsReportRequested(),
              );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Report submitted'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text(
              'Report',
              style: TextStyle(color: AppColors.warning),
            ),
          ),
        ],
      ),
    );
  }
}
