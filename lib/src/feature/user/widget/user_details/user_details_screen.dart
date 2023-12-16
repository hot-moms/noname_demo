import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noname_demo/src/feature/dependencies/widget/dependencies_scope.dart';
import 'package:noname_demo/src/feature/user/controller/details/user_details_bloc.dart';
import 'package:noname_demo/src/feature/user/model/user_entity.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({
    super.key,
    this.userEntity,
    required this.userId,
  });

  final UserEntity? userEntity;
  final int userId;

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  late final bloc = UserDetailsBloc(userRepository: DependenciesScope.of(context).userRepository, defaultEntity: widget.userEntity)
    ..fetchUser(targetId: widget.userId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ColoredBox(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: BlocBuilder<UserDetailsBloc, UserDetailsState>(
            bloc: bloc,
            builder: (context, state) {
              final user = state.currentEntity;
              final metaInfo = 'User#${user?.id} (${user?.email})';
              final userName = user?.fullName ?? metaInfo;
              final avatarUrl = user?.avatarUrl;

              return Center(
                // widthFactor: 0,
                child: state.currentEntity == null
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 32,
                              foregroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
                              backgroundColor: Colors.grey.shade600,
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(userName),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(user?.fullName != null ? metaInfo : 'Hello world!')
                              ],
                            )
                          ],
                        )),
              );
            },
          ),
        ));
  }
}
