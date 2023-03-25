import 'package:meta/meta.dart';

import 'UserModel.dart';

class Post {
  final int id;
  final Map user;
  final String content;
  final String date;
  final List postImages;
  final List postLikes;
  final List postComments;
  final bool isLiked;
  final bool? isShared;
  final String? SharedBy;

  const Post({
    required this.id,
    required this.user,
    required this.content,
    required this.date,
    required this.postImages,
    required this.postComments,
    required this.postLikes,
    required this.isLiked,
    this.isShared,
    this.SharedBy,
  });
}
