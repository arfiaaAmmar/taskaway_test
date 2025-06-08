import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';

class TaskScreen extends ConsumerWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(taskProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
      ),
      body: tasksAsync.when(
        data: (tasks) {
          final completedTasks = tasks.where((task) => task.isCompleted).toList();
          final pendingTasks = tasks.where((task) => !task.isCompleted).toList();

          return ListView(
            children: [
              if (pendingTasks.isNotEmpty) ...[                
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Pending',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                _TaskList(tasks: pendingTasks),
              ],
              if (completedTasks.isNotEmpty) ...[                
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Completed',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                _TaskList(tasks: completedTasks),
              ],
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: 'Task Title',
                ),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(selectedDate != null
                    ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                    : 'Select Due Date'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() => selectedDate = date);
                  }
                },
              ),
              if (selectedDate != null)
                ListTile(
                  title: Text(selectedTime != null
                      ? '${selectedTime!.hour}:${selectedTime!.minute.toString().padLeft(2, '0')}'
                      : 'Select Time'),
                  trailing: const Icon(Icons.access_time),
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (time != null) {
                      setState(() => selectedTime = time);
                    }
                  },
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  DateTime? dueDate;
                  if (selectedDate != null && selectedTime != null) {
                    dueDate = DateTime(
                      selectedDate!.year,
                      selectedDate!.month,
                      selectedDate!.day,
                      selectedTime!.hour,
                      selectedTime!.minute,
                    );
                  }
                  ref.read(taskProvider.notifier).addTask(
                    controller.text,
                    dueDate: dueDate,
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskList extends ConsumerWidget {
  final List<Task> tasks;

  const _TaskList({required this.tasks});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return ListTile(
          leading: Checkbox(
            value: task.isCompleted,
            onChanged: (value) {
              ref.read(taskProvider.notifier).toggleTaskCompletion(task);
            },
          ),
          title: Text(
            task.title,
            style: TextStyle(
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: task.dueDate != null
              ? Text(
                  'Due: ${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year} '
                  '${task.dueDate!.hour}:${task.dueDate!.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    color: task.dueDate!.isBefore(DateTime.now()) && !task.isCompleted
                        ? Colors.red
                        : null,
                  ),
                )
              : null,
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              ref.read(taskProvider.notifier).deleteTask(task.id);
            },
          ),
        );
      },
    );
  }

  void _showEditTaskDialog(BuildContext context, WidgetRef ref, Task task) {
    final controller = TextEditingController(text: task.title);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Task'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter task title',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                ref.read(taskProvider.notifier).updateTask(
                      task.copyWith(title: controller.text),
                    );
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
