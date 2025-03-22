import 'package:flutter/material.dart';

class TimerDisplay extends StatefulWidget {
  final int remainingTime;
  final AnimationController animationController;
  final Function(int) onDurationChanged;

  const TimerDisplay({
    super.key,
    required this.remainingTime,
    required this.animationController,
    required this.onDurationChanged,
  });

  @override
  State<TimerDisplay> createState() => _TimerDisplayState();
}

class _TimerDisplayState extends State<TimerDisplay> {
  late bool isEditing;
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    isEditing = false;
    _controller = TextEditingController();
    _focusNode = FocusNode();

    // Listener for focus changes
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && isEditing) {
        _finishEditing();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String get formattedTime {
    final minutes = (widget.remainingTime ~/ 60).toString().padLeft(2, '0');
    final seconds = (widget.remainingTime % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  void _startEditing() {
    setState(() {
      isEditing = true;
      _controller.text = formattedTime;
      _focusNode.requestFocus();
    });
  }

  void _finishEditing() {
    final input = _controller.text;
    final parts = input.split(':');

    if (parts.length == 2) {
      final minutes = int.tryParse(parts[0]) ?? 0;
      final seconds = int.tryParse(parts[1]) ?? 0;
      final totalSeconds = (minutes * 60) + seconds;

      if (totalSeconds > 0) {
        widget.onDurationChanged(totalSeconds);
      }
    }

    setState(() {
      isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: _startEditing,
      child: SizedBox(
        width: 150,
        height: 150,
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedBuilder(
              animation: widget.animationController,
              builder: (context, child) {
                return CircularProgressIndicator(
                  value: widget.animationController.value,
                  strokeWidth: 8,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation(theme.primary),
                );
              },
            ),
            Center(
              child: isEditing
                  ? SizedBox(
                width: 80,
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode, // <-- Attach FocusNode here
                  autofocus: true,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: 'mm:ss',
                  ),
                  onSubmitted: (_) => _finishEditing(),
                  onEditingComplete: _finishEditing,
                ),
              )
                  : Text(
                formattedTime,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}