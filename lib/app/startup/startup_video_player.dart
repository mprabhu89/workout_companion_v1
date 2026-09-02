import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

const ritmoStartupVideoAssetPath = 'assets/videos/ritmo_startup_intro.mp4';

typedef StartupVideoPlayerFactory = StartupVideoPlayer Function();

abstract interface class StartupVideoPlayer {
  Future<void> initialize();
  Future<void> play();
  bool get isInitialized;
  bool get isCompleted;
  double get aspectRatio;
  void addListener(VoidCallback listener);
  void removeListener(VoidCallback listener);
  Widget buildView();
  Future<void> dispose();
}

class AssetStartupVideoPlayer implements StartupVideoPlayer {
  AssetStartupVideoPlayer()
    : _controller = VideoPlayerController.asset(
        ritmoStartupVideoAssetPath,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: false),
      );

  final VideoPlayerController _controller;

  @override
  bool get isInitialized => _controller.value.isInitialized;

  @override
  bool get isCompleted {
    final value = _controller.value;
    return value.isInitialized &&
        value.duration > Duration.zero &&
        value.position >= value.duration &&
        !value.isPlaying;
  }

  @override
  double get aspectRatio {
    final aspectRatio = _controller.value.aspectRatio;
    return aspectRatio > 0 ? aspectRatio : 9 / 16;
  }

  @override
  void addListener(VoidCallback listener) {
    _controller.addListener(listener);
  }

  @override
  Widget buildView() => VideoPlayer(_controller);

  @override
  Future<void> dispose() => _controller.dispose();

  @override
  Future<void> initialize() => _controller.initialize();

  @override
  Future<void> play() => _controller.play();

  @override
  void removeListener(VoidCallback listener) {
    _controller.removeListener(listener);
  }
}
