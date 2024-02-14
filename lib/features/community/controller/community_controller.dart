import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/providers/storage_repository_provider.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/community/repository/community_repository.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

final CommunityControllerProvider =
    StateNotifierProvider<CommunityController, bool>((ref) {
  final communityRepository = ref.watch(CommunityRepositoryProvider);
  final storageRepository = ref.watch(StorageRepositoryProvider);
  return CommunityController(
    communityRepository: communityRepository,
    ref: ref,
    storageRepository: storageRepository,
  );
});

final UserCommunityProvider = StreamProvider((ref) {
  final communityController = ref.watch(CommunityControllerProvider.notifier);
  return communityController.getUserCommunity();
});

final CommunityByNameProvider = StreamProvider.family((ref, String name) {
  final communityController = ref.watch(CommunityControllerProvider.notifier);
  return communityController.getCommunityByName(name);
});

final SearchCommunityProvider = StreamProvider.family((ref, String query) {
  final communityController = ref.watch(CommunityControllerProvider.notifier);
  return communityController.searchCommunty(query);
});

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  CommunityController(
      {required CommunityRepository communityRepository,
      required Ref ref,
      required StorageRepository storageRepository})
      : _communityRepository = communityRepository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);

  void createCommunity(String name, BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? "";
    Community community = Community(
      id: name,
      name: name,
      banner: Constants.bannerDefault,
      avatar: Constants.avatarDefault,
      members: [uid],
      mods: [uid],
    );
    final res = await _communityRepository.createCommunity(community);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, "Community created successfully");
        Routemaster.of(context).pop();
      },
    );
  }

  void editCommunity({
    required File? profileImage,
    required File? bannerImage,
    required BuildContext context,
    required Community community,
  }) async {
    if (profileImage != null) {
      final res = await _storageRepository.storeFile(
        path: "communities/profile",
        id: community.name,
        file: profileImage,
      );
      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => community = community.copyWith(avatar: r),
      );
    }

    if (bannerImage != null) {
      final res = await _storageRepository.storeFile(
        path: "communities/banner",
        id: community.name,
        file: bannerImage,
      );
      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => community = community.copyWith(avatar: r),
      );
    }

    final res = await _communityRepository.editCommunity(community);

    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => Routemaster.of(context).pop(),
    );
  }

  Stream<Community> getCommunityByName(String name) {
    return _communityRepository.getCommunityByName(name);
  }

  Stream<List<Community>> searchCommunty(String query) {
    return _communityRepository.searchCommuniy(query);
  }

  Stream<List<Community>> getUserCommunity() {
    final uid = _ref.read(userProvider)!.uid;
    return _communityRepository.getUserCommunities(uid);
  }
}
