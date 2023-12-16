import 'dart:convert';

import 'package:noname_demo/src/feature/user/model/dto/user_dto.dart';

class UserListResponse {
  int page;
  int perPage;
  int total;
  int totalPages;
  List<UserDTO> data;

  UserListResponse({
    required this.page,
    required this.perPage,
    required this.total,
    required this.totalPages,
    required this.data,
  });

  factory UserListResponse.fromMap(Map<String, dynamic> data) {
    return UserListResponse(
      page: data['page'] as int,
      perPage: data['per_page'] as int,
      total: data['total'] as int,
      totalPages: data['total_pages'] as int,
      data: (data['data'] as List<dynamic>).map((e) => UserDTO.fromMap(e as Map<String, dynamic>)).toList(),
    );
  }

  factory UserListResponse.fromNullableMap(Map<String, dynamic>? data) {
    if (data == null) throw Exception('Got Null instead of Map<String, dynamic>');

    return UserListResponse.fromMap(data);
  }

  Map<String, dynamic> toMap() => {
        'page': page,
        'per_page': perPage,
        'total': total,
        'total_pages': totalPages,
        'data': data.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [UserListResponse].
  factory UserListResponse.fromJson(String data) {
    return UserListResponse.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [UserListResponse] to a JSON string.
  String toJson() => json.encode(toMap());
}
