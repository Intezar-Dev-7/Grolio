// features/devsnaps/presentation/pages/devsnaps_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class DevSnapsPage extends StatefulWidget {
  const DevSnapsPage({super.key});

  @override
  State<DevSnapsPage> createState() => _DevSnapsPageState();
}

class _DevSnapsPageState extends State<DevSnapsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Load data on init
    context.read<DevSnapBloc>().add(const DevSnapStoriesLoadRequested());
    // context.read<DevSnapBloc>().add(const DevSnapRecentLoadRequested());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      // Load more when reaching 90% of scroll
      // context.read<DevSnapBloc>().add(const DevSnapRecentLoadMoreRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<DevSnapBloc>().add(const DevSnapStoriesLoadRequested());
          // context.read<DevSnapBloc>().add(const DevSnapRecentLoadRequested());
        },
        color: AppColors.primaryGreen,
        backgroundColor: AppColors.surfaceDark,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // App Bar
            const DevSnapAppBar(),

            // Stories Section
            BlocBuilder<DevSnapBloc, DevSnapState>(
              builder: (context, state) {
                return SliverToBoxAdapter(
                  child: Container(
                    height: 110,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.stories.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return StoryCircle(
                            username: 'Your story',
                            initial: 'Y',
                            hasStory: false,
                            isAddStory: true,
                            onTap: () {
                              // Navigate to create DevSnap
                            },
                          );
                        }

                        final story = state.stories[index - 1];
                        return StoryCircle(
                          username: story.username,
                          initial: story.username[0].toUpperCase(),
                          hasStory: story.hasNewContent,
                          onTap: () {
                            // Navigate to story viewer
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            ),

            // DevSnaps Info Cards
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main header card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primaryGreen.withOpacity(0.15),
                            AppColors.primaryBlue.withOpacity(0.15),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primaryGreen.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.primaryGreen.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.bolt,
                              color: AppColors.primaryGreen,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'DevSnaps',
                                  style: AppTypography.titleLarge.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Share your dev moments',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Info cards
                    const DevSnapsInfoCard(
                      icon: Icons.camera_alt,
                      iconColor: Color(0xFF2196F3),
                      title: 'Share Developer Moments',
                      description:
                          'Capture and share your coding wins, workspace setups, and dev life with fellow developers. Add code snippets, text, or hashtags to your snaps.',
                    ),
                    const SizedBox(height: 12),
                    const DevSnapsInfoCard(
                      icon: Icons.access_time,
                      iconColor: Color(0xFFFFA726),
                      title: '24-Hour Stories',
                      description:
                          'All DevSnaps disappear after 24 hours. Snapshots freely without worrying about your feed getting cluttered with old content.',
                    ),
                    const SizedBox(height: 12),
                    const DevSnapsInfoCard(
                      icon: Icons.code,
                      iconColor: Color(0xFF4CAF93),
                      title: 'Developer Tools',
                      description:
                          'Add code snippets with syntax highlighting, tech stack hashtags, and custom text overlays to make your snaps unique.',
                    ),
                  ],
                ),
              ),
            ),

            /*// Recent DevSnaps Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Text(
                  'Recent DevSnaps',
                  style: AppTypography.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // ✅ Dynamic Recent DevSnaps Grid
            const RecentDevSnapsGrid(),*/
          ],
        ),
      ),
    );
  }
}
