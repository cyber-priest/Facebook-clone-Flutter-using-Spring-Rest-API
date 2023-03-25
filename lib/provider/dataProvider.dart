import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mini_facebook/models/Models.dart';

class DataProvider extends ChangeNotifier {
  var _isLoggedIn = false;
  var _userData;
  var _friends;
  var _users;
  var _groups;
  List<Post>? _postData;
  var _sharedPost;
  var postCount;
  var _token;
  var _id;

  Future<int> login(userName, password) async {
    Uri url = Uri.http("localhost:8080", "public/login",
        {'userName': userName, 'password': password});
    var res = await post(
      url,
      headers: {'Content-Type': 'application/json'},
    ).catchError((error) {
      throw error;
    });
    if (res.statusCode == 200) {
      _token = res.body;
      await fetchUser();
      await fetchFriends();
      await fetchPostContent();
      await fetchSharedPost();
      await fetchGroups();
      _isLoggedIn = true;
      notifyListeners();
    }
    return res.statusCode;
  }

  Future fetchUser() async {
    Uri url = Uri.http(
      "localhost:8080",
      "public/",
    );
    var res = await get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    ).catchError((error) {
      print(error.toString());
    });
    if (res.statusCode == 200) {
      var users = jsonDecode(res.body);
      _users = users;
      users.forEach((user) {
        if (user['token'] == _token) {
          _userData = User(
              firstName: user['firstName'],
              lastName: user['lastName'],
              userName: user['userName'],
              phoneNumber: user['phoneNumber']);
          _id = user['id'];
          notifyListeners();
        }
      });
    } else {
      print(res.statusCode);
    }
  }

  Future postContent(Map data) async {
    Uri url = Uri.http(
      "localhost:8080",
      "/posts",
    );
    print(data);
    var res = await post(url,
            headers: {
              'Content-Type': 'application/json',
              'userId': _id.toString(),
            },
            body: json.encode(data))
        .catchError((error) {
      print(error.toString());
    });
    if (res.statusCode == 200) {
      print(res.body);
      await fetchPostContent();
      notifyListeners();
      // messanger("Successfully Signed in.");
    } else {
      print(res.statusCode);
      // messanger("Something went wrong.");
    }
  }

  Future fetchPostContent() async {
    Uri url = Uri.http(
      "localhost:8080",
      "/posts",
    );
    var res = await get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    ).catchError((error) {
      print(error.toString());
    });
    if (res.statusCode == 200) {
      List posts = jsonDecode(res.body);
      _postData = posts.map((post) {
        bool isLiked = false;
        post['postLikes'].forEach((like) {
          if (like['appUser']['id'] == _id) {
            isLiked = true;
          }
          ;
        });
        List comments = post['postComments'];
        comments = comments.reversed.toList();
        return Post(
            isLiked: isLiked,
            id: post['id'],
            user: post['appUser'],
            content: post['content'],
            date: post['dateCreated'],
            postImages: post['postImages'],
            postComments: comments,
            postLikes: post['postLikes']);
      }).toList();
      _postData = _postData!.reversed.toList();
      notifyListeners();
    } else {
      print(res.statusCode);
      // messanger("Something went wrong.");
    }
  }

  Future likePost(String postId) async {
    Uri url = Uri.http(
      "localhost:8080",
      "/posts/${postId}/likes",
    );
    var res = await post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'userId': _id.toString(),
      },
    ).catchError((error) {
      print(error.toString());
    });
    if (res.statusCode == 200) {
      print(res.body);
      await fetchPostContent();
      notifyListeners();
    } else {
      print(res.statusCode);
      // messanger("Something went wrong.");
    }
  }

  Future unlikePost(String postId) async {
    Uri url = Uri.http(
      "localhost:8080",
      "/likes/${postId}",
    );
    var res = await delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'userId': _id.toString(),
      },
    ).catchError((error) {
      print(error.toString());
    });
    if (res.statusCode == 200) {
      print(res.body);
      await fetchPostContent();
      notifyListeners();
    } else {
      print(res.statusCode);
      // messanger("Something went wrong.");
    }
  }

  Future commentPost(String postId, Map data) async {
    Uri url = Uri.http(
      "localhost:8080",
      "/posts/${postId}/comments",
    );
    var res = await post(
      url,
      body: json.encode(data),
      headers: {
        'Content-Type': 'application/json',
        'userId': _id.toString(),
      },
    ).catchError((error) {
      throw error;
    });
    if (res.statusCode == 200) {
      print("Posted");
      await fetchPostContent();
      notifyListeners();
    } else {
      print(res.statusCode);
      // messanger("Something went wrong.");
    }
  }

  Future fetchFriends() async {
    Uri url = Uri.http(
      "localhost:8080",
      "/friends/${_id}/",
    );
    var res = await get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'userId': _id.toString(),
      },
    ).catchError((error) {
      print(error.toString());
    });
    if (res.statusCode == 200) {
      var friends = jsonDecode(res.body);
      _friends = friends;
      notifyListeners();
    } else {
      print(res.statusCode);
    }
  }

  Future sendFriendRequest(String friendId) async {
    Uri url = Uri.http(
      "localhost:8080",
      "/send-friend-request/${friendId}/",
    );
    var res = await post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'userId': _id.toString(),
      },
    ).catchError((error) {
      print(error.toString());
    });
    if (res.statusCode == 200) {
      print("Friend Request Sent");
    } else {
      print(res.statusCode);
    }
    fetchFriends();
    notifyListeners();
  }

  Future acceptFriendRequest(String friendId) async {
    Uri url = Uri.http(
      "localhost:8080",
      "accept-friend-request/${friendId}/",
    );
    var res = await post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'userId': _id.toString(),
      },
    ).catchError((error) {
      print(error.toString());
    });
    if (res.statusCode == 200) {
      print("Friend Request Sent");
    } else {
      print(res.statusCode);
    }
    fetchFriends();
    notifyListeners();
  }

  Future unfriend(String friendId) async {
    Uri url = Uri.http(
      "localhost:8080",
      "/unfriend/${friendId}/",
    );
    var res = await delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'userId': _id.toString(),
      },
    ).catchError((error) {
      print(error.toString());
    });
    if (res.statusCode == 200) {
      print("Unfriend successfully");
    } else {
      print(res.statusCode);
    }
    fetchFriends();
    notifyListeners();
  }

  Future fetchGroups() async {
    Uri url = Uri.http(
      "localhost:8080",
      "/groups",
    );
    var res = await get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'userId': _id.toString(),
      },
    ).catchError((error) {
      print(error.toString());
    });
    if (res.statusCode == 200) {
      var groups = jsonDecode(res.body);
      _groups = groups;
      _groups = _groups.reversed.toList();
      notifyListeners();
    } else {
      print(res.statusCode);
    }
  }

  Future createGroup(var data) async {
    Uri url = Uri.http(
      "localhost:8080",
      "/groups",
    );
    var res = await post(
      url,
      body: json.encode(data),
      headers: {
        'Content-Type': 'application/json',
        'userId': _id.toString(),
      },
    ).catchError((error) {
      print(error.toString());
    });
    if (res.statusCode == 200) {
      print("Group Created Successfully");
      fetchGroups();
    } else {
      print(res.statusCode);
    }
  }

  Future joinGroup(String groupId) async {
    Uri url = Uri.http(
      "localhost:8080",
      "/groups/${groupId}/${_id}",
    );
    var res = await post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'userId': _id.toString(),
      },
    ).catchError((error) {
      print(error.toString());
    });
    if (res.statusCode == 200) {
      print("Joined Successfully");
      fetchGroups();
    } else {
      print(res.statusCode);
    }
  }

  Future fetchSharedPost() async {
    Uri url = Uri.http(
      "localhost:8080",
      "/sharedPosts",
    );
    var res = await get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'userId': _id.toString(),
      },
    ).catchError((error) {
      print(error.toString());
    });
    if (res.statusCode == 200) {
      var sharedPost = json.decode(res.body) as List;
      _sharedPost = sharedPost.reversed.toList();
      print(sharedPost);
      // postCount = _sharedPost.length + _postData.length ;
      notifyListeners();
    } else {
      print(res.statusCode);
    }
  }

  Future sharePost(String postId) async {
    Uri url = Uri.http(
      "localhost:8080",
      "/share-post/${postId}/",
    );
    var res = await post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'userId': _id.toString(),
      },
    ).catchError((error) {
      print(error.toString());
    });
    if (res.statusCode == 200) {
      print("Shared Successfully");
      fetchSharedPost();
    } else {
      print(res.statusCode);
    }
  }

  signin() {
    _isLoggedIn = true;
    notifyListeners();
  }

  signout() {
    _isLoggedIn = false;
    notifyListeners();
  }

  get isLoggedIn {
    return _isLoggedIn;
  }

  get user {
    return _userData;
  }

  get users {
    return _users;
  }

  get friends {
    return _friends;
  }

  get groups {
    return _groups;
  }

  get token {
    return _token;
  }

  get posts {
    return _postData;
  }
}
