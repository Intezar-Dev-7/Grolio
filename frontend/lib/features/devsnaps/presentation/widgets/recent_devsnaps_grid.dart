// features/devsnaps/presentation/widgets/recent_devsnaps_grid.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/devsnaps/presentation/widgets/devsnap_card.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/devsnap_entity.dart';
import '../bloc/devsnap_bloc.dart';

class RecentDevSnapsGrid extends StatelessWidget {
  const RecentDevSnapsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DevSnapBloc, DevSnapState>(
      builder: (context, state) {
        // Show loading
        if (state.status == DevSnapStatus.loading && state.recentSnaps.isEmpty) {
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primaryGreen,
                  ),
                ),
              ),
            ),
          );
        }

        // Show error
        if (state.status == DevSnapStatus.error && state.recentSnaps.isEmpty) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Column(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.errorMessage ?? 'Failed to load DevSnaps',
                      style: const TextStyle(color: AppColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<DevSnapBloc>().add(
                          const DevSnapRecentLoadRequested(),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // Show empty state
        if (state.recentSnaps.isEmpty) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.photo_library_outlined,
                      size: 64,
                      color: AppColors.textTertiary.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No DevSnaps yet',
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Be the first to share your dev moments!',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // ✅ Show dynamic data from BLoC
        return SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                // Show loading indicator at the end while loading more
                if (index == state.recentSnaps.length) {
                  if (state.status == DevSnapStatus.loadingMore) {
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.surfaceDark,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primaryGreen,
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }

                final snap = state.recentSnaps[index];
                return DevSnapCard(
                  snap: snap,
                  onTap: () {
                    // TODO: Open DevSnap viewer
                    _showDevSnapViewer(context, snap);
                  },
                );
              },
              childCount: state.status == DevSnapStatus.loadingMore
                  ? state.recentSnaps.length + 1
                  : state.recentSnaps.length,
            ),
          ),
        );
      },
    );
  }

  void _showDevSnapViewer(BuildContext context, DevSnapEntity snap) {
    // TODO: Navigate to full-screen DevSnap viewer
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening DevSnap by ${snap.username}'),
        backgroundColor: AppColors.primaryGreen,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
