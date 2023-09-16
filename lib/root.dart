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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25),
          child: Row(
            children: [
              SizedBox(
                width: 15,
              ),
              ClipRRect(
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
              const SizedBox(
                width: 20,
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
        ),
      ),
    );
  }
}
