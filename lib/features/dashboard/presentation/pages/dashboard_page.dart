import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../calendar/data/models/task_model.dart';
import '../../../calendar/providers/task_providers.dart';
import '../../../calendar/presentation/widgets/task_card.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  List<TaskModel> _getUpcomingTasks(List<TaskModel> tasks) {
    final now = DateTime.now();
    return tasks
        .where((task) =>
            !task.isCompleted && task.deadline.isAfter(now))
        .toList()
      ..sort((a, b) => a.deadline.compareTo(b.deadline));
  }

  List<TaskModel> _getOverdueTasks(List<TaskModel> tasks) {
    final now = DateTime.now();
    return tasks
        .where((task) =>
            !task.isCompleted && task.deadline.isBefore(now))
        .toList()
      ..sort((a, b) => a.deadline.compareTo(b.deadline));
  }

  List<TaskModel> _getCompletedTasks(List<TaskModel> tasks) {
    return tasks.where((task) => task.isCompleted).toList()
      ..sort((a, b) => b.completedAt!.compareTo(a.completedAt!));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksStreamProvider);

    return Scaffold(
      body: tasksAsync.when(
        data: (tasks) {
          final upcomingTasks = _getUpcomingTasks(tasks);
          final overdueTasks = _getOverdueTasks(tasks);
          final completedTasks = _getCompletedTasks(tasks);
          final totalTasks = tasks.length;
          final completedCount = completedTasks.length;
          final completionRate = totalTasks > 0
              ? (completedCount / totalTasks * 100).toInt()
              : 0;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dashboard',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        title: 'Total Tasks',
                        value: totalTasks.toString(),
                        icon: Icons.task_alt,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _StatCard(
                        title: 'Completed',
                        value: completedCount.toString(),
                        icon: Icons.check_circle,
                        color: AppColors.success,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _StatCard(
                        title: 'Overdue',
                        value: overdueTasks.length.toString(),
                        icon: Icons.warning,
                        color: AppColors.error,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _StatCard(
                        title: 'Completion Rate',
                        value: '$completionRate%',
                        icon: Icons.trending_up,
                        color: AppColors.info,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                if (overdueTasks.isNotEmpty) ...[
                  _SectionHeader(
                    title: 'Overdue Tasks',
                    count: overdueTasks.length,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  ...overdueTasks.take(5).map((task) => TaskCard(task: task)),
                  const SizedBox(height: 32),
                ],
                if (upcomingTasks.isNotEmpty) ...[
                  _SectionHeader(
                    title: 'Upcoming Tasks',
                    count: upcomingTasks.length,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 16),
                  ...upcomingTasks.take(10).map((task) => TaskCard(task: task)),
                  const SizedBox(height: 32),
                ],
                if (completedTasks.isNotEmpty) ...[
                  _SectionHeader(
                    title: 'Recently Completed',
                    count: completedTasks.length,
                    color: AppColors.success,
                  ),
                  const SizedBox(height: 16),
                  ...completedTasks.take(5).map((task) => TaskCard(task: task)),
                ],
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}

class _StatCard extends StatefulWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered ? widget.color : AppColors.borderLight,
            width: _isHovered ? 2 : 1,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: widget.color.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: widget.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    widget.icon,
                    color: widget.color,
                    size: 24,
                  ),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              widget.value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimaryLight,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondaryLight,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;
  final Color color;

  const _SectionHeader({
    required this.title,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            count.toString(),
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
