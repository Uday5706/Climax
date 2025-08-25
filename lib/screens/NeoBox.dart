import 'package:flutter/material.dart';

class NeoBox extends StatelessWidget {
  final Widget child;

  const NeoBox({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFE0E5EC),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          // Top-left white shadow (outset)
          BoxShadow(
            color: Colors.white,
            offset: Offset(-6, -4),
            blurRadius: 10,
            spreadRadius: 1,
          ),
          // Bottom-right grey shadow (outset)
          BoxShadow(
            color: Color(0xFF9E9E9E), // soft grey
            offset: Offset(4, 4),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: child,
    );
  }
}
