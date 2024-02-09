import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
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
            )
          ],
        ),
      ),
    );
  }
}
