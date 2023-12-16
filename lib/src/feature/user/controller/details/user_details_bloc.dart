import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pure/pure.dart';
import 'package:noname_demo/src/feature/user/model/user_entity.dart';
import 'package:noname_demo/src/feature/user/repository/user_repository_base.dart';
import 'package:noname_demo/src/shared/controller/throttle_droppable.dart';

part 'user_details_event.dart';
part 'user_details_state.dart';

const _defaultState = UserDetailsState.idle(
  currentEntity: null,
  requestedId: null,
);

// comm: вообще, у меня есть собственная реализация универсального блока пагинации
// где ты тупо обьявляешь репозиторий под определенной абстракцией и можешь спокойно юзать
// но я решил сюда его не пихать иначе вообще сойдешь с ума читая его :D
// там дженерик на дженерике в дженерике под дженериками в дженериках с дженериками и так далее :D
class UserDetailsBloc extends Bloc<UserDetailsEvent, UserDetailsState> {
  UserDetailsBloc({required IUserRepository userRepository, UserEntity? defaultEntity})
      : _userRepository = userRepository,
        super(defaultEntity?.pipe((entity) => UserDetailsState.idle(currentEntity: entity, requestedId: entity.id)) ?? _defaultState) {
    on<_UserDetailsEvent>(_eventMapper, transformer: throttleDroppable(kDefaultThrottle));
  }

  Future<void> _eventMapper(_UserDetailsEvent event, Emitter<UserDetailsState> emit) => event.mapEmitter(
        emit,
        fetchUser: _fetchUser,
      );

  final IUserRepository _userRepository;

  void fetchUser({required int targetId}) => add(_FetchUser$UserDetailsEvent(targetId: targetId));

  Future<void> _fetchUser(_FetchUser$UserDetailsEvent event, Emitter<UserDetailsState> emit) async {
    try {
      emit(state.toLoading());
      final newEntity = await _userRepository.loadUserById(event.targetId);

      emit(state.toSuccesfull(
        currentEntity: newEntity,
        requestedId: event.targetId,
      ));
    } on Object catch (e) {
      emit(state.toError(e));
      rethrow;
    } finally {
      await Future.delayed(const Duration(seconds: 1));
      emit(state.toIdle());
    }
  }
}
