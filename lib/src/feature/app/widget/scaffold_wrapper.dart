import 'package:flutter/material.dart';

class ScaffoldWrapper extends StatefulWidget {
  const ScaffoldWrapper({
    super.key,
    this.child,
  });

  final Widget? child;

  @override
  State<ScaffoldWrapper> createState() => _ScaffoldWrapperState();
}

class _ScaffoldWrapperState extends State<ScaffoldWrapper> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: widget.child,
      );
}
