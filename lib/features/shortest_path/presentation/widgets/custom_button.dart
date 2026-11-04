import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final double height;

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 24, 180, 252),
          border: Border.all(
            color: Colors.blueAccent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}