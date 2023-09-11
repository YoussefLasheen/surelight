import 'package:flutter/material.dart';
import 'package:surelight/screens/main_screen/shared_components/control_card.dart';

class LivePresets extends StatelessWidget {
  const LivePresets({super.key});

  @override
  Widget build(BuildContext context) {
    return ControlCard(
      title: 'PRESETS',
      width: 300,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: List.generate(
            10,
            (index) => ListTile(
              title: Text('Preset $index'),
            ),
          ),
        ),
      ),
    );
  }
}
