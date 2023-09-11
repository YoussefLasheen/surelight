import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexagon/hexagon.dart';
import 'package:surelight/providers/artnet_provider.dart';
import 'package:surelight/providers/live_scene_provider.dart';

class ColorsGrid extends ConsumerStatefulWidget {
  const ColorsGrid({super.key});

  @override
  ConsumerState<ColorsGrid> createState() => _ColorsGridState();
}

class _ColorsGridState extends ConsumerState<ColorsGrid> {
  List<int> index = [0, 0];
  @override
  Widget build(BuildContext context) {
    final liveScene = ref.watch(liveSceneProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: HexagonGrid.flat(
        depth: 2,
        buildTile: (coordinates) => HexagonWidgetBuilder(
          padding: 2.0,
          color: colors[coordinates.q]![coordinates.r],
        ),
        buildChild: (coordinates) {
          final Color color = colors[coordinates.q]![coordinates.r]!;
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              liveScene.toggleColor(color);
              setState(() {
                index = [coordinates.q, coordinates.r];
              });
            },
            child: SizedBox.expand(
              child: Icon(
                Icons.circle,
                color:
                    index.first == coordinates.q && index.last == coordinates.r
                        ? Colors.black
                        : Colors.transparent,
              ),
            ),
          );
        },
      ),
    );
  }
}

const colors = {
  -2: {
    0: Colors.red,
    1: Colors.redAccent,
    2: Colors.pink,
  },
  -1: {
    -1: Colors.blue,
    0: Colors.blueAccent,
    1: Colors.blueGrey,
    2: Colors.grey,
  },
  0: {
    -2: Colors.red,
    -1: Colors.redAccent,
    0: Colors.orange,
    1: Colors.orangeAccent,
    2: Colors.amber,
  },
  1: {
    -2: Colors.green,
    -1: Colors.greenAccent,
    0: Colors.teal,
    1: Colors.tealAccent,
  },
  2: {
    -2: Colors.yellow,
    -1: Colors.tealAccent,
    0: Colors.white,
  }
};
