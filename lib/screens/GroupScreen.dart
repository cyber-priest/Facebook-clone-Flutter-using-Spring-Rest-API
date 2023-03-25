import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mini_facebook/models/UserModel.dart';
import 'package:provider/provider.dart';

import '../config/pallete.dart';
import '../provider/dataProvider.dart';
import '../widgets/CircleButton.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({Key? key}) : super(key: key);

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController discController = TextEditingController();
  String? errorName;
  String? errorDisc;

  @override
  Widget build(BuildContext context) {
    var groups = Provider.of<DataProvider>(context).groups as List;
    var currentUser = Provider.of<DataProvider>(context).user as User;
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
            height: 10,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "Groups",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Column(
              children: groups.map((group) {
                bool joined = false;
                for (var user in group["appUsers"]) {
                  if (user['userName'] == currentUser.userName) {
                    setState(() {
                      joined = true;
                    });
                  }
                }
                return InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: ListView(
                                  children:
                                      group["appUsers"].map<Widget>((user) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
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
                                          user["firstName"][0]
                                              .toString()
                                              .toUpperCase(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    title: Text(
                                      user["firstName"] +
                                          " " +
                                          user["lastName"],
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    trailing: Icon(
                                      Icons.check_circle,
                                      color: Palette.facebookBlue,
                                    ),
                                  ),
                                );
                              }).toList()));
                        });
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Palette.facebookBlue,
                          ),
                          child: CircleAvatar(child: Icon(Icons.group)),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  group["groupName"],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                child: Text(
                                  group['description'],
                                  style: TextStyle(
                                    // color: Colors.,
                                    fontWeight: FontWeight.w300,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                child: Text(
                                  group['appUsers']!.length.toString() +
                                      " Memebers",
                                  style: TextStyle(
                                    // color: Colors.,
                                    fontWeight: FontWeight.w200,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                            child: InkWell(
                          onTap: () async {
                            if (!joined) {
                              await context
                                  .read<DataProvider>()
                                  .joinGroup(group["id"].toString());
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color:
                                  joined ? Colors.grey : Palette.facebookBlue,
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 15),
                            child: Text(
                              joined ? "Joined" : "Join",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                          ),
                        )),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                    child: ListView(children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 40),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextField(
                      controller: nameController,
                      maxLines: 1,
                      onChanged: (name) {
                        int length = name.length;
                        errorName =
                            length > 0 ? null : "Please fill the name field";
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Group Name",
                        hintStyle: TextStyle(fontFamily: "monte", fontSize: 13),
                        errorText: errorName,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 40),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextField(
                      controller: discController,
                      maxLines: 1,
                      onChanged: (disc) {
                        int length = disc.length;
                        errorDisc = length > 0
                            ? null
                            : "Please fill the discription field";
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Group Discription",
                        hintStyle: TextStyle(fontFamily: "monte", fontSize: 13),
                        errorText: errorDisc,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (errorName == null && errorDisc == null) {
                          var data = {
                            "groupName": nameController.text,
                            "description": discController.text
                          };
                          await context.read<DataProvider>().createGroup(data);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text("Create"),
                      ),
                    ),
                  ),
                ]));
              });
        },
        child: Icon(
          Icons.add,
        ),
        mini: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
