import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mini_facebook/config/pallete.dart';
import 'package:mini_facebook/provider/dataProvider.dart';
import 'package:provider/provider.dart';

import '../widgets/CircleButton.dart';

class FriendScreen extends StatefulWidget {
  FriendScreen({Key? key}) : super(key: key);

  @override
  State<FriendScreen> createState() => _FriendScreenState();
}

class _FriendScreenState extends State<FriendScreen> {
  List requests = [];

  @override
  Widget build(BuildContext context) {
    var friends = Provider.of<DataProvider>(context).friends as List;
    var users = Provider.of<DataProvider>(context).users as List;
    var token = Provider.of<DataProvider>(context).token;
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        title: Text(
          'facebook',
          style: const TextStyle(
            color: Palette.facebookBlue,
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            letterSpacing: -1.2,
          ),
        ),
        actions: [
          CircleButton(
            icon: Icons.search,
            iconSize: 30.0,
            onPressed: () {
              var user = context.read<DataProvider>().user;
              print(user);
            },
          ),
          CircleButton(
            icon: MdiIcons.facebookMessenger,
            iconSize: 30.0,
            onPressed: () async {
              await context.read<DataProvider>().fetchPostContent();
            },
          ),
          CircleButton(
            icon: Icons.menu,
            iconSize: 30.0,
            onPressed: () async {
              await context.read<DataProvider>().signout();
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "Friends",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Column(
              children: friends.map((friend) {
                setState(() {
                  requests = [...requests, friend['userName']];
                });
                if (friend['status'] != 'PENDING') {
                  return SizedBox();
                }
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: Container(
                      alignment: Alignment.center,
                      width: 70,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Palette.facebookBlue,
                      ),
                      child: Text(
                          friend["firstName"][0].toString().toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold)),
                    ),
                    title: Text(
                      friend["firstName"] + " " + friend["lastName"],
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Container(
                        child: Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            var id;
                            for (var user in users) {
                              if (user['userName'] == friend['userName']) {
                                id = user['id'];
                              }
                            }
                            await context
                                .read<DataProvider>()
                                .acceptFriendRequest(id.toString());
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Palette.facebookBlue,
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 15),
                            child: Text(
                              "Confirm",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        InkWell(
                          onTap: () async {
                            var id;
                            for (var user in users) {
                              if (user['userName'] == friend['userName']) {
                                id = user['id'];
                              }
                            }
                            await context
                                .read<DataProvider>()
                                .unfriend(id.toString());
                            setState(() {
                              //  requests = [requests]
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.grey,
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 15),
                            child: Text(
                              "Remove",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                          ),
                        )
                      ],
                    )),
                  ),
                );
              }).toList(),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Text(
              "Find some people",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            child: Column(
              children: users.map((user) {
                if (user['token'] == token ||
                    requests.contains(user['userName'])) {
                  return SizedBox();
                }
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: Container(
                      alignment: Alignment.center,
                      width: 70,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Palette.facebookBlue,
                      ),
                      child: Text(user["firstName"][0].toString().toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold)),
                    ),
                    title: Text(
                      user["firstName"] + " " + user["lastName"],
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Container(
                        child: Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            bool alreadyFriends = false;
                            for (var friend in friends) {
                              if (user['userName'] == friend['userName']) {
                                alreadyFriends = true;
                              }
                            }
                            if (alreadyFriends == false) {
                              await context
                                  .read<DataProvider>()
                                  .sendFriendRequest(user['id'].toString());
                            } else {
                              print("already Friends");
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Palette.facebookBlue,
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 15),
                            child: Text(
                              "Add Friend",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
