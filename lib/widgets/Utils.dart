import 'package:flutter/material.dart';

messanger(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.blue,
      content: Container(
          color: Colors.blue,
          margin: EdgeInsets.only(bottom: 30),
          child: Text(
            message,
            style: TextStyle(
              color: Colors.black,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ))));
}
