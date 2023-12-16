part of 'user_pagination_bloc.dart';

abstract class UserPaginationEvent {
  const factory UserPaginationEvent.loadMore() = _LoadMore$UserPaginationEvent;

  const factory UserPaginationEvent.clear() = _Clear$UserPaginationEvent;
}

sealed class _UserPaginationEvent implements UserPaginationEvent {
  const _UserPaginationEvent();

  T mapEmitter<T>(
    Emitter<UserPaginationState> emit, {
    required T Function(_LoadMore$UserPaginationEvent event, Emitter<UserPaginationState> emit)
        loadMore,
    required T Function(_Clear$UserPaginationEvent event, Emitter<UserPaginationState> emit) clear,
  }) =>
      switch (this) {
        _LoadMore$UserPaginationEvent $ => loadMore($, emit),
        _Clear$UserPaginationEvent $ => clear($, emit),
      };
}

class _LoadMore$UserPaginationEvent extends _UserPaginationEvent {
  const _LoadMore$UserPaginationEvent();
}

class _Clear$UserPaginationEvent extends _UserPaginationEvent {
  const _Clear$UserPaginationEvent();
}
