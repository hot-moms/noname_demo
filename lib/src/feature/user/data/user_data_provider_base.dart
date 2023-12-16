import 'package:noname_demo/src/feature/user/model/dto/user_dto.dart';

abstract class IUserDataProvider {
  Stream<UserDTO> loadUsers({
    required int page,
    required int perPage,
  });

  Future<UserDTO> loadUserById(int id);
}
