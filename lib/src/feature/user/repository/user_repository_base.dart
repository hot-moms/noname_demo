import 'package:noname_demo/src/feature/user/model/user_entity.dart';

abstract class IUserRepository {
  Future<List<UserEntity>> loadUsers({required int page, required int perPage});
  Future<UserEntity> loadUserById(int id);
}
