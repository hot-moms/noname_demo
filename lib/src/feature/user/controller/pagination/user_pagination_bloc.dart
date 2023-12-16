import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noname_demo/src/feature/user/model/user_entity.dart';
import 'package:noname_demo/src/feature/user/repository/user_repository_base.dart';
import 'package:noname_demo/src/shared/controller/throttle_droppable.dart';

part 'user_pagination_event.dart';
part 'user_pagination_state.dart';

const _defaultState = UserPaginationState.idle(
  users: [],
  currentPage: 1,
);

// comm: вообще, у меня есть собственная реализация универсального блока пагинации
// где ты тупо обьявляешь репозиторий под определенной абстракцией и можешь спокойно юзать
// но я решил сюда его не пихать иначе вообще сойдешь с ума читая его :D
// там дженерик на дженерике в дженерике под дженериками в дженериках с дженериками и так далее :D
class UserPaginationBloc extends Bloc<UserPaginationEvent, UserPaginationState> {
  UserPaginationBloc({required IUserRepository userRepository, int perPageItems = 7})
      : _userRepository = userRepository,
        _perPageItems = perPageItems,
        super(_defaultState) {
    on<_UserPaginationEvent>(_eventMapper, transformer: throttleDroppable(kDefaultThrottle));
  }

  Future<void> _eventMapper(_UserPaginationEvent event, Emitter<UserPaginationState> emit) => event.mapEmitter(
        emit,
        loadMore: _loadMore,
        clear: _clear,
      );

  final IUserRepository _userRepository;
  final int _perPageItems;

  Future<void> _loadMore(_LoadMore$UserPaginationEvent event, Emitter<UserPaginationState> emit) async {
    if (state.hasReachedEnd) return;
    try {
      emit(state.toLoading());
      final usersChunk = await _userRepository.loadUsers(page: state.currentPage, perPage: _perPageItems);
      final hasReachedEnd = usersChunk.length < _perPageItems;
      final newUsers = [...state.users, ...usersChunk];

      emit(state.toIdle(
        users: newUsers,
        currentPage: state.currentPage + 1,
        hasReachedEnd: hasReachedEnd,
      ));
    } on Object catch (e) {
      emit(state.toError(e));
      rethrow;
    }
  }

  Future<void> _clear(_Clear$UserPaginationEvent event, Emitter<UserPaginationState> emit) async => emit(_defaultState);
}
