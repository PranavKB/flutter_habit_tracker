import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../models/habit.dart';
import 'package:uuid/uuid.dart';

class AddHabitScreen extends StatefulWidget {
  final Habit? habit; // null = add, not null = edit

  const AddHabitScreen({super.key, this.habit});

  @override
  _AddHabitScreenState createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  late TextEditingController titleCtrl;
  late TextEditingController descCtrl;

  @override
  void initState() {
    super.initState();
    titleCtrl = TextEditingController(text: widget.habit?.title ?? "");
    descCtrl = TextEditingController(text: widget.habit?.description ?? "");
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.habit != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? "Edit Habit" : "Add Habit")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: "Habit Name"),
            ),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: Text(isEditing ? "Update Habit" : "Add Habit"),
              onPressed: () {
                final provider = context.read<HabitProvider>();

                if (isEditing) {
                  final updatedHabit = Habit(
                    id: widget.habit!.id,
                    title: titleCtrl.text,
                    description: descCtrl.text,
                    createdAt: widget.habit!.createdAt,
                    completions: widget.habit!.completions,
                  );
                  provider.updateHabit(updatedHabit);
                } else {
                  final newHabit = Habit(
                    id: const Uuid().v4(),
                    title: titleCtrl.text,
                    description: descCtrl.text,
                    createdAt: DateTime.now(),
                    completions: [],
                  );
                  provider.addHabit(newHabit);
                }

                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
