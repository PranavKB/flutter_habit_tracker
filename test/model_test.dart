import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_habit_tracker/models/habit.dart';

void main() {
  test('Habit serialization includes new fields', () {
    final habit = Habit(
      id: '1',
      title: 'Run',
      description: 'Run 5km',
      createdAt: DateTime(2023, 1, 1),
      completions: [],
      schedule: ScheduleType.weekly,
      weeklyTarget: 3,
      customDays: [1, 3, 5],
    );

    final map = habit.toMap();
    
    expect(map['schedule'], ScheduleType.weekly.index);
    expect(map['weeklyTarget'], 3);
    expect(map['customDays'], [1, 3, 5]);
  });

  test('Habit deserialization handles missing fields (backward compatibility)', () {
    final oldMap = {
      "id": "2",
      "title": "Old Habit",
      "description": "Was made before update",
      "createdAt": "2023-01-01T00:00:00.000",
      "completions": [],
      // missing schedule, weeklyTarget, customDays
    };

    final habit = Habit.fromMap(oldMap);

    expect(habit.schedule, ScheduleType.daily); // Default
    expect(habit.weeklyTarget, 1); // Default
    expect(habit.customDays, isEmpty);
  });
  
  test('Habit deserialization handles new fields', () {
    final newMap = {
      "id": "3",
      "title": "New Habit",
      "description": "With schedule",
      "createdAt": "2023-01-01T00:00:00.000",
      "completions": [],
      "schedule": 2, // ScheduleType.customDays
      "weeklyTarget": 1,
      "customDays": [2, 4],
    };

    final habit = Habit.fromMap(newMap);

    expect(habit.schedule, ScheduleType.customDays);
    expect(habit.customDays, [2, 4]);
  });
}
