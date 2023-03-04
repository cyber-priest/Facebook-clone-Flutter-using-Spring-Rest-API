import 'package:meta/meta.dart';

class User {
  final String firstName;
  final String lastName;
  final String userName;
  final String phoneNumber;

  const User({
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.phoneNumber,
  });
}
