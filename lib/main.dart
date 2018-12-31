import 'package:flutter/material.dart';
import 'package:flutter_login/auth.dart';
import 'package:flutter_login/pages/root_page.dart';
import 'auth.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  final BaseAuth auth = Auth();
  @override
  MyAppState createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Login App",
      home: RootPage(auth: widget.auth,),
    );
  }
}


