import 'package:flutter/material.dart';
import 'package:flutter_pink_noise/home_page/timer_section.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import './play_button.dart';
import './play_state_provider.dart';

/// ホームページ
class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isPlaying = ref.watch(playStateProvider);
    final remainingSecond = 777; // TODO(nunokawa) 再生タイマーのプロバイダを作る

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
                  onTimerSetButtonClicked: _onTimerSetButtonClicked,
                  onTimerOffButtonClicked: _onTimerOffButtonClicked,
                  onTimerOnButtonClicked: _onTimerOnButtonClicked,
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
  void _onTimerSetButtonClicked() {
    // TODO(nunokawa) IMPLEMENT THIS
  }

  /// タイマー開始ボタンをタップ
  void _onTimerOnButtonClicked() {
    // TODO(nunokawa) IMPLEMENT THIS
  }

  /// タイマー停止ボタンをタップ
  void _onTimerOffButtonClicked() {
    // TODO(nunokawa) IMPLEMENT THIS
  }
}
