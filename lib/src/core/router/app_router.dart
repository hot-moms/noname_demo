import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:noname_demo/src/core/router/transitions/fade_page.dart';
import 'package:noname_demo/src/feature/user/model/user_entity.dart';
import 'package:noname_demo/src/feature/user/widget/user_details/user_details_screen.dart';
import 'package:noname_demo/src/feature/user/widget/user_input/user_input_screen.dart';
import 'package:noname_demo/src/feature/user/widget/user_list/user_list_screen.dart';

part 'routes.dart';

abstract class AppRouter {
  // Moved into src/core/router/routes.dart
  static List<RouteBase> get routes => _routes;

  static final GlobalKey<NavigatorState> _rootKey = GlobalKey();

  static GoRouter toGoRouter() => GoRouter(
        routes: routes,
        debugLogDiagnostics: true,
        navigatorKey: _rootKey,
      );
}
