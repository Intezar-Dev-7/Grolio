import 'package:flutter/material.dart';
import 'package:frontend/utils/app_colors.dart';

class GoalCard extends StatelessWidget {
  final String title;
  final String time;
  final double progress;
  final String category;
  final bool completed;
  final VoidCallback onTap;

  const GoalCard({
    Key? key,
    required this.title,
    required this.time,
    required this.progress,
    required this.category,
    required this.completed,
    required this.onTap,
  }) : super(key: key);

  Color _getCategoryColor() {
    switch (category) {
      case 'work':
        return AppColors.yellow;
      case 'personal':
        return AppColors.purple;
      case 'team':
        return AppColors.secondary;
      case 'health':
        return AppColors.primary;
      default:
        return AppColors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Checkbox
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: completed ? AppColors.primary : AppColors.grey,
                  width: 2,
                ),
                color: completed ? AppColors.primary : Colors.transparent,
              ),
              child: completed
                  ? const Icon(
                Icons.check,
                size: 16,
                color: AppColors.white,
              )
                  : null,
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      decoration: completed ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: AppColors.greyLight,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        completed ? AppColors.primary : AppColors.textPrimary,
                      ),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Time and category
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getCategoryColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _getCategoryColor(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
