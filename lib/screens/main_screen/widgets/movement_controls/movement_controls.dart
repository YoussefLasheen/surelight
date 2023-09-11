import 'package:flutter/material.dart';
import 'package:surelight/screens/main_screen/shared_components/control_card.dart';
import 'package:surelight/screens/main_screen/widgets/color_controls/widgets/effects_grid.dart';

class MovementControls extends StatefulWidget {
  const MovementControls({super.key});

  @override
  State<MovementControls> createState() => _MovementControlsState();
}

class _MovementControlsState extends State<MovementControls> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return ControlCard(
      title: 'MOVEMENTS',
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
                    label: const Icon(Icons.settings),
                    selected: index == 1,
                    showCheckmark: false,
                    onSelected: (bool selected) {
                      setState(() {
                        index = 1;
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
              Container(
                color: Colors.blue,
              ),
            ],
          )),
        ],
      ),
    );
  }
}
