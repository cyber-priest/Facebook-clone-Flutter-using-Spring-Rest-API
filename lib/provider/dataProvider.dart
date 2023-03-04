import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mini_facebook/models/Models.dart';

class DataProvider extends ChangeNotifier {
  var _isLoggedIn = false;
  var _userData;
  List<Post>? _postData;
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
      await fetchPostContent();
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
        return Post(
            isLiked: isLiked,
            id: post['id'],
            user: post['appUser'],
            content: post['content'],
            date: post['dateCreated'],
            postImages: post['postImages'],
            postComments: post['postComments'],
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

  get posts {
    return _postData;
  }
}
