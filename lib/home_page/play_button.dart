import 'package:flutter/material.dart';

/// 再生・停止ボタン
class PlayButton extends StatelessWidget {
  const PlayButton(
      {super.key, required this.isPlaying, required this.onClicked});

  final bool isPlaying;
  final VoidCallback onClicked;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 96,
      icon: isPlaying
          ? const Icon(Icons.pause_circle_filled)
          : const Icon(Icons.play_circle_fill),
      onPressed: onClicked,
    );
  }
}
