import 'package:flutter/material.dart';
import 'package:noname_demo/src/core/router/app_router.dart';
import 'package:noname_demo/src/feature/app/widget/scaffold_wrapper.dart';
import 'package:noname_demo/src/feature/dependencies/model/dependencies.dart';
import 'package:noname_demo/src/feature/dependencies/widget/dependencies_scope.dart';

class AppRunner extends StatefulWidget {
  const AppRunner({super.key, required this.dependencies});

  final DependenciesBase dependencies;

  @override
  State<AppRunner> createState() => _AppRunnerState();
}

class _AppRunnerState extends State<AppRunner> {
  late final _router = AppRouter.toGoRouter();

  @override
  Widget build(BuildContext context) {
    return DependenciesScope(
        dependencies: widget.dependencies,
        child: MaterialApp.router(
          routerConfig: _router,
          builder: (context, child) => ScaffoldWrapper(
            child: child,
          ),
        ));
  }
}
