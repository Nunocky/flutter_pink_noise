// https://qiita.com/mkosuke/items/f9a3f099be264491d106

import 'package:flutter/cupertino.dart';

// 時・分の表示カラムの幅です
const double _kColumnWidths = 48.0;

class TimePickerWidget extends StatefulWidget {
  // 後述の[TimePickerController]が必須パラメータです。[TimePickerController]経由で日時の操作・取得を行います。
  const TimePickerWidget({super.key, required this.controller});

  final TimePickerController controller;

  @override
  TimePickerState createState() => TimePickerState();
}

class TimePickerState extends State<TimePickerWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHourPicker(),
        // 時、分の間のコロンです。私の好みで追加しました。
        _buildSeparator(),
        _buildMinutePicker(),
      ],
    );
  }

  /// 「時」選択Picker
  Widget _buildHourPicker() {
    return _buildPicker(24, widget.controller._hourController);
  }

  /// 「分」選択Picker
  Widget _buildMinutePicker() {
    return _buildPicker(60, widget.controller._minuteController);
  }

  /// Picker生成
  /// [size]の分のPickerを作ります。操作できるように[FixedExtentScrollController]を渡してください
  Widget _buildPicker(int size, FixedExtentScrollController controller) {
    return SizedBox(
      width: _kColumnWidths,
      // 数値は[CupertinoDatePicker]を参考にしています
      child: CupertinoPicker(
        // backgroundColor: Colors.white,
        scrollController: controller,
        offAxisFraction: 0.45,
        itemExtent: 32,
        useMagnifier: true,
        magnification: 2.35 / 2.1,
        squeeze: 1.25,
        looping: true,
        onSelectedItemChanged: (_) {},
        children: List.generate(size, (int index) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SizedBox(
                  width: _kColumnWidths, child: _buildLabel(context, index)),
            ),
          );
        }),
      ),
    );
  }

  /// Pickerの選択肢となるテキストラベルを生成します
  Widget _buildLabel(BuildContext context, int number) {
    return Text(
      number.toString().padLeft(2, '0'),
      style: CupertinoTheme.of(context).textTheme.dateTimePickerTextStyle,
    );
  }

  Widget _buildSeparator() {
    return const Text(' : ',
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500));
  }

  @override
  void dispose() {
//    widget.controller._dispose();
    super.dispose();
  }
}

// [TimePicker]と同じファイルに記述します

class TimePickerController {
  TimePickerController()
      : _hourController = FixedExtentScrollController(initialItem: 0),
        _minuteController = FixedExtentScrollController(initialItem: 0);

  final FixedExtentScrollController _hourController;
  final FixedExtentScrollController _minuteController;

  /// 時刻の設定。これが今回一番実現したかったこと。
  void setTime(DateTime time) {
    _hourController.animateToItem(time.hour,
        duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
    _minuteController.animateToItem(time.minute,
        duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
  }

  int get hour {
    if (!_hourController.hasClients) {
      return 0;
    }
    // 何周もすると、マイナスにも24以上の値にもなってしまうため、あまりを求める
    return _hourController.selectedItem % 24;
  }

  int get minute {
    if (!_minuteController.hasClients) {
      return 0;
    }
    return _minuteController.selectedItem % 60;
  }

  /// [TimePicker]内で自動で開放します
  void _dispose() {
    _hourController.dispose();
    _minuteController.dispose();
  }
}
