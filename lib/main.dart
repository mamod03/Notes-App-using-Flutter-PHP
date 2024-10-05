import 'package:flutter/material.dart';
import 'package:getx_test/app/auth/login.dart';
import 'package:getx_test/app/auth/signup.dart';
import 'package:getx_test/app/auth/success.dart';
import 'package:getx_test/app/home.dart';
import 'package:getx_test/app/notes/add.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sharedPref;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPref = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      initialRoute: sharedPref.getString('id') == null ? "/login" : "home",
      routes: {
        "/login": (context) => Login(),
        "signup": (context) => Signup(),
        "home": (context) => Home(),
        "success": (context) => Success(),
        "addnote": (context) => AddNotes(),
      },
    );
  }
}
