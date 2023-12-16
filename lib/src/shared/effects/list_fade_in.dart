import 'package:flutter/material.dart';
import 'package:keframe/keframe.dart';

class ListFadeInWidget extends StatefulWidget {
  final Widget child;
  final int? index;
  const ListFadeInWidget({
    super.key,
    required this.child,
    this.index,
  });

  @override
  _OpacityState createState() => _OpacityState();
}

class _OpacityState extends State<ListFadeInWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller = AnimationController(
    duration: kThemeAnimationDuration,
    vsync: this,
  )..forward();

  @override
  Widget build(BuildContext context) => FrameSeparateWidget(
        index: widget.index,
        child: FadeTransition(
          opacity: controller,
          child: widget.child,
        ),
      );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
