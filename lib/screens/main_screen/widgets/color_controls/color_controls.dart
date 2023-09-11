import 'package:flutter/material.dart';
import 'package:surelight/screens/main_screen/shared_components/control_card.dart';
import 'package:surelight/screens/main_screen/shared_components/hold_button.dart';
import 'package:surelight/screens/main_screen/widgets/color_controls/widgets/colors_grid.dart';

import 'widgets/effects_grid.dart';

class ColorControls extends StatefulWidget {
  const ColorControls({super.key});

  @override
  State<ColorControls> createState() => _ColorControlsState();
}

class _ColorControlsState extends State<ColorControls> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return ControlCard(
      title: 'COLOURS',
      child: Column(
        children: [
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ChoiceChip(
                    label: const Text('EFFECTS'),
                    selected: index == 0,
                    showCheckmark: false,
                    onSelected: (bool selected) {
                      setState(() {
                        index = 0;
                      });
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ChoiceChip(
                    label: const Text('COLOUR'),
                    selected: index == 1,
                    showCheckmark: false,
                    onSelected: (bool selected) {
                      setState(() {
                        index = 1;
                      });
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ChoiceChip(
                    label: const Icon(Icons.settings),
                    selected: index == 2,
                    showCheckmark: false,
                    onSelected: (bool selected) {
                      setState(() {
                        index = 2;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
              child: IndexedStack(
            index: index,
            children: [
              EffectsGrid(),
              ColorsGrid(),
              Container(
                color: Colors.green,
              ),
            ],
          )),
        ],
      ),
    );
  }
}
