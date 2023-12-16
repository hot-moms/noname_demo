import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:noname_demo/src/feature/dependencies/widget/dependencies_scope.dart';
import 'package:noname_demo/src/feature/user/controller/pagination/user_pagination_bloc.dart';
import 'package:sliver_tools/sliver_tools.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late final bloc = UserPaginationBloc(userRepository: DependenciesScope.of(context).userRepository)
    ..add(
      const UserPaginationEvent.loadMore(),
    );

  late final scrollController = ScrollController()
    ..addListener(() {
      if (_isBottom) bloc.add(const UserPaginationEvent.loadMore());
    });

  bool get _isBottom {
    if (!scrollController.hasClients) return false;
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.offset;

    return currentScroll >= (maxScroll - 100);
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: CustomScrollView(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            const SliverAppBar(
              flexibleSpace: FlexibleSpaceBar(),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              sliver: BlocBuilder<UserPaginationBloc, UserPaginationState>(
                  bloc: bloc,
                  builder: (context, state) {
                    final isLoaded = state.isNotEmpty;
                    final loadedValueKey = ValueKey('user-listing-$isLoaded');

                    return SliverMainAxisGroup(
                      slivers: [
                        SliverAnimatedSwitcher(
                          duration: kThemeAnimationDuration,
                          child: SliverFixedExtentList.builder(
                            key: loadedValueKey,
                            itemExtent: 150,
                            itemCount: state.isEmpty ? 12 : state.users.length,
                            itemBuilder: (context, index) {
                              final user = state.users.elementAtOrNull(index);
                              final metaInfo = 'User#${user?.id} (${user?.email})';
                              final userName = user?.fullName ?? metaInfo;
                              final avatarUrl = user?.avatarUrl;

                              return state.isEmpty
                                  ? const ListTileShimmer()
                                  : ListTile(
                                      onTap: () => context.pushNamed('user_details', pathParameters: {'id': (user?.id).toString()}),
                                      title: Text(userName),
                                      subtitle: Text(user?.fullName != null ? metaInfo : 'Hello world!'),
                                      leading: CircleAvatar(
                                        radius: 32,
                                        foregroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
                                        backgroundColor: Colors.grey.shade600,
                                        child: const Icon(
                                          Icons.person,
                                          color: Colors.white,
                                        ),
                                      ));
                            },
                          ),
                        ),
                        SliverToBoxAdapter(
                            child: Center(
                                child: state.maybeWhen(
                          orElse: () => null,
                          loading: (_, __) => const CircularProgressIndicator(),
                          error: (_, __, ___, message) => Text('Error: $message'),
                        )))
                      ],
                    );
                  }),
            ),
          ],
        ));
  }
}

class ListTileShimmer extends StatelessWidget {
  const ListTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        foregroundColor: Colors.grey,
        radius: 32,
      ),
      subtitle: Container(
        constraints: const BoxConstraints(maxWidth: 200),
        width: 200,
        height: 16,
        margin: const EdgeInsets.symmetric(vertical: 8),
        color: Colors.grey.shade400,
      ),
      title: Container(
        constraints: const BoxConstraints(maxWidth: 150),
        width: 150,
        height: 20,
        color: Colors.grey.shade200,
      ),
    );
  }
}
