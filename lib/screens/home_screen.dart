import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../providers/theme_provider.dart';
import 'add_habit_screen.dart';
import '../widgets/habit_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final habits = context.watch<HabitProvider>().habits;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Habit Tracker"),
        actions: [
          PopupMenuButton<ThemeMode>(
            onSelected: (ThemeMode mode) {
              context.read<ThemeProvider>().setTheme(mode);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<ThemeMode>>[
              const PopupMenuItem<ThemeMode>(
                value: ThemeMode.system,
                child: Text('System Default'),
              ),
              const PopupMenuItem<ThemeMode>(
                value: ThemeMode.light,
                child: Text('Light Mode'),
              ),
              const PopupMenuItem<ThemeMode>(
                value: ThemeMode.dark,
                child: Text('Dark Mode'),
              ),
            ],
          ),
        ],
      ),
      body: habits.isEmpty
          ? const Center(child: Text("No habits yet. Add one!"))
          : ListView.builder(
              itemCount: habits.length,
              itemBuilder: (_, i) => HabitTile(habit: habits[i]),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddHabitScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
