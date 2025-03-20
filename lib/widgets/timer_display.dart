import 'package:flutter/material.dart';

class TimerDisplay extends StatelessWidget {
  final int remainingTime;
  final AnimationController animationController;

  const TimerDisplay({
    super.key,
    required this.remainingTime,
    required this.animationController,
  });

  String get formattedTime {
    final minutes = (remainingTime ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingTime % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 150,
      height: 150,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              return CircularProgressIndicator(
                value: animationController.value,
                strokeWidth: 8,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation(theme.primary),
              );
            },
          ),
          Center(
            child: Text(
              formattedTime,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}