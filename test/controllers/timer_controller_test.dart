import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:lagom_lands/controllers/timer_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TimerController timerController;
  late AnimationController animationController;
  late bool timerCompleted;

  setUp(() {
    timerCompleted = false;
    animationController = AnimationController(
      vsync: const TestVSync(),
      duration: const Duration(seconds: 5),
    );
    timerController = TimerController(
      initialTime: 5,
      animationController: animationController,
      onTimerComplete: () => timerCompleted = true,
    );
  });

  tearDown(() {
    timerController.dispose();
    animationController.dispose();
  });

  test('Timer counts down and completes correctly', () async {
    timerController.startTimer();
    expect(timerController.remainingTime, 5);

    await Future.delayed(const Duration(seconds: 6));
    // ensure callback is called
    expect(timerCompleted, true);
    //ensure timer is reset
    expect(timerController.remainingTime, 5);
  });

  test('Timer stops and resets correctly if cancelled', () async {
    timerController.startTimer();
    await Future.delayed(const Duration(seconds: 2));

    timerController.stopTimer();
    expect(timerController.remainingTime, 5);
    expect(animationController.value, 0);
  });

  test('Timer handles rapid start-stop actions gracefully', () async {
    // Rapidly start and stop the timer multiple times
    for (int i = 0; i < 5; i++) {
      timerController.startTimer();
      await Future.delayed(const Duration(milliseconds: 200));
      timerController.stopTimer();
      await Future.delayed(const Duration(milliseconds: 100));
    }

    // Check if the timer is correctly reset and no callbacks were wrongly triggered
    expect(timerController.remainingTime, 5);
    expect(animationController.value, 0);
    expect(timerCompleted, false);

    // Finally, start the timer fully to completion to confirm it still works normally
    timerController.startTimer();
    await Future.delayed(const Duration(seconds: 6));
    expect(timerCompleted, true);
    expect(timerController.remainingTime, 5);
  });
}

class TestVSync implements TickerProvider {
  const TestVSync();
  @override
  Ticker createTicker(onTick) => Ticker(onTick);
}