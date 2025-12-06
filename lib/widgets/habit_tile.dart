import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';
import '../screens/habit_detail_screen.dart';
import '../screens/add_habit_screen.dart';

class HabitTile extends StatelessWidget {
  final Habit habit;
  const HabitTile({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HabitProvider>();
    final currentHabit = provider.habits.firstWhere((h) => h.id == habit.id);

    String lastCompleted = "Never";
    if (currentHabit.completions.isNotEmpty) {
      final last = currentHabit.completions.last;
      lastCompleted = "${last.year}-${last.month}-${last.day}";
    }

    return Dismissible(
      key: Key(currentHabit.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Delete Habit?"),
            content: Text(
              "Are you sure you want to delete '${currentHabit.title}'?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) {
        provider.deleteHabit(currentHabit.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${currentHabit.title} deleted")),
        );
      },
      child: Card(
        elevation: 1,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 8,
          ),

          // Tap → open habit detail
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => HabitDetailScreen(habit: currentHabit),
              ),
            );
          },

          title: Text(
            currentHabit.title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Completed: ${currentHabit.completions.length} time(s)"),
              Text(
                "Last: $lastCompleted",
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),

          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Edit button
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddHabitScreen(habit: currentHabit),
                    ),
                  );
                },
              ),

              // Complete button
              IconButton(
                icon: const Icon(Icons.check_circle, color: Colors.green),
                onPressed: () {
                  provider.markHabitComplete(currentHabit.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
