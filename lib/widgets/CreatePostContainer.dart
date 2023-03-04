import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_dart/storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:mini_facebook/provider/dataProvider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../config/pallete.dart';
import '../models/UserModel.dart';
import '../screens/EditProfile.dart';
import 'widgets.dart';

class CreatePostContainer extends StatefulWidget {
  final User? currentUser;
  CreatePostContainer({Key? key, this.currentUser}) : super(key: key);

  @override
  State<CreatePostContainer> createState() => _CreatePostContainerState();
}

class _CreatePostContainerState extends State<CreatePostContainer> {
  final TextEditingController bodyController = TextEditingController();
  final TextEditingController imgController = TextEditingController();
  String? errorBody;
  String? fileName;
  String? filePath;
  String? url;
  List<File>? images;

  Future<List> uploadFile() async {
    List<String> urls = [];
    for (var imagePath in images!) {
      String des = "Images/" + Uuid().v1() + ".jpg";
      var firebaseStorageRef = FirebaseStorage.instance.ref(des);
      var uploadTask =
          await firebaseStorageRef.putData(imagePath.readAsBytesSync());
      await uploadTask.ref.getDownloadURL().then((url) {
        urls = [...urls, url];
      });
    }
    return urls;
  }

  messanger(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.blue,
        content: Container(
            color: Colors.blue,
            margin: EdgeInsets.only(bottom: 30),
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ))));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 0.0),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => EditProfile()));
                },
                child: CircleAvatar(
                    radius: 20.0,
                    backgroundColor: Colors.blueGrey,
                    child: Icon(Icons.edit)),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: TextField(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        images = null;
                        return StatefulBuilder(builder: (context, setState) {
                          return Container(
                            child: ListView(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 15),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: TextField(
                                    controller: bodyController,
                                    maxLines: 3,
                                    onChanged: (body) {
                                      int length = body.length;
                                      setState(() {});
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "What's on your mind?",
                                      hintStyle: TextStyle(
                                          fontFamily: "monte", fontSize: 13),
                                      errorText: errorBody,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: GestureDetector(
                                        onTap: () async {
                                          var result = await FilePicker.platform
                                              .pickFiles();
                                          fileName = result!.files.first.name;
                                          filePath = result.files.first.path;

                                          if (fileName!.endsWith(".png") ||
                                              fileName!.endsWith(".jpg") ||
                                              fileName!.endsWith(".Jpeg") ||
                                              fileName!.endsWith(".gif")) {
                                            setState(() {
                                              images = [
                                                ...?images,
                                                File(filePath as String)
                                              ];
                                              images =
                                                  images!.reversed.toList();
                                            });
                                          } else {
                                            fileName = null;
                                            filePath = null;
                                            messanger(
                                                "please pick image files only.");
                                          }
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 8),
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 35),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.blueAccent),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black12,
                                                  blurRadius: 4,
                                                  offset: Offset(0, 5))
                                            ],
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.image,
                                                color: Palette.facebookBlue,
                                                size: 30,
                                              ),
                                              SizedBox(width: 10),
                                              Expanded(
                                                child: Text("Add Images",
                                                    style: TextStyle(
                                                        color: Palette
                                                            .facebookBlue,
                                                        fontSize: 12,
                                                        fontFamily: "monte"),
                                                    textAlign:
                                                        TextAlign.justify),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 35),
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            List<Map> postImages = [];
                                            String content =
                                                bodyController.text;
                                            var date = DateTime.now();
                                            String ppid = Uuid().v1();
                                            if (images!.isNotEmpty) {
                                              var urlList = await uploadFile();
                                              postImages = urlList
                                                  .map((url) =>
                                                      {"imageUrl": url})
                                                  .toList();
                                              print(postImages);
                                            }
                                            Map data = {
                                              "content": content,
                                              "dateCreated":
                                                  date.toIso8601String(),
                                              "ppId": "2324",
                                              "postImages":
                                                  postImages.isNotEmpty
                                                      ? postImages
                                                      : [],
                                              "postComments": [],
                                              "postLikes": []
                                            };
                                            await context
                                                .read<DataProvider>()
                                                .postContent(data);
                                          },
                                          child: Icon(Icons.send_rounded),
                                          style: ButtonStyle(
                                              maximumSize:
                                                  MaterialStateProperty.all(
                                                      Size.fromWidth(100)),
                                              padding:
                                                  MaterialStateProperty.all(
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
                                images != null
                                    ? Container(
                                        height: 150,
                                        margin: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 35),
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: images!.length,
                                            itemBuilder: (context, index) {
                                              return Stack(
                                                children: [
                                                  Container(
                                                    height: 150,
                                                    width: 90,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5,
                                                            horizontal: 5),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      child: Image.file(
                                                        images![index],
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.black,
                                                      radius: 15,
                                                      child: IconButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            images!.removeAt(
                                                                index);
                                                          });
                                                        },
                                                        icon: Icon(
                                                          FontAwesomeIcons
                                                              .circleXmark,
                                                          size: 15,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              );
                                            }))
                                    : SizedBox(),
                              ],
                            ),
                          );
                        });
                      },
                    );
                  },
                  decoration: InputDecoration.collapsed(
                      hintText: 'What\'s on your mind?'),
                ),
              )
            ],
          ),
          const Divider(height: 10.0, thickness: 0.5),
          Container(
            height: 40.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.videocam,
                    color: Colors.red,
                  ),
                  label: Text(
                    'Live',
                  ),
                ),
                const VerticalDivider(width: 8.0),
                FlatButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.photo_library,
                    color: Colors.green,
                  ),
                  label: Text(
                    'Photo',
                  ),
                ),
                const VerticalDivider(width: 8.0),
                FlatButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.video_call,
                    color: Colors.purpleAccent,
                  ),
                  label: Text(
                    'Room',
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
