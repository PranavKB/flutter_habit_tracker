import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/habit.dart';

class HabitProvider with ChangeNotifier {
  final SharedPreferences _prefs;
  List<Habit> _habits = [];

  List<Habit> get habits => _habits;

  HabitProvider(this._prefs) {
    _loadHabits();
  }

  void _loadHabits() {
    final data = _prefs.getString("habits");

    if (data != null) {
      final decoded = json.decode(data) as List;
      _habits = decoded.map((e) => Habit.fromMap(e)).toList();
      notifyListeners();
    }
  }

  void saveHabits() {
    final encoded = json.encode(_habits.map((h) => h.toMap()).toList());
    _prefs.setString("habits", encoded);
  }

  void addHabit(Habit habit) {
    _habits.add(habit);
    saveHabits();
    notifyListeners();
  }

  void markHabitComplete(String id) {
    final habit = _habits.firstWhere((h) => h.id == id);
    habit.toggleCompletion();
    saveHabits();
    notifyListeners();
  }

  void deleteHabit(String id) {
    _habits.removeWhere((h) => h.id == id);
    saveHabits();
    notifyListeners();
  }

  void updateHabit(Habit updatedHabit) {
    final index = _habits.indexWhere((h) => h.id == updatedHabit.id);
    if (index != -1) {
      _habits[index] = updatedHabit;
      saveHabits();
      notifyListeners();
    }
  }
}
