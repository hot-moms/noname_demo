import 'package:noname_demo/src/feature/user/model/dto/user_dto.dart';

class UserEntity {
  final int id;
  final String email;
  final String? fullName;
  final String? avatarUrl;

  const UserEntity({
    required this.id,
    required this.email,
    this.fullName,
    this.avatarUrl,
  });

  // Example of parsing Entity from DTO
  factory UserEntity.fromDTO(UserDTO dto) {
    final (nameData) = (dto.firstName, dto.lastName);

    final fullName = switch (nameData) {
      (String firstName, String lastName) => '$firstName $lastName',
      _ => null,
    };

    return UserEntity(
      id: dto.id,
      email: dto.email,
      fullName: fullName,
      avatarUrl: dto.avatar,
    );
  }
}
