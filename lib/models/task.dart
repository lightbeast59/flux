import 'package:flutter/material.dart';

enum TaskStatus {
  assigned,
  inProgress,
  completed,
}

enum TaskPriority {
  low,
  medium,
  high,
  urgent,
}

extension TaskPriorityExtension on TaskPriority {
  String get label {
    switch (this) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
      case TaskPriority.urgent:
        return 'Urgent';
    }
  }

  Color get color {
    switch (this) {
      case TaskPriority.low:
        return const Color(0xFF10B981); // Green
      case TaskPriority.medium:
        return const Color(0xFF3B82F6); // Blue
      case TaskPriority.high:
        return const Color(0xFFF97316); // Orange
      case TaskPriority.urgent:
        return const Color(0xFFEF4444); // Red
    }
  }

  IconData get icon {
    switch (this) {
      case TaskPriority.low:
        return Icons.arrow_downward;
      case TaskPriority.medium:
        return Icons.remove;
      case TaskPriority.high:
        return Icons.arrow_upward;
      case TaskPriority.urgent:
        return Icons.priority_high;
    }
  }
}

class Task {
  final String id;
  final String name;
  final String description;
  final String? notes;
  final Color color;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;
  TaskStatus status;
  TaskPriority priority;

  Task({
    required this.id,
    required this.name,
    required this.description,
    this.notes,
    required this.color,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    this.status = TaskStatus.assigned,
    this.priority = TaskPriority.medium,
  });

  bool get isCompleted => status == TaskStatus.completed;

  // Convert Task to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'notes': notes,
      'color': color.value,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'status': status.index,
      'priority': priority.index,
    };
  }

  // Create Task from Firestore Map
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      notes: map['notes'] as String?,
      color: Color(map['color'] as int),
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate'] as int),
      endDate: DateTime.fromMillisecondsSinceEpoch(map['endDate'] as int),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      status: TaskStatus.values[map['status'] as int],
      priority: TaskPriority.values[map['priority'] as int],
    );
  }

  Task copyWith({
    String? id,
    String? name,
    String? description,
    String? notes,
    Color? color,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    TaskStatus? status,
    TaskPriority? priority,
  }) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      notes: notes ?? this.notes,
      color: color ?? this.color,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      priority: priority ?? this.priority,
    );
  }
}
