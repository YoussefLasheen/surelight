import 'package:flutter/material.dart';

class ControlCard extends StatelessWidget {
  const ControlCard(
      {super.key, required this.title, required this.child, this.width = 500});

  final String title;
  final Widget child;

  final double width;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white10,
      ),
      clipBehavior: Clip.hardEdge,
      child: Row(
        children: [
          Container(
            width: 75,
            height: double.infinity,
            color: Colors.white10,
            child: Center(
              child: RotatedBox(
                quarterTurns: 3,
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w200,
                    letterSpacing: 5,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: child,
          )
        ],
      ),
    );
  }
}
