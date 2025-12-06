import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_habit_tracker/main.dart';
import 'package:flutter_habit_tracker/providers/habit_provider.dart';
import 'package:flutter_habit_tracker/providers/theme_provider.dart';

void main() {
  testWidgets('Habit Tracker smoke test', (WidgetTester tester) async {
    // Mock SharedPreferences
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => HabitProvider(prefs)),
          ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)),
        ],
        child: const MyApp(),
      ),
    );

    // Verify that our app title shows up
    expect(find.text('Habit Tracker'), findsOneWidget);
    
    // Verify that we start with no habits
    expect(find.text('No habits yet. Add one!'), findsOneWidget);

    // Verify FAB exists
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
