import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../providers/theme_provider.dart';

class TaskCreationDialog extends StatefulWidget {
  const TaskCreationDialog({super.key});

  @override
  State<TaskCreationDialog> createState() => _TaskCreationDialogState();
}

class _TaskCreationDialogState extends State<TaskCreationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();

  Color _selectedColor = AppColors.primary;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 7));
  TaskPriority _selectedPriority = TaskPriority.medium;

  final List<Color> _availableColors = [
    AppColors.primary,
    AppColors.secondary,
    AppColors.success,
    AppColors.warning,
    AppColors.error,
    AppColors.info,
    const Color(0xFFEC4899),
    const Color(0xFF8B5CF6),
    const Color(0xFF14B8A6),
    const Color(0xFFF97316),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _selectStartDate() async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: themeProvider.primaryColor,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimaryLight,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
        if (_endDate.isBefore(_startDate)) {
          _endDate = _startDate.add(const Duration(days: 1));
        }
      });
    }
  }

  void _selectEndDate() async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate.isBefore(_startDate) ? _startDate : _endDate,
      firstDate: _startDate,
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: themeProvider.primaryColor,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimaryLight,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final task = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        color: _selectedColor,
        startDate: _startDate,
        endDate: _endDate,
        createdAt: DateTime.now(),
        priority: _selectedPriority,
      );

      Provider.of<TaskProvider>(context, listen: false).addTask(task);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Dialog(
      backgroundColor: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 800),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Row(
                    children: [
                      Icon(
                        Icons.add_task,
                        color: themeProvider.primaryColor,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Create New Task',
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : AppColors.textPrimaryLight,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: isDarkMode ? Colors.white70 : AppColors.textSecondaryLight,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Task Name
                  _buildTextField(
                    controller: _nameController,
                    label: 'Task Name',
                    hint: 'Enter task name',
                    icon: Icons.title,
                    isDarkMode: isDarkMode,
                    primaryColor: themeProvider.primaryColor,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a task name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Description
                  _buildTextField(
                    controller: _descriptionController,
                    label: 'Description',
                    hint: 'Enter task description',
                    icon: Icons.description,
                    isDarkMode: isDarkMode,
                    primaryColor: themeProvider.primaryColor,
                    maxLines: 2,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Notes (Optional)
                  _buildTextField(
                    controller: _notesController,
                    label: 'Notes (Optional)',
                    hint: 'Add additional notes...',
                    icon: Icons.note,
                    isDarkMode: isDarkMode,
                    primaryColor: themeProvider.primaryColor,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 20),

                  // Priority Selector
                  _buildSectionLabel('Priority', isDarkMode),
                  const SizedBox(height: 12),
                  _buildPrioritySelector(isDarkMode, themeProvider.primaryColor),
                  const SizedBox(height: 20),

                  // Color Picker
                  _buildSectionLabel('Color', isDarkMode),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _availableColors.map((color) {
                      return _ColorCircle(
                        color: color,
                        isSelected: _selectedColor == color,
                        onTap: () => setState(() => _selectedColor = color),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Date Pickers
                  _buildSectionLabel('Task Duration', isDarkMode),
                  const SizedBox(height: 12),
                  _DatePickerTile(
                    label: 'Start Date',
                    date: _startDate,
                    onTap: _selectStartDate,
                    isDarkMode: isDarkMode,
                    primaryColor: themeProvider.primaryColor,
                    icon: Icons.play_arrow,
                  ),
                  const SizedBox(height: 12),
                  _DatePickerTile(
                    label: 'End Date',
                    date: _endDate,
                    onTap: _selectEndDate,
                    isDarkMode: isDarkMode,
                    primaryColor: themeProvider.primaryColor,
                    icon: Icons.flag,
                  ),
                  const SizedBox(height: 24),

                  // Save Button
                  _HoverButton(
                    onPressed: _saveTask,
                    text: 'Create Task',
                    primaryColor: themeProvider.primaryColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label, bool isDarkMode) {
    return Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: isDarkMode ? Colors.white : AppColors.textPrimaryLight,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool isDarkMode,
    required Color primaryColor,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(
        color: isDarkMode ? Colors.white : AppColors.textPrimaryLight,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: primaryColor),
        alignLabelWithHint: maxLines > 1,
        labelStyle: TextStyle(
          color: isDarkMode ? Colors.white70 : AppColors.textSecondaryLight,
        ),
        hintStyle: TextStyle(
          color: isDarkMode ? Colors.white38 : AppColors.textSecondaryLight,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDarkMode ? const Color(0xFF334155) : AppColors.borderLight,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildPrioritySelector(bool isDarkMode, Color primaryColor) {
    return Row(
      children: TaskPriority.values.map((priority) {
        final isSelected = _selectedPriority == priority;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedPriority = priority),
            child: Container(
              margin: EdgeInsets.only(
                right: priority != TaskPriority.urgent ? 8 : 0,
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? priority.color.withOpacity(0.2)
                    : (isDarkMode ? const Color(0xFF0F172A) : Colors.grey.shade100),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? priority.color : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    priority.icon,
                    color: isSelected
                        ? priority.color
                        : (isDarkMode ? Colors.white60 : AppColors.textSecondaryLight),
                    size: 20,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    priority.label,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected
                          ? priority.color
                          : (isDarkMode ? Colors.white60 : AppColors.textSecondaryLight),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _DatePickerTile extends StatefulWidget {
  final String label;
  final DateTime date;
  final VoidCallback onTap;
  final bool isDarkMode;
  final Color primaryColor;
  final IconData icon;

  const _DatePickerTile({
    required this.label,
    required this.date,
    required this.onTap,
    required this.isDarkMode,
    required this.primaryColor,
    required this.icon,
  });

  @override
  State<_DatePickerTile> createState() => _DatePickerTileState();
}

class _DatePickerTileState extends State<_DatePickerTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _isHovered
                ? widget.primaryColor.withOpacity(0.1)
                : (widget.isDarkMode ? const Color(0xFF0F172A) : Colors.grey.shade50),
            border: Border.all(
              color: _isHovered
                  ? widget.primaryColor
                  : (widget.isDarkMode ? const Color(0xFF334155) : AppColors.borderLight),
              width: _isHovered ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: widget.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  widget.icon,
                  color: widget.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.label,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: widget.isDarkMode ? Colors.white60 : AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.date.day}/${widget.date.month}/${widget.date.year}',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: widget.isDarkMode ? Colors.white : AppColors.textPrimaryLight,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Icon(
                Icons.calendar_today,
                size: 20,
                color: widget.isDarkMode ? Colors.white60 : AppColors.textSecondaryLight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ColorCircle extends StatefulWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorCircle({
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_ColorCircle> createState() => _ColorCircleState();
}

class _ColorCircleState extends State<_ColorCircle> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: widget.color,
            shape: BoxShape.circle,
            border: Border.all(
              color: widget.isSelected ? Colors.white : Colors.transparent,
              width: 3,
            ),
            boxShadow: [
              if (_isHovered || widget.isSelected)
                BoxShadow(
                  color: widget.color.withOpacity(0.5),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
            ],
          ),
          child: widget.isSelected
              ? const Icon(Icons.check, color: Colors.white, size: 18)
              : null,
        ),
      ),
    );
  }
}

class _HoverButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;
  final Color primaryColor;

  const _HoverButton({
    required this.onPressed,
    required this.text,
    required this.primaryColor,
  });

  @override
  State<_HoverButton> createState() => _HoverButtonState();
}

class _HoverButtonState extends State<_HoverButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: ElevatedButton(
          onPressed: widget.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: _isHovered
                ? widget.primaryColor.withOpacity(0.9)
                : widget.primaryColor,
            foregroundColor: Colors.white,
            elevation: _isHovered ? 4 : 0,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            widget.text,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
