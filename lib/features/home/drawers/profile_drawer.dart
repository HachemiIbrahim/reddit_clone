import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:reddit_clone/features/auth/controller/auth_controller.dart";
import "package:reddit_clone/theme/pallete.dart";

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user!.profilePicture),
              radius: 70,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "u/${user.name}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.person,
              ),
              title: const Text("My Profile"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Pallete.redColor,
              ),
              title: const Text("Log Out"),
              onTap: () {},
            ),
            Switch.adaptive(
              value: true,
              onChanged: (value) {},
            )
          ],
        ),
      ),
    );
  }
}
