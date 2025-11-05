// features/profile/presentation/pages/profile_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/services/auth_service.dart';
import 'package:frontend/features/profile/presentation/widgets/profile_app_bar.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/profile_bloc.dart';
import '../widgets/profile_header.dart';
import '../widgets/pinned_projects_section.dart';
import '../widgets/tech_stack_section.dart';

class ProfilePage extends StatefulWidget {
  final String? userId;

  const ProfilePage({super.key, this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isCurrentUser = true;

  @override
  void initState() {
    super.initState();
    _checkIfCurrentUser();
    context.read<ProfileBloc>().add(
      ProfileLoadRequested(userId: widget.userId),
    );
  }

  Future<void> _checkIfCurrentUser() async {
    final isCurrentUser = await AuthService.isCurrentUser(widget.userId!);
    setState(() {
      _isCurrentUser = isCurrentUser;
    });
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
          final isOwnProfile = _isCurrentUser;

          return CustomScrollView(
            slivers: [
              // App Bar
              isOwnProfile
                  ? ProfileAppBar(widget: widget)
                  : SliverAppBar(
                    floating: true,
                    snap: true,
                    automaticallyImplyLeading: false,
                    backgroundColor: AppColors.backgroundDark,
                    elevation: 0,
                    actions: [
                      IconButton(
                        icon: const Icon(
                          Icons.more_vert,
                          color: AppColors.iconColor,
                        ),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 4),
                    ],
                    leading: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.iconColor,
                      ),
                    ),
                    title: Text(profile.name),
                  ),

              // Profile Header
              SliverToBoxAdapter(
                child: ProfileHeader(
                  profile: profile,
                  isOwnProfile: isOwnProfile,
                ),
              ),

              // Tech Stack Section
              SliverToBoxAdapter(
                child: TechStackSection(techStack: profile.techStack),
              ),

              // Projects Section
              SliverToBoxAdapter(
                child: ProjectsSection(projects: profile.pinnedProjects),
              ),
            ],
          );
        },
      ),
    );
  }
}
