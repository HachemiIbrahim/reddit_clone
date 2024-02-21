import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/posts/controller/post_controller.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/theme/pallete.dart';

class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({required this.post, super.key});

  void deletePost(WidgetRef ref, Post post, BuildContext context) {
    ref.watch(postControllerProvider.notifier).deletePost(post, context);
  }

  void upvotePost(WidgetRef ref, Post post) {
    ref.watch(postControllerProvider.notifier).upvote(post);
  }

  void downvotePost(WidgetRef ref, Post post) {
    ref.watch(postControllerProvider.notifier).downvote(post);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = post.type == 'image';
    final isTypeText = post.type == 'text';
    final isTypeLink = post.type == 'link';
    final user = ref.watch(userProvider)!;
    final currentTheme = ref.watch(themeNotifierProvider);
    return Column(
      children: [
        Container(
          decoration:
              BoxDecoration(color: currentTheme.drawerTheme.backgroundColor),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 4),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(post.communityProfilePic),
                                    radius: 16,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Text(
                                          "r/${post.communityName}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Text(
                                          "u/${post.username}",
                                          style: const TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              IconButton(
                                onPressed: () => deletePost(ref, post, context),
                                icon: Icon(
                                  Icons.delete,
                                  color: Pallete.redColor,
                                ),
                              )
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                post.title,
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          if (isTypeImage)
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.35,
                              width: double.infinity,
                              child: Image.network(
                                post.link!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          if (isTypeLink)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18),
                              child: AnyLinkPreview(
                                displayDirection:
                                    UIDirection.uiDirectionHorizontal,
                                link: post.link!,
                              ),
                            ),
                          if (isTypeText)
                            Container(
                              alignment: Alignment.bottomLeft,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                post.description!,
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () => upvotePost(ref, post),
                                      icon: Icon(
                                        Icons.arrow_upward_sharp,
                                        size: 20,
                                        color: post.upvotes.contains(user.uid)
                                            ? Pallete.redColor
                                            : null,
                                      ),
                                    ),
                                    Text(
                                      '${post.upvotes.length - post.downvotes.length == 0 ? 'Vote' : post.upvotes.length - post.downvotes.length}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    IconButton(
                                      onPressed: () => downvotePost(ref, post),
                                      icon: Icon(
                                        Icons.arrow_downward_sharp,
                                        size: 20,
                                        color: post.downvotes.contains(user.uid)
                                            ? Pallete.blueColor
                                            : null,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.comment,
                                        size: 20,
                                      ),
                                    ),
                                    Text(
                                      '${post.commentCount == 0 ? 'Comment' : post.commentCount}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
