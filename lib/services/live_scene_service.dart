import 'dart:async';
import 'dart:developer';

import 'package:complete_timer/timer/complete_timer.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surelight/providers/artnet_provider.dart';
import 'package:surelight/services/artnet.dart';

class LiveScene extends StateNotifier<LiveSceneSettings> {
  final Ref ref;
  LiveScene(this.ref) : super(LiveSceneSettings.empty);

  List<DRGBStep> steps = [];

  // List<Color> colors = [];

  // Effect effect = Effect.stop;

  // int bpm = 120;

  CompleteTimer? timer;

  void setEffect(Effect newEffect) {
    state = state.copyWith(effect: newEffect);
    _restartCounter();
  }

  void setBPM(int newBPM) {
    state = state.copyWith(bpm: newBPM);
    _restartCounter();
  }

  void toggleColor(Color newColors) {
    if (state.colors.contains(newColors)) {
      // colors.remove(newColors);
      state = state.copyWith(
        colors: state.colors.where((element) => element != newColors).toList(),
      );
    } else {
      // colors.add(newColors);
      state = state.copyWith(
        colors: [...state.colors, newColors],
      );
    }
    _restartCounter();
  }

  void _restartCounter() {
    switch (state.effect) {
      case Effect.cycle:
        steps = cycleEffect();
      case Effect.stop:
        steps = [];
        return;
    }

    if (timer != null) {
      timer!.cancel();
    }

    timer = CompleteTimer(
      duration: Duration(
        milliseconds: (60000 / state.bpm).round(),
      ),
      periodic: true,
      callback: (b) {
        if (steps.isEmpty) {
          return;
        }
        log('BEAT ${b.tick}');
        _setStep(steps[b.tick % steps.length]);
      },
    );

    timer!.start();
  }

  void toggleTimer(bool value) {
    if (value) {
      timer!.start();
    } else {
      timer!.stop();
    }
  }

  void _setStep(DRGBStep step) {
    final artnet = ref.read(artNetProvider);
    artnet.sendOpOutput(
      data: Uint8List.fromList(step.data),
      ip: '192.168.1.9',
    );
  }

  int colorIndex(Color color) => state.colors.indexOf(color);

  get bpm => state.bpm;
  get effect => state.effect;

  List<DRGBStep> cycleEffect() {
    List<DRGBStep> result =
        state.colors.map((e) => DRGBStep(r: e.red, g: e.green, b: e.blue)).toList();

    return result;
  }
}

class DRGBStep {
  final int r;
  final int g;
  final int b;
  final int d;

  DRGBStep({
    required this.r,
    required this.g,
    required this.b,
    this.d = 255,
  });

  List<int> get data => [r, g, b, d];
}

enum Effect { stop, cycle }

class LiveSceneSettings {
  final Effect effect;
  final int bpm;
  final List<Color> colors;

  LiveSceneSettings({
    required this.effect,
    required this.bpm,
    required this.colors,
  });

  LiveSceneSettings copyWith({
    Effect? effect,
    int? bpm,
    List<Color>? colors,
  }) {
    return LiveSceneSettings(
      effect: effect ?? this.effect,
      bpm: bpm ?? this.bpm,
      colors: colors ?? this.colors,
    );
  }

  //Empty
  static LiveSceneSettings get empty => LiveSceneSettings(
        effect: Effect.stop,
        bpm: 120,
        colors: [],
      );
}
