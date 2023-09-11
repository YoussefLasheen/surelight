import 'package:flutter/material.dart';
import 'widgets/color_controls/color_controls.dart';
import 'widgets/movement_controls/movement_controls.dart';

import 'widgets/presets/presets.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 34),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  color: Colors.black,
                ),
              ),
              Expanded(
                flex: 4,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    SizedBox(
                      width: 42,
                    ),
                    ColorControls(),
                    SizedBox(
                      width: 20,
                    ),
                    MovementControls(),
                    SizedBox(
                      width: 20,
                    ),
                    LivePresets(),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
