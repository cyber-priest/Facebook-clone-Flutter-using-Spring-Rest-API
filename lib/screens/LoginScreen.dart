import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mini_facebook/provider/dataProvider.dart';
import 'package:mini_facebook/screens/signUp.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../config/pallete.dart';
import '../widgets/Utils.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? errorPassword;
  String? errorUserName;
  bool onProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 25,
            ),
            Icon(
              FontAwesomeIcons.facebook,
              color: Palette.facebookBlue,
              size: 55,
            ),
            SizedBox(
              height: 35,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextField(
                controller: userNameController,
                onChanged: (username) {
                  var length = username.length;
                  setState(() {
                    errorUserName = length > 1 ? null : "Invalide username.";
                  });
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: "Username",
                  labelStyle: TextStyle(fontFamily: "monte", fontSize: 13),
                  prefixIcon: Icon(Icons.person_outlined),
                  errorText: errorUserName,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextField(
                controller: passwordController,
                onChanged: (password) {
                  int length = password.length;
                  setState(() {
                    errorPassword = length > 5
                        ? null
                        : "Password length should greater than 5 characters!";
                  });
                },
                obscureText: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: "Password",
                  labelStyle: TextStyle(fontFamily: "monte", fontSize: 13),
                  prefixIcon: Icon(Icons.lock),
                  errorText: errorPassword,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      onProgress = true;
                    });
                    var userName = userNameController.text;
                    var password = passwordController.text;
                    if (errorPassword == null && errorUserName == null) {
                      if (userName.isNotEmpty && password.isNotEmpty) {
                        await context
                            .read<DataProvider>()
                            .login(userName, password)
                            .then((value) {
                          if (value != 200) {
                            messanger(context,
                                "Incorrect username or passowrd, please try again.");
                          }
                        }).catchError((error) {
                          return messanger(context, error.toString());
                        });
                      }
                    }
                    setState(() {
                      onProgress = false;
                    });
                  },
                  child: Text(
                    "Log in",
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
            ),
            SizedBox(height: 10),
            TextButton(
                onPressed: () async {
                  context.read<DataProvider>().fetchUser();
                  var user = context.read<DataProvider>().user;
                  print(user);
                },
                child: Text(
                  "Forgot password?",
                  style: TextStyle(color: Colors.black),
                )),
            SizedBox(height: 40),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => SignUp()));
              },
              child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 3),
                        blurRadius: 5,
                        color: Colors.black12,
                      )
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "Create new account",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ]),
    );
  }
}
