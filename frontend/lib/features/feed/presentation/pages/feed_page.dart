// features/feed/presentation/pages/feed_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/feed_bloc.dart';
import '../widgets/feed_app_bar.dart';
import '../widgets/post_card.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Load feed on init
    context.read<FeedBloc>().add(const FeedLoadRequested());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      context.read<FeedBloc>().add(const FeedLoadMoreRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: BlocBuilder<FeedBloc, FeedState>(
        builder: (context, state) {
          if (state.status == FeedStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryGreen,
                ),
              ),
            );
          }

          if (state.status == FeedStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.errorMessage ?? 'An error occurred',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<FeedBloc>().add(const FeedLoadRequested());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<FeedBloc>().add(const FeedRefreshRequested());
            },
            color: AppColors.primaryGreen,
            backgroundColor: AppColors.surfaceDark,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                const FeedAppBar(),
                SliverPadding(
                  padding: const EdgeInsets.only(top: 8),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        if (index >= state.posts.length) {
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

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: PostCard(
                            post: state.posts[index],
                            onLike: () {
                              context.read<FeedBloc>().add(
                                PostLikeToggled(state.posts[index].id),
                              );
                            },
                            onBookmark: () {
                              context.read<FeedBloc>().add(
                                PostBookmarkToggled(state.posts[index].id),
                              );
                            },
                            onShare: () {
                              context.read<FeedBloc>().add(
                                PostShared(state.posts[index].id),
                              );
                            },
                          ),
                        );
                      },
                      childCount: state.status == FeedStatus.loadingMore
                          ? state.posts.length + 1
                          : state.posts.length,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
