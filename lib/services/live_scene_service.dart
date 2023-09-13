import 'dart:async';
import 'dart:developer';

import 'package:complete_timer/timer/complete_timer.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surelight/const.dart';
import 'package:surelight/models/fixture/fixture.dart';
import 'package:surelight/providers/artnet_provider.dart';
import 'package:surelight/services/artnet.dart';

class LiveScene extends StateNotifier<LiveSceneSettings> {
  final Ref ref;
  LiveScene(this.ref) : super(LiveSceneSettings.empty);

  List<Step> steps = [];

  List<Fixture> fixtures = [
    Fixture(data: basicFixture, startingChannel: 7),
    Fixture(data: basicFixture, startingChannel: 14),
    Fixture(data: basicFixture, startingChannel: 32),
    Fixture(data: basicFixture, startingChannel: 50),
  ];

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
      case Effect.constant:
        steps = constantEffect();
      case Effect.cycle:
        steps = cycleEffect();
      case Effect.chase:
        steps = chaseEffect();
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

  void _setStep(Step step) {
    log(step.data.toString());
    final artnet = ref.read(artNetProvider);
    artnet.sendOpOutput(
      data: Uint8List.fromList(step.data),
      ip: '192.168.1.9',
    );
  }

  // int colorIndex(Color color) => state.colors.indexOf(color);

  get bpm => state.bpm;
  get effect => state.effect;

  List<Step> constantEffect() {
    List<Step> result = <Step>[];
    if (state.colors.isEmpty) {
      return result;
    }
    List<int> data = List.filled(512, 0);
    Color color = state.colors.last;
    for (var fixture in fixtures) {
      data.setAll(fixture.startingChannel, [
        color.red,
        color.green,
        color.blue,
        255,
      ]);
      result.add(Step(data: data));
    }

    return result;
  }

  List<Step> cycleEffect() {
    List<Step> result = <Step>[];
    if (state.colors.isEmpty) {
      return result;
    }
    for (var color in state.colors) {
      for (var fixture in fixtures) {
        List<int> data = List.filled(512, 0);
        data.setAll(fixture.startingChannel, [
          color.red,
          color.green,
          color.blue,
          255,
        ]);
        result.add(Step(data: data));
      }
    }

    return result;
  }

  List<Step> chaseEffect() {
    List<Step> result = <Step>[];
    if (state.colors.isEmpty) {
      return result;
    }
    for (var color in state.colors) {
      List<int> data = List.filled(512, 0);
      for (var fixture in fixtures) {
        data.setAll(fixture.startingChannel, [
          color.red,
          color.green,
          color.blue,
          255,
        ]);
        result.add(Step(data: data));
      }
    }

    return result;
  }
}

class Step {
  final List<int> data;

  Step({required this.data});
}

enum Effect { stop, constant, cycle, chase }

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
