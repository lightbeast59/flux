import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/task_model.dart';
import '../../providers/task_providers.dart';
import 'task_creation_dialog.dart';

class CalendarGrid extends ConsumerStatefulWidget {
  const CalendarGrid({super.key});

  @override
  ConsumerState<CalendarGrid> createState() => _CalendarGridState();
}

class _CalendarGridState extends ConsumerState<CalendarGrid> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();

  List<TaskModel> _getTasksForDay(DateTime day, List<TaskModel> allTasks) {
    return allTasks.where((task) {
      return isSameDay(task.deadline, day);
    }).toList();
  }

  Future<void> _showTaskCreationDialog(DateTime selectedDay) async {
    await showDialog(
      context: context,
      builder: (context) => TaskCreationDialog(
        initialDate: selectedDay,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(tasksStreamProvider);
    final selectedDate = ref.watch(selectedDateProvider);

    return tasksAsync.when(
      data: (tasks) {
        return TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) => isSameDay(selectedDate, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _focusedDay = focusedDay;
            });
            ref.read(selectedDateProvider.notifier).state = selectedDay;
          },
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
          eventLoader: (day) => _getTasksForDay(day, tasks),
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            selectedDecoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            markerDecoration: const BoxDecoration(
              color: AppColors.secondary,
              shape: BoxShape.circle,
            ),
            outsideDaysVisible: false,
            cellMargin: const EdgeInsets.all(4),
            defaultTextStyle: const TextStyle(
              color: AppColors.textPrimaryLight,
            ),
            weekendTextStyle: TextStyle(
              color: AppColors.textPrimaryLight.withOpacity(0.7),
            ),
          ),
          headerStyle: HeaderStyle(
            titleCentered: true,
            formatButtonVisible: true,
            formatButtonDecoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            formatButtonTextStyle: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
            leftChevronIcon: const Icon(
              Icons.chevron_left,
              color: AppColors.primary,
            ),
            rightChevronIcon: const Icon(
              Icons.chevron_right,
              color: AppColors.primary,
            ),
          ),
          daysOfWeekStyle: const DaysOfWeekStyle(
            weekdayStyle: TextStyle(
              color: AppColors.textSecondaryLight,
              fontWeight: FontWeight.w600,
            ),
            weekendStyle: TextStyle(
              color: AppColors.textSecondaryLight,
              fontWeight: FontWeight.w600,
            ),
          ),
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, focusedDay) {
              return _buildDayCell(context, day, tasks, false);
            },
            todayBuilder: (context, day, focusedDay) {
              return _buildDayCell(context, day, tasks, true);
            },
            selectedBuilder: (context, day, focusedDay) {
              return _buildDayCell(context, day, tasks, false, isSelected: true);
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error loading calendar: $error'),
      ),
    );
  }

  Widget _buildDayCell(
    BuildContext context,
    DateTime day,
    List<TaskModel> allTasks,
    bool isToday, {
    bool isSelected = false,
  }) {
    final tasksForDay = _getTasksForDay(day, allTasks);
    final hasHighPriority = tasksForDay.any((t) => t.priority == TaskPriority.high);
    final hasMediumPriority = tasksForDay.any((t) => t.priority == TaskPriority.medium);
    final hasLowPriority = tasksForDay.any((t) => t.priority == TaskPriority.low);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _showTaskCreationDialog(day),
        child: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary
                : isToday
                    ? AppColors.primary.withOpacity(0.3)
                    : null,
            shape: BoxShape.circle,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${day.day}',
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : isToday
                          ? AppColors.textPrimaryLight
                          : AppColors.textPrimaryLight,
                  fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              if (tasksForDay.isNotEmpty) ...[
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (hasHighPriority)
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        decoration: const BoxDecoration(
                          color: AppColors.priorityHigh,
                          shape: BoxShape.circle,
                        ),
                      ),
                    if (hasMediumPriority)
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        decoration: const BoxDecoration(
                          color: AppColors.priorityMedium,
                          shape: BoxShape.circle,
                        ),
                      ),
                    if (hasLowPriority)
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        decoration: const BoxDecoration(
                          color: AppColors.priorityLow,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
