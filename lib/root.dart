import 'package:flutter/material.dart';

import 'screens/fixtures_screen/fixtures_screen.dart';
import 'screens/main_screen/main_screen.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Row(
        children: [
          Column(
            children: [
              Spacer(),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: NavigationRail(
                      selectedIndex: index,
                      onDestinationSelected: (int newIndex) {
                        setState(() {
                          index = newIndex;
                        });
                      },
                      labelType: NavigationRailLabelType.none,
                      minWidth: 75,
                      destinations: const [
                        NavigationRailDestination(
                          icon: Icon(Icons.home),
                          label: Text('Live'),
                          padding: EdgeInsets.all(10),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.lightbulb),
                          label: Text('Fixtures'),
                          padding: EdgeInsets.all(10),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: IndexedStack(
              index: index,
              children: [
                const MainScreen(),
                const FixturesScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
