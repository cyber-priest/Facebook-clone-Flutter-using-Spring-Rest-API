import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_dart/storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mini_facebook/provider/dataProvider.dart';
import 'package:mini_facebook/widgets/Utils.dart';
import 'package:provider/provider.dart';

import '../config/pallete.dart';
import '../models/PostModel.dart';
import 'ProfileAvatar.dart';

class PostContainer extends StatelessWidget {
  final Post? post;
  final int? index;

  PostContainer({Key? key, this.post, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _PostHeader(post: post),
                  SizedBox(height: 4.0),
                  Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      child: Text(post!.content)),
                  post!.postImages.length > 0
                      ? const SizedBox.shrink()
                      : const SizedBox(
                          height: 6.0,
                        ),
                ],
              ),
            ),
            post!.postImages.length > 0
                ? StreamBuilder<Uint8List?>(
                    stream: FirebaseStorage.instance
                        .refFromURL(post!.postImages[0]['imageUrl'])
                        .getData()
                        .asStream(),
                    builder: (context, snapshot) {
                      print(post!.postImages[0]['imageUrl']);
                      if (snapshot.hasData) {
                        return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Image.memory(snapshot.data as Uint8List));
                      } else {
                        return SizedBox.shrink();
                      }
                    })
                : SizedBox.shrink(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: _PostStats(
                post: post,
                index: index,
              ),
            )
          ],
        ));
  }
}

class _PostStats extends StatelessWidget {
  final Post? post;
  final int? index;

  _PostStats({Key? key, this.post, this.index}) : super(key: key);
  final TextEditingController contentController = TextEditingController();
  String? errorContent;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<DataProvider>(context);
    if (post!.postImages.isNotEmpty) {
      print("Yes it has images");
    }
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: Palette.facebookBlue,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.thumb_up,
                size: 10.0,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 4.0),
            Expanded(
              child: Text(
                '${post?.postLikes.length}',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            Text(
              '${post?.postComments.length} Comments',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(width: 8.0),
            // Text(
            //   '${post?.postComments.length} Shares',
            //   style: TextStyle(color: Colors.grey[600]),
            // )
          ],
        ),
        const Divider(),
        Row(
          children: [
            _PostButton(
              icon: Icon(
                post!.isLiked ? MdiIcons.thumbUp : MdiIcons.thumbUpOutline,
                color: post!.isLiked ? Palette.facebookBlue : Colors.grey[600],
                size: 20.0,
              ),
              label: 'like',
              onTap: () async {
                if (post!.isLiked) {
                  await provider
                      .unlikePost(post!.postLikes[0]['id'].toString());
                } else {
                  await provider.likePost(post!.id.toString());
                }
              },
            ),
            _PostButton(
              icon: Icon(
                MdiIcons.commentOutline,
                color: Colors.grey[600],
                size: 20.0,
              ),
              label: 'Comment',
              onTap: () async {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    final test = Provider.of<DataProvider>(context);
                    Post? post = test.posts[index];
                    return ListenableProvider.value(
                      value: test,
                      child: Container(
                        child: ListView(
                          children: [
                            Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width /
                                          1.3,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 15),
                                      margin: EdgeInsets.only(left: 15, top: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: TextField(
                                        controller: contentController,
                                        maxLines: 1,
                                        onChanged: (body) {
                                          int length = body.length;
                                        },
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: "Write a comment",
                                          hintStyle: TextStyle(
                                              fontFamily: "monte",
                                              fontSize: 13),
                                          errorText: errorContent,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(right: 35, top: 15),
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          String content =
                                              contentController.text;
                                          var date = DateTime.now();
                                          Map data = {
                                            "content": content,
                                            "dateCreated":
                                                date.toIso8601String(),
                                          };
                                          await context
                                              .read<DataProvider>()
                                              .commentPost(
                                                  post!.id.toString(), data)
                                              .then((value) {})
                                              .catchError((error) {
                                            print(error);
                                            messanger(
                                                context, error.toString());
                                          });
                                        },
                                        child: Icon(
                                          Icons.send,
                                        ),
                                        style: ButtonStyle(
                                            maximumSize:
                                                MaterialStateProperty.all(
                                                    Size.fromWidth(100)),
                                            padding: MaterialStateProperty.all(
                                                EdgeInsets.symmetric(
                                                    vertical: 20)),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                              Palette.facebookBlue,
                                            )),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 35),
                              child: Text(
                                "Comments",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            post!.postComments.length > 0
                                ? Container(
                                    child: Column(
                                      children:
                                          post.postComments.map((comment) {
                                        var date = DateTime.parse(
                                            comment['dateCreated']);
                                        var currentDate = DateTime.now();
                                        var newDate =
                                            currentDate.difference(date);
                                        return Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ListTile(
                                                dense: true,
                                                leading: CircleAvatar(
                                                  child: Text(comment['appUser']
                                                      ['firstName'][0]),
                                                ),
                                                title: Text(
                                                    comment['appUser']
                                                            ['firstName'] +
                                                        " " +
                                                        comment['appUser']
                                                            ['lastName'],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                subtitle: Text(
                                                    newDate.inHours > 0
                                                        ? newDate.inHours
                                                                .toString() +
                                                            " hours ago."
                                                        : newDate.inMinutes
                                                                .toString() +
                                                            " minutes ago.",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500)),
                                                trailing: IconButton(
                                                  onPressed: () {},
                                                  icon: Icon(
                                                    Icons.thumb_up_alt,
                                                    size: 20,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 35),
                                                child: Text(comment['content']),
                                              ),
                                              Divider()
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  )
                                : SizedBox()
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            _PostButton(
              icon: Icon(
                MdiIcons.shareOutline,
                color: Colors.grey[600],
                size: 25.0,
              ),
              label: 'Share',
              onTap: () {},
            )
          ],
        )
      ],
    );
  }
}

class _PostButton extends StatelessWidget {
  final Icon? icon;
  final String? label;
  final Function? onTap;

  const _PostButton({Key? key, this.icon, this.label, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: () => onTap!(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            height: 25.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon as Widget,
                SizedBox(width: 4.0),
                Text(label!),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PostHeader extends StatelessWidget {
  final Post? post;

  const _PostHeader({Key? key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();
    DateTime postCreated = DateTime.parse(post!.date);
    var postTime = currentDate.difference(postCreated).inDays;
    return Row(
      children: [
        ProfileAvatar(
          name: post!.user['firstName'],
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post!.user['firstName'] + " " + post!.user['lastName'],
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  Text(
                    '${postTime} .',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12.0,
                    ),
                  ),
                  Icon(
                    Icons.public,
                    color: Colors.grey[600],
                    size: 12.0,
                  )
                ],
              )
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.more_horiz),
          onPressed: () {},
        )
      ],
    );
  }
}
