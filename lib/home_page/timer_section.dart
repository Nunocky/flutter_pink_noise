import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

/// ホーム画面 タイマー残り時間表示と設定ボタン
class TimerSection extends StatelessWidget {
  const TimerSection({
    super.key,
    required this.isPlaying,
    required this.remainingSeconds,
    this.onTimerSetButtonClicked,
    this.onTimerOnButtonClicked,
    this.onTimerOffButtonClicked,
  });

  final bool isPlaying;
  final int remainingSeconds;
  final VoidCallback? onTimerSetButtonClicked;
  final VoidCallback? onTimerOnButtonClicked;
  final VoidCallback? onTimerOffButtonClicked;

  @override
  Widget build(BuildContext context) {
    if (0 < remainingSeconds) {
      // 残り時間あり : 残り時間ボタンとアイコンボタン
      return Row(
        children: [
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
            ),
            onPressed: () {
              onTimerSetButtonClicked?.call();
            },
            child: Text(_formatTime(remainingSeconds)),
          ),
          Padding(
            padding: const EdgeInsets.all(4),
            child: CircleAvatar(
              radius: 24,
              child: IconButton(
                onPressed: () {
                  onTimerOffButtonClicked?.call();
                },
                icon: const Icon(Icons.timer_off),
              ),
            ),
          ),
        ],
      );
    } else {
      // 残り時間なし : アイコンボタン
      return Row(
        children: [
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(4),
            child: CircleAvatar(
              radius: 24,
              child: IconButton(
                onPressed: () {
                  onTimerOffButtonClicked?.call();
                },
                icon: const Icon(Icons.timer),
              ),
            ),
          ),
        ],
      );
    }
  }
}

/// 秒を "hh:mm:ss"の形式に変換。分と秒は 0で埋めて 2桁にする。
String _formatTime(int remainingSeconds) {
  final hours = remainingSeconds ~/ 3600;
  final minutes = (remainingSeconds - (hours * 3600)) ~/ 60;
  final seconds = remainingSeconds % 60;
  return sprintf("%d:%02d:%02d", [hours, minutes, seconds]);
}
