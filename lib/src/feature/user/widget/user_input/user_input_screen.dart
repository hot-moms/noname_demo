import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:noname_demo/src/core/util/screen_util.dart';
import 'package:noname_demo/src/feature/dependencies/widget/dependencies_scope.dart';
import 'package:noname_demo/src/feature/user/controller/details/user_details_bloc.dart';
import 'package:noname_demo/src/shared/widget/button/button_with_shadow.dart';

const _allowedCodeUnits = [48, 49, 50, 51, 52, 53, 54, 55, 56, 57];

class UserInputScreen extends StatefulWidget {
  const UserInputScreen({super.key});

  @override
  State<UserInputScreen> createState() => _UserInputScreenState();
}

class _UserInputScreenState extends State<UserInputScreen> {
  late final bloc = UserDetailsBloc(
    userRepository: DependenciesScope.of(context).userRepository,
  );

  final textFieldController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _getTargetUser() {
    final validation = _formKey.currentState?.validate() ?? false;
    if (!validation) return;

    final int input = int.parse(textFieldController.text);
    bloc.add(UserDetailsEvent.fetchUser(targetId: input));
  }

  @override
  Widget build(BuildContext context) => Center(
      child: FractionallySizedBox(
          widthFactor: ScreenUtil.screenSizeOf(context).maybeWhen(
            phone: () => .8,
            orElse: () => .6,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocConsumer<UserDetailsBloc, UserDetailsState>(
                bloc: bloc,
                listenWhen: (previousState, nextState) => previousState.isSuccessfull && !nextState.isSuccessfull,
                listener: (context, state) => context.pushNamed(
                  'user_details',
                  pathParameters: {
                    'id': state.requestedId.toString(),
                  },
                ),
                builder: (context, state) => Row(
                  children: [
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.always,
                          validator: (input) => input?.codeUnits.every(_allowedCodeUnits.contains) ?? false
                              ? null
                              : 'Поле ввода может содержать только цифры',
                          enabled: state.maybeWhen(orElse: () => true, loading: (_, __) => false),
                          controller: textFieldController,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    ButtonWithShadow(
                      onTap: _getTargetUser,
                      width: state.isLoading ? 80 : 120,
                      gradient: state.maybeWhen(
                        orElse: () => const LinearGradient(
                          colors: [Color(0xFF0B55BB), Color(0xFF5038ED)],
                        ),
                        idle: (_, __) => null,
                        successful: (_, __) => null,
                      ),
                      color: state.maybeWhen(
                        orElse: () => null,
                        error: (_, __, ___, ____) => Colors.red,
                        successful: (_, __) => Colors.green,
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 100),
                        child: state.when(
                          idle: (_, __) => const Text(
                            'Поиск',
                            key: ValueKey(
                              'search-state-idle',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          successful: (_, __) => const Icon(
                            key: ValueKey('search-state-success'),
                            Icons.check,
                            color: Colors.white,
                          ),
                          loading: (_, __) => const CircularProgressIndicator(
                            key: ValueKey('search-state-process'),
                            color: Colors.white,
                          ),
                          error: (_, __, ___, ____) => const Icon(
                            key: ValueKey('search-state-error'),
                            Icons.error,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              ButtonWithShadow.defaultBlue(
                'Список пользователей',
                onTap: () => context.pushNamed('user_list'),
              ),
            ],
          )));

  String? inputValidator(input) =>
      input?.codeUnits.every(_allowedCodeUnits.contains) ?? false ? null : 'Поле ввода может содержать только цифры';
}
