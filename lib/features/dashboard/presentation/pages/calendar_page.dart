import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../models/task.dart';
import '../../../../providers/task_provider.dart';
import '../../../../providers/theme_provider.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

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
                  'Loading calendar...',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        final selectedDayTasks = _selectedDay != null
            ? taskProvider.getTasksForDate(_selectedDay!)
            : <Task>[];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Calendar',
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 24),

              // Calendar Widget
              Container(
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: border),
                ),
                padding: const EdgeInsets.all(16),
                child: TableCalendar<Task>(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  calendarFormat: CalendarFormat.month,
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'Month',
                  },
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  rowHeight: 100,
                  daysOfWeekHeight: 40,
                  eventLoader: (day) {
                    return taskProvider.getTasksForDate(day);
                  },
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: GoogleFonts.inter(
                      color: textSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    weekendStyle: GoogleFonts.inter(
                      color: textSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    leftChevronIcon: Icon(
                      Icons.chevron_left,
                      color: textPrimary,
                    ),
                    rightChevronIcon: Icon(
                      Icons.chevron_right,
                      color: textPrimary,
                    ),
                    titleTextStyle: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                  ),
                  calendarBuilders: CalendarBuilders<Task>(
                    // Remove default markers
                    markerBuilder: (context, date, events) {
                      return const SizedBox.shrink();
                    },
                    defaultBuilder: (context, day, focusedDay) {
                      return _buildDayCell(
                        day: day,
                        tasks: taskProvider.getTasksForDate(day),
                        isSelected: false,
                        isToday: false,
                        isDark: isDark,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                        border: border,
                      );
                    },
                    selectedBuilder: (context, day, focusedDay) {
                      return _buildDayCell(
                        day: day,
                        tasks: taskProvider.getTasksForDate(day),
                        isSelected: true,
                        isToday: false,
                        isDark: isDark,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                        border: border,
                      );
                    },
                    todayBuilder: (context, day, focusedDay) {
                      return _buildDayCell(
                        day: day,
                        tasks: taskProvider.getTasksForDate(day),
                        isSelected: isSameDay(_selectedDay, day),
                        isToday: true,
                        isDark: isDark,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                        border: border,
                      );
                    },
                    outsideBuilder: (context, day, focusedDay) {
                      return _buildDayCell(
                        day: day,
                        tasks: taskProvider.getTasksForDate(day),
                        isSelected: false,
                        isToday: false,
                        isDark: isDark,
                        textPrimary: textSecondary.withOpacity(0.4),
                        textSecondary: textSecondary.withOpacity(0.3),
                        border: border,
                        isOutside: true,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Tasks for selected day
              if (_selectedDay != null) ...[
                Text(
                  'Tasks for ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                if (selectedDayTasks.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(
                            Icons.event_busy,
                            size: 48,
                            color: textSecondary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No tasks for this day',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...selectedDayTasks.map((task) => _TaskCard(
                        task: task,
                        isDark: isDark,
                        surface: surface,
                        border: border,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                      )),
              ],
            ],
          ),
        );
      },
    );
  }

  // Check if this day is the middle day of the task's duration
  bool _isMiddleDay(DateTime day, Task task) {
    final startDate = DateTime(task.startDate.year, task.startDate.month, task.startDate.day);
    final endDate = DateTime(task.endDate.year, task.endDate.month, task.endDate.day);
    final currentDate = DateTime(day.year, day.month, day.day);

    // Calculate total days of the task
    final totalDays = endDate.difference(startDate).inDays + 1;

    // Calculate which day number this is (0-indexed)
    final dayIndex = currentDate.difference(startDate).inDays;

    // Find the middle day index
    final middleDayIndex = (totalDays - 1) ~/ 2;

    return dayIndex == middleDayIndex;
  }

  Widget _buildDayCell({
    required DateTime day,
    required List<Task> tasks,
    required bool isSelected,
    required bool isToday,
    required bool isDark,
    required Color textPrimary,
    required Color textSecondary,
    required Color border,
    bool isOutside = false,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withOpacity(0.15)
                : isToday
                    ? AppColors.primary.withOpacity(0.08)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : isToday
                      ? AppColors.primary.withOpacity(0.5)
                      : border.withOpacity(0.5),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Day number
              Padding(
                padding: const EdgeInsets.only(left: 6, top: 4),
                child: Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: isToday
                      ? BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        )
                      : null,
                  child: Text(
                    '${day.day}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: isToday || isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isToday ? Colors.white : textPrimary,
                    ),
                  ),
                ),
              ),
              // Task bars
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ...tasks.take(4).map((task) {
                        final showName = _isMiddleDay(day, task);
                        return _TaskBar(
                          task: task,
                          showName: showName,
                          isOutside: isOutside,
                        );
                      }),
                      if (tasks.length > 4)
                        Padding(
                          padding: const EdgeInsets.only(top: 1),
                          child: Text(
                            '+${tasks.length - 4}',
                            style: GoogleFonts.inter(
                              fontSize: 8,
                              color: textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TaskBar extends StatelessWidget {
  final Task task;
  final bool showName;
  final bool isOutside;

  const _TaskBar({
    required this.task,
    required this.showName,
    this.isOutside = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      height: 14, // Fixed height for consistent square-like bars
      decoration: BoxDecoration(
        color: isOutside ? task.color.withOpacity(0.3) : task.color.withOpacity(0.85),
        borderRadius: BorderRadius.circular(3),
      ),
      alignment: Alignment.center,
      child: showName
          ? Text(
              task.name,
              style: GoogleFonts.inter(
                fontSize: 8,
                fontWeight: FontWeight.w600,
                color: isOutside ? task.color : Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            )
          : null,
    );
  }
}

class _TaskCard extends StatefulWidget {
  final Task task;
  final bool isDark;
  final Color surface;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;

  const _TaskCard({
    required this.task,
    required this.isDark,
    required this.surface,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  State<_TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<_TaskCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: widget.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isHovered ? widget.task.color : widget.border,
              width: _isHovered ? 2 : 1,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: widget.task.color.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              // Color indicator
              Container(
                width: 4,
                height: 60,
                decoration: BoxDecoration(
                  color: widget.task.color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 16),

              // Task details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.task.name,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: widget.textPrimary,
                              decoration: widget.task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ),
                        // Priority badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: widget.task.priority.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                widget.task.priority.icon,
                                size: 12,
                                color: widget.task.priority.color,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.task.priority.label,
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: widget.task.priority.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.task.description,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: widget.textSecondary,
                        decoration: widget.task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        // Status badge
                        _buildStatusBadge(widget.task.status),
                        const SizedBox(width: 8),
                        // Date range
                        Icon(
                          Icons.date_range,
                          size: 12,
                          color: widget.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${_formatDate(widget.task.startDate)} - ${_formatDate(widget.task.endDate)}',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: widget.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Checkbox
              Checkbox(
                value: widget.task.isCompleted,
                onChanged: (value) {
                  Provider.of<TaskProvider>(context, listen: false)
                      .cycleTaskStatus(widget.task.id);
                },
                activeColor: widget.task.color,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}';
  }

  Widget _buildStatusBadge(TaskStatus status) {
    Color color;
    String label;
    IconData icon;

    switch (status) {
      case TaskStatus.assigned:
        color = const Color(0xFF3B82F6);
        label = 'Assigned';
        icon = Icons.assignment;
        break;
      case TaskStatus.inProgress:
        color = const Color(0xFFF97316);
        label = 'In Progress';
        icon = Icons.pending;
        break;
      case TaskStatus.completed:
        color = const Color(0xFF10B981);
        label = 'Completed';
        icon = Icons.check_circle;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
