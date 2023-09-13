import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surelight/providers/live_scene_provider.dart';

class FixturesScreen extends ConsumerStatefulWidget {
  const FixturesScreen({super.key});

  @override
  ConsumerState<FixturesScreen> createState() => _FixturesScreenState();
}

class _FixturesScreenState extends ConsumerState<FixturesScreen> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final liveScene = ref.watch(liveSceneProvider);
    return Material(
      color: Colors.transparent,
      child: Column(
        children: [
          Spacer(),
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Expanded(
                    child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: ListView.separated(
                      itemCount: liveScene.fixtures.length,
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 15,
                      ),
                      itemBuilder: (context, index) {
                        final fixture = liveScene.fixtures[index];
                        return ListTile(
                          title: Text(fixture.data.name),
                          subtitle: Text(
                              'Starting Channel: ${fixture.startingChannel + 1}'),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          tileColor: Colors.white12,
                          selectedTileColor: Colors.white24,
                          selected: index == selectedIndex,
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                        );
                      },
                    ),
                  ),
                )),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: liveScene
                            .fixtures[selectedIndex].data.numberOfChannels,
                        separatorBuilder: (context, index) => const SizedBox(
                          width: 15,
                        ),
                        itemBuilder: (context, index) {
                          final fixture = liveScene.fixtures[selectedIndex];
                          final int channel = fixture.startingChannel + index;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              children: [
                                Expanded(
                                  child: RotatedBox(
                                    quarterTurns: 3,
                                    child: Slider(
                                      value: liveScene.currentStep.data[
                                              fixture.startingChannel + index] /
                                          255,
                                      onChanged: (value) {
                                        ref
                                            .read(liveSceneProvider.notifier)
                                            .setFixtureChannelValue(
                                                fixtureIndex: selectedIndex,
                                                channelIndex: index,
                                                value: (value * 255).toInt());
                                      },
                                      min: 0,
                                      max: 1,
                                      divisions: 255,
                                    ),
                                  ),
                                ),
                                Text('#${channel + 1}'),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
