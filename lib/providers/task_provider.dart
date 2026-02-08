import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks = [];
  String _searchQuery = '';
  String? _userId;
  bool _isLoading = false;

  List<Task> get tasks => List.unmodifiable(_tasks);
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;

  // Firestore reference
  CollectionReference<Map<String, dynamic>> _getTasksCollection() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(_userId)
        .collection('tasks');
  }

  // Load tasks for a specific user
  Future<void> loadTasksForUser(String userId) async {
    _userId = userId;
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _getTasksCollection().get();
      _tasks.clear();

      for (final doc in snapshot.docs) {
        try {
          final task = Task.fromMap(doc.data());
          _tasks.add(task);
        } catch (e) {
          debugPrint('Error parsing task: $e');
        }
      }
    } catch (e) {
      debugPrint('Error loading tasks: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear tasks on logout
  void clearTasks() {
    _tasks.clear();
    _userId = null;
    _searchQuery = '';
    notifyListeners();
  }

  // Save task to Firestore
  Future<void> _saveTaskToFirestore(Task task) async {
    if (_userId == null) return;
    try {
      await _getTasksCollection().doc(task.id).set(task.toMap());
    } catch (e) {
      debugPrint('Error saving task: $e');
    }
  }

  // Delete task from Firestore
  Future<void> _deleteTaskFromFirestore(String taskId) async {
    if (_userId == null) return;
    try {
      await _getTasksCollection().doc(taskId).delete();
    } catch (e) {
      debugPrint('Error deleting task: $e');
    }
  }

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
    _saveTaskToFirestore(task);
  }

  void updateTask(Task task) {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      notifyListeners();
      _saveTaskToFirestore(task);
    }
  }

  void deleteTask(String taskId) {
    _tasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
    _deleteTaskFromFirestore(taskId);
  }

  void setTaskStatus(String taskId, TaskStatus status) {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      _tasks[index].status = status;
      notifyListeners();
      _saveTaskToFirestore(_tasks[index]);
    }
  }

  void setTaskPriority(String taskId, TaskPriority priority) {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      _tasks[index].priority = priority;
      notifyListeners();
      _saveTaskToFirestore(_tasks[index]);
    }
  }

  void cycleTaskStatus(String taskId) {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      final currentStatus = _tasks[index].status;
      switch (currentStatus) {
        case TaskStatus.assigned:
          _tasks[index].status = TaskStatus.inProgress;
          break;
        case TaskStatus.inProgress:
          _tasks[index].status = TaskStatus.completed;
          break;
        case TaskStatus.completed:
          _tasks[index].status = TaskStatus.assigned;
          break;
      }
      notifyListeners();
      _saveTaskToFirestore(_tasks[index]);
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  List<Task> _filterBySearch(List<Task> tasks) {
    if (_searchQuery.isEmpty) return tasks;
    final query = _searchQuery.toLowerCase();
    return tasks.where((task) {
      return task.name.toLowerCase().contains(query) ||
          task.description.toLowerCase().contains(query) ||
          (task.notes?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  List<Task> getTasksForDate(DateTime date) {
    return _filterBySearch(_tasks.where((task) {
      final taskStart = DateTime(task.startDate.year, task.startDate.month, task.startDate.day);
      final taskEnd = DateTime(task.endDate.year, task.endDate.month, task.endDate.day);
      final checkDate = DateTime(date.year, date.month, date.day);
      return !checkDate.isBefore(taskStart) && !checkDate.isAfter(taskEnd);
    }).toList());
  }

  List<Task> getAssignedTasks() {
    return _filterBySearch(_tasks
        .where((task) => task.status == TaskStatus.assigned)
        .toList()
      ..sort((a, b) {
        // Sort by priority first, then by start date
        final priorityCompare = b.priority.index.compareTo(a.priority.index);
        if (priorityCompare != 0) return priorityCompare;
        return a.startDate.compareTo(b.startDate);
      }));
  }

  List<Task> getInProgressTasks() {
    return _filterBySearch(_tasks
        .where((task) => task.status == TaskStatus.inProgress)
        .toList()
      ..sort((a, b) {
        final priorityCompare = b.priority.index.compareTo(a.priority.index);
        if (priorityCompare != 0) return priorityCompare;
        return a.endDate.compareTo(b.endDate);
      }));
  }

  List<Task> getCompletedTasks() {
    return _filterBySearch(_tasks
        .where((task) => task.status == TaskStatus.completed)
        .toList()
      ..sort((a, b) => b.endDate.compareTo(a.endDate)));
  }

  List<Task> getTasksByPriority(TaskPriority priority) {
    return _filterBySearch(_tasks
        .where((task) => task.priority == priority && !task.isCompleted)
        .toList()
      ..sort((a, b) => a.endDate.compareTo(b.endDate)));
  }

  List<Task> getUrgentTasks() {
    return _filterBySearch(_tasks
        .where((task) => task.priority == TaskPriority.urgent && !task.isCompleted)
        .toList()
      ..sort((a, b) => a.endDate.compareTo(b.endDate)));
  }

  // Analytics methods
  int get totalTasks => _tasks.length;
  int get completedTasksCount => _tasks.where((t) => t.isCompleted).length;
  int get assignedTasksCount => _tasks.where((t) => t.status == TaskStatus.assigned).length;
  int get inProgressTasksCount => _tasks.where((t) => t.status == TaskStatus.inProgress).length;

  double get completionRate {
    if (_tasks.isEmpty) return 0;
    return (completedTasksCount / _tasks.length) * 100;
  }

  Map<TaskPriority, int> get tasksByPriorityCount {
    return {
      TaskPriority.low: _tasks.where((t) => t.priority == TaskPriority.low).length,
      TaskPriority.medium: _tasks.where((t) => t.priority == TaskPriority.medium).length,
      TaskPriority.high: _tasks.where((t) => t.priority == TaskPriority.high).length,
      TaskPriority.urgent: _tasks.where((t) => t.priority == TaskPriority.urgent).length,
    };
  }

  List<Task> getRecentlyCompleted({int limit = 5}) {
    final completed = _tasks
        .where((t) => t.isCompleted)
        .toList()
      ..sort((a, b) => b.endDate.compareTo(a.endDate));
    return completed.take(limit).toList();
  }
}
