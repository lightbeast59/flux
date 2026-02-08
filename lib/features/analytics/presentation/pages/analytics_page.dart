import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../models/task.dart';
import '../../../../providers/task_provider.dart';
import '../../../../providers/theme_provider.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<TaskProvider, ThemeProvider>(
      builder: (context, taskProvider, themeProvider, child) {
        final isDark = themeProvider.isDarkMode;
        final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
        final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
        final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
        final border = isDark ? AppColors.borderDark : AppColors.borderLight;

        if (taskProvider.isLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: AppColors.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Loading analytics...',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Analytics',
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Track your productivity and task progress',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: textSecondary,
                ),
              ),
              const SizedBox(height: 32),

              // Overview Stats
              _buildSectionTitle('Overview', textPrimary),
              const SizedBox(height: 16),
              _buildOverviewCards(taskProvider, isDark, surface, border, textPrimary, textSecondary),
              const SizedBox(height: 32),

              // Tasks by Status
              _buildSectionTitle('Tasks by Status', textPrimary),
              const SizedBox(height: 16),
              _buildStatusCards(taskProvider, isDark, surface, border, textPrimary, textSecondary),
              const SizedBox(height: 32),

              // Tasks by Priority
              _buildSectionTitle('Tasks by Priority', textPrimary),
              const SizedBox(height: 16),
              _buildPriorityCards(taskProvider, isDark, surface, border, textPrimary),
              const SizedBox(height: 32),

              // Completion Progress
              _buildSectionTitle('Completion Progress', textPrimary),
              const SizedBox(height: 16),
              _buildCompletionProgress(taskProvider, isDark, surface, border, textPrimary, textSecondary),
              const SizedBox(height: 32),

              // Recently Completed
              _buildSectionTitle('Recently Completed', textPrimary),
              const SizedBox(height: 16),
              _buildRecentlyCompleted(taskProvider, isDark, surface, border, textPrimary, textSecondary),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title, Color textColor) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
    );
  }

  Widget _buildOverviewCards(
    TaskProvider taskProvider,
    bool isDark,
    Color surface,
    Color border,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _StatCard(
          title: 'Total Tasks',
          value: taskProvider.totalTasks.toString(),
          icon: Icons.task_alt,
          iconColor: AppColors.primary,
          isDark: isDark,
          surface: surface,
          border: border,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
        ),
        _StatCard(
          title: 'Completion Rate',
          value: '${taskProvider.completionRate.toStringAsFixed(1)}%',
          icon: Icons.percent,
          iconColor: AppColors.success,
          isDark: isDark,
          surface: surface,
          border: border,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
        ),
        _StatCard(
          title: 'Active Tasks',
          value: (taskProvider.assignedTasksCount + taskProvider.inProgressTasksCount).toString(),
          icon: Icons.pending_actions,
          iconColor: AppColors.warning,
          isDark: isDark,
          surface: surface,
          border: border,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
        ),
        _StatCard(
          title: 'Completed',
          value: taskProvider.completedTasksCount.toString(),
          icon: Icons.check_circle,
          iconColor: AppColors.success,
          isDark: isDark,
          surface: surface,
          border: border,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
        ),
      ],
    );
  }

  Widget _buildStatusCards(
    TaskProvider taskProvider,
    bool isDark,
    Color surface,
    Color border,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Row(
      children: [
        Expanded(
          child: _StatusCard(
            title: 'Assigned',
            count: taskProvider.assignedTasksCount,
            color: const Color(0xFF3B82F6),
            icon: Icons.assignment,
            isDark: isDark,
            surface: surface,
            border: border,
            textPrimary: textPrimary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StatusCard(
            title: 'In Progress',
            count: taskProvider.inProgressTasksCount,
            color: const Color(0xFFF97316),
            icon: Icons.pending,
            isDark: isDark,
            surface: surface,
            border: border,
            textPrimary: textPrimary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StatusCard(
            title: 'Completed',
            count: taskProvider.completedTasksCount,
            color: const Color(0xFF10B981),
            icon: Icons.check_circle,
            isDark: isDark,
            surface: surface,
            border: border,
            textPrimary: textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildPriorityCards(
    TaskProvider taskProvider,
    bool isDark,
    Color surface,
    Color border,
    Color textPrimary,
  ) {
    final priorityCounts = taskProvider.tasksByPriorityCount;
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: TaskPriority.values.map((priority) {
        return _PriorityCard(
          priority: priority,
          count: priorityCounts[priority] ?? 0,
          isDark: isDark,
          surface: surface,
          border: border,
          textPrimary: textPrimary,
        );
      }).toList(),
    );
  }

  Widget _buildCompletionProgress(
    TaskProvider taskProvider,
    bool isDark,
    Color surface,
    Color border,
    Color textPrimary,
    Color textSecondary,
  ) {
    final completionRate = taskProvider.completionRate;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Overall Progress',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                ),
              ),
              Text(
                '${completionRate.toStringAsFixed(1)}%',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: completionRate / 100,
              minHeight: 12,
              backgroundColor: isDark ? AppColors.borderDark : const Color(0xFFE5E7EB),
              valueColor: AlwaysStoppedAnimation<Color>(
                completionRate >= 75
                    ? AppColors.success
                    : completionRate >= 50
                        ? AppColors.warning
                        : AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            taskProvider.totalTasks == 0
                ? 'Create tasks to start tracking your progress'
                : '${taskProvider.completedTasksCount} of ${taskProvider.totalTasks} tasks completed',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentlyCompleted(
    TaskProvider taskProvider,
    bool isDark,
    Color surface,
    Color border,
    Color textPrimary,
    Color textSecondary,
  ) {
    final recentTasks = taskProvider.getRecentlyCompleted(limit: 5);

    if (recentTasks.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 48,
                color: textSecondary,
              ),
              const SizedBox(height: 16),
              Text(
                'No completed tasks yet',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Complete tasks to see them here',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: recentTasks.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          color: border,
        ),
        itemBuilder: (context, index) {
          final task = recentTasks[index];
          return ListTile(
            leading: Container(
              width: 8,
              height: 40,
              decoration: BoxDecoration(
                color: task.color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            title: Text(
              task.name,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: textPrimary,
                decoration: TextDecoration.lineThrough,
              ),
            ),
            subtitle: Text(
              task.description,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Icon(
              Icons.check_circle,
              color: AppColors.success,
            ),
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  final bool isDark;
  final Color surface;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.isDark,
    required this.surface,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final String title;
  final int count;
  final Color color;
  final IconData icon;
  final bool isDark;
  final Color surface;
  final Color border;
  final Color textPrimary;

  const _StatusCard({
    required this.title,
    required this.count,
    required this.color,
    required this.icon,
    required this.isDark,
    required this.surface,
    required this.border,
    required this.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 32,
          ),
          const SizedBox(height: 12),
          Text(
            count.toString(),
            style: GoogleFonts.inter(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _PriorityCard extends StatelessWidget {
  final TaskPriority priority;
  final int count;
  final bool isDark;
  final Color surface;
  final Color border;
  final Color textPrimary;

  const _PriorityCard({
    required this.priority,
    required this.count,
    required this.isDark,
    required this.surface,
    required this.border,
    required this.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: priority.color.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: priority.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              priority.icon,
              color: priority.color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                count.toString(),
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
              Text(
                priority.label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: priority.color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
