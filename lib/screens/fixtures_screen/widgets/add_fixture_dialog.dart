import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:surelight/const.dart';
import 'package:surelight/models/fixture/fixture_data.dart';
import 'package:surelight/providers/live_scene_provider.dart';

class AddFixtureDialog extends ConsumerWidget {
  AddFixtureDialog({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController fixtureName =
        TextEditingController(text: 'Basic Light');
    int startingChannel = 0;
    FixtureData fixtureType = RGBD;
    return Center(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: AlertDialog(
          title: const Text('Add Fixture'),
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: fixtureName,
                  decoration: const InputDecoration(
                    labelText: 'Fixture Name',
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 15,
                  buildCounter: (context,
                          {required currentLength,
                          required isFocused,
                          maxLength}) =>
                      null,
                ),
                SizedBox(
                  height: 20,
                ),
                ListTile(
                  title: const Text('Starting Channel'),
                  contentPadding: EdgeInsets.zero,
                  trailing: SizedBox(
                    width: 150,
                    child: SpinBox(
                      min: 1,
                      max: 512,
                      value: 1,
                      onChanged: (value) {
                        startingChannel = (value.toInt()) - 1;
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ListTile(
                  title: const Text('Fixture'),
                  contentPadding: EdgeInsets.zero,
                  trailing: SizedBox(
                    width: 150,
                    child: DropdownButtonFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      value: fixtureType,
                      items: fixtureTypes
                          .map((fixture) => DropdownMenuItem(
                                child: Text(fixture.name),
                                value: fixture,
                              ))
                          .toList(),
                      onChanged: (value) {
                        fixtureType = value as FixtureData;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                try {
                  ref.read(liveSceneProvider.notifier).addFixture(
                      fixtureType, startingChannel, fixtureName.text);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                    ),
                  );
                }
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}

List fixtureTypes = [
  RGBD,
  DRGB,
];
