import 'package:firebase_dart/core.dart';
import 'package:firebase_dart/implementation/pure_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mini_facebook/provider/dataProvider.dart';
import 'package:mini_facebook/screens/LoginScreen.dart';
import 'package:mini_facebook/screens/screens.dart';
import 'package:provider/provider.dart';
import 'config/pallete.dart';
import 'screens/MainScreens.dart';

void main() async {
  FirebaseDart.setup();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white,
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDKLZQ4ybZZ1tXjHwuK8xNcmcevt7GumMA",
      appId: "1:875173986232:web:07968b386514cd5210194d",
      storageBucket: "mini-facebook-a0344.appspot.com",
      messagingSenderId: "875173986232",
      projectId: "mini-facebook-a0344",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DataProvider>(create: (_) => DataProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Facebook',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          scaffoldBackgroundColor: Palette.scaffold,
        ),
        home: AppScreen(),
      ),
    );
  }
}

class AppScreen extends StatelessWidget {
  const AppScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isLoggedIn =
        Provider.of<DataProvider>(context, listen: true).isLoggedIn;
    return isLoggedIn ? MainScreen() : Login();
  }
}
