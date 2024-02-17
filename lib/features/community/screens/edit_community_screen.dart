// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loading.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:reddit_clone/theme/pallete.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  final String name;
  const EditCommunityScreen({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  ConsumerState<EditCommunityScreen> createState() =>
      _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
  File? bannerImage;
  File? profileImage;

  void SelectBannerImage() async {
    final res = await ImagePicker();
    if (res != null) {
      setState(() {
        bannerImage = File(res.files.first.path!);
      });
    }
  }

  void SelectProfileImage() async {
    final res = await ImagePicker();
    if (res != null) {
      setState(() {
        profileImage = File(res.files.first.path!);
      });
    }
  }

  void save(Community community) {
    ref.read(CommunityControllerProvider.notifier).editCommunity(
        profileImage: profileImage,
        bannerImage: bannerImage,
        context: context,
        community: community);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(CommunityControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);
    return ref.watch(CommunityByNameProvider(widget.name)).when(
          data: (data) {
            return Scaffold(
              backgroundColor: currentTheme.backgroundColor,
              appBar: AppBar(
                title: const Text("Edit Community"),
                actions: [
                  TextButton(
                    onPressed: () => save(data),
                    child: const Text("Save"),
                  ),
                ],
              ),
              body: isLoading
                  ? Center(
                      child: Loading(),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 200,
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: SelectBannerImage,
                                  child: DottedBorder(
                                    borderType: BorderType.RRect,
                                    radius: const Radius.circular(20),
                                    dashPattern: const [10, 4],
                                    strokeCap: StrokeCap.round,
                                    color: Pallete.darkModeAppTheme.textTheme
                                        .bodyText2!.color!,
                                    child: Container(
                                      width: double.infinity,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: bannerImage != null
                                          ? Image.file(bannerImage!)
                                          : data.banner.isEmpty ||
                                                  data.banner ==
                                                      Constants.bannerDefault
                                              ? const Center(
                                                  child: Icon(Icons
                                                      .camera_alt_outlined),
                                                )
                                              : Center(
                                                  child: Image.network(
                                                      data.banner),
                                                ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 20,
                                  bottom: 20,
                                  child: GestureDetector(
                                    onTap: SelectProfileImage,
                                    child: profileImage != null
                                        ? CircleAvatar(
                                            radius: 32,
                                            backgroundImage:
                                                FileImage(profileImage!),
                                          )
                                        : CircleAvatar(
                                            radius: 32,
                                            backgroundImage:
                                                NetworkImage(data.avatar),
                                          ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
            );
          },
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
          loading: () => Loading(),
        );
  }
}
