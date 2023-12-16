part of 'user_pagination_bloc.dart';

sealed class UserPaginationState {
  const UserPaginationState();

  abstract final List<UserEntity> users;
  abstract final int currentPage;
  abstract final bool hasReachedEnd;

  bool get isEmpty => users.isEmpty;
  bool get isNotEmpty => users.isNotEmpty;

  _Idle$UserPaginationState toIdle(
          {List<UserEntity>? users, int? currentPage, bool? hasReachedEnd}) =>
      _Idle$UserPaginationState(
        users: users ?? this.users,
        currentPage: currentPage ?? this.currentPage,
        hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      );
  _Loading$UserPaginationState toLoading() => _Loading$UserPaginationState(
        users: users,
        currentPage: currentPage,
        hasReachedEnd: hasReachedEnd,
      );
  _Error$UserPaginationState toError(Object exception, {String? message}) =>
      _Error$UserPaginationState(
        users: users,
        currentPage: currentPage,
        exception: exception,
        message: message,
        hasReachedEnd: hasReachedEnd,
      );

  const factory UserPaginationState.idle({
    required List<UserEntity> users,
    required int currentPage,
    bool hasReachedEnd,
  }) = _Idle$UserPaginationState;

  const factory UserPaginationState.loading({
    required List<UserEntity> users,
    required int currentPage,
    required bool hasReachedEnd,
  }) = _Loading$UserPaginationState;

  const factory UserPaginationState.error({
    required List<UserEntity> users,
    required int currentPage,
    required Object exception,
    required bool hasReachedEnd,
    String? message,
  }) = _Error$UserPaginationState;

  T maybeWhen<T>({
    required T Function() orElse,
    T Function(List<UserEntity> users, int currentPage, bool hasReachedEnd)? idle,
    T Function(List<UserEntity> users, int currentPage)? loading,
    T Function(List<UserEntity> users, int currentPage, Object exception, String? message)? error,
  }) =>
      when(
        idle: (a, b, c) => idle != null ? idle.call(a, b, c) ?? orElse() : orElse(),
        loading: (a, b) => loading != null ? loading.call(a, b) ?? orElse() : orElse(),
        error: (a, b, c, d) => error != null ? error.call(a, b, c, d) ?? orElse() : orElse(),
      );

  T when<T>({
    required T Function(List<UserEntity> users, int currentPage, bool hasReachedEnd) idle,
    required T Function(List<UserEntity> users, int currentPage) loading,
    required T Function(List<UserEntity> users, int currentPage, Object exception, String? message)
        error,
  }) =>
      switch (this) {
        _Idle$UserPaginationState(:final users, :final currentPage, :final hasReachedEnd) =>
          idle(users, currentPage, hasReachedEnd),
        _Loading$UserPaginationState(:final users, :final currentPage) =>
          loading(users, currentPage),
        _Error$UserPaginationState(
          :final users,
          :final currentPage,
          :final exception,
          :final message
        ) =>
          error(users, currentPage, exception, message)
      };
}

class _Idle$UserPaginationState extends UserPaginationState {
  @override
  final List<UserEntity> users;
  @override
  final int currentPage;

  @override
  final bool hasReachedEnd;

  const _Idle$UserPaginationState({
    required this.users,
    required this.currentPage,
    this.hasReachedEnd = false,
  });
}

class _Loading$UserPaginationState extends UserPaginationState {
  @override
  final List<UserEntity> users;
  @override
  final int currentPage;
  @override
  final bool hasReachedEnd;

  const _Loading$UserPaginationState({
    required this.users,
    required this.currentPage,
    required this.hasReachedEnd,
  });
}

class _Error$UserPaginationState extends UserPaginationState {
  @override
  final List<UserEntity> users;
  @override
  final int currentPage;
  @override
  final bool hasReachedEnd;
  final String? message;
  final Object exception;

  const _Error$UserPaginationState({
    required this.users,
    required this.currentPage,
    required this.exception,
    required this.hasReachedEnd,
    this.message,
  });
}
