import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:pure/pure.dart';
import 'package:noname_demo/src/feature/user/model/dto/user_dto.dart';

@immutable
class UserDetailsResponse {
  final UserDTO user;

  const UserDetailsResponse._({required this.user});

  factory UserDetailsResponse.fromMap(Map<String, dynamic> data) {
    return UserDetailsResponse._(
      user: (data['data'] as Map<String, dynamic>).pipe(UserDTO.fromMap),
    );
  }

  factory UserDetailsResponse.fromNullableMap(Map<String, dynamic>? data) {
    if (data == null) throw Exception('Got Null instead of Map<String, dynamic>');

    return UserDetailsResponse.fromMap(data);
  }

  Map<String, dynamic> toMap() => {
        'data': user.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [UserDetailsResponse].
  factory UserDetailsResponse.fromJson(String data) {
    return UserDetailsResponse.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [UserDetailsResponse] to a JSON string.
  String toJson() => json.encode(toMap());
}
