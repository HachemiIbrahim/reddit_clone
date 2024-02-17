import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPostScreenType extends ConsumerStatefulWidget {
  final String type;
  const AddPostScreenType({super.key, required this.type});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddPostScreenTypeState();
}

class _AddPostScreenTypeState extends ConsumerState<AddPostScreenType> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
