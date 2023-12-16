part of 'app_router.dart';

final _routes = <RouteBase>[
  GoRoute(
    path: '/',
    name: 'user_id_input',
    pageBuilder: (context, state) => FadePage(
      key: state.pageKey,
      child: const UserInputScreen(),
    ),
  ),
  GoRoute(
    path: '/user/list',
    name: 'user_list',
    pageBuilder: (context, state) => FadePage(
      key: state.pageKey,
      child: const UserListScreen(),
    ),
  ),
  GoRoute(
      path: '/user/details/:id',
      name: 'user_details',
      pageBuilder: (context, state) => FadePage(
              child: UserDetailsScreen(
            userEntity: state.extra as UserEntity?,
            userId: int.parse(state.pathParameters['id']!),
          ))),
];
