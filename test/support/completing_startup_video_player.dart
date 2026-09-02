import 'package:flutter/material.dart';
import 'package:workout_companion_v1/app/startup/startup_video_player.dart';

class CompletingStartupVideoPlayer implements StartupVideoPlayer {
  final Set<VoidCallback> _listeners = {};
  bool _isInitialized = false;
  bool _isCompleted = false;

  @override
  double get aspectRatio => 9 / 16;

  @override
  bool get isCompleted => _isCompleted;

  @override
  bool get isInitialized => _isInitialized;

  @override
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  @override
  Widget buildView() => const SizedBox.expand();

  @override
  Future<void> dispose() async {}

  @override
  Future<void> initialize() async {
    _isInitialized = true;
    _notifyListeners();
  }

  void _notifyListeners() {
    for (final listener in List<VoidCallback>.of(_listeners)) {
      listener();
    }
  }

  @override
  Future<void> play() async {
    _isCompleted = true;
    _notifyListeners();
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }
}
