import 'package:flutter/material.dart';
import 'package:noname_demo/src/shared/effects/bounceable.dart';

class ButtonWithShadow extends StatelessWidget {
  const ButtonWithShadow({
    super.key,
    this.color,
    required this.child,
    this.width = double.infinity,
    this.elevation = 15,
    this.onTap,
    this.gradient,
  });

  final VoidCallback? onTap;
  final Color? color;
  final LinearGradient? gradient;
  final Widget child;
  final double elevation;
  final double width;

  factory ButtonWithShadow.defaultBlue(
    String text, {
    double width = double.infinity,
    VoidCallback? onTap,
    double elevation = 15,
  }) =>
      ButtonWithShadow(
        width: width,
        elevation: elevation,
        gradient: const LinearGradient(
          colors: [Color(0xFF0B55BB), Color(0xFF5038ED)],
        ),
        onTap: onTap,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        // Figma height
        duration: const Duration(milliseconds: 150),
        curve: Curves.ease,
        height: 52, alignment: Alignment.centerLeft,
        width: width,
        child: Bounceable(
          onTap: onTap,
          child: PhysicalModel(
            elevation: elevation,
            color: Colors.transparent,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: gradient,
                color: color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Align(
                child: child,
              ),
            ),
          ),
        ),
      );
}
