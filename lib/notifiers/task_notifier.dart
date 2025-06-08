import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';
import '../services/supabase_service.dart';

class TaskNotifier extends StateNotifier<AsyncValue<List<Task>>> {
  final SupabaseService _supabaseService;

  TaskNotifier(this._supabaseService) : super(const AsyncValue.loading()) {
    loadTasks();
  }

  Future<void> loadTasks() async {
    try {
      state = const AsyncValue.loading();
      final tasks = await _supabaseService.getTasks();
      state = AsyncValue.data(tasks);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> addTask(String title, {DateTime? dueDate}) async {
    try {
      final task = await _supabaseService.createTask(title, dueDate: dueDate);
      state.whenData((tasks) {
        state = AsyncValue.data([task, ...tasks]);
      });
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      final updatedTask = await _supabaseService.updateTask(task);
      state.whenData((tasks) {
        state = AsyncValue.data(
          tasks.map((t) => t.id == task.id ? updatedTask : t).toList(),
        );
      });
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await _supabaseService.deleteTask(id);
      state.whenData((tasks) {
        state = AsyncValue.data(tasks.where((t) => t.id != id).toList());
      });
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> toggleTaskCompletion(Task task) async {
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    await updateTask(updatedTask);
  }
}
