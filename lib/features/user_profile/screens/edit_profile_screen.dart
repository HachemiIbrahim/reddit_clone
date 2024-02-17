import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loading.dart';
import 'package:flutter/material.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/user_profile/contoller/user_profile_controller.dart';
import 'package:reddit_clone/theme/pallete.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final String uid;
  const EditProfileScreen({super.key, required this.uid});

  @override
  ConsumerState<EditProfileScreen> createState() => EditProfileScreenState();
}

class EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  File? bannerImage;
  File? profileImage;
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: ref.read(userProvider)!.name);
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

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

  void save() {
    ref.read(UserProfileControllerProvider.notifier).editProfile(
          profileImage: profileImage,
          bannerImage: bannerImage,
          context: context,
          name: nameController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(UserProfileControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);
    return ref.watch(getUserDataProvider(widget.uid)).when(
          data: (data) {
            return Scaffold(
              backgroundColor: currentTheme.backgroundColor,
              appBar: AppBar(
                title: const Text("Edit Profile"),
                actions: [
                  TextButton(
                    onPressed: () => save(),
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
                                            backgroundImage: NetworkImage(
                                                data.profilePicture),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              hintText: "name",
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(18),
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
