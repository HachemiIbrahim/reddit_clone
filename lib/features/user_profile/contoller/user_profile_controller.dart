import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/enum/enum.dart';
import 'package:reddit_clone/core/providers/storage_repository_provider.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/user_profile/repository/user_profile_repository.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/models/user_model.dart';
import 'package:routemaster/routemaster.dart';

final UserProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  final userRepository = ref.watch(userProfileRepositoryProvider);
  final storageRepository = ref.watch(StorageRepositoryProvider);
  return UserProfileController(
    ref: ref,
    storageRepository: storageRepository,
    profileRepository: userRepository,
  );
});

final getUserPostsProvider = StreamProvider.family((ref, String uid) {
  final _profileController = ref.watch(UserProfileControllerProvider.notifier);
  return _profileController.getUserPosts(uid);
});

class UserProfileController extends StateNotifier<bool> {
  final UserProfileRepository _profileRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  UserProfileController(
      {required UserProfileRepository profileRepository,
      required Ref ref,
      required StorageRepository storageRepository})
      : _profileRepository = profileRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void editProfile({
    required File? profileImage,
    required File? bannerImage,
    required BuildContext context,
    required String name,
  }) async {
    state = true;
    UserModel user = _ref.read(userProvider)!;
    if (profileImage != null) {
      final res = await _storageRepository.storeFile(
        path: "users/profile",
        id: user.uid,
        file: profileImage,
      );
      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => user = user.copyWith(profilePicture: r),
      );
    }

    if (bannerImage != null) {
      final res = await _storageRepository.storeFile(
        path: "users/banner",
        id: user.uid,
        file: bannerImage,
      );
      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => user = user.copyWith(banner: r),
      );
    }

    user = user.copyWith(name: name);
    final res = await _profileRepository.editProfile(user);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      _ref.read(userProvider.notifier).update((state) => user);
      Routemaster.of(context).pop();
    });
  }

  Stream<List<Post>> getUserPosts(String uid) {
    return _profileRepository.getUserPosts(uid);
  }

  void updateUserKarma(UserKarma karma) async {
    UserModel user = _ref.read(userProvider)!;
    user = user.copyWith(karma: user.karma + karma.karma);

    final res = await _profileRepository.updateUserKarma(user);
    res.fold((l) => null,
        (r) => _ref.read(userProvider.notifier).update((state) => user));
  }
}
