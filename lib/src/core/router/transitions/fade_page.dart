import 'package:flutter/material.dart';

class FadePage<T> extends Page<T> {
  final Widget child;

  const FadePage({
    super.key,
    super.name,
    required this.child,
  });

  @override
  Route<T> createRoute(BuildContext context) => FadePageRoute(child, this);
}

class FadePageRoute<T> extends PageRoute<T> {
  FadePageRoute(this.child, RouteSettings settings) : super(settings: settings);

  @override
  Color get barrierColor => Colors.transparent;

  @override
  String? get barrierLabel => null;

  final Widget child;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) =>
      FadeTransition(
        opacity: animation,
        child: child,
      );

  @override
  bool get maintainState => true;

  @override
  bool get opaque => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 400);

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 300);
}
