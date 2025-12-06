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
  ScheduleType _schedule = ScheduleType.daily;
  List<int> _customDays = [];
  int _weeklyTarget = 1;

  @override
  void initState() {
    super.initState();
    titleCtrl = TextEditingController(text: widget.habit?.title ?? "");
    descCtrl = TextEditingController(text: widget.habit?.description ?? "");
    if (widget.habit != null) {
      _schedule = widget.habit!.schedule;
      _customDays = List.from(widget.habit!.customDays);
      _weeklyTarget = widget.habit!.weeklyTarget;
    }
  }

  String _getDayName(int index) {
    const days = ["M", "T", "W", "T", "F", "S", "S"];
    return days[index - 1];
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

            // Schedule Type Selector
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Schedule", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            DropdownButton<ScheduleType>(
              value: _schedule,
              items: const [
                DropdownMenuItem(value: ScheduleType.daily, child: Text("Daily")),
                DropdownMenuItem(value: ScheduleType.weekly, child: Text("Weekly")),
                DropdownMenuItem(value: ScheduleType.customDays, child: Text("Custom Days")),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _schedule = val);
              },
            ),

            if (_schedule == ScheduleType.weekly) ...[
              const SizedBox(height: 10),
              Text("Target per week: $_weeklyTarget"),
              Slider(
                value: _weeklyTarget.toDouble(),
                min: 1,
                max: 7,
                divisions: 6,
                label: _weeklyTarget.toString(),
                onChanged: (val) {
                  setState(() => _weeklyTarget = val.toInt());
                },
              ),
            ],

            if (_schedule == ScheduleType.customDays) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 5,
                children: List.generate(7, (index) {
                  final dayIndex = index + 1; // 1=Mon, 7=Sun
                  final isSelected = _customDays.contains(dayIndex);
                  return FilterChip(
                    label: Text(_getDayName(dayIndex)),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _customDays.add(dayIndex);
                        } else {
                          _customDays.remove(dayIndex);
                        }
                      });
                    },
                  );
                }),
              ),
            ],

            const SizedBox(height: 20),
            ElevatedButton(
              child: Text(isEditing ? "Update Habit" : "Add Habit"),
              onPressed: () {
                if (titleCtrl.text.isEmpty) return;

                final provider = context.read<HabitProvider>();

                if (isEditing) {
                  final updatedHabit = Habit(
                    id: widget.habit!.id,
                    title: titleCtrl.text,
                    description: descCtrl.text,
                    createdAt: widget.habit!.createdAt,
                    completions: widget.habit!.completions,
                    schedule: _schedule,
                    customDays: _customDays,
                    weeklyTarget: _weeklyTarget,
                  );
                  provider.updateHabit(updatedHabit);
                } else {
                  final newHabit = Habit(
                    id: const Uuid().v4(),
                    title: titleCtrl.text,
                    description: descCtrl.text,
                    createdAt: DateTime.now(),
                    completions: [],
                    schedule: _schedule,
                    customDays: _customDays,
                    weeklyTarget: _weeklyTarget,
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
