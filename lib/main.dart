import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/task_screen.dart';
import 'services/supabase_service.dart';
import 'models/task.dart';
import 'notifiers/task_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://glnxuirukyhccpfjfbnn.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imdsbnh1aXJ1a3loY2NwZmpmYm5uIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkzNTQ1NDMsImV4cCI6MjA2NDkzMDU0M30.WaS2MW-dypYJTdmIOu9wRGwgK_XLUfzqUg2V2TO4y34",
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const TaskScreen(),
    );
  }
}

final supabaseProvider = Provider<SupabaseService>((ref) {
  return SupabaseService(Supabase.instance.client);
});

final taskProvider =
    StateNotifierProvider<TaskNotifier, AsyncValue<List<Task>>>((ref) {
      final supabase = ref.watch(supabaseProvider);
      return TaskNotifier(supabase);
    });
