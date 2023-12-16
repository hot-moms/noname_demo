import 'package:noname_demo/src/feature/user/data/user_data_provider_base.dart';
import 'package:noname_demo/src/feature/user/model/user_entity.dart';
import 'package:noname_demo/src/feature/user/repository/user_repository_base.dart';

class UserRepository implements IUserRepository {
  final IUserDataProvider _userDataProvider;

  const UserRepository({required IUserDataProvider userDataProvider}) : _userDataProvider = userDataProvider;

  @override
  Future<UserEntity> loadUserById(int id) => _userDataProvider.loadUserById(id).then(UserEntity.fromDTO);

  @override
  Future<List<UserEntity>> loadUsers({required int page, required int perPage}) =>
      _userDataProvider.loadUsers(page: page, perPage: perPage).map(UserEntity.fromDTO).toList();
}
