import 'dart:convert';

class Habit {
  String id;
  String title;
  String description;
  DateTime createdAt;
  List<DateTime> completions;

  Habit({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.completions,
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
    );
  }
}
