import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'startup_video_player.dart';

typedef StartupDestinationResolver = FutureOr<String> Function();

String defaultStartupDestinationResolver() => '/';

class StartupPage extends StatefulWidget {
  const StartupPage({
    super.key,
    this.destinationResolver = defaultStartupDestinationResolver,
    this.videoPlayerFactory = AssetStartupVideoPlayer.new,
  });

  final StartupDestinationResolver destinationResolver;
  final StartupVideoPlayerFactory videoPlayerFactory;

  @override
  State<StartupPage> createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  late final StartupVideoPlayer _videoPlayer;
  bool _navigationStarted = false;
  bool _isVideoReady = false;

  @override
  void initState() {
    super.initState();

    _videoPlayer = widget.videoPlayerFactory();
    _videoPlayer.addListener(_onVideoChanged);
    unawaited(_initializeVideo());
  }

  Future<void> _initializeVideo() async {
    try {
      await _videoPlayer.initialize();
      if (!mounted) {
        return;
      }

      setState(() {
        _isVideoReady = true;
      });
      await _videoPlayer.play();
    } catch (_) {
      if (mounted) {
        unawaited(_resolveDestination());
      }
    }
  }

  void _onVideoChanged() {
    if (_videoPlayer.isCompleted) {
      unawaited(_resolveDestination());
      return;
    }

    if (mounted && _videoPlayer.isInitialized && !_isVideoReady) {
      setState(() {
        _isVideoReady = true;
      });
    }
  }

  Future<void> _resolveDestination() async {
    if (_navigationStarted) {
      return;
    }
    _navigationStarted = true;

    String destination = '/';
    try {
      destination = await widget.destinationResolver();
    } catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'startup',
          context: ErrorDescription('while resolving the startup destination'),
        ),
      );
    }

    if (mounted) {
      context.go(destination);
    }
  }

  @override
  void dispose() {
    _videoPlayer.removeListener(_onVideoChanged);
    unawaited(_videoPlayer.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Semantics(
          label: 'RITMO startup video',
          child: _isVideoReady
              ? AspectRatio(
                  aspectRatio: _videoPlayer.aspectRatio,
                  child: _videoPlayer.buildView(),
                )
              : const SizedBox.expand(),
        ),
      ),
    );
  }
}
