import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import 'add_habit_screen.dart';
import '../widgets/habit_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final habits = context.watch<HabitProvider>().habits;

    return Scaffold(
      appBar: AppBar(title: const Text("Habit Tracker")),
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
