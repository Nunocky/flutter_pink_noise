import 'package:flutter/material.dart';
import 'package:flutter_pink_noise/home_page/timer_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import './time_picker_widget.dart';
import './timer_section.dart';
import './play_button.dart';
import './play_state_provider.dart';
import './timer_provider.dart';

final logger = Logger();

/// ホームページ
class MyHomePage extends ConsumerWidget {
  MyHomePage({super.key});

  final _controller = TimePickerController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPlaying = ref.watch(playStateProvider);
    final timer = ref.watch(timerProvider);

    final remainingSecond = timer.remainingTime.inSeconds;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Pink Noise"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TimerSection(
                  isPlaying: isPlaying,
                  remainingSeconds: remainingSecond,
                  onTimerSetButtonClicked: () {
                    _onTimerSetButtonClicked(context, ref);
                  },
                  onTimerOffButtonClicked: () {
                    _onTimerOffButtonClicked(context, ref);
                  },
                  onTimerOnButtonClicked: () {
                    _onTimerOnButtonClicked(context, ref);
                  },
                ),
              ],
            ),
          ),
          PlayButton(
            isPlaying: isPlaying,
            onClicked: () {
              // 再生状態を反転させる
              ref.read(playStateProvider.notifier).toggle();
            },
          ),
          const Spacer(),
        ],
      ),
    );
  }

  /// タイマー時間変更ボタンをタップ
  void _onTimerSetButtonClicked(BuildContext context, WidgetRef ref) {}

  /// タイマー開始ボタンをタップ
  void _onTimerOnButtonClicked(BuildContext context, WidgetRef ref) async {
//    logger.d("_onTimerOnButtonClicked");
    final time = await showDialog<Duration?>(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 200,
                  child: TimePickerWidget(
                    controller: _controller,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(null);
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  final hours = _controller.hour;
                  final seconds = _controller.minute;
                  Navigator.of(context)
                      .pop(Duration(hours: hours, minutes: seconds));
                },
                child: const Text("OK"),
              ),
            ],
          );
        });

    if (time != null) {
      // タイマー時間を更新する
      // ref.read(playStateProvider.notifier).setTimer(time); // 未実装
      ref.read(timerProvider.notifier).selectedTime = time;
      logger.d("timer set: $time");
    } else {
      logger.d("timer set: cancelled");
    }
  }

  /// タイマー停止ボタンをタップ
  void _onTimerOffButtonClicked(BuildContext context, WidgetRef ref) {
    // TODO(nunokawa) IMPLEMENT THIS
    logger.d("_onTimerOffButtonClicked");
  }
}
