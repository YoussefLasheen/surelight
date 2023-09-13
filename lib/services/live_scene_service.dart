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

  CompleteTimer? timer;

  void setEffect(Effect newEffect) {
    state = state.copyWith(effect: newEffect);
    _restartCounter();
  }

  void setBPM(int newBPM) {
    state = state.copyWith(bpm: newBPM);
    _restartCounter();
  }

  void setFixtureChannelValue({
    required int fixtureIndex,
    required int channelIndex,
    required int value,
  }) {
    final fixtureStartingChannel = state.fixtures[fixtureIndex].startingChannel;
    final channel = fixtureStartingChannel + channelIndex;
    final newStep = currentStep.data;
    newStep[channel] = value;
    state = state.copyWith(
      steps: [Step(data: newStep)],
      effect: Effect.stop,
    );
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
        state = state.copyWith(steps: constantEffect());
      case Effect.cycle:
        state = state.copyWith(steps: cycleEffect());
      case Effect.chase:
        state = state.copyWith(steps: chaseEffect());
      case Effect.stop:
        state = state.copyWith(steps: []);
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
        if (state.steps.isEmpty) {
          return;
        }
        log('BEAT ${b.tick}');
        int tick = b.tick % state.steps.length;
        state = state.copyWith(tick: tick);
        _setStep();
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

  void _setStep() {
    Step step = state.steps[state.tick];
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
  get colors => state.colors;
  // get fixtures => state.fixtures;
  Step get currentStep {
    if (timer == null) {
      return state.steps[0];
    }
    return state.steps[timer!.tick % state.steps.length];
  }

  List<Step> constantEffect() {
    List<Step> result = <Step>[];
    if (state.colors.isEmpty) {
      return result;
    }
    List<int> data = List.filled(512, 0);
    Color color = state.colors.last;
    for (var fixture in state.fixtures) {
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

  List<Step> chaseEffect() {
    List<Step> result = <Step>[];
    if (state.colors.isEmpty) {
      return result;
    }
    for (var color in state.colors) {
      for (var fixture in state.fixtures) {
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

  List<Step> cycleEffect() {
    List<Step> result = <Step>[];
    if (state.colors.isEmpty) {
      return result;
    }
    for (var color in state.colors) {
      List<int> data = List.filled(512, 0);
      for (var fixture in state.fixtures) {
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
  final List<Fixture> fixtures;
  final List<Step> steps;
  final int tick;

  LiveSceneSettings({
    required this.effect,
    required this.bpm,
    required this.colors,
    required this.fixtures,
    required this.steps,
    required this.tick,
  });

  LiveSceneSettings copyWith(
      {Effect? effect,
      int? bpm,
      List<Color>? colors,
      List<Fixture>? fixtures,
      List<Step>? steps,
      int? tick}) {
    return LiveSceneSettings(
      effect: effect ?? this.effect,
      bpm: bpm ?? this.bpm,
      colors: colors ?? this.colors,
      fixtures: fixtures ?? this.fixtures,
      steps: steps ?? this.steps,
      tick: tick ?? this.tick,
    );
  }

  //Empty
  static LiveSceneSettings get empty => LiveSceneSettings(
        effect: Effect.stop,
        bpm: 120,
        colors: [],
        steps: [],
        fixtures: builtInfixtures,
        tick: 0,
      );

  Step get currentStep {
    if (steps.isEmpty) {
      return Step(data: List.filled(512, 0));
    }
    return steps[tick % steps.length];
  }
}

List<Fixture> builtInfixtures = [
  Fixture(data: basicFixture, startingChannel: 7),
  Fixture(data: basicFixture, startingChannel: 15),
  Fixture(data: basicFixture, startingChannel: 32),
  Fixture(data: basicFixture, startingChannel: 50),
];
