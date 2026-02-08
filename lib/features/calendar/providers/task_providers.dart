import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/providers/auth_providers.dart';
import '../data/models/task_model.dart';
import '../data/repositories/task_repository.dart';

// Task Repository Provider
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository();
});

// Tasks Stream Provider - Real-time sync with Firestore
final tasksStreamProvider = StreamProvider<List<TaskModel>>((ref) {
  final authState = ref.watch(authStateProvider);
  final taskRepository = ref.watch(taskRepositoryProvider);

  return authState.when(
    data: (user) {
      if (user != null) {
        return taskRepository.getTasksStream(user.uid);
      }
      return Stream.value([]);
    },
    loading: () => Stream.value([]),
    error: (_, __) => Stream.value([]),
  );
});

// Selected Date Provider
final selectedDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

// Task Controller
final taskControllerProvider = Provider<TaskController>((ref) {
  return TaskController(ref);
});

class TaskController {
  final Ref _ref;

  TaskController(this._ref);

  Future<void> createTask(TaskModel task) async {
    final taskRepository = _ref.read(taskRepositoryProvider);
    await taskRepository.createTask(task);
  }

  Future<void> updateTask(TaskModel task) async {
    final taskRepository = _ref.read(taskRepositoryProvider);
    await taskRepository.updateTask(task);
  }

  Future<void> deleteTask(String taskId) async {
    final taskRepository = _ref.read(taskRepositoryProvider);
    await taskRepository.deleteTask(taskId);
  }

  Future<void> toggleTaskCompletion(TaskModel task) async {
    final taskRepository = _ref.read(taskRepositoryProvider);
    await taskRepository.toggleTaskCompletion(task);
  }

  Future<void> moveTaskToDate(TaskModel task, DateTime newDate) async {
    final taskRepository = _ref.read(taskRepositoryProvider);
    await taskRepository.moveTaskToDate(task, newDate);
  }
}
