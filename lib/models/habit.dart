import 'dart:convert';

class Habit {
  String id;
  String title;
  String description;
  DateTime createdAt;
  List<DateTime> completions;
  ScheduleType schedule;
  List<int> customDays; // 1 = Monday, 7 = Sunday
  int weeklyTarget;

  Habit({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.completions,
    this.schedule = ScheduleType.daily,
    this.customDays = const [],
    this.weeklyTarget = 1,
  });

  void toggleCompletion() {
    final today = DateTime.now();
    completions.add(today);
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "description": description,
    "createdAt": createdAt.toIso8601String(),
    "completions": completions.map((d) => d.toIso8601String()).toList(),
    "schedule": schedule.index,
    "customDays": customDays,
    "weeklyTarget": weeklyTarget,
  };

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map["id"],
      title: map["title"],
      description: map["description"],
      createdAt: DateTime.parse(map["createdAt"]),
      completions: (map["completions"] as List)
          .map((d) => DateTime.parse(d))
          .toList(),
      schedule: map["schedule"] != null
          ? ScheduleType.values[map["schedule"]]
          : ScheduleType.daily,
      customDays: map["customDays"] != null
          ? List<int>.from(map["customDays"])
          : [],
      weeklyTarget: map["weeklyTarget"] ?? 1,
    );
  }
}

enum ScheduleType { daily, weekly, customDays }
