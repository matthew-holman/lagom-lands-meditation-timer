import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioPlayer _beepPlayer = AudioPlayer();
  bool isFading = false;

  Future<void> fadeIn() async {
    if (isFading) return;
    isFading = true;
    for (double vol = 0.0; vol <= 1.0; vol += 0.1) {
      await _audioPlayer.setVolume(vol);
      await Future.delayed(const Duration(milliseconds: 25));
    }
    isFading = false;
  }

  Future<void> fadeOut() async {
    if (isFading) return;
    isFading = true;
    for (double vol = 1.0; vol >= 0.0; vol -= 0.1) {
      await _audioPlayer.setVolume(vol);
      await Future.delayed(const Duration(milliseconds: 25));
    }
    await _audioPlayer.stop();
    isFading = false;
  }

  Future<void> playSound(String soundPath) async {
    await _audioPlayer.setSource(AssetSource(soundPath));
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.setVolume(0.0);
    await _audioPlayer.play(AssetSource(soundPath));
  }

  Future<void> playBeep() async {
    await _beepPlayer.setSource(AssetSource("sounds/beep.mp3"));
    await _beepPlayer.play(AssetSource("sounds/beep.mp3"));
  }

  void dispose() {
    _audioPlayer.dispose();
    _beepPlayer.dispose();
  }
}