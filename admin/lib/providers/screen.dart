import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

class FrameLessNotifier extends StateNotifier<bool> {
  FrameLessNotifier() : super(false);

  Future<void> setFrameLess(bool value) async {
    if (value == true) {
      await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
    } else {
      await windowManager.setTitleBarStyle(TitleBarStyle.normal);
    }

    state = value;
  }
}

// Riverpod provider for FrameLessNotifier
final frameLessProvider = StateNotifierProvider<FrameLessNotifier, bool>((ref) {
  return FrameLessNotifier();
});
