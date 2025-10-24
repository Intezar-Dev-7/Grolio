import 'package:flutter/material.dart';
import 'package:frontend/features/home/widgets/action_button_grid.dart';
import 'package:frontend/utils/app_colors.dart';
import '../widgets/goal_card.dart';
import '../widgets/stats_card.dart';
import '../widgets/day_streak_card.dart';
import '../widgets/motivation_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _todayGoals = [
    {
      'title': 'Complete morning workout',
      'time': '8:00 AM',
      'progress': 1.0,
      'category': 'health',
      'completed': true,
    },
    {
      'title': 'Review team project proposal',
      'time': '2:00 PM',
      'progress': 0.65,
      'category': 'work',
      'completed': false,
    },
  ];

  final List<Map<String, dynamic>> _allGoals = [
    {
      'title': 'Review team project proposal',
      'time': '2:00 PM',
      'progress': 0.65,
      'category': 'work',
      'completed': false,
    },
    {
      'title': 'Call mom and catch up',
      'time': '6:00 PM',
      'progress': 0.0,
      'category': 'personal',
      'completed': false,
    },
    {
      'title': 'Collaborate on marketing strategy',
      'time': '4:30 PM',
      'progress': 0.30,
      'category': 'team',
      'completed': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: _currentIndex == 0 ? _buildHomeContent() : _buildPlaceholder(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('Add new goal');
        },
        backgroundColor: AppColors.secondary,
        child: const Icon(Icons.add, color: AppColors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(),
            const SizedBox(height: 24),

            // Day Streak Card (from second screenshot)
            DayStreakCard(
              streakDays: 7,
              totalGoals: 4,
              completedGoals: 1,
              progress: 0.25,
            ),
            const SizedBox(height: 16),

            // Action Button Grid (from second screenshot)
            const ActionButtonGrid(),
            const SizedBox(height: 16),

            // Motivation Card (from second screenshot)
            const MotivationCard(
              message: 'Progress, not perfection. You\'re doing great!',
              emoji: '🎯',
            ),
            const SizedBox(height: 24),

            // Today's Goals Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Today\'s Goals',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, size: 20),
                  onPressed: () {
                    print('Refresh goals');
                  },
                  color: AppColors.textPrimary,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Today's Goals List
            ..._todayGoals.map((goal) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GoalCard(
                  title: goal['title'],
                  time: goal['time'],
                  progress: goal['progress'],
                  category: goal['category'],
                  completed: goal['completed'],
                  onTap: () {
                    print('Goal tapped: ${goal['title']}');
                  },
                ),
              );
            }).toList(),

            const SizedBox(height: 24),

            // All Goals Section (from first screenshot)
            const Text(
              'All Goals',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            // All Goals List
            ..._allGoals.map((goal) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GoalCard(
                  title: goal['title'],
                  time: goal['time'],
                  progress: goal['progress'],
                  category: goal['category'],
                  completed: goal['completed'],
                  onTap: () {
                    print('Goal tapped: ${goal['title']}');
                  },
                ),
              );
            }).toList(),

            const SizedBox(height: 16),

            // Tip Card (from first screenshot)
            _buildTipCard(),
            const SizedBox(height: 24),

            // Weekly Stats (from first screenshot)
            _buildWeeklyStats(),
            const SizedBox(height: 100), // Space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Good morning! ',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const Text(
                  '👋',
                  style: TextStyle(fontSize: 22),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Ready to crush your goals today?',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {
                    print('Notifications');
                  },
                  color: AppColors.textPrimary,
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () {
                print('Settings');
              },
              color: AppColors.textPrimary,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTipCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.yellow.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.yellow.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Text('💡', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Tip: Swipe left on a goal to delete it',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'This Week',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Icon(
              Icons.trending_up,
              color: AppColors.primary,
              size: 20,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            StatsCard(
              value: '24',
              label: 'Goals\nCompleted',
              color: AppColors.primary,
            ),
            const SizedBox(width: 12),
            StatsCard(
              value: '3',
              label: 'Team\nCollaborations',
              color: AppColors.secondary,
            ),
            const SizedBox(width: 12),
            StatsCard(
              value: '180',
              label: 'Points Earned',
              color: AppColors.orange,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    String title = '';
    switch (_currentIndex) {
      case 1:
        title = 'Circles';
        break;
      case 2:
        title = 'Chat';
        break;
      case 3:
        title = 'Profile';
        break;
    }

    return Center(
      child: Text(
        '$title Screen',
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomAppBar(
        color: AppColors.white,
        elevation: 0,
        notchMargin: 8,
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 'Home', 0),
              _buildNavItem(Icons.groups_outlined, 'Circles', 1),
              const SizedBox(width: 40),
              _buildNavItem(Icons.chat_bubble_outline, 'Chat', 2),
              _buildNavItem(Icons.person_outline, 'Profile', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isActive = _currentIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive ? AppColors.primary : AppColors.grey,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? AppColors.primary : AppColors.grey,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
