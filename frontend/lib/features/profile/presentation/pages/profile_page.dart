// features/profile/presentation/pages/profile_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/profile/presentation/widgets/profile_app_bar.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/profile_bloc.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_tabs.dart';
import '../widgets/achievements_section.dart';
import '../widgets/pinned_projects_section.dart';
import '../widgets/stats_progress_section.dart';
import '../widgets/tech_stack_section.dart';

class ProfilePage extends StatefulWidget {
  final String? userId;

  const ProfilePage({
    super.key,
    this.userId,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(ProfileLoadRequested(userId: widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state.status == ProfileStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryGreen,
                ),
              ),
            );
          }

          if (state.status == ProfileStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.errorMessage ?? 'Failed to load profile',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProfileBloc>().add(
                        ProfileLoadRequested(userId: widget.userId),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state.profile == null) {
            return const SizedBox.shrink();
          }

          final profile = state.profile!;
          final isOwnProfile = widget.userId == null;

          return CustomScrollView(
            slivers: [
              // App Bar
              ProfileAppBar(widget: widget),

              // Profile Header
              SliverToBoxAdapter(
                child: ProfileHeader(
                  profile: profile,
                  isOwnProfile: isOwnProfile,
                  onFollowTap: () {
                    if (!isOwnProfile) {
                      context.read<ProfileBloc>().add(
                        ProfileFollowToggled(profile.id),
                      );
                    }
                  },
                ),
              ),

              // Profile Tabs (Feed, Projects, About)
              const SliverToBoxAdapter(
                child: ProfileTabs(),
              ),

              // Achievements Section
              SliverToBoxAdapter(
                child: AchievementsSection(
                  achievements: profile.achievements,
                ),
              ),

              // Stats & Progress Section
              SliverToBoxAdapter(
                child: StatsProgressSection(
                  stats: profile.stats,
                ),
              ),

              // Tech Stack Section
              SliverToBoxAdapter(
                child: TechStackSection(
                  techStack: profile.techStack,
                ),
              ),

              // Pinned Projects Section
              SliverToBoxAdapter(
                child: PinnedProjectsSection(
                  projects: profile.pinnedProjects,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
