import 'package:flutter/material.dart';

class KButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;

  const KButton({super.key, required this.child, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),

              )
          )
      ),

      onPressed: onPressed,
      child: child,
    );

  }
}
