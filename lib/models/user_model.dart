import 'package:flutter/foundation.dart';

class UserModel {
  final String uid;
  final String name;
  final String profilePicture;
  final String banner;
  final int karma;
  final List<String> rewards;
  final bool isGuest;
  UserModel({
    required this.uid,
    required this.name,
    required this.profilePicture,
    required this.banner,
    required this.karma,
    required this.rewards,
    required this.isGuest,
  });

  UserModel copyWith({
    String? uid,
    String? name,
    String? profilePicture,
    String? banner,
    int? karma,
    List<String>? rewards,
    bool? isGuest,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      profilePicture: profilePicture ?? this.profilePicture,
      banner: banner ?? this.banner,
      karma: karma ?? this.karma,
      rewards: rewards ?? this.rewards,
      isGuest: isGuest ?? this.isGuest,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'profilePicture': profilePicture,
      'banner': banner,
      'karma': karma,
      'rewards': rewards,
      'isGuest': isGuest,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    // Ensure that 'rewards' is a List<String>
    var rewardsList = map['rewards'] as List<dynamic>;
    List<String> rewards = rewardsList.cast<String>();

    return UserModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      profilePicture: map['profilePicture'] as String,
      banner: map['banner'] as String,
      karma: map['karma'] as int,
      rewards: rewards,
      isGuest: map['isGuest'] as bool,
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, profilePicture: $profilePicture, banner: $banner, karma: $karma, rewards: $rewards, isGuest: $isGuest)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.name == name &&
        other.profilePicture == profilePicture &&
        other.banner == banner &&
        other.karma == karma &&
        listEquals(other.rewards, rewards) &&
        other.isGuest == isGuest;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        profilePicture.hashCode ^
        banner.hashCode ^
        karma.hashCode ^
        rewards.hashCode ^
        isGuest.hashCode;
  }
}
