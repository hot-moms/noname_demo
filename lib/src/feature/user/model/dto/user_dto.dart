import 'dart:convert';

import 'package:meta/meta.dart';

@immutable
class UserDTO {
  final int id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? avatar;

  const UserDTO({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.avatar,
  });

  @override
  String toString() {
    return 'UserDTO(id: $id, email: $email, firstName: $firstName, lastName: $lastName, avatar: $avatar)';
  }

  factory UserDTO.fromMap(Map<String, dynamic> data) => UserDTO(
        id: data['id'] as int,
        email: data['email'] as String,
        firstName: data['first_name'] as String?,
        lastName: data['last_name'] as String?,
        avatar: data['avatar'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'avatar': avatar,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [UserDTO].
  factory UserDTO.fromJson(String data) {
    return UserDTO.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [UserDTO] to a JSON string.
  String toJson() => json.encode(toMap());
}
