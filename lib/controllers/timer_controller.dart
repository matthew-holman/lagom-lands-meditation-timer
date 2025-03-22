import 'dart:async';
import 'package:flutter/material.dart';

class TimerController extends ChangeNotifier {
  int initialTime;
  late int remainingTime;
  Timer? _timer;
  final AnimationController animationController;
  final VoidCallback onTimerComplete;

  TimerController({
    required this.initialTime,
    required this.animationController,
    required this.onTimerComplete,
  }) {
    remainingTime = initialTime;
  }

  void startTimer() {
    _timer?.cancel();  // Ensure previous timer is canceled
    remainingTime = initialTime;
    animationController.duration = Duration(seconds: initialTime);
    animationController.forward(from: 0);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      remainingTime--;
      animationController.value = 1 - (remainingTime / initialTime);
      notifyListeners();

      if (remainingTime <= 0) {
        stopTimer();
        onTimerComplete();
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    animationController.reset();
    remainingTime = initialTime;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}