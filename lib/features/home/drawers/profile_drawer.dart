import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:reddit_clone/features/auth/controller/auth_controller.dart";
import "package:reddit_clone/models/user_model.dart";
import "package:reddit_clone/theme/pallete.dart";
import "package:routemaster/routemaster.dart";

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  void LogOut(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).LogOut();
  }

  void navigateToUserProfile(BuildContext context, UserModel user) {
    Routemaster.of(context).push('/u/${user.uid}');
  }

  void toggleTheme(WidgetRef ref) {
    ref.read(themeNotifierProvider.notifier).toogleTheme();
  }

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
              onTap: () => navigateToUserProfile(context, user),
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Pallete.redColor,
              ),
              title: const Text("Log Out"),
              onTap: () => LogOut(ref),
            ),
            Switch.adaptive(
              value: ref.watch(themeNotifierProvider.notifier).mode ==
                  ThemeMode.dark,
              onChanged: (value) => toggleTheme(ref),
            )
          ],
        ),
      ),
    );
  }
}
