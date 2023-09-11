import 'dart:async';
import 'dart:developer';

import 'package:complete_timer/timer/complete_timer.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surelight/providers/artnet_provider.dart';
import 'package:surelight/services/artnet.dart';

class LiveScene {
  final Ref ref;
  LiveScene(this.ref);

  late final ArtNet artNet;

  List<DRGBStep> steps = [];

  List<Color> colors = [];

  Effect effect = Effect.cycle;

  int bpm = 120;

  CompleteTimer? timer;

  void toggleColor(Color newColors) {
    if (colors.contains(newColors)) {
      colors.remove(newColors);
    } else {
      colors.add(newColors);
    }
    _restartCounter();
  }

  void _restartCounter() {
    switch (effect) {
      case Effect.cycle:
        steps = cycleEffect();
    }

    if (timer != null) {
      timer!.cancel();
    }

    timer = CompleteTimer(
      duration: Duration(
        seconds: 1,
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

  List<DRGBStep> cycleEffect() {
    List<DRGBStep> result =
        colors.map((e) => DRGBStep(r: e.red, g: e.green, b: e.blue)).toList();

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

enum Effect { cycle }
