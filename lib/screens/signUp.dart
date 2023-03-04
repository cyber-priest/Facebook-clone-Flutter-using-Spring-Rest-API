// import 'package:United/screens/withdraw.dart';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:mini_facebook/config/pallete.dart';
import 'package:uuid/uuid.dart';

import '../widgets/Utils.dart';

// import '../engine/authProvider.dart';

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController conPasswordController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController fNameController = TextEditingController();
  final TextEditingController lNameController = TextEditingController();
  String phoneNumber = "";
  String password = "";
  double balance = 60.0;
  int level = 0;
  String? superior;
  String? referal;
  String bankNum = "";
  bool isVer = false;
  String? errorPhone;
  String? errorPassword;
  String? errorConPassword;
  String? errorUserName;
  String? errorFname;
  String? errorLname;
  Map<String, dynamic> userData = {};
  bool onProgress = false;

  bool isValidEmail(email) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }

  Future signup() async {
    String phone = phoneController.text;
    String username = userNameController.text;
    String firstName = fNameController.text;
    String lastName = lNameController.text;
    String password = passwordController.text;
    String token = Uuid().v1();
    Map data = {
      "firstName": firstName,
      "lastName": lastName,
      "phoneNumber": phone,
      "userName": username,
      "password": password,
      "token": token,
    };

    Uri url = Uri.http("localhost:8080", "public");
    var res = await post(url,
            headers: {'Content-Type': 'application/json'},
            body: json.encode(data))
        .catchError((error) {
      print(error.toString());
    });

    if (res.statusCode == 200) {
      messanger(context, "User signed up successfully.");
      Navigator.pop(context);
    } else {
      messanger(context, "Something went wrong!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Palette.facebookBlue),
        ),
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
                height: 15,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  "Create account",
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        // width: MediaQuery.of(context).size.width / 2.3,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        margin:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: TextField(
                          controller: fNameController,
                          onChanged: (fname) {
                            int length = fname.length;
                            setState(() {
                              errorFname = length > 1
                                  ? null
                                  : "First name should be more than 1 character.";
                            });
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: "First name",
                            labelStyle:
                                TextStyle(fontFamily: "monte", fontSize: 12),
                            prefixIcon: Icon(Icons.person),
                            errorText: errorFname,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        // width: MediaQuery.of(context).size.width / 2.3,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        margin: EdgeInsets.only(right: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: TextField(
                          controller: lNameController,
                          onChanged: (lname) {
                            int length = lname.length;
                            setState(() {
                              errorLname = length > 1
                                  ? null
                                  : "Last name should be more than 1 character.";
                            });
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: "Last name",
                            labelStyle:
                                TextStyle(fontFamily: "monte", fontSize: 12),
                            prefixIcon: Icon(Icons.person),
                            errorText: errorLname,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: TextField(
                  controller: phoneController,
                  onChanged: (phone) {
                    var length = phone.length;
                    setState(() {
                      errorPhone =
                          length == 10 ? null : "Invalide phonenumber.";
                    });
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: "Phone",
                    labelStyle: TextStyle(fontFamily: "monte", fontSize: 12),
                    prefixIcon: Icon(Icons.phone),
                    errorText: errorPhone,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
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
                    labelStyle: TextStyle(fontFamily: "monte", fontSize: 12),
                    prefixIcon: Icon(Icons.person_outlined),
                    errorText: errorUserName,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
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
                    labelStyle: TextStyle(fontFamily: "monte", fontSize: 12),
                    prefixIcon: Icon(Icons.lock),
                    errorText: errorPassword,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: TextField(
                  controller: conPasswordController,
                  onChanged: (password) {
                    setState(() {
                      errorConPassword = password == passwordController.text
                          ? null
                          : "Passwords should match!";
                    });
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: "Confirm Password",
                    labelStyle: TextStyle(fontFamily: "monte", fontSize: 12),
                    prefixIcon: Icon(Icons.lock),
                    errorText: errorConPassword,
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
                      // vbzgehfp
                      var phone = phoneController.text;
                      var password = passwordController.text;
                      var conPassword = conPasswordController.text;
                      var fName = fNameController.text;
                      var lName = lNameController.text;
                      var username = userNameController.text;

                      if (errorPhone == null &&
                          errorUserName == null &&
                          errorConPassword == null &&
                          errorPassword == null &&
                          errorFname == null &&
                          errorLname == null) {
                        setState(() {
                          onProgress = true;
                        });

                        if (conPassword == password) {
                          await signup();
                        } else {
                          messanger(
                            context,
                            "Passwords does not match.",
                          );
                        }
                      } else {
                        messanger(
                          context,
                          "Please make sure to fill all the forms correctly.",
                        );
                      }
                      setState(() {
                        onProgress = false;
                      });
                    },
                    child: Text(
                      "Continue",
                      style: TextStyle(
                          // color: theme.colorScheme.primary,
                          ),
                    ),
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(vertical: 20)),
                        backgroundColor: MaterialStateProperty.all(
                          Palette.facebookBlue,
                        )),
                  ),
                ),
              )
            ],
          ),
        ]));
  }
}
