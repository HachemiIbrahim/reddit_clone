// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class ModToolsScreen extends StatelessWidget {
  final String name;
  const ModToolsScreen({
    Key? key,
    required this.name,
  }) : super(key: key);

  void NavigationToAddMods(context) {
    Routemaster.of(context).push('/add_mod/$name');
  }

  void NavigationToEditCommunity(context) {
    Routemaster.of(context).push('/edit_community/$name');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Moderator tools"),
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.add_moderator),
            title: const Text("add moderator"),
            onTap: () => NavigationToAddMods(context),
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text("edit community"),
            onTap: () => NavigationToEditCommunity(context),
          )
        ],
      ),
    );
  }
}
