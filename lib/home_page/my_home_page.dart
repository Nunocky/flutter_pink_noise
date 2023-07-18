import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import './timer_provider.dart';
import './time_picker_widget.dart';
import './timer_section.dart';
import './play_button.dart';
import './play_state_provider.dart';

final logger = Logger();

/// ホームページ
class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final _controller = TimePickerController();

  @override
  Widget build(BuildContext context) {
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
                Consumer(builder: (context, ref, _) {
                  final playState = ref.watch(playStateProvider);
                  final timer = ref.watch(timerProvider);

                  return TimerSection(
                    isPlaying: playState.isPlaying,
                    remainingSeconds: timer.remainingTime.inSeconds,
                    onTimerSetButtonClicked: () {
                      _onTimerSetButtonClicked(context, ref);
                    },
                    onTimerOffButtonClicked: () {
                      _onTimerOffButtonClicked(context, ref);
                    },
                    onTimerOnButtonClicked: () {
                      _onTimerOnButtonClicked(context, ref);
                    },
                  );
                }),
              ],
            ),
          ),
          Consumer(builder: (context, ref, _) {
            final playState = ref.watch(playStateProvider);
            return PlayButton(
              isPlaying: playState.isPlaying,
              onClicked: () {
                // 再生状態を反転させる
                playState.toggle();
              },
            );
          }),
          const Spacer(),

          // 動作しているタイマーが0になったら再生を停止する
          Consumer(builder: (context, ref, _) {
            final playState = ref.watch(playStateProvider);
            final timer = ref.watch(timerProvider);
            if (timer.isWorking && timer.remainingTime.inSeconds == 0) {
              /// MEMO : 状態を直接更新すると「ビルド中に再ビルドがかかる」状態になる
              Timer.run(() {
                Future.delayed(const Duration(milliseconds: 0), () {
                  timer.stopTimer();
                  playState.stop();
                });
              });
            }
            return Container();
          }),
        ],
      ),
    );
  }

  /// タイマー時間変更ボタンをタップ
  void _onTimerSetButtonClicked(BuildContext context, WidgetRef ref) {
    showTimerSetDialog(context, ref);
  }

  /// タイマー開始ボタンをタップ
  void _onTimerOnButtonClicked(BuildContext context, WidgetRef ref) async {
    showTimerSetDialog(context, ref);
  }

  /// タイマー停止ボタンをタップ
  void _onTimerOffButtonClicked(BuildContext context, WidgetRef ref) {
    // stop playing and timer
    ref.read(timerProvider.notifier).stopTimer();
    ref.read(playStateProvider.notifier).stop();
  }

  /// タイマー設定ダイアログの表示と処理
  void showTimerSetDialog(BuildContext context, WidgetRef ref) async {
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
      ref.read(timerProvider.notifier).selectedTime = time;
      if (0 < time.inSeconds) {
        ref.read(playStateProvider.notifier).start();
        ref.read(timerProvider.notifier).startTimer();
      } else {
        // timer is set to 0 -> stop playing
        ref.read(playStateProvider.notifier).stop();
        ref.read(timerProvider.notifier).stopTimer();
      }
    } else {
      // logger.d("timer set: cancelled");
      // do nothing
    }
  }
}
