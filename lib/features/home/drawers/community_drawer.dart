import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:reddit_clone/core/common/error_text.dart";
import "package:reddit_clone/core/common/loading.dart";
import "package:reddit_clone/features/community/controller/community_controller.dart";
import "package:routemaster/routemaster.dart";

class CommunityDrawer extends ConsumerWidget {
  const CommunityDrawer({super.key});

  void NavigateToCommunity(BuildContext context) {
    Routemaster.of(context).push('/create-community');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
              title: Text("Create Community"),
              leading: Icon(Icons.add),
              onTap: () => NavigateToCommunity(context),
            ),
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
