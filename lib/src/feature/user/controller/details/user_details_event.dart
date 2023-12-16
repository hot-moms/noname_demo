part of 'user_details_bloc.dart';

abstract class UserDetailsEvent {
  const factory UserDetailsEvent.fetchUser({required int targetId}) = _FetchUser$UserDetailsEvent;
}

sealed class _UserDetailsEvent implements UserDetailsEvent {
  const _UserDetailsEvent();

  T mapEmitter<T>(
    Emitter<UserDetailsState> emit, {
    required T Function(_FetchUser$UserDetailsEvent event, Emitter<UserDetailsState> emit)
        fetchUser,
  }) =>
      switch (this) {
        _FetchUser$UserDetailsEvent $ => fetchUser($, emit),
      };
}

class _FetchUser$UserDetailsEvent extends _UserDetailsEvent {
  final int targetId;

  const _FetchUser$UserDetailsEvent({
    required this.targetId,
  });
}
