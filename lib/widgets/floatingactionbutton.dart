import 'package:flutter/material.dart';
//these are custom widgets for reusable code

class KFloatingActionButton extends StatelessWidget {
  final IconData? icon;
  final String? heroTag;
  final VoidCallback onPressed;

  const KFloatingActionButton({super.key, required this.icon, required this.heroTag,required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: heroTag,
      onPressed: onPressed,
      child:  Icon(icon!),
    );
  }
}
