import 'package:flutter/material.dart';

class ButtonWithIcon extends StatelessWidget {
  final VoidCallback onPressed;
  final Icon icon;
  final String label;
  final Color color;

  const ButtonWithIcon(
      {required this.onPressed,
      required this.icon,
      required this.label,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36.0),
      child: SizedBox(
        width: double.infinity,
        height: 50.0,
        child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                backgroundColor: color,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                  Radius.circular(20.0),
                ))),
            onPressed: onPressed,
            icon: icon,
            label: Text(label, style: const TextStyle(fontSize: 15.0))),
      ),
    );
  }
}
