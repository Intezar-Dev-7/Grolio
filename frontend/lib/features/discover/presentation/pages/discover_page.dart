// features/discover/presentation/pages/discover_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/discover/presentation/widgets/discover_app_bar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../bloc/discover_bloc.dart';
import '../widgets/discover_tabs.dart';
import '../widgets/developer_card.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<DiscoverBloc>().add(const DiscoverLoadRequested());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      context.read<DiscoverBloc>().add(const DiscoverLoadMoreRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<DiscoverBloc>().add(const DiscoverRefreshRequested());
        },
        color: AppColors.primaryGreen,
        backgroundColor: AppColors.surfaceDark,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            const DiscoverAppBar(),

            // Tabs (Projects, Events)
            const DiscoverTabs(),

            // AI Recommended Developers Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Row(
                  children: [
                    BlocBuilder<DiscoverBloc, DiscoverState>(
                      builder: (context, state) {
                        if (state.selectedTechFilters.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Based on your tech stack ${state.selectedTechFilters.join(', ')}',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.primaryGreen,
                              fontSize: 11,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Developer Cards List
            BlocBuilder<DiscoverBloc, DiscoverState>(
              builder: (context, state) {
                if (state.status == DiscoverStatus.loading) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primaryGreen,
                        ),
                      ),
                    ),
                  );
                }

                if (state.status == DiscoverStatus.error) {
                  return SliverFillRemaining(
                    child: Center(
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
                            state.errorMessage ?? 'An error occurred',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<DiscoverBloc>().add(
                                const DiscoverLoadRequested(),
                              );
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (state.developers.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 64,
                            color: AppColors.textTertiary,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No developers found',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index == state.developers.length) {
                          if (state.status == DiscoverStatus.loadingMore) {
                            return const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primaryGreen,
                                  ),
                                ),
                              ),
                            );
                          }
                          return const SizedBox(height: 80);
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: DeveloperCard(
                            developer: state.developers[index],
                            onFollowTap: () {
                              context.read<DiscoverBloc>().add(
                                DeveloperFollowToggled(
                                  state.developers[index].id,
                                ),
                              );
                            },
                          ),
                        );
                      },
                      childCount:
                          state.status == DiscoverStatus.loadingMore
                              ? state.developers.length + 1
                              : state.developers.length + 1,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
