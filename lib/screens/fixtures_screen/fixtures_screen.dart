import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surelight/models/fixture/fixture.dart';
import 'package:surelight/models/fixture/fixture_data.dart';
import 'package:surelight/providers/live_scene_provider.dart';
import 'package:surelight/screens/fixtures_screen/widgets/add_fixture_dialog.dart';

class FixturesScreen extends ConsumerStatefulWidget {
  const FixturesScreen({super.key});

  @override
  ConsumerState<FixturesScreen> createState() => _FixturesScreenState();
}

class _FixturesScreenState extends ConsumerState<FixturesScreen> {
  int? selectedIndex;
  @override
  Widget build(BuildContext context) {
    final liveScene = ref.watch(liveSceneProvider);
    return Material(
      color: Colors.black,
      child: Row(
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(right: 10, left: 10, top: 10),
                    child: ListView.separated(
                      itemCount: liveScene.fixtures.length,
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 15,
                      ),
                      itemBuilder: (context, index) {
                        final fixture = liveScene.fixtures[index];
                        return ListTile(
                          title: Text(fixture.name),
                          subtitle: Text(
                              '${fixture.data.name} : ${fixture.startingChannel + 1} - ${fixture.startingChannel + fixture.data.numberOfChannels}'),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              ref
                                  .read(liveSceneProvider.notifier)
                                  .removeFixture(fixture.id);
                            },
                          ),
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
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AddFixtureDialog(),
                      );
                    },
                    label: Text('Add Fixture'),
                    icon: Icon(Icons.add),
                  ),
                )
              ],
            ),
          ),
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
              child: Builder(builder: (context) {
                if (selectedIndex == null ||
                    selectedIndex! >= liveScene.fixtures.length) {
                  return Center(
                    child: Text('Select a fixture'),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: liveScene
                        .fixtures[selectedIndex!].data.numberOfChannels,
                    separatorBuilder: (context, index) => const SizedBox(
                      width: 15,
                    ),
                    itemBuilder: (context, index) {
                      final fixture = liveScene.fixtures[selectedIndex!];
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
                                            fixtureIndex: selectedIndex!,
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
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
