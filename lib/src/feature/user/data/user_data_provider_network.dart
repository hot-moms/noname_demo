import 'package:noname_demo/src/core/components/rest_client/rest_client.dart';
import 'package:noname_demo/src/core/extensions/gen_ext.dart';
import 'package:noname_demo/src/feature/user/data/user_data_provider_base.dart';
import 'package:noname_demo/src/feature/user/model/dto/user_details_response.dart';
import 'package:noname_demo/src/feature/user/model/dto/user_dto.dart';
import 'package:noname_demo/src/feature/user/model/dto/user_list_response.dart';

class UserDataProviderNetwork implements IUserDataProvider {
  final RestClient restClient;

  UserDataProviderNetwork({required this.restClient});

  @override
  Stream<UserDTO> loadUsers({
    required int page,
    required int perPage,
  }) =>
      restClient
          .get('https://reqres.in/api/users', queryParams: {
            'page': page,
            'per_page': perPage,
          })
          .then((value) {
            print(perPage);
            print(page);
            print(value);
            return value;
          })
          .then(UserListResponse.fromNullableMap)
          .then(($) => $.data)
          .asStream()
          .expand(self);

  @override
  Future<UserDTO> loadUserById(int id) async {
    final response = await restClient.get('https://reqres.in/api/users/$id').then(
          UserDetailsResponse.fromNullableMap,
        );
    return response.user;
  }
}
