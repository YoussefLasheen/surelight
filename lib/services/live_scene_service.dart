import 'dart:async';
import 'dart:developer';

import 'package:complete_timer/timer/complete_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surelight/const.dart';
import 'package:surelight/models/fixture/fixture.dart';
import 'package:surelight/models/fixture/fixture_data.dart';
import 'package:surelight/providers/artnet_provider.dart';
import 'package:surelight/providers/settings_provider.dart';
import 'package:surelight/services/artnet.dart';

class LiveScene extends StateNotifier<LiveSceneSettings> {
  final Ref ref;
  LiveScene(this.ref) : super(LiveSceneSettings.empty);

  CompleteTimer? timer;

  void setEffect(Effect newEffect) {
    state = state.copyWith(effect: newEffect);
    if (newEffect == Effect.stop) state = state.copyWith(steps: []);
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
    final newStep = state.currentStep.data;
    newStep[channel] = value;
    state = state.copyWith(
      steps: [Step(data: newStep)],
      effect: Effect.stop,
    );
    _restartCounter();
  }

  void addFixture(FixtureData fixture, int startingChannel, String name) {
    if (fixture.name.isEmpty) {
      throw 'Fixture name cannot be empty';
    }

    // Check if channel range is available
    if (state.fixtures.any((element) =>
        startingChannel >= element.startingChannel &&
        startingChannel <=
            element.startingChannel + element.data.numberOfChannels)) {
      throw 'Channel range is not available';
    }

    var newState = state.copyWith(
      fixtures: [
        ...state.fixtures,
        Fixture(
          startingChannel: startingChannel,
          data: fixture,
          id: DateTime.now().toString(),
          name: name,
        )
      ],
    );
    newState.fixtures
        .sort((a, b) => a.startingChannel.compareTo(b.startingChannel));
    state = newState;

    _restartCounter();
  }

  void removeFixture(String id) {
    state = state.copyWith(
      fixtures: state.fixtures.where((element) => element.id != id).toList(),
    );
    _restartCounter();
  }

  void toggleColor(Color newColors) {
    if (state.colors.contains(newColors)) {
      // colors.remove(newColors);
      if (colors.length == 1) {
        return;
      }
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
    if (state.fixtures.isEmpty) {
      return;
    }
    switch (state.effect) {
      case Effect.constant:
        state = state.copyWith(steps: constantEffect());
      case Effect.cycle:
        state = state.copyWith(steps: cycleEffect());
      case Effect.chase:
        state = state.copyWith(steps: chaseEffect());
      case Effect.stop:
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
          log('NO STEPS');
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
    final settings = ref.read(settingsProvider);
    artnet.sendOpOutput(
      data: Uint8List.fromList(step.data),
      ip: settings.ip,
    );
  }

  // int colorIndex(Color color) => state.colors.indexOf(color);

  get bpm => state.bpm;
  get effect => state.effect;
  get colors => state.colors;

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
        colors: [
          Colors.blue,
          Colors.red,
          Colors.green,
        ],
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
  Fixture(name: 'Fixture 1', id: '1', data: basicFixture, startingChannel: 7),
];
