import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surelight/providers/live_scene_provider.dart';
import 'package:surelight/screens/main_screen/shared_components/hold_button.dart';
import 'package:surelight/services/live_scene_service.dart';

class EffectsGrid extends ConsumerStatefulWidget {
  const EffectsGrid({super.key});

  @override
  ConsumerState<EffectsGrid> createState() => _EffectsGridState();
}

class _EffectsGridState extends ConsumerState<EffectsGrid> {
  @override
  Widget build(BuildContext context) {
    final liveScene = ref.watch(liveSceneProvider);
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Slider(
              value: liveScene.bpm.toDouble(),
              min: 15,
              max: 240,
              divisions: 15,
              label: liveScene.bpm.toString(),
              onChanged: (double value) {
                ref.watch(liveSceneProvider.notifier).setBPM(value.toInt());
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: Effect.values.length,
              itemBuilder: (BuildContext context, int selectedIndex) {
                return HoldButton(
                  title: Effect.values[selectedIndex].name.toUpperCase(),
                  color: selectedIndex == 0 ? Colors.red : null,
                  isPressed: selectedIndex == liveScene.effect.index,
                  onPressed: () {
                    ref
                        .watch(liveSceneProvider.notifier)
                        .setEffect(Effect.values[selectedIndex]);
                    setState(() {});
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
