import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../logger.dart';

// 再生状態を監視し、バックグラウンドで音を鳴らす StateNotifier を作る
// それを使って、ボタンを押したら音を鳴らす
final playStateProvider = StateNotifierProvider<PlayStateNotifier, bool>((ref) {
  return PlayStateNotifier(false);
});

class PlayStateNotifier extends StateNotifier<bool> {
  PlayStateNotifier(super.state);

  void toggle() {
    state = !state;

    if (state) {
      // 音を鳴らす
      logger.d("TODO: 音を鳴らす");
    } else {
      // 音を止める
      logger.d("TODO: 音を止める");
    }
  }
}
