import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mini_facebook/provider/dataProvider.dart';
import 'package:provider/provider.dart';

import '../config/pallete.dart';

class EditProfile extends StatefulWidget {
  EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String? fileName;

  String? filePath;

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<DataProvider>(context).user;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Edit Profile", style: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
              ),
              Center(
                child: InkWell(
                  onTap: () async {
                    var result = await FilePicker.platform.pickFiles();
                    setState(() {
                      fileName = result!.files.first.name;
                      filePath = result.files.first.path;
                    });

                    if (fileName!.endsWith(".png") ||
                        fileName!.endsWith(".jpg") ||
                        fileName!.endsWith(".Jpeg") ||
                        fileName!.endsWith(".gif")) {
                      setState(() {});
                    } else {
                      fileName = null;
                      filePath = null;
                    }
                  },
                  child: CircleAvatar(
                    backgroundImage: filePath != null
                        ? Image.file(File(filePath as String)).image
                        : null,
                    backgroundColor: Color.fromARGB(255, 221, 221, 221),
                    radius: 50,
                    child: filePath == null
                        ? Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.black,
                            size: 40,
                          )
                        : null,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: TextFormField(
                  initialValue: user.firstName,
                  decoration: InputDecoration(
                    // border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: TextFormField(
                  initialValue: user.lastName,
                  decoration: InputDecoration(
                    // border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: TextFormField(
                  initialValue: user.userName,
                  decoration: InputDecoration(
                    // border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: TextFormField(
                  initialValue: user.phoneNumber,
                  decoration: InputDecoration(
                    // border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {},
                  child: Text(
                    "Update",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  style: ButtonStyle(
                      maximumSize:
                          MaterialStateProperty.all(Size.fromWidth(100)),
                      padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(vertical: 20)),
                      backgroundColor: MaterialStateProperty.all(
                        Palette.facebookBlue,
                      )),
                ),
              ),
            ],
          )),
    );
  }
}
