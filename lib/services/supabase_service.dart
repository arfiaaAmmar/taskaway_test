import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/task.dart';

class SupabaseService {
  final SupabaseClient client;

  SupabaseService(this.client);

  Future<List<Task>> getTasks() async {
    final response = await client
        .from('tasks')
        .select()
        .order('created_at', ascending: false);
    
    return (response as List).map((task) => Task.fromJson(task)).toList();
  }

  Future<Task> createTask(String title, {DateTime? dueDate}) async {
    final response = await client.from('tasks').insert({
      'title': title,
      'due_date': dueDate?.toIso8601String(),
      'is_completed': false,
    }).select().single();
    
    return Task.fromJson(response);
  }

  Future<Task> updateTask(Task task) async {
    final response = await client
        .from('tasks')
        .update(task.toJson())
        .eq('id', task.id)
        .select()
        .single();
    
    return Task.fromJson(response);
  }

  Future<void> deleteTask(String id) async {
    await client.from('tasks').delete().eq('id', id);
  }
}
