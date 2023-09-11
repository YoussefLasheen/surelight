import 'package:flutter/material.dart';

class HoldButton extends StatelessWidget {
  const HoldButton({
    super.key,
    this.isPressed = false,
    this.color,
    required this.title,
    required this.onPressed,
  });

  final bool isPressed;
  final String title;
  final Color? color;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(20),
        minimumSize: const Size.square(100),
        backgroundColor: Colors.black38,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: isPressed
              ? BorderSide(
                  color: color ?? Colors.white,
                  width: 2,
                )
              : BorderSide.none,
        ),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w300,
            color: color ?? Colors.white,
          ),
        ),
      ),
    );
  }
}
