import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/task_model.dart';
import '../../providers/task_providers.dart';
import '../widgets/calendar_grid.dart';
import '../widgets/task_card.dart';
import '../widgets/task_creation_dialog.dart';

class CalendarPage extends ConsumerWidget {
  const CalendarPage({super.key});

  List<TaskModel> _getTasksForSelectedDay(DateTime selectedDate, List<TaskModel> allTasks) {
    return allTasks.where((task) {
      return task.deadline.year == selectedDate.year &&
          task.deadline.month == selectedDate.month &&
          task.deadline.day == selectedDate.day;
    }).toList()
      ..sort((a, b) => a.deadline.compareTo(b.deadline));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksStreamProvider);
    final selectedDate = ref.watch(selectedDateProvider);

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: AppColors.borderLight),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Calendar',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 16),
                      const Expanded(child: CalendarGrid()),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: 1,
            color: AppColors.borderLight,
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat.EEEE().format(selectedDate),
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              DateFormat.yMMMd().format(selectedDate),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textSecondaryLight,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => TaskCreationDialog(
                              initialDate: selectedDate,
                            ),
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add Task'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  Expanded(
                    child: tasksAsync.when(
                      data: (allTasks) {
                        final tasksForDay = _getTasksForSelectedDay(selectedDate, allTasks);

                        if (tasksForDay.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.event_available,
                                  size: 64,
                                  color: AppColors.textSecondaryLight.withOpacity(0.3),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No tasks for this day',
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        color: AppColors.textSecondaryLight,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Click the + button or a calendar day to add tasks',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppColors.textSecondaryLight,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: tasksForDay.length,
                          itemBuilder: (context, index) {
                            return TaskCard(task: tasksForDay[index]);
                          },
                        );
                      },
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      error: (error, stack) => Center(
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
                              'Error loading tasks',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              error.toString(),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textSecondaryLight,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
