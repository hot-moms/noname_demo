import 'package:flutter/material.dart';

class Bounceable extends StatefulWidget {
  /// Set it to `null` to disable `onTap`.
  final VoidCallback? onTap;
  final void Function(PointerUpEvent)? onTapUp;
  final void Function(PointerDownEvent)? onTapDown;
  final void Function(PointerCancelEvent)? onTapCancel;

  /// The reverse duration of the scaling animation when `onTapUp`.
  final Duration? duration;

  /// The duration of the scaling animation when `onTapDown`.
  final Duration? reverseDuration;

  /// The reverse curve of the scaling animation when `onTapUp`.
  final Curve curve;

  /// How to behavior while hit
  final HitTestBehavior? behavior;

  /// The curve of the scaling animation when `onTapDown`..
  final Curve? reverseCurve;

  /// The scale factor of the child widget. The valid range of `scaleFactor` is from `0.0` to `1.0`.
  final double scaleFactor;

  final Widget child;

  const Bounceable({
    super.key,
    this.onTap,
    required this.child,
    this.scaleFactor = 0.95,
    this.onTapUp,
    this.onTapDown,
    this.onTapCancel,
    this.duration = const Duration(milliseconds: 150),
    this.reverseDuration,
    this.curve = Curves.easeInSine,
    this.behavior,
    this.reverseCurve,
  }) : assert(
          scaleFactor >= 0.0 && scaleFactor <= 1.0,
          'The valid range of scaleFactor is from 0.0 to 1.0.',
        );

  @override
  _BounceableState createState() => _BounceableState();
}

class _BounceableState extends State<Bounceable>
    with SingleTickerProviderStateMixin {
  bool _processTap = false;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
    reverseDuration: widget.reverseDuration,
    value: 1,
    lowerBound: widget.scaleFactor,
  );

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: widget.curve,
    reverseCurve: widget.reverseCurve,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapUp(PointerUpEvent details) {
    if (_processTap) {
      widget.onTap?.call();
    }

    _controller.forward();
  }

  void _onTapDown(PointerDownEvent details) {
    _processTap = true;
    widget.onTapDown?.call(details);
    _controller.reverse();
  }

  void _onTapCancel(PointerCancelEvent details) {
    widget.onTapCancel?.call(details);
    _controller.forward();
  }

  void _onTapMove(PointerMoveEvent details) {
    if (_processTap && details.delta.distanceSquared > 4) _processTap = false;
  }

  @override
  Widget build(BuildContext context) => Listener(
        onPointerDown: _onTapDown,
        behavior: HitTestBehavior.opaque,
        onPointerCancel: _onTapCancel,
        onPointerUp: _onTapUp,
        onPointerMove: _onTapMove,
        child: ScaleTransition(
          scale: _animation,
          child: widget.child,
        ),
      );
}
