import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:lagom_lands/controllers/timer_controller.dart';

void main() {
  late TimerController timerController;
  late AnimationController animationController;
  bool timerCompleted = false;

  setUp(() {
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
    expect(timerController.remainingTime, 2);

    await Future.delayed(const Duration(seconds: 3));
    expect(timerController.remainingTime, 0);
    expect(timerCompleted, true);
  });

  test('Timer stops and resets correctly', () async {
    timerController.startTimer();
    await Future.delayed(const Duration(seconds: 2));

    timerController.stopTimer();
    expect(timerController.remainingTime, 5);
    expect(animationController.value, 0);
  });
}

class TestVSync implements TickerProvider {
  const TestVSync();
  @override
  Ticker createTicker(onTick) => Ticker(onTick);
}