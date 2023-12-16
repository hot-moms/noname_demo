import 'package:dio/dio.dart';
import 'package:noname_demo/src/core/components/rest_client/rest_client.dart';
import 'package:noname_demo/src/feature/user/data/user_data_provider_base.dart';
import 'package:noname_demo/src/feature/user/repository/user_repository.dart';
import 'package:noname_demo/src/feature/user/repository/user_repository_base.dart';

abstract interface class DependenciesBase {
  abstract final IUserRepository userRepository;
}

class DependenciesDev implements DependenciesBase {
  const DependenciesDev({
    required this.userRepository,
  });

  @override
  final IUserRepository userRepository;
}

class $MutableDependencies {
  Dio? dio;
  RestClient? restClient;
  IUserDataProvider? userDataProvider;

  DependenciesDev freeze() => DependenciesDev(
        userRepository: UserRepository(userDataProvider: userDataProvider!),
      );

  $MutableDependencies();
}
