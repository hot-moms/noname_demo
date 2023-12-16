part of 'user_details_bloc.dart';

sealed class UserDetailsState {
  const UserDetailsState();

  abstract final UserEntity? currentEntity;
  abstract final int? requestedId;

  _Idle$UserDetailsState toIdle({
    UserEntity? currentEntity,
    int? requestedId,
  }) =>
      _Idle$UserDetailsState(
        currentEntity: currentEntity ?? this.currentEntity,
        requestedId: requestedId ?? this.requestedId,
      );
  _Successfull$UserDetailsState toSuccesfull({
    UserEntity? currentEntity,
    int? requestedId,
  }) =>
      _Successfull$UserDetailsState(
        currentEntity: currentEntity ?? this.currentEntity,
        requestedId: requestedId ?? this.requestedId,
      );
  _Loading$UserDetailsState toLoading() => _Loading$UserDetailsState(
        currentEntity: currentEntity,
        requestedId: requestedId,
      );
  _Error$UserDetailsState toError(Object exception, {String? message}) => _Error$UserDetailsState(
        currentEntity: currentEntity,
        requestedId: requestedId,
        exception: exception,
        message: message,
      );

  const factory UserDetailsState.idle({
    UserEntity? currentEntity,
    int? requestedId,
  }) = _Idle$UserDetailsState;

  const factory UserDetailsState.loading({
    required UserEntity currentEntity,
    required int requestedId,
  }) = _Loading$UserDetailsState;

  const factory UserDetailsState.error({
    required UserEntity currentEntity,
    required int requestedId,
    required Object exception,
    String? message,
  }) = _Error$UserDetailsState;

  bool get isLoading => maybeWhen(orElse: () => false, loading: (_, __) => true);
  bool get isError => maybeWhen(orElse: () => false, error: (_, __, ___, ____) => true);
  bool get isSuccessfull => maybeWhen(
      orElse: () => false,
      successful: (
        _,
        __,
      ) =>
          true);

  T maybeWhen<T>({
    T Function(UserEntity? currentEntity, int? requestedId)? idle,
    T Function(UserEntity? currentEntity, int? requestedId)? successful,
    T Function(UserEntity? currentEntity, int? requestedId)? loading,
    T Function(UserEntity? currentEntity, int? requestedId, Object exception, String? message)?
        error,
    required T Function() orElse,
  }) =>
      when(
        idle: (a, b) => idle?.call(a, b) ?? orElse(),
        successful: (a, b) => successful != null ? successful.call(a, b) : orElse(),
        loading: (a, b) => loading != null ? loading.call(a, b) ?? orElse() : orElse(),
        error: (a, b, c, d) => error != null ? error.call(a, b, c, d) : orElse(),
      );

  T when<T>({
    required T Function(UserEntity? currentEntity, int? requestedId) idle,
    required T Function(UserEntity? currentEntity, int? requestedId) successful,
    required T Function(UserEntity? currentEntity, int? requestedId) loading,
    required T Function(
            UserEntity? currentEntity, int? requestedId, Object exception, String? message)
        error,
  }) =>
      switch (this) {
        _Idle$UserDetailsState(
          :final currentEntity,
          :final requestedId,
        ) =>
          idle(
            currentEntity,
            requestedId,
          ),
        _Successfull$UserDetailsState(
          :final currentEntity,
          :final requestedId,
        ) =>
          successful(
            currentEntity,
            requestedId,
          ),
        _Loading$UserDetailsState(
          :final currentEntity,
          :final requestedId,
        ) =>
          loading(
            currentEntity,
            requestedId,
          ),
        _Error$UserDetailsState(
          :final currentEntity,
          :final requestedId,
          :final exception,
          :final message
        ) =>
          error(
            currentEntity,
            requestedId,
            exception,
            message,
          )
      };
}

class _Idle$UserDetailsState extends UserDetailsState {
  @override
  final UserEntity? currentEntity;
  @override
  final int? requestedId;

  const _Idle$UserDetailsState({
    this.currentEntity,
    this.requestedId,
  });
}

class _Loading$UserDetailsState extends UserDetailsState {
  @override
  final UserEntity? currentEntity;
  @override
  final int? requestedId;

  const _Loading$UserDetailsState({
    this.currentEntity,
    this.requestedId,
  });
}

class _Error$UserDetailsState extends UserDetailsState {
  @override
  final UserEntity? currentEntity;
  @override
  final int? requestedId;

  final String? message;
  final Object exception;

  const _Error$UserDetailsState({
    this.currentEntity,
    this.requestedId,
    required this.exception,
    this.message,
  });
}

class _Successfull$UserDetailsState extends UserDetailsState {
  @override
  final UserEntity? currentEntity;
  @override
  final int? requestedId;

  const _Successfull$UserDetailsState({
    this.currentEntity,
    this.requestedId,
  });
}
