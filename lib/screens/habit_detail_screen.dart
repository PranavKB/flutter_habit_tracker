import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';

class HabitDetailScreen extends StatelessWidget {
  final Habit habit;

  const HabitDetailScreen({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HabitProvider>();
    final currentHabit = provider.habits.firstWhere((h) => h.id == habit.id);

    return Scaffold(
      appBar: AppBar(title: Text(currentHabit.title)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Habit description
            Text(
              currentHabit.description,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),

            // Total completions
            Text(
              "Completed: ${currentHabit.completions.length} time(s)",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            const Text(
              "Completion History",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: currentHabit.completions.isEmpty
                  ? const Center(child: Text("No completions yet."))
                  : ListView.builder(
                      itemCount: currentHabit.completions.length,
                      itemBuilder: (context, index) {
                        final date = currentHabit.completions[index];
                        return ListTile(
                          leading: const Icon(Icons.check, color: Colors.green),
                          title: Text(
                            "${date.year}-${date.month}-${date.day}"
                            " at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}",
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      // Mark as completed button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          provider.markHabitComplete(currentHabit.id);
        },
        label: const Text("Mark Completed"),
        icon: const Icon(Icons.check_circle),
      ),
    );
  }
}
