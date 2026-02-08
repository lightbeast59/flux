import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';

class TaskRepository {
  final FirebaseFirestore _firestore;

  TaskRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // Stream of tasks for a specific user
  Stream<List<TaskModel>> getTasksStream(String userId) {
    return _firestore
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .orderBy('deadline')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList();
    });
  }

  // Get tasks for a specific date range
  Stream<List<TaskModel>> getTasksForDateRange(
    String userId,
    DateTime start,
    DateTime end,
  ) {
    return _firestore
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .where('deadline', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('deadline', isLessThan: Timestamp.fromDate(end))
        .orderBy('deadline')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList();
    });
  }

  // Create a new task
  Future<void> createTask(TaskModel task) async {
    await _firestore.collection('tasks').add(task.toFirestore());
  }

  // Update an existing task
  Future<void> updateTask(TaskModel task) async {
    await _firestore.collection('tasks').doc(task.id).update(task.toFirestore());
  }

  // Delete a task
  Future<void> deleteTask(String taskId) async {
    await _firestore.collection('tasks').doc(taskId).delete();
  }

  // Toggle task completion
  Future<void> toggleTaskCompletion(TaskModel task) async {
    final updatedTask = task.copyWith(
      isCompleted: !task.isCompleted,
      completedAt: !task.isCompleted ? DateTime.now() : null,
    );
    await updateTask(updatedTask);
  }

  // Move task to a different date
  Future<void> moveTaskToDate(TaskModel task, DateTime newDate) async {
    final newDeadline = DateTime(
      newDate.year,
      newDate.month,
      newDate.day,
      task.deadline.hour,
      task.deadline.minute,
    );
    final updatedTask = task.copyWith(deadline: newDeadline);
    await updateTask(updatedTask);
  }
}
