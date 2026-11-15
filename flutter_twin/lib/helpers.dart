import 'package:flutter/material.dart';

// ---- Shared look ------------------------------------------------------------

const ink = Color(0xFF111827);
const muted = Color(0xFF6B7280);
const line = Color(0xFFE5E7EB);
const page = Color(0xFFF7F7F8);
const red = Color(0xFFEF4444);
const green = Color(0xFF16A34A);
const blue = Color(0xFF3B82F6);
const amber = Color(0xFFF59E0B);

/// A coloured square used in the repros.
Widget box(Color color, {double size = 24}) =>
    Container(width: size, height: size, color: color);

/// A labelled, outlined area a repro is drawn in.
class Frame extends StatelessWidget {
  const Frame({
    required this.label,
    required this.color,
    required this.child,
    super.key,
  });

  final String label;
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            border: Border.all(color: color, width: 1.5),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(10),
          child: child,
        ),
      ],
    );
  }
}

