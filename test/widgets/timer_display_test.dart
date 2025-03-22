import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:lagom_lands/widgets/timer_display.dart';

void main() {
  testWidgets('TimerDisplay editable interaction test', (WidgetTester tester) async {
    int? updatedDuration;

    final animationController = AnimationController(
      vsync: const TestVSync(),
      duration: const Duration(seconds: 60),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TimerDisplay(
            remainingTime: 60,
            animationController: animationController,
            onDurationChanged: (int duration) {
              updatedDuration = duration;
            },
          ),
        ),
      ),
    );

    // Verify initial state is displayed
    expect(find.text('01:00'), findsOneWidget);

    // Tap on the TimerDisplay to start editing
    await tester.tap(find.text('01:00'));
    await tester.pumpAndSettle();

    // TextField should appear
    expect(find.byType(TextField), findsOneWidget);

    // Enter a new duration
    await tester.enterText(find.byType(TextField), '02:30');
    await tester.pump();

    // Now simulate losing focus by tapping outside
    await tester.tapAt(const Offset(0, 0)); // tap away to remove focus
    await tester.pumpAndSettle();

    // Verify TextField is gone and display is updated
    expect(find.byType(TextField), findsNothing);
    expect(find.text('02:30'), findsOneWidget);

    // Ensure the callback was correctly called with new duration
    expect(updatedDuration, 150); // 2 minutes 30 seconds = 150 seconds
  });
}

// Helper for animation tests
class TestVSync implements TickerProvider {
  const TestVSync();
  @override
  Ticker createTicker(onTick) => Ticker(onTick);
}