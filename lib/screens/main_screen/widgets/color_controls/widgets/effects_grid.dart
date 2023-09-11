import 'package:flutter/material.dart';
import 'package:surelight/screens/main_screen/shared_components/hold_button.dart';

class EffectsGrid extends StatefulWidget {
  const EffectsGrid({super.key});

  @override
  State<EffectsGrid> createState() => _EffectsGridState();
}

class _EffectsGridState extends State<EffectsGrid> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: 12,
        itemBuilder: (BuildContext context, int selectedIndex) {
          return HoldButton(
            title: 'EFFECT ${selectedIndex + 1}',
            color: selectedIndex == 0 ? Colors.red : null,
            isPressed: index == selectedIndex,
            onPressed: () {
              setState(() {
                index = selectedIndex;
              });
            },
          );
        },
      ),
    );
  }
}