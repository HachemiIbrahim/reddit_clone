import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:reddit_clone/core/common/error_text.dart";
import "package:reddit_clone/core/common/loading.dart";
import "package:reddit_clone/core/common/sign_in_button.dart";
import "package:reddit_clone/features/auth/controller/auth_controller.dart";
import "package:reddit_clone/features/community/controller/community_controller.dart";
import "package:reddit_clone/models/community_model.dart";
import "package:routemaster/routemaster.dart";

class CommunityDrawer extends ConsumerWidget {
  const CommunityDrawer({super.key});

  void NavigateToCreateCommunity(BuildContext context) {
    Routemaster.of(context).push('/create-community');
  }

  void navigateToCommunity(BuildContext context, Community community) {
    Routemaster.of(context).push('/r/${community.name}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userProvider)!;
    final isGeust = user.isGuest;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            isGeust
                ? const SignInButton(
                    isFromLogin: false,
                  )
                : ListTile(
                    title: const Text("Create Community"),
                    leading: const Icon(Icons.add),
                    onTap: () => NavigateToCreateCommunity(context),
                  ),
            if (!isGeust)
              ref.watch(UserCommunityProvider).when(
                    data: (data) => Expanded(
                      child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final community = data[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(community.avatar),
                            ),
                            title: Text("r/${community.name}"),
                            onTap: () =>
                                navigateToCommunity(context, community),
                          );
                        },
                      ),
                    ),
                    error: (error, stackTrace) => ErrorText(
                      error: error.toString(),
                    ),
                    loading: () => Loading(),
                  )
          ],
        ),
      ),
    );
  }
}
