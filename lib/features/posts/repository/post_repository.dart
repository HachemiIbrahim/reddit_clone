import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/constants/firebase_constants.dart';
import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/core/providers/firebase_providers.dart';
import 'package:reddit_clone/core/type_defs.dart';
import 'package:reddit_clone/models/comment_model.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:reddit_clone/models/post_model.dart';

final PostRepositoryProvider = Provider((ref) {
  return PostRepository(firestore: ref.read(firstorProvider));
});

class PostRepository {
  final FirebaseFirestore _firestore;
  PostRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _posts =>
      _firestore.collection(FirebaseConstants.postsCollection);

  CollectionReference get _comments =>
      _firestore.collection(FirebaseConstants.commentsCollection);

  FutureVoid addPost(Post post) async {
    try {
      return right(
        _posts.doc(post.id).set(
              post.toMap(),
            ),
      );
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid deletePost(Post post) async {
    try {
      return right(await _posts.doc(post.id).delete());
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid addComment(Comment commnet) async {
    try {
      return right(
        await _comments.doc(commnet.id).set(
              commnet.toMap(),
            ),
      );
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  void upvotePost(Post post, String uid) {
    if (post.downvotes.contains(uid)) {
      _posts.doc(post.id).update(
        {
          'downvotes': FieldValue.arrayRemove([uid]),
        },
      );
    }
    if (post.upvotes.contains(uid)) {
      _posts.doc(post.id).update(
        {
          'upvotes': FieldValue.arrayRemove([uid]),
        },
      );
    } else {
      _posts.doc(post.id).update(
        {
          'upvotes': FieldValue.arrayUnion([uid]),
        },
      );
    }
  }

  void downvotePost(Post post, String uid) {
    if (post.upvotes.contains(uid)) {
      _posts.doc(post.id).update(
        {
          'upvotes': FieldValue.arrayRemove([uid]),
        },
      );
    }
    if (post.downvotes.contains(uid)) {
      _posts.doc(post.id).update(
        {
          'downvotes': FieldValue.arrayRemove([uid]),
        },
      );
    } else {
      _posts.doc(post.id).update(
        {
          'downvotes': FieldValue.arrayUnion([uid]),
        },
      );
    }
  }

  Stream<List<Post>> fetchUserPosts(List<Community> communties) {
    return _posts
        .where("communityName", whereIn: communties.map((e) => e.name).toList())
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => Post.fromMap(e.data() as Map<String, dynamic>),
              )
              .toList(),
        );
  }

  Stream<Post> getPostById(String postId) {
    return _posts.doc(postId).snapshots().map(
          (event) => Post.fromMap(event.data() as Map<String, dynamic>),
        );
  }
}
