import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../models/task.dart';
import '../../../../providers/task_provider.dart';
import '../../../../providers/theme_provider.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        // Show loading indicator while tasks are being loaded
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
                  'Loading tasks...',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: isDarkMode ? Colors.white70 : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          );
        }

        final assignedTasks = taskProvider.getAssignedTasks();
        final inProgressTasks = taskProvider.getInProgressTasks();
        final completedTasks = taskProvider.getCompletedTasks();

        return LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 600;

            return SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 16 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with title and search
                  if (isMobile) ...[
                    Text(
                      'Tasks',
                      style: GoogleFonts.inter(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : AppColors.textPrimaryLight,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Search Bar - full width on mobile
                    TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        taskProvider.setSearchQuery(value);
                      },
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : AppColors.textPrimaryLight,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search tasks...',
                        hintStyle: TextStyle(
                          color: isDarkMode ? Colors.white38 : AppColors.textSecondaryLight,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: isDarkMode ? Colors.white60 : AppColors.textSecondaryLight,
                        ),
                        suffixIcon: taskProvider.searchQuery.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: isDarkMode ? Colors.white60 : AppColors.textSecondaryLight,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  taskProvider.setSearchQuery('');
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isDarkMode ? const Color(0xFF334155) : AppColors.borderLight,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isDarkMode ? const Color(0xFF334155) : AppColors.borderLight,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: themeProvider.primaryColor,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ] else ...[
                    Row(
                      children: [
                        Text(
                          'Tasks',
                          style: GoogleFonts.inter(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : AppColors.textPrimaryLight,
                          ),
                        ),
                        const Spacer(),
                        // Search Bar
                        SizedBox(
                          width: 300,
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) {
                              taskProvider.setSearchQuery(value);
                            },
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : AppColors.textPrimaryLight,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search tasks...',
                              hintStyle: TextStyle(
                                color: isDarkMode ? Colors.white38 : AppColors.textSecondaryLight,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: isDarkMode ? Colors.white60 : AppColors.textSecondaryLight,
                              ),
                              suffixIcon: taskProvider.searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: Icon(
                                        Icons.clear,
                                        color: isDarkMode ? Colors.white60 : AppColors.textSecondaryLight,
                                      ),
                                      onPressed: () {
                                        _searchController.clear();
                                        taskProvider.setSearchQuery('');
                                      },
                                    )
                                  : null,
                              filled: true,
                              fillColor: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: isDarkMode ? const Color(0xFF334155) : AppColors.borderLight,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: isDarkMode ? const Color(0xFF334155) : AppColors.borderLight,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: themeProvider.primaryColor,
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 24),

                  // Stats Cards - 2x2 grid on mobile, row on desktop
                  if (isMobile)
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _StatCard(
                                title: 'Total',
                                value: taskProvider.totalTasks.toString(),
                                icon: Icons.task_alt,
                                color: themeProvider.primaryColor,
                                isDarkMode: isDarkMode,
                                compact: true,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _StatCard(
                                title: 'Assigned',
                                value: taskProvider.assignedTasksCount.toString(),
                                icon: Icons.assignment,
                                color: AppColors.info,
                                isDarkMode: isDarkMode,
                                compact: true,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _StatCard(
                                title: 'In Progress',
                                value: taskProvider.inProgressTasksCount.toString(),
                                icon: Icons.pending_actions,
                                color: AppColors.warning,
                                isDarkMode: isDarkMode,
                                compact: true,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _StatCard(
                                title: 'Completed',
                                value: taskProvider.completedTasksCount.toString(),
                                icon: Icons.check_circle,
                                color: AppColors.success,
                                isDarkMode: isDarkMode,
                                compact: true,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            title: 'Total',
                            value: taskProvider.totalTasks.toString(),
                            icon: Icons.task_alt,
                            color: themeProvider.primaryColor,
                            isDarkMode: isDarkMode,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _StatCard(
                            title: 'Assigned',
                            value: taskProvider.assignedTasksCount.toString(),
                            icon: Icons.assignment,
                            color: AppColors.info,
                            isDarkMode: isDarkMode,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _StatCard(
                            title: 'In Progress',
                            value: taskProvider.inProgressTasksCount.toString(),
                            icon: Icons.pending_actions,
                            color: AppColors.warning,
                            isDarkMode: isDarkMode,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _StatCard(
                            title: 'Completed',
                            value: taskProvider.completedTasksCount.toString(),
                            icon: Icons.check_circle,
                            color: AppColors.success,
                            isDarkMode: isDarkMode,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 32),

              // Assigned Tasks
              if (assignedTasks.isNotEmpty) ...[
                _SectionHeader(
                  title: 'Assigned',
                  count: assignedTasks.length,
                  color: AppColors.info,
                  isDarkMode: isDarkMode,
                ),
                const SizedBox(height: 16),
                ...assignedTasks.map((task) => _TaskCard(
                  task: task,
                  isDarkMode: isDarkMode,
                  primaryColor: themeProvider.primaryColor,
                )),
                const SizedBox(height: 32),
              ],

              // In Progress Tasks
              if (inProgressTasks.isNotEmpty) ...[
                _SectionHeader(
                  title: 'In Progress',
                  count: inProgressTasks.length,
                  color: AppColors.warning,
                  isDarkMode: isDarkMode,
                ),
                const SizedBox(height: 16),
                ...inProgressTasks.map((task) => _TaskCard(
                  task: task,
                  isDarkMode: isDarkMode,
                  primaryColor: themeProvider.primaryColor,
                )),
                const SizedBox(height: 32),
              ],

              // Completed Tasks
              if (completedTasks.isNotEmpty) ...[
                _SectionHeader(
                  title: 'Completed',
                  count: completedTasks.length,
                  color: AppColors.success,
                  isDarkMode: isDarkMode,
                ),
                const SizedBox(height: 16),
                ...completedTasks.map((task) => _TaskCard(
                  task: task,
                  isDarkMode: isDarkMode,
                  primaryColor: themeProvider.primaryColor,
                )),
              ],

              // Empty State
              if (taskProvider.tasks.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(64),
                    child: Column(
                      children: [
                        Icon(
                          Icons.inbox,
                          size: 80,
                          color: isDarkMode ? Colors.white38 : AppColors.textSecondaryLight,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No tasks yet',
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: isDarkMode ? Colors.white60 : AppColors.textSecondaryLight,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Click the + button to create your first task',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: isDarkMode ? Colors.white60 : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // No results for search
              if (taskProvider.tasks.isNotEmpty &&
                  taskProvider.searchQuery.isNotEmpty &&
                  assignedTasks.isEmpty &&
                  inProgressTasks.isEmpty &&
                  completedTasks.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(64),
                    child: Column(
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 80,
                          color: isDarkMode ? Colors.white38 : AppColors.textSecondaryLight,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No tasks found',
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: isDarkMode ? Colors.white60 : AppColors.textSecondaryLight,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try a different search term',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: isDarkMode ? Colors.white60 : AppColors.textSecondaryLight,
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
      },
    );
  }
}

class _StatCard extends StatefulWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final bool isDarkMode;
  final bool compact;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.isDarkMode,
    this.compact = false,
  });

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isCompact = widget.compact;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(isCompact ? 12 : 20),
        decoration: BoxDecoration(
          color: widget.isDarkMode ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isHovered
                ? widget.color
                : (widget.isDarkMode ? const Color(0xFF334155) : AppColors.borderLight),
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
                Icon(widget.icon, color: widget.color, size: isCompact ? 20 : 28),
                if (isCompact) ...[
                  const Spacer(),
                  Text(
                    widget.value,
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: widget.isDarkMode ? Colors.white : AppColors.textPrimaryLight,
                    ),
                  ),
                ],
              ],
            ),
            SizedBox(height: isCompact ? 8 : 12),
            if (!isCompact)
              Text(
                widget.value,
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: widget.isDarkMode ? Colors.white : AppColors.textPrimaryLight,
                ),
              ),
            Text(
              widget.title,
              style: GoogleFonts.inter(
                fontSize: isCompact ? 12 : 14,
                color: widget.isDarkMode ? Colors.white60 : AppColors.textSecondaryLight,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
  final bool isDarkMode;

  const _SectionHeader({
    required this.title,
    required this.count,
    required this.color,
    required this.isDarkMode,
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
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : AppColors.textPrimaryLight,
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
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

class _TaskCard extends StatefulWidget {
  final Task task;
  final bool isDarkMode;
  final Color primaryColor;

  const _TaskCard({
    required this.task,
    required this.isDarkMode,
    required this.primaryColor,
  });

  @override
  State<_TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<_TaskCard> {
  bool _isHovered = false;

  Color _getStatusColor() {
    switch (widget.task.status) {
      case TaskStatus.assigned:
        return AppColors.info;
      case TaskStatus.inProgress:
        return AppColors.warning;
      case TaskStatus.completed:
        return AppColors.success;
    }
  }

  String _getStatusLabel() {
    switch (widget.task.status) {
      case TaskStatus.assigned:
        return 'Assigned';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.completed:
        return 'Completed';
    }
  }

  IconData _getStatusIcon() {
    switch (widget.task.status) {
      case TaskStatus.assigned:
        return Icons.assignment;
      case TaskStatus.inProgress:
        return Icons.pending_actions;
      case TaskStatus.completed:
        return Icons.check_circle;
    }
  }

  void _showStatusMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu<TaskStatus>(
      context: context,
      position: position,
      items: [
        PopupMenuItem(
          value: TaskStatus.assigned,
          child: Row(
            children: [
              Icon(Icons.assignment, color: AppColors.info, size: 20),
              const SizedBox(width: 8),
              const Text('Assigned'),
            ],
          ),
        ),
        PopupMenuItem(
          value: TaskStatus.inProgress,
          child: Row(
            children: [
              Icon(Icons.pending_actions, color: AppColors.warning, size: 20),
              const SizedBox(width: 8),
              const Text('In Progress'),
            ],
          ),
        ),
        PopupMenuItem(
          value: TaskStatus.completed,
          child: Row(
            children: [
              Icon(Icons.check_circle, color: AppColors.success, size: 20),
              const SizedBox(width: 8),
              const Text('Completed'),
            ],
          ),
        ),
      ],
    ).then((status) {
      if (status != null) {
        Provider.of<TaskProvider>(context, listen: false)
            .setTaskStatus(widget.task.id, status);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 400;

        return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: EdgeInsets.all(isMobile ? 12 : 16),
              decoration: BoxDecoration(
                color: widget.isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isHovered
                      ? widget.task.color
                      : (widget.isDarkMode ? const Color(0xFF334155) : AppColors.borderLight),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Color indicator
                  Container(
                    width: 4,
                    height: isMobile ? 100 : 80,
                    decoration: BoxDecoration(
                      color: widget.task.color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(width: isMobile ? 12 : 16),

                  // Task details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Task name
                        Text(
                          widget.task.name,
                          style: GoogleFonts.inter(
                            fontSize: isMobile ? 14 : 16,
                            fontWeight: FontWeight.w600,
                            color: widget.isDarkMode ? Colors.white : AppColors.textPrimaryLight,
                            decoration: widget.task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Badges - wrap on mobile
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            // Priority Badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: widget.task.priority.color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
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
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: widget.task.priority.color,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Status Badge
                            GestureDetector(
                              onTap: () => _showStatusMenu(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: statusColor.withOpacity(0.3),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _getStatusIcon(),
                                      size: 14,
                                      color: statusColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      _getStatusLabel(),
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: statusColor,
                                      ),
                                    ),
                                    const SizedBox(width: 2),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      size: 16,
                                      color: statusColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.task.description,
                          style: GoogleFonts.inter(
                            fontSize: isMobile ? 12 : 14,
                            color: widget.isDarkMode ? Colors.white60 : AppColors.textSecondaryLight,
                            decoration: widget.task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),
                        // Date Range - wrap on mobile
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.play_arrow,
                                  size: 14,
                                  color: widget.isDarkMode ? Colors.white60 : AppColors.textSecondaryLight,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${widget.task.startDate.day}/${widget.task.startDate.month}/${widget.task.startDate.year}',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: widget.isDarkMode ? Colors.white60 : AppColors.textSecondaryLight,
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward,
                              size: 12,
                              color: widget.isDarkMode ? Colors.white38 : AppColors.textSecondaryLight,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.flag,
                                  size: 14,
                                  color: widget.isDarkMode ? Colors.white60 : AppColors.textSecondaryLight,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${widget.task.endDate.day}/${widget.task.endDate.month}/${widget.task.endDate.year}',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: widget.isDarkMode ? Colors.white60 : AppColors.textSecondaryLight,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Delete button
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      size: isMobile ? 20 : 24,
                      color: widget.isDarkMode ? Colors.white38 : AppColors.textSecondaryLight,
                    ),
                    onPressed: () {
                      Provider.of<TaskProvider>(context, listen: false)
                          .deleteTask(widget.task.id);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
