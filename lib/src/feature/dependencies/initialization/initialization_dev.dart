import 'dart:async';

import 'package:dio/dio.dart';
import 'package:noname_demo/src/core/components/rest_client/src/rest_client_dio.dart';
import 'package:noname_demo/src/feature/dependencies/initialization/init/initialization.dart';
import 'package:noname_demo/src/feature/dependencies/model/dependencies.dart';
import 'package:noname_demo/src/feature/user/data/user_data_provider_network.dart';

typedef AppDependency = InitializationExecutor<$MutableDependencies, DependenciesBase>;

class DependencyInitializationDev extends AppDependency {
  @override
  DependenciesBase Function($MutableDependencies $) get freeze => ($) => $.freeze();

  @override
  List<
      (
        String,
        FutureOr<void> Function(
          $MutableDependencies dependencies,
        )
      )> get initializationSteps => [
        (
          'Dio',
          (container) => container.dio = Dio(),
        ),
        ('REST Client', (container) async => container.restClient = RestClientDio(dio: container.dio!)),
        (
          'User Data Provider',
          (container) async => container.userDataProvider = UserDataProviderNetwork(restClient: container.restClient!),
        ),
      ];

  @override
  $MutableDependencies Function() get create => $MutableDependencies.new;
}
