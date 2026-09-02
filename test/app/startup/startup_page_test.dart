import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:workout_companion_v1/app/startup/startup_page.dart';
import 'package:workout_companion_v1/app/startup/startup_video_player.dart';

void main() {
  test('RITMO startup video asset is registered', () async {
    final data = await rootBundle.load(ritmoStartupVideoAssetPath);
    expect(data.lengthInBytes, greaterThan(0));
  });

  testWidgets('StartupPage renders the RITMO startup video', (tester) async {
    final videoPlayer = _FakeStartupVideoPlayer();

    await tester.pumpWidget(
      MaterialApp(home: StartupPage(videoPlayerFactory: () => videoPlayer)),
    );
    await tester.pump();

    expect(find.bySemanticsLabel('RITMO startup video'), findsOneWidget);
    expect(find.byKey(const Key('startup-video-view')), findsOneWidget);
    expect(videoPlayer.playCalls, 1);
  });

  testWidgets(
    'video completion resolves the Dashboard destination once and is removed',
    (tester) async {
      var resolverCalls = 0;
      final videoPlayer = _FakeStartupVideoPlayer();
      final router = _startupRouter(
        destinationResolver: () {
          resolverCalls += 1;
          return '/dashboard';
        },
        videoPlayerFactory: () => videoPlayer,
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pump();
      videoPlayer.complete();
      videoPlayer.complete();
      await tester.pumpAndSettle();

      expect(find.text('Dashboard destination'), findsOneWidget);
      expect(resolverCalls, 1);
      expect(router.canPop(), isFalse);
      expect(find.byType(StartupPage), findsNothing);
    },
  );

  testWidgets('startup supports an asynchronous destination resolver', (
    tester,
  ) async {
    final destination = Completer<String>();
    final videoPlayer = _FakeStartupVideoPlayer();
    final router = _startupRouter(
      destinationResolver: () => destination.future,
      videoPlayerFactory: () => videoPlayer,
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pump();
    videoPlayer.complete();
    await tester.pump();
    expect(find.byType(StartupPage), findsOneWidget);

    destination.complete('/dashboard');
    await tester.pumpAndSettle();

    expect(find.text('Dashboard destination'), findsOneWidget);
    expect(router.canPop(), isFalse);
  });

  testWidgets('video initialization failure falls back to the destination', (
    tester,
  ) async {
    var resolverCalls = 0;
    final router = _startupRouter(
      destinationResolver: () {
        resolverCalls += 1;
        return '/dashboard';
      },
      videoPlayerFactory: () => _FakeStartupVideoPlayer(failInitialize: true),
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    expect(find.text('Dashboard destination'), findsOneWidget);
    expect(resolverCalls, 1);
    expect(router.canPop(), isFalse);
  });
}

GoRouter _startupRouter({
  required StartupDestinationResolver destinationResolver,
  required StartupVideoPlayerFactory videoPlayerFactory,
}) {
  return GoRouter(
    initialLocation: '/startup',
    routes: [
      GoRoute(
        path: '/startup',
        builder: (context, state) => StartupPage(
          destinationResolver: destinationResolver,
          videoPlayerFactory: videoPlayerFactory,
        ),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Dashboard destination'))),
      ),
    ],
  );
}

class _FakeStartupVideoPlayer implements StartupVideoPlayer {
  _FakeStartupVideoPlayer({this.failInitialize = false});

  final bool failInitialize;
  final Set<VoidCallback> _listeners = {};
  bool _isInitialized = false;
  bool _isCompleted = false;
  int playCalls = 0;

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

  void complete() {
    _isCompleted = true;
    _notifyListeners();
  }

  @override
  Widget buildView() =>
      const ColoredBox(key: Key('startup-video-view'), color: Colors.black);

  @override
  Future<void> dispose() async {}

  @override
  Future<void> initialize() async {
    if (failInitialize) {
      throw StateError('Video unavailable');
    }
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
    playCalls += 1;
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }
}
